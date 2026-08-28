# Sofintel Development Log

A running log of change sets. **Add an entry for every commit.** Keep it reverse-chronological
(newest at the top). Each entry is one line per change set: a short summary, the crate or area
touched, and the commit hash.

## How to use

- Before a release, this is the source of truth for what changed.
- When you land a commit, prepend a new entry. Copy the style already here.
- If a commit is purely a refactor with no behavior change, still record it in one line so the
  history is complete.

## Commit convention

```
[area] Short imperative summary
```

Example:

```
[workspace] Fix File mode not showing the Project sidebar
[website] Add per-platform download buttons to the hero
[browser] Defer CEF init to first browser use
```

---

## 2026-08

### v1.0.3 + follow-ups (latest)

- `[docs]` Add ARCHITECTURE.md, DEVELOPMENT-LOG.md, SOFINTEL-ROADMAP.md
- `[workspace]` Fix File/Editor mode not selecting the Project sidebar section so files appear
- `[website]` Expand hero to 6 direct-download buttons (Mac ARM/Intel, Linux amd64/arm64, Windows x64, Source)
- `[README]` Add a full Download table with per-platform release links
- `[ci]` Fix macOS packaging to locate the CEF framework from `CEF_PATH`
- `[ci]` Pre-fetch CEF with retry in macOS release builds (fixes hang)
- `[ci]` Fix CEF pre-fetch workspace resolution (cef-rs checkout subdir)
- `[ci]` Fix release validation on `workflow_dispatch` (no `HEAD^` on shallow checkout)
- `[website]` Neutral (pi.dev-style) buttons; per-platform release links
- `[brand]` Rebrand to Sofintel; defer CEF keychain prompt to first browser use; v1.0.3

### Earlier (Qedit → Sofintel pre-release)

- `[release]` Add cross-platform build scripts; fix browser mode imports; non-macOS compile
- `[ci]` Release pipeline + docs site; cross-platform GitHub release
- `[icons]` Validate releases and apply Sofintel icon
- `[img]` Keep macOS disk images focused (discard old DMGs after build)

- `[workspace]` Restore classic file tree in the Project/File sidebar (real ProjectPanel instead of threads navigator)
- `[agent]` Defer agent panel load to first use (no credential keychain prompts at startup)
- `[agent]` One-time explanation toast about local provider credentials when agents first read them

- `[brand]` Bump to v1.0.4; app menu / About dialog renamed to Sofintel with GitHub + website links
- `[brand]` Release channel display name, Windows product metadata renamed to Sofintel
