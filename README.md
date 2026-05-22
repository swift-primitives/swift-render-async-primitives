# Render Async Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Async streaming infrastructure for `Render` — `Render.Async.Sink`, `Render.Async.Sink.Buffered`, and `Render.Async.Sink.Chunked` build on top of `Render_Primitives_Core` and provide channel-backed byte emission via `swift-async-primitives` and `swift-byte-primitives`.

Sibling extraction of swift-render-primitives. The bare `Render` enum + `Render.Primitive` types live in `Render_Primitive`; the synchronous core (View / Context / Builder) lives in `Render_Primitives_Core`; this package adds the async streaming surface that depends on `swift-async-primitives` (Channel) and `swift-byte-primitives` (Byte). Subject-first naming per the inventory v3.3 manual triage — Render is the subject domain, Async is the role.

---
