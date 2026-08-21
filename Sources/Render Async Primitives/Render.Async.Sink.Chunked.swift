public import Byte_Primitives

extension Render.Async.Sink {

    @usableFromInline
    actor Chunked {
        @usableFromInline
        var buffer: [Byte]

        @usableFromInline
        let chunkSize: Int

        @usableFromInline
        let continuation: AsyncStream<ArraySlice<Byte>>.Continuation

        @usableFromInline
        var bytesSinceYield: Int = 0

        @usableFromInline
        let yieldInterval: Int

        @usableFromInline
        init(
            chunkSize: Int,
            yieldInterval: Int = 4096,
            continuation: AsyncStream<ArraySlice<Byte>>.Continuation
        ) {
            self.buffer = []
            self.buffer.reserveCapacity(chunkSize)
            self.chunkSize = chunkSize
            self.yieldInterval = yieldInterval
            self.continuation = continuation
        }
    }
}

extension Render.Async.Sink.Chunked {

    @usableFromInline
    func append<S: Swift.Sequence>(contentsOf bytes: S) async where S.Element == Byte {
        let countBefore = buffer.count
        buffer.append(contentsOf: bytes)
        bytesSinceYield += buffer.count - countBefore

        await flushFullChunks()
    }

    @usableFromInline
    func append(_ byte: Byte) async {
        buffer.append(byte)
        bytesSinceYield += 1

        if buffer.count >= chunkSize {
            await flushFullChunks()
        }
    }

    @usableFromInline
    func flushFullChunks() async {
        var offset = 0
        while buffer.count - offset >= chunkSize {
            let end = offset + chunkSize
            continuation.yield(buffer[offset..<end])
            offset = end
        }
        if offset > 0 {
            buffer.removeFirst(offset)
        }

        if bytesSinceYield >= yieldInterval {
            bytesSinceYield = 0
            await Task.yield()
        }
    }

    @usableFromInline
    func finish() {
        if !buffer.isEmpty {
            continuation.yield(ArraySlice(buffer))
            buffer.removeAll(keepingCapacity: false)
        }
        continuation.finish()
    }
}
