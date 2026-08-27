$ErrorActionPreference = 'Stop'
$version = if ($env:SOFINTEL_VERSION) { $env:SOFINTEL_VERSION } else { '1.0.3' }

cargo build --features mimalloc --package zed --package cli
New-Item -ItemType Directory -Force -Path package, dist | Out-Null
Copy-Item target/debug/zed.exe package/Sofintel.exe
Copy-Item target/debug/cli.exe package/sofintel-cli.exe
Copy-Item LICENSE-GPL package/LICENSE-GPL
Copy-Item icon.png package/Sofintel.png
Compress-Archive -Path package/* -DestinationPath "dist/Sofintel-$version-windows-x86_64.zip" -Force
