extension Render.Async {
    /// Namespace for async sink types (destinations for rendered bytes).
    ///
    /// The `Render.Async.Sink` enum provides:
    /// - `Render.Async.Sink.Protocol` - Contract for byte sinks with backpressure
    /// - `Render.Async.Sink.Buffered` - Actor-based sink using Async.Channel.Bounded
    /// - `Render.Async.Sink.Chunked` - Alternative sink using AsyncStream
    public enum Sink {}
}
