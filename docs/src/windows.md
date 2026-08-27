---
title: Sofintel on Windows
description: "Windows installation, troubleshooting, and source build links for Sofintel."
---

# Sofintel on Windows

## Installing Sofintel

Sofintel runs on Windows. This page covers the Windows experience and links to the development setup when you want to build from source.

See [Building Sofintel for Windows](./development/windows.md).

## Uninstall

- Installed via installer: Use `Settings` -> `Apps` -> `Installed apps`, search for Sofintel, and click Uninstall.
- Built from source: Remove the build output directory you created, such as `target`.

Your settings and extensions live in your user profile. When uninstalling, you can choose to keep or remove them.

## Remote Development

Sofintel supports the same Windows remote-development foundations as Zed, including SSH and WSL workflows.

For setup details, see [Remote Development](./remote-development.md).

## Troubleshooting

### Sofintel fails to start or shows a blank window

- Update GPU drivers from Intel, AMD, NVIDIA, or Qualcomm.
- Ensure hardware acceleration is enabled and not blocked by third-party software.
- Try launching with no custom settings or extensions to isolate conflicts.
- Check the development guide if you are running from source: [Building Sofintel for Windows](./development/windows.md).

### Terminal issues

If shell activation scripts do not run, verify that PowerShell or your preferred shell is on `PATH` and that profile scripts are not exiting early.

### SSH remoting problems

If credential prompts do not appear, check for credential manager conflicts and confirm that GUI prompts are not being blocked by your shell or terminal host.

### Graphics issues

Sofintel requires a DirectX 11 compatible GPU to run. If Sofintel fails to open, your GPU may not meet the minimum requirement.

Run:

```text
dxdiag
```

If you are running Sofintel inside a virtual machine, it will use the emulated adapter provided by the VM. The app can run in that environment, but performance may be degraded.
