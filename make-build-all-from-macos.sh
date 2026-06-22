#!/usr/bin/env bash

echo "Building macOS CLI/GUI from macOS..."
./make-build-macos-cli-gui-from-macos.sh

echo "Building Windows CLI from macOS..."
./make-build-windows-cli-from-macos.sh

echo "Building Linux CLI from macOS..."
./make-build-linux-cli-from-macos.sh

echo "Building Windows GUI from macOS is not supported in this script. Sorry."
echo "Building Linux X11 GUI from macOS is not supported in this script. Sorry."
echo "Building Linux Wayland GUI from macOS is not supported in this script. Sorry."

exit
