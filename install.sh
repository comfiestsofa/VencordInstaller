#!/bin/sh
set -e

if [ "$(id -u)" -eq 0 ]; then
    echo "Run me as normal user, not root!"
    exit 1
fi

if grep -q "CHROMEOS_RELEASE_NAME" /etc/lsb-release 2>/dev/null; then
	echo "ChromeOS is not supported! Use the chrome extension. https://chromewebstore.google.com/detail/vencord-web/cbghhgpcnddeihccjmnadmkaejncjndb"
	exit 1
fi

outfile=$(mktemp --tmpdir="$HOME")
trap 'rm -f "$outfile"' EXIT

echo "Downloading Installer..."

set -- "XDG_CONFIG_HOME=$XDG_CONFIG_HOME"

if [[ "$OSTYPE" == "darwin"* ]]; then
  curl -sS https://github.com/comfiestsofa/VencordInstaller/releases/latest/download/VencordInstallerCli-macOS \
    --output "$outfile" \
    --location \
    --fail

  "$outfile"
elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
  # https://stackoverflow.com/a/8597411
  curl -sS https://github.com/comfiestsofa/VencordInstaller/releases/latest/download/VencordInstallerCli.exe \
    --output "$outfile" \
    --location \
    --fail

  "$outfile"
else
  curl -sS https://github.com/comfiestsofa/VencordInstaller/releases/latest/download/VencordInstallerCli-Linux \
    --output "$outfile" \
    --location \
    --fail

  chmod +x "$outfile"

  if command -v sudo >/dev/null; then
    echo "Running with sudo"
    sudo env "$@" "$outfile"
  elif command -v doas >/dev/null; then
    echo "Running with doas"
    doas env "$@" "$outfile"
  elif command -v run0 >/dev/null; then
    echo "Running with run0"
    run0 env "$@" "$outfile"
  elif command -v pkexec >/dev/null; then
    echo "Running with pkexec"
    pkexec env "$@" "SUDO_USER=$(whoami)" "$outfile"
  else
    echo "Neither sudo nor doas were found. Please install either of them to proceed."
  fi
fi

exit
