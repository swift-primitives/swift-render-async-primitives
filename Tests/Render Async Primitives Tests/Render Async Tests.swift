import Testing

@testable import Render_Async_Primitives

extension Render.Async {
    @Suite("Render Async")
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}
