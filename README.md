# Render Async Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Async streaming infrastructure for `Render` — `Render.Async.Sink`, `Render.Async.Sink.Buffered`, and `Render.Async.Sink.Chunked` build on top of `Render_Primitives_Core` and provide channel-backed byte emission via `swift-async-primitives` and `swift-byte-primitives`.

The synchronous rendering core (View / Context / Builder) lives in `swift-render-primitives`; this package adds the async streaming surface, backed by channels from `swift-async-primitives` and bytes from `swift-byte-primitives`.

## Installation

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-render-async-primitives.git", branch: "main")
]
```

Add the product to your target:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Render Async Primitives", package: "swift-render-async-primitives")
    ]
)
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
