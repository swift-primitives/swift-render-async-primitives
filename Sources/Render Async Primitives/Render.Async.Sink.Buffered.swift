public import Byte_Primitives

extension Render.Async.Sink {

    public actor Buffered: Render.Async.Sink.`Protocol` {
        private let sender: Async.Channel<ArraySlice<Byte>>.Bounded.Sender
        private var buffer: [Byte]
        private let chunkSize: Int

        public init(sender: Async.Channel<ArraySlice<Byte>>.Bounded.Sender, chunkSize: Int = 4096) {
            self.sender = sender
            self.buffer = []
            self.buffer.reserveCapacity(chunkSize)
            self.chunkSize = chunkSize
        }
    }
}

extension Render.Async.Sink.Buffered {

    public func write(_ bytes: some Swift.Sequence<Byte> & Sendable) async {
        buffer.append(contentsOf: bytes)
        await flushFullChunks()
    }

    public func write(_ byte: Byte) async {
        buffer.append(byte)
        if buffer.count >= chunkSize {
            await flushFullChunks()
        }
    }

    private func flushFullChunks() async {
        var offset = 0
        while buffer.count - offset >= chunkSize {
            let end = offset + chunkSize

            do throws(Async.Channel<ArraySlice<Byte>>.Error) {
                try await sender.send(ArraySlice(buffer[offset..<end]))
            } catch {}
            offset = end
        }
        if offset > 0 {
            buffer.removeFirst(offset)
        }
    }

    public func finish() async {
        if !buffer.isEmpty {

            do throws(Async.Channel<ArraySlice<Byte>>.Error) {
                try await sender.send(ArraySlice(buffer))
            } catch {}
            buffer.removeAll()
        }
        sender.close()
    }
}
