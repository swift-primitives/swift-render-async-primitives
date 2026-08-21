public import Byte_Primitives

extension Render.Async.Sink {

    public protocol `Protocol`: Sendable {

        func write(_ bytes: some Swift.Sequence<Byte> & Sendable) async

        func write(_ byte: Byte) async
    }
}
