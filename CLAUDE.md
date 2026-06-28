# CLAUDE.md — Flutter Forge Kit

handharr-labs · Flutter Forge Kit — shared packages for Clean Architecture + BLoC apps. The Flutter counterpart of the iOS and Web Forge Kits.

## Architecture

- **Glossary (All Terms):** `docs/principles/forge-kit/glossary.md`
- **Design Principles (What & Why):** `docs/principles/forge-kit/design-principles.md`
- **Conventions (What, How, When):** `docs/principles/forge-kit/conventions.md`
- **Directory Structure (What & Where):** `docs/principles/forge-kit/directory-structure.md`
- **Tiered Design System (Tiers, Brand Packages, Rules):** `docs/principles/forge-kit/tiered-design-system.md`
- **Flutter Architecture (layer reference + code conventions):** `docs/principles/flutter-architecture/`

## Principles

Clean Architecture · DRY · SOLID — apply to all new code.

**Layer dependency rule:** Presentation → Domain ← Data. Domain depends on nothing.

```
Presentation  →  Widget + BLoC/Cubit (states + events; no business logic)
Domain        →  UseCase + RepositoryProtocol + Request + FetchPolicy + Model + Result
Data          →  Repository + DataSource + DTO + Mapper + ApiRequest
Application    →  DI composition root (get_it/injectable); router/navigation
```

## Packages

A Melos + Dart pub workspace. One root `pubspec.yaml` lists the members; each is a published-by-path package. Downstream apps depend via `path` (monorepo) or git/pub once released.

| Package | Scope | Purpose |
|---|---|---|
| `forge_core` | Platform-agnostic | `Result`/`DomainError`, `FetchPolicy`, `Request<Q,P>`, `UseCase`, `AnalyticsGateway` (+ Console/NoOp), `Logger`. Pure Dart, zero deps. |
| `forge_client` | IO | `ApiClient` (Dio), `WebSocketClient` (multiplexed), `LocalDataSource` (+ in-memory). Deps: `forge_core`, `dio`, `web_socket_channel`. |
| `forge_ui` | Design system | Token-first `FUI*` widgets configured by `*Configuration`; `FUITheme`/`FUITokens`. Standalone Flutter package. Single base tier (future Bronze). |

## Key Rules

- Domain never imports `forge_client`, `forge_ui`, Infrastructure, or Flutter IO.
- `forge_core` has zero deps and is pure Dart. `forge_client` depends on `forge_core`. `forge_ui` is standalone.
- Only the Data layer imports `forge_client`; only Presentation + Application import `forge_ui`.
- DI is `get_it`/`injectable` wired at the **composition root** — no service location inside features.
- `forge_ui` holds no domain or feature logic; widgets carry the `FUI` prefix and a `*Configuration` API.
- Features live in downstream apps (or the playground), never in the kit packages.

## Key Patterns to Know Cold

- DTO → Mapper → Domain Model (the Mapper is the only type that knows both)
- Errors flow as `Result<T>` (`Ok`/`Err` over `DomainError`) — never thrown across layer boundaries
- `FetchPolicy` (.fresh / .cached / .strict) rides on `Request` from BLoC to Repository
- `Request<Q, P>` is the unified UseCase input — adding a field never breaks call sites; HTTP structs are `*ApiRequest`
- BLoC/Cubit holds presentation state only; all business logic lives behind a `UseCase`
- `WebSocketClient` is one socket, channel-multiplexed; wrap it for envelope-aware routing
- Unit tests: mock the layer below, assert on the layer you just built

## Playground

`playground/` is the one runnable host (`forge_kit_playground`), a workspace member that depends on `forge_ui` by path. It owns no UI of its own — `main.dart` boots a `MaterialApp` whose `home` is the design system's `ForgeUICatalog`.

- **The catalog lives in the design system, not the host.** `ForgeUICatalog` (in `forge_ui/lib/src/catalog/`) is the gallery of every `FUI` component + token; hosts just mount it. Add a component → extend the catalog there, and every host picks it up for free.
- Run: `scripts/run.sh` (any device) or `scripts/run.sh -d chrome` for a quick look. The script runs the playground on the repo-pinned Flutter, forwarding extra args to `flutter run`. Equivalent: `cd playground && fvm flutter run`.
- In VS Code, F5 uses the `playground` configs in `.vscode/launch.json`; `.vscode/settings.json` points the Dart extension at the same pinned SDK.
- Targets generated: iOS, Android, web.

## Commands

Toolchain is pinned per-repo via `fvm` to the latest stable Flutter (`.fvmrc` → 3.44.4), independent of the machine-global Flutter. After cloning, run `fvm install` once to materialize `.fvm/`. Always invoke Flutter as `fvm flutter …` inside this repo.

```
fvm install                      # after clone: fetch the pinned SDK
dart pub global activate melos   # once
melos bootstrap                  # resolve the workspace
melos run analyze                # flutter analyze across packages
melos run test                   # test across packages
melos run format                 # dart format .
```

## Docs

`docs/` is a symlink into `personal-workdocs/flutter-forge-kit-docs` and is git-ignored (local only), as is `.claude/`. Principles and initiatives live there, mirroring the iOS/Web kits.
