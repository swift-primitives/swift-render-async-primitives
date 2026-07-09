// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-render-async-primitives open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-render-async-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

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
