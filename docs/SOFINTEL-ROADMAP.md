# Sofintel Roadmap

A high-level view of where Sofintel is going. This is a living document. It is intentionally
broad and forward-looking: prioritize, discard, and add freely. This is the "global view" of
the product, not a sprint backlog.

## North star

One native app where browsing, coding, and the terminal live together. When you open Sofintel
you should not need to leave it to look something up, run something, or write something.

## Current pillars

- **Browser** — embedded Chromium (CEF). Real web pages inside the editor.
- **Editor** — Zed-derived. Fast, GPU-accelerated, keyboard-first.
- **Terminal** — fully integrated.
- **Three-context shell** — Browser / File / Terminal switch in one window, each with its own
  tabs and content area.

## Themes / direction

1. **One surface, not three apps.** Reduce switching cost. Anything you can do in a browser
   tab or a terminal should be reachable two keystrokes from your editor.
2. **Extensible.** Open packages, not walled garden. Users should be able to add languages,
   browser extensions, and agents/marketplaces.
3. **Privacy-friendly and native.** No telemetry by default, no accounts required, GPUI
   rendering.

---

## Planned / aspirational features

### Marketplaces (the big three)

Sofintel should grow three distinct markets. Each has a natural upstream source it can inherit
from.

- **Agents Marketplace** (for the Agent / Terminal area)
  Ship agents and agent skills as installable packages. Let users browse, install, and pin
  versions from inside Sofintel. Think of it as a package registry for automation.

- **Browser Extensions Marketplace** (for the CEF Browser area)
  Load **Chromium-compatible Chrome extensions** into the embedded browser. This gives the
  browser real power (password managers, ad blockers, devtools, productivity) without building
  every feature. CEF supports the Chrome extension API; the work is a curated registry and a
  safe install flow.

- **Sofintel Extensions Marketplace** (Zed-compatible)
  Adopt and integrate Zed's existing extensions ecosystem: https://zed.dev/extensions
  Themes, language support, keymaps, workflow extensions. Reuse the upstream extension format so
  the whole Zed catalog becomes available. This is the highest-leverage marketplace because the
  catalog already exists.

### Product ideas

- **Services hub** — first-class service providers (LLM providers, hosting, connectors) behind a
  clean settings page. Already scaffolded in `crates/service_hub_ui/`.
- **Collaboration** — the Zed collaboration stack is partially wired; decide whether to keep or
  strip it.
- **AI / model providers** — Sofintel already carries Zed's model-provider crates (OpenAI,
  Anthropic, Bedrock, Mistral, Ollama, etc.). Decide the product story: local-first vs. cloud.
- **Project templates & bootstrap** — one-command setup for common stacks.
- **Theming / syntax themes** — promote the existing theme system into a browsable catalog.
- **The mode shell** — continue to refine Browser / File / Terminal so each context feels like a
  first-class app with its own tabs, history, and state.

## Long-term / ambitious

- Cross-platform parity everywhere (macOS, Linux, Windows) with signed, reproducible builds.
- A first-class mobile / tablet story (long shot).
- Distributed collaboration (peer-to-peer or relay) integrated with the browser context.

## Non-goals (for now)

- Replacing a full general-purpose browser as the default system browser.
- Building a full cloud IDE. Sofintel is a desktop app.
- Monetization decisions are open; nothing is decided.

## How to contribute ideas

Add entries to the appropriate section. For a concrete feature, open a GitHub issue and link it
here. Keep the roadmap honest: mark anything speculative as "idea", anything committed as
"planned".

---

## Keep it updated

Whenever you ship something notable, move it from the roadmap into
[`DEVELOPMENT-LOG.md`](./DEVELOPMENT-LOG.md). Product direction questions should be answered on
the GitHub discussions/issue tracker, not here.
