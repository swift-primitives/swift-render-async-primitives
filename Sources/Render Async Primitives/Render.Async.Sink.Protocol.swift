public import Byte_Primitives

extension Render.Async.Sink {
    /// A protocol for async sinks that accept bytes with backpressure.
    ///
    /// Sinks are the destination for rendered bytes during async rendering.
    /// Conforming types provide an async `write` method that may suspend to apply
    /// backpressure when the consumer is slower than the producer.
    public protocol `Protocol`: Sendable {
        /// Write bytes to the sink, potentially suspending for backpressure.
        func write(_ bytes: some Swift.Sequence<Byte> & Sendable) async

        /// Write a single byte to the sink.
        func write(_ byte: Byte) async
    }
}
