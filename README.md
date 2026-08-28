# Sofintel

<p align="center">
  <img src="assets/images/sofintel-icon.png" alt="Sofintel icon" width="180">
</p>

Sofintel is a browser, code editor, and terminal in one app. It brings browsing, coding, and command-line workflows together in a single environment.

## Download

Grab the latest builds from [GitHub Releases](https://github.com/sofintel/sofintel/releases) — every platform, signed and reproducible from source.

| Platform | Architecture | Download |
| --- | --- | --- |
| **macOS** | Apple Silicon (arm64) | [Sofintel-1.0.3-macos-arm64.zip](https://github.com/sofintel/sofintel/releases/download/v1.0.3/Sofintel-1.0.3-macos-arm64.zip) |
| **macOS** | Intel (x86_64) | [Sofintel-1.0.3-macos-x86_64.zip](https://github.com/sofintel/sofintel/releases/download/v1.0.3/Sofintel-1.0.3-macos-x86_64.zip) |
| **Linux** | amd64 | [Sofintel-1.0.3-linux-amd64.deb](https://github.com/sofintel/sofintel/releases/download/v1.0.3/Sofintel-1.0.3-linux-amd64.deb) |
| **Linux** | arm64 | [Sofintel-1.0.3-linux-arm64.deb](https://github.com/sofintel/sofintel/releases/download/v1.0.3/Sofintel-1.0.3-linux-arm64.deb) |
| **Windows** | x64 | [Sofintel-1.0.3-windows-x86_64.zip](https://github.com/sofintel/sofintel/releases/download/v1.0.3/Sofintel-1.0.3-windows-x86_64.zip) |

## Features

- **Browser** - Browse and work without leaving the app.
- **Code editor** - A high-performance editor with native macOS and Windows support.
- **Terminal** - A fully integrated terminal for development workflows.

## Building

- [Build Sofintel for macOS](./docs/src/development/macos.md)
- [Build Sofintel for Windows](./docs/src/development/windows.md)

For local GPUI development, use [`script/cargo-gpui-local`](./script/cargo-gpui-local) or [`script/cargo-gpui-local.ps1`](./script/cargo-gpui-local.ps1).

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution guidelines.

## License

Sofintel is licensed under the [GNU General Public License v3.0 or later](./LICENSE-GPL).

A small number of utility crates are licensed under [Apache License 2.0](./LICENSE-APACHE). See individual crate `Cargo.toml` files for details.
