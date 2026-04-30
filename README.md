# Prism Launcher Offline Arch Fix Installer

Automated installer script for `prismlauncher-offline` on Arch Linux. This script fixes common build errors found in the current AUR package.

## 🛠️ Problems Fixed

This script addresses several issues that currently cause the `prismlauncher-offline` AUR package to fail during installation:

1.  **Version Mismatch:** Fixes the error where the PKGBUILD points to version `10.0.2` which no longer exists in the source repository. It updates the build to version `11.0.2`.
2.  **Java Compatibility:** Fixes compilation errors caused by the removal of the `java.applet` package in newer OpenJDK versions (e.g., JDK 26). The script temporarily switches to **JDK 17** for the build process.
3.  **Missing Dependencies:** Automatically installs `vulkan-headers` which is required for the `HardwareInfo` component.
4.  **GNOME Integration:** Applies a specific environment configuration (`WAYLAND_DISPLAY=`, `QT_WAYLAND_DECORATION=adwaita`, `QT_QPA_PLATFORMTHEME=adwaita`) to ensure proper window decorations and stability on GNOME.
5.  **Automatic Sudo:** Designed to run with minimal intervention using a predefined password.

## 🚀 Usage

1.  Clone this repository:
    ```bash
    git clone https://github.com/your-username/prismlauncher-offline-arch-fix-installer.git
    cd prismlauncher-offline-arch-fix-installer
    ```

2.  Run the installer:
    ```bash
    ./install_prismlauncher.sh
    ```

## 📋 Requirements

*   Arch Linux (or Arch-based distro)
*   AUR access (script uses `makepkg`)
*   Sudo privileges

## ⚙️ How it works

The script performs the following steps:
1. Installs necessary build dependencies (`jdk17-openjdk`, `vulkan-headers`, `git`, `base-devel`).
2. Temporarily sets the system's default Java to Version 17.
3. Clones the official AUR `prismlauncher-offline` repository.
4. Patches the `PKGBUILD` to use version `11.0.2` and adds `vulkan-headers` to `makedepends`.
5. Builds and installs the package using `makepkg -si`.
6. Restores your original system Java version.
7. Cleans up temporary build files.

---
**Note:** The script currently uses a hardcoded password for sudo convenience. It is recommended to review the script before running it.
