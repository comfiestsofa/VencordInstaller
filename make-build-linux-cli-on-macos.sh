#!/usr/bin/env bash
# Based off of .github/workflows/release.yml

# Delete old build folder
if [ -d "build" ]; then
	rm -rf "build/linux-"*
fi

# Install Go and dependencies
brew install go pkg-config sdl2

# Install build dependencies
go get -v

export RELEASE_TAG="$(git describe --always --tags)"

# Linux CLI (amd64)
mkdir -p build/linux-amd64
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -buildvcs=false -v -tags "static cli" -ldflags "-s -w -X 'vencordinstaller/buildinfo.InstallerGitHash=$(git rev-parse --short HEAD)' -X 'vencordinstaller/buildinfo.InstallerTag=${RELEASE_TAG}'" -o build/linux-amd64/VencordInstallerCli-linux
chmod +x build/linux-amd64/VencordInstallerCli-linux

exit
