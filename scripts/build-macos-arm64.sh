#!/usr/bin/env bash
set -euo pipefail

version="${SOFINTEL_VERSION:-1.0.4}"
cargo build --release --features mimalloc --package zed --package cli
cargo build --release --package browser --bin sofintel_helper
target_dir="target/release"
app="$target_dir/Sofintel.app"
rm -rf "$app"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources" dist
cp "$target_dir/zed" "$app/Contents/MacOS/Sofintel"
cp crates/zed/resources/Sofintel.icns "$app/Contents/Resources/Sofintel.icns"
framework=$(find "$target_dir/build" -path '*/cef_macos_aarch64/Chromium Embedded Framework.framework' -type d -print -quit)
test -n "$framework"
ditto "$framework" "$app/Contents/Frameworks/Chromium Embedded Framework.framework"

helpers=("Helper" "Helper (GPU)" "Helper (Renderer)" "Helper (Plugin)" "Helper (Alerts)")
for helper_suffix in "${helpers[@]}"; do
  helper_name="Sofintel $helper_suffix"
  helper_app="$app/Contents/Frameworks/$helper_name.app"
  if [[ "$helper_suffix" == "Helper" ]]; then
    helper_identifier="dev.sofintel.Sofintel.helper"
  else
    helper_type="${helper_suffix#Helper (}"
    helper_type="${helper_type%)}"
    helper_identifier="dev.sofintel.Sofintel.helper.$helper_type"
  fi

  mkdir -p "$helper_app/Contents/MacOS"
  cp "$target_dir/sofintel_helper" "$helper_app/Contents/MacOS/$helper_name"
  cat > "$helper_app/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleName</key><string>$helper_name</string>
<key>CFBundleDisplayName</key><string>$helper_name</string>
<key>CFBundleExecutable</key><string>$helper_name</string>
<key>CFBundleIdentifier</key><string>$helper_identifier</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>LSUIElement</key><true/>
</dict></plist>
PLIST
  printf 'APPL????' > "$helper_app/Contents/PkgInfo"
done
cat > "$app/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleName</key><string>Sofintel</string>
<key>CFBundleDisplayName</key><string>Sofintel</string>
<key>CFBundleExecutable</key><string>Sofintel</string>
<key>CFBundleIdentifier</key><string>dev.sofintel.Sofintel</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleIconFile</key><string>Sofintel.icns</string>
<key>CFBundleShortVersionString</key><string>$version</string>
<key>CFBundleVersion</key><string>$version</string>
</dict></plist>
PLIST
codesign --force --sign - "$app/Contents/Frameworks/Chromium Embedded Framework.framework"
for helper_suffix in "${helpers[@]}"; do
  codesign --force --sign - "$app/Contents/Frameworks/Sofintel $helper_suffix.app"
done
codesign --force --sign - "$app"
codesign --verify --deep --strict --verbose=2 "$app"
stage=$(mktemp -d)
cp -R "$app" "$stage/Sofintel.app"
ln -s /Applications "$stage/Applications"
hdiutil create -volname Sofintel -srcfolder "$stage" -ov -format UDZO "dist/Sofintel-$version-macos-arm64.dmg"
rm -rf "$stage"
