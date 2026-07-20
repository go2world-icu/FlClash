# CLAUDE.md

This repository uses [AGENTS.md](AGENTS.md) as the canonical agent entry point.
Read that file first, then follow the `.agents/` references it routes to.

## Codebase at a Glance

FlClash is a multi-platform (Android, Windows, macOS, Linux) proxy client built on ClashMeta (mihomo). Flutter UI + Go core.

### Where things live

| Path | What |
|------|------|
| `lib/views/`, `lib/pages/` | UI screens and page shells |
| `lib/providers/` | Riverpod state management (app, config, state, action, database) |
| `lib/core/` | CoreController — singleton facade over Go kernel (FFI on Android, JSON socket on desktop) |
| `lib/models/` | Freezed data models |
| `lib/database/` | Drift/SQLite schema (Profiles, Scripts, Rules, ProxyGroups, IconRecords) |
| `lib/manager/` | Platform concern InheritedWidgets (Window, Tray, VPN, Connectivity, ...) |
| `lib/common/` | Shared utilities, extensions, helpers |
| `lib/sdk/flutter_xboard_sdk/` | Vendored SDK for panel API integration |
| `lib/xboard/` | Added UI module for panel/subscription/auth features (Migrated from fork) |
| `core/` | Go ClashMeta kernel (submodule) |
| `plugins/` | Platform FFI plugins (setup, proxy, rust_api, tray_manager, wifi_ssid, window_ext) |
| `services/helper/` | Windows-only Rust privileged helper for TUN |

### State architecture

Providers in `lib/providers/`:
- `app.dart` — runtime/UI state (logs, traffic, delays, loading, navigation)
- `config.dart` — persistent config (app settings, theme, VPN, proxy style)
- `state.dart` — derived/computed providers (navigation, proxy, tray, color scheme)
- `action.dart` — business logic notifiers (setup, backup, core lifecycle, proxy selection, profile CRUD)
- `database.dart` — Drift database provider wrappers

Generated provider code lives in `lib/providers/generated/`. `globalState` in `lib/state.dart` is a singleton for app lifecycle, theme, and start/stop state.

### Key patterns

- Managers are nested InheritedWidgets configured in `lib/application.dart`.
- `setup.dart` orchestrates release builds (Go core + Flutter + packaging).
- xboard module (from fork) is at `lib/xboard/` — follows the same Riverpod/Freezed conventions.

### Panel Module Boundary

Panel (面板)-related features — subscription, authentication, payment, invite, remote config, online support, and any backend-specific logic — **must** be developed inside `lib/xboard/` or the vendored `lib/sdk/flutter_xboard_sdk/`.

- `lib/xboard/` may import from the main app (`common/`, `providers/`, `models/`, `enum/`, `state.dart`, `core/controller.dart`, `l10n/`) but the reverse must not happen: the main app should never directly import from `lib/xboard/`.
- Panel-specific models, providers, and API clients belong in the SDK or xboard module.
- When xboard needs to extend or modify app behavior (navigation, startup, lifecycle), do it through Riverpod listeners or injected configuration — not by patching app internals.
