# Vencord Installer (Unofficial fork with macOS CLI support)

The Vencord Installer repo has been rejecting every pull request made in the past year because they're working on a Rust rewrite instead.

I got tired of waiting and wanted a macOS CLI version so I could script/automate patching my Discord app on macOS, since it gets unpatched every time Discord updates the actual app and not the web part. (You can tell when this is about to happen if a Discord update prompts you to enter your macOS password.)

So I made this fork which merges [pull request #176](https://github.com/Vencord/Installer/pull/176), and adds macOS CLI build support, sort of based off of [pull request #168](https://github.com/Vencord/Installer/pull/168) but adjusted to work with the Universal arm64/x64 format.

Basically, I just wanted to be able to quickly do this after every update lol:
```bash
sudo /Applications/VencordInstaller.app/Contents/MacOS/VencordInstallerCli-macOS -install -install-openasar -location "/Applications/Vencord.app"
sudo fileicon set "/Applications/Vencord.app" "/Applications/VencordInstaller.app/Contents/Resources/icon.icns"
```

* For me, `/Applications/Vencord.app` is a copy of `Discord.app` but renamed.
* `fileicon` is this: https://github.com/mklement0/fileicon (you can do `brew install fileicon` or [install it manually](https://github.com/mklement0/fileicon#manual-installation))
* `sudo` is used so I don't have to `sudo chown -R "$(whoami):staff" "/Applications/Vencord.app"` beforehand, since I assume Discord has *some* reason for wanting the app to be `root:wheel`?

## Changes
* macOS builds are now Universal (Intel + Apple silicon).
* macOS CLI build is available, making it easy to automate in a script after Discord updates.
* Windows CLI build is now available in 64-bit.

## Getting the builds
Look in [Releases](https://github.com/comfiestsofa/VencordInstaller/releases).

Included builds:
* macOS Universal (Intel + Apple silicon) CLI (`VencordInstallerCli-macOS`)
* macOS Universal (Intel + Apple silicon) GUI (`VencordInstaller.app` inside `VencordInstaller.MacOS.zip`)
* Windows 64-bit CLI (`VencordInstallerCli64.exe`)
* Windows 32-bit CLI (`VencordInstallerCli.exe`)
* Windows 64-bit GUI (`VencordInstaller.exe`)
* Linux 64-bit CLI (`VencordInstallerCli-linux`)

Or you can run this in Terminal. Works on macOS, Windows (Git Bash, MSYS2), Linux.
```bash
/bin/bash -c "$(curl -fsSL https://github.com/comfiestsofa/VencordInstaller/raw/refs/heads/sofa/install.sh)"
```

There's also a PowerShell version for Windows.
```ps1
& ([scriptblock]::Create((irm "https://github.com/comfiestsofa/VencordInstaller/raw/refs/heads/sofa/install.ps1")))
```
If you are on an older version of Windows, you may need to run this PowerShell command first:
```ps1
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
```

## Building from source on macOS
Install [Homebrew](https://brew.sh/), then run in Terminal:
```bash
./make-build-all-from-macos.sh
```
Or if you want to build only a specific version:
```
./make-build-macos-cli-gui-from-macos.sh
./make-build-windows-cli-from-macos.sh
./make-build-linux-cli-from-macos.sh
```

I'm too dumb to figure out how to build Windows GUI or Linux X11/Wayland GUI from macOS, sorry. Just use the GitHub Actions builds [in the Releases](https://github.com/comfiestsofa/VencordInstaller/releases).

## Disclaimer
**This is an unofficial fork. Please do not bother Vencord developers about any issues in this fork.**

The original README is attached below this line. Please note that the build instructions seem to be a little outdated/incomplete, I recommend reading [.github/workflows/release.yml](.github/workflows/release.yml) instead.

---

# Vencord Installer

The Vencord Installer allows you to install [Vencord, the cutest Discord Desktop client mod](https://github.com/Vendicated/Vencord)

![image](https://user-images.githubusercontent.com/45497981/226734476-5fb42420-844d-4e27-ae06-4799118e086e.png)

## Usage

See https://vencord.dev/download

## Building from source

### Prerequisites 

You need to install the [Go programming language](https://go.dev/doc/install) and GCC, the GNU Compiler Collection (MinGW on Windows)

<details>
<summary>Additionally, if you're using Linux, you have to install some additional dependencies:</summary>

#### Base dependencies
```sh
apt install -y pkg-config libsdl2-dev libglx-dev libgl1-mesa-dev
dnf install pkg-config libGL-devel libXxf86vm-devel
```

#### X11 dependencies
```sh
apt install -y xorg-dev
dnf install libXcursor-devel libXi-devel libXinerama-devel libXrandr-devel
```

#### Wayland dependencies
```sh
apt install -y libwayland-dev libxkbcommon-dev wayland-protocols extra-cmake-modules
dnf install wayland-devel libxkbcommon-devel wayland-protocols-devel extra-cmake-modules
```

</details>

### Building

#### Install dependencies

```sh
go mod tidy
```

#### Build the GUI

##### Windows / Mac / Linux X11
```sh
go build
```

##### Linux Wayland
```sh
go build --tags wayland
```

#### Build the CLI
```
go build --tags cli
```

You might want to pass some flags to this command to get a better build.
See [the GitHub workflow](https://github.com/Vendicated/VencordInstaller/blob/main/.github/workflows/release.yml) for what flags I pass or if you want more precise instructions
