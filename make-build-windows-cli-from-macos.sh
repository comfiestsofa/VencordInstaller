#!/usr/bin/env bash
# Based off of .github/workflows/release.yml

# Delete old build folder
if [ -d "build" ]; then
	rm -rf "build/windows-"*
fi

# Install Go and dependencies
brew install go pkg-config sdl2

# Install build dependencies
go get -v

export RELEASE_TAG="$(git describe --always --tags)"

# Windows CLI (i386)
mkdir -p build/windows-i386
CGO_ENABLED=0 GOOS=windows GOARCH=386 go build -buildvcs=false -v -tags "static cli" -ldflags "-s -w -extldflags=-static -X 'vencordinstaller/buildinfo.InstallerGitHash=$(git rev-parse --short HEAD)' -X 'vencordinstaller/buildinfo.InstallerTag=${RELEASE_TAG}'" -o build/windows-i386/VencordInstallerCli.exe

# Windows CLI (amd64)
mkdir -p build/windows-amd64
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -buildvcs=false -v -tags "static cli" -ldflags "-s -w -extldflags=-static -X 'vencordinstaller/buildinfo.InstallerGitHash=$(git rev-parse --short HEAD)' -X 'vencordinstaller/buildinfo.InstallerTag=${RELEASE_TAG}'" -o build/windows-amd64/VencordInstallerCli64.exe

exit
