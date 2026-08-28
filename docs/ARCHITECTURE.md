# Sofintel Architecture

Sofintel is a fork of **Zed** (https://zed.dev) with Vue/Glass-style additions: an embedded
Chromium (CEF) browser, a three-context workspace shell (Browser / File / Terminal), and a
service hub. It is a large Rust workspace. This document maps the tree so you can find things
fast and modify them safely.

> Use `cargo check --locked --package <crate>` to type-check a single crate. Use
> `./script/clippy` instead of `cargo clippy`.

## The two big ideas

1. **The workspace is Zed's workspace.** Almost all crates are upstream Zed crates, unmodified
   or lightly touched. When you change editor behavior, you are usually in a Zed crate.
2. **Sofintel-specific behavior lives in a handful of crates and can be identified by the word
   `mode`, `browser`, `workspace_chrome`, or `service_hub`.** These are the ones that create the
   distinct Sofintel experience.

## Repository layout

| Path | What it is |
| --- | --- |
| `crates/zed/` | The `zed` binary crate (the app entry point). `main.rs`, `zed.rs`, `build.rs`. |
| `crates/workspace/` | The workspace UI: panes, docks, sidebar host, mode switching. Most Sofintel UI logic. |
| `crates/workspace_modes/` | The `ModeId` type (Browser / Editor / Terminal) and `ModeViewRegistry`. |
| `crates/workspace_chrome/` | The `ModeControl` (3-icon switcher) and `SidebarNavigationList` widgets. |
| `crates/browser/` | The embedded Chromium (CEF) browser: `cef_instance.rs`, `browser_view.rs`, `tab.rs`. |
| `crates/title_bar/` | Title bar + native toolbar; owns the mode switcher rendering on macOS. |
| `crates/service_hub_ui/` | The Services / service-provider UI. Registers the `Services` sidebar section. |
| `crates/paths/` | App data paths. Defines the `Qedit`/`Sofintel` data dir (rebrand isolation). |
| `crates/cli/` | The `sofintel-cli` binary (installed with the app). |
| `scripts/` | Per-platform build scripts (`build-macos-*.sh`, `build-linux-*.sh`, `build-windows-*.ps1`). |
| `.github/workflows/` | CI: `release-sofintel.yml` (cross-platform release), `website.yml` (GitHub Pages). |
| `website/` | The GitHub Pages marketing site (static, self-contained). |
| `docs/` | mdBook documentation (user/contributor). |
| `assets/` | Brand images, settings defaults, themes. |
| `sofintel-icon.png` | The transparent master icon; `script/generate-icons` derives all other icons. |

## The mode system (how Browser / File / Terminal switch)

The whole Sofintel shell is driven by `workspace.active_mode` (`workspace_modes::ModeId`).

- `ModeId::BROWSER` — fullscreen browser. `crates/browser` registers a `ModeViewFactory` for it.
- `ModeId::EDITOR` — the "File" context. It is **not** a registered mode view; it falls back to
  the normal Zed editor dock + center panes. The sidebar should show the **Project** section.
- `ModeId::TERMINAL` — the terminal. The bottom-dock `TerminalPanel` is promoted to primary.

Key entry points:

- `crates/workspace/src/workspace.rs` — `switch_to_mode()`, `layout_preset()`,
  `select_sidebar_section()`, `active_section_view()`, `WorkspaceSidebarSection`.
- `crates/workspace_chrome/src/mode_control.rs` — the 3-icon switcher widget
  (`mode_label`, `mode_icon`, `mode_index`, `mode_from_index`).
- `crates/title_bar/src/title_bar.rs` and `crates/title_bar/src/native_toolbar/items.rs` — where
  the switcher is wired to `SwitchTo*Mode` actions.
- `crates/workspace_modes/src/mode_view_registry.rs` — the global registry of mode view
  factories / registered views.

### How a mode switch flows

```
click icon
  └─ SwitchToEditorMode action (title_bar / native_toolbar)
       └─ workspace.switch_to_mode(ModeId::EDITOR, window, cx)
            ├─ deactivate previous mode's on_deactivate callback
            ├─ self.active_mode = mode_id
            ├─ ensure_mode_view(mode_id)  // only for factories (Browser)
            ├─ on_activate callback
            ├─ per-mode setup (e.g. EDITOR selects the Project sidebar section)
            └─ serialize_workspace + cx.notify()  // triggers repaint
```

### The agent panel is lazy

The `AgentPanel` is **not** loaded at app startup. It is created the first time the user
opens the Agent area (via `AgentPanel::toggle`/`toggle_focus`, which call
`AgentPanel::ensure_loaded`). This matters because constructing the panel also constructs
the model selector, which runs `authenticate_all_providers` and reads every provider's
credentials from the system keychain. Deferring that load avoids a flood of "access
keychain" prompts on launch, and lets Sofintel show a one-time explanatory toast about
local provider credentials the first time the Agent area is opened.

### Mode → layout preset map

`layout_preset()` returns:

- `ModeId::BROWSER` → `WorkspaceLayoutPreset::Browser`
- `ModeId::TERMINAL` → `WorkspaceLayoutPreset::Terminal`
- anything else → `WorkspaceLayoutPreset::Editor`

The main `Workspace::render` branches on `self.active_mode` to choose the primary content:
BROWSER renders the browser view, TERMINAL promotes the terminal panel, EDITOR renders the
normal dock shell.

## The sidebar sections

`WorkspaceSidebarSection` (in `workspace.rs`) has: `Project`, `Outline`, `Git`, `Collab`,
`Tabs`, `BrowserTabs`, `Services`, `Terminal`. Each maps to a registered panel or a
`set_sidebar_section_view` view. `Services` is provided by `crates/service_hub_ui`
(`services_page.rs` registers it and selects it on open). These are natural extension points.

## The embedded browser (CEF)

- `crates/browser/src/cef_instance.rs` — CEF initialization, subprocess handling, path
  resolution, message pump.
- `crates/browser/src/browser_view.rs` — the main browser view, tab strip, toolbar glue.
- `crates/browser/src/tab.rs` — a single browser tab (hosts a CEF browser).
- `crates/browser/src/bin/sofintel_helper.rs` — the CEF helper subprocess binary.
- `crates/browser/src/omnibox.rs`, `new_tab_page.rs`, `text_input.rs` — chrome UI.

Important: CEF is **lazy** — it initializes only when the user enables the browser. The macOS
Keychain prompt ("Chromium Safe Storage") appears the first time the browser is used. The code
that explains this shows in `browser_view/content.rs` (the placeholder/continue screen). On
macOS, `handle_cef_subprocess()` is not called at startup (the helper bundles handle it); it's
called on `CefInstance::initialize`. On Windows it is called early in `main()` because Windows
CEF subprocesses re-launch the same executable.

### CEF in CI (important)

CEF is downloaded at build time by the `cef-dll-sys` build script with **no retry**, which
hangs on shared runner networks. The macOS CI job pre-fetches CEF via the upstream
`export-cef-dir` tool (with retries) into `$HOME/cef-*` and sets `CEF_PATH`, so the build uses
the local copy. The macOS "Package app" step locates the framework at `$CEF_PATH` when it's
set. Any change to macOS packaging must keep this in mind.

## Icon generation

`script/generate-icons` regenerates every platform icon from `sofintel-icon.png` (the
transparent master). It produces the `.icns`, `app-icon*.png` channels, the Windows `.ico`
files, the website favicon, and the in-app brand logos. Run it after replacing the master
artwork. The master must have an alpha channel.

## Build & release

- Local build: `scripts/build-macos-arm64.sh` (and `x86_64`). Produces a `.dmg` in `dist/`.
- CI release: `.github/workflows/release-sofintel.yml` builds macOS (arm64/x86_64), Linux
  (amd64/arm64 `.deb`), and Windows (x64 `.zip`), then creates a GitHub release. Trigger it
  with `gh workflow run` and a `version` input, or by pushing a `v*` tag.
- `scripts/verify-release.sh` validates manifests, shell scripts, and compiles key crates
  before you push.
- Website: `website/` is deployed by `.github/workflows/website.yml` to the project Pages
  (`https://sofintel.github.io/`). The org-level site is a separate `sofintel/sofintel.github.io`
  repo that mirrors `website/`.

## Where to look for common changes

| You want to... | Look here |
| --- | --- |
| Change the 3-icon switcher | `crates/workspace_chrome/src/mode_control.rs` |
| Change what a mode shows | `crates/workspace/src/workspace.rs` (`render`, `switch_to_mode`) |
| Add a sidebar section | `crates/workspace/src/workspace.rs` (`WorkspaceSidebarSection`) + register a panel |
| Change the browser | `crates/browser/src/` |
| Change the terminal | `crates/terminal/`, `crates/terminal_view/` |
| Change the editor | `crates/editor/`, `crates/workspace/src/pane.rs` |
| Add a service/provider | `crates/service_hub_ui/` |
| Change branding/assets | `script/generate-icons`, `assets/`, `crates/zed/resources/` |
| Change data dir (rebrand) | `crates/paths/src/paths.rs` |
