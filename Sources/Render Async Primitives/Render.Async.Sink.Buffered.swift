public import Byte_Primitives

extension Render.Async.Sink {
    /// An actor-based sink that accepts bytes and sends chunks with backpressure.
    ///
    /// This sink wraps `Async.Channel.Bounded` to provide bounded memory streaming.
    /// When a chunk is ready, `send()` suspends until the consumer processes it,
    /// ensuring memory usage is bounded to O(chunkSize).
    ///
    /// ## Backpressure
    ///
    /// Unlike `AsyncStream` which can buffer unbounded data when the consumer
    /// is slow, `Render.Async.Sink.Buffered` applies backpressure by suspending the
    /// producer until chunks are consumed. This ensures memory is bounded.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// var channel = Async.Channel<ArraySlice<Byte>>.Bounded(capacity: 4)
    /// let sink = Render.Async.Sink.Buffered(sender: channel.sender, chunkSize: 4096)
    ///
    /// // Producer task
    /// Task {
    ///     await sink.write("<html>".utf8.map(Byte.init))
    ///     await sink.write("<body>".utf8.map(Byte.init))
    ///     await sink.finish()
    /// }
    ///
    /// // Consumer
    /// for try await chunk in channel.receiver.elements {
    ///     await response.write(chunk)
    /// }
    /// ```
    public actor Buffered: Render.Async.Sink.`Protocol` {
        private let sender: Async.Channel<ArraySlice<Byte>>.Bounded.Sender
        private var buffer: [Byte]
        private let chunkSize: Int

        /// Creates a buffered sink using a channel sender.
        ///
        /// - Parameters:
        ///   - sender: The sender endpoint of a bounded channel.
        ///   - chunkSize: The size of chunks to yield (default 4096).
        public init(sender: Async.Channel<ArraySlice<Byte>>.Bounded.Sender, chunkSize: Int = 4096) {
            self.sender = sender
            self.buffer = []
            self.buffer.reserveCapacity(chunkSize)
            self.chunkSize = chunkSize
        }
    }
}

extension Render.Async.Sink.Buffered {
    /// Write bytes to the sink, sending full chunks with backpressure.
    ///
    /// When the buffer fills to `chunkSize`, a chunk is sent to the channel.
    /// The `send()` call suspends until the consumer reads the chunk,
    /// providing backpressure.
    ///
    /// - Parameter bytes: The bytes to write.
    public func write(_ bytes: some Swift.Sequence<Byte> & Sendable) async {
        buffer.append(contentsOf: bytes)
        await flushFullChunks()
    }

    /// Write a single byte to the sink.
    ///
    /// - Parameter byte: The byte to write.
    public func write(_ byte: Byte) async {
        buffer.append(byte)
        if buffer.count >= chunkSize {
            await flushFullChunks()
        }
    }

    /// Flush any full chunks to the channel.
    ///
    /// Uses offset-based iteration to avoid O(n²) behavior from repeated
    /// `removeFirst()` calls. Only performs a single `removeFirst()` at the end.
    private func flushFullChunks() async {
        var offset = 0
        while buffer.count - offset >= chunkSize {
            let end = offset + chunkSize
            // Backpressure: suspends until consumed. Silently stops on close/cancel.
            // swiftlint:disable:next no_try_optional - reason: deliberate backpressure send that silently stops on close/cancel (see comment above); the send error carries no recoverable signal ([IMPL-108] escape hatch)
            try? await sender.send(ArraySlice(buffer[offset..<end]))
            offset = end
        }
        if offset > 0 {
            buffer.removeFirst(offset)
        }
    }

    /// Flush remaining bytes and close the sender.
    ///
    /// Call this when rendering is complete to send any remaining buffered
    /// bytes and signal to consumers that the stream is finished.
    public func finish() async {
        if !buffer.isEmpty {
            // swiftlint:disable:next no_try_optional - reason: deliberate backpressure send that silently stops on close/cancel — mirrors flushFullChunks; the send error carries no recoverable signal ([IMPL-108] escape hatch)
            try? await sender.send(ArraySlice(buffer))
            buffer.removeAll()
        }
        sender.close()
    }
}
