/// Extends the Render namespace with async streaming support.
extension Render {
    /// Namespace for async rendering types.
    ///
    /// The `Render.Async` enum provides types for progressive streaming:
    /// - `Render.Async.Sink.Protocol` -- Contract for async byte sinks
    /// - `Render.Async.Sink.Buffered` -- Actor-based sink using Async.Channel.Bounded
    /// - `Render.Async.Sink.Chunked` -- Alternative sink using AsyncStream
    public enum Async {}
}
