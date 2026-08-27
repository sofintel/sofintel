#!/usr/bin/env bash
set -euo pipefail

version="${SOFINTEL_VERSION:-1.0.3}"
target="aarch64-unknown-linux-gnu"
rustup target add "$target"
cargo build --release --features mimalloc --package zed --package cli --target "$target"
package="sofintel_${version}_arm64"
rm -rf "$package"
mkdir -p "$package/DEBIAN" "$package/usr/bin" "$package/usr/share/icons/hicolor/512x512/apps"
install -m 0755 "target/$target/release/zed" "$package/usr/bin/sofintel"
install -m 0755 "target/$target/release/cli" "$package/usr/bin/sofintel-cli"
install -m 0644 icon.png "$package/usr/share/icons/hicolor/512x512/apps/sofintel.png"
cat > "$package/DEBIAN/control" <<CONTROL
Package: sofintel
Version: $version
Section: editors
Priority: optional
Architecture: arm64
Maintainer: Sofintel contributors
Description: Sofintel browser, code editor, and terminal
 Sofintel is a fast development environment for focused work.
CONTROL
mkdir -p dist
dpkg-deb --build --root-owner-group "$package" "dist/Sofintel-$version-linux-arm64.deb"
