#!/usr/bin/env bash
# Based off of .github/workflows/release.yml

# Delete old build folder
if [ -d "build" ]; then
	rm -rf "build/macos-"*
fi

# Install Go and dependencies
brew install go pkg-config sdl2

# Install build dependencies
go get -v

export RELEASE_TAG="$(git describe --always --tags)"

# macOS GUI and CLI amd64 (Intel)
mkdir -p build/macos-amd64
MACOSX_DEPLOYMENT_TARGET=10.8 CGO_ENABLED=1 GOOS=darwin GOARCH=amd64 go build -buildvcs=false -v -tags static -ldflags "-s -w -X 'vencordinstaller/buildinfo.InstallerGitHash=$(git rev-parse --short HEAD)' -X 'vencordinstaller/buildinfo.InstallerTag=${RELEASE_TAG}'" -o build/macos-amd64/VencordInstaller
MACOSX_DEPLOYMENT_TARGET=10.8 CGO_ENABLED=1 GOOS=darwin GOARCH=amd64 go build -buildvcs=false -v -tags "static cli" -ldflags "-s -w -X 'vencordinstaller/buildinfo.InstallerGitHash=$(git rev-parse --short HEAD)' -X 'vencordinstaller/buildinfo.InstallerTag=${RELEASE_TAG}'" -o build/macos-amd64/VencordInstallerCli-macOS
chmod +x build/macos-amd64/VencordInstaller
chmod +x build/macos-amd64/VencordInstallerCli-macOS

# macOS GUI and CLI arm64 (Apple silicon)
mkdir -p build/macos-arm64
MACOSX_DEPLOYMENT_TARGET=11.0 CGO_ENABLED=1 GOOS=darwin GOARCH=arm64 go build -buildvcs=false -v -tags static -ldflags "-s -w -X 'vencordinstaller/buildinfo.InstallerGitHash=$(git rev-parse --short HEAD)' -X 'vencordinstaller/buildinfo.InstallerTag=${RELEASE_TAG}'" -o build/macos-arm64/VencordInstaller
MACOSX_DEPLOYMENT_TARGET=11.0 CGO_ENABLED=1 GOOS=darwin GOARCH=arm64 go build -buildvcs=false -v -tags "static cli" -ldflags "-s -w -X 'vencordinstaller/buildinfo.InstallerGitHash=$(git rev-parse --short HEAD)' -X 'vencordinstaller/buildinfo.InstallerTag=${RELEASE_TAG}'" -o build/macos-arm64/VencordInstallerCli-macOS
chmod +x build/macos-arm64/VencordInstaller
chmod +x build/macos-arm64/VencordInstallerCli-macOS

# macOS GUI Universal (Intel and Apple silicon)
mkdir -p build/macos-universal
lipo -create \
	build/macos-amd64/VencordInstaller \
	build/macos-arm64/VencordInstaller \
	-output build/macos-universal/VencordInstaller
chmod +x build/macos-universal/VencordInstaller

# macOS CLI Universal (Intel and Apple silicon)
lipo -create \
	build/macos-amd64/VencordInstallerCli-macOS \
	build/macos-arm64/VencordInstallerCli-macOS \
	-output build/macos-universal/VencordInstallerCli-macOS
chmod +x build/macos-universal/VencordInstallerCli-macOS

# macOS .app folder
mkdir -p build/macos-universal/VencordInstaller.app/Contents/MacOS
mkdir -p build/macos-universal/VencordInstaller.app/Contents/Resources
cp macos/Info.plist build/macos-universal/VencordInstaller.app/Contents/Info.plist
mv build/macos-universal/VencordInstaller build/macos-universal/VencordInstaller.app/Contents/MacOS/VencordInstaller
cp build/macos-universal/VencordInstallerCli-macOS build/macos-universal/VencordInstaller.app/Contents/MacOS/VencordInstallerCli-macOS
cp macos/icon.icns build/macos-universal/VencordInstaller.app/Contents/Resources/icon.icns

# Package macOS stuff up
cd build/macos-universal
zip -r VencordInstaller.MacOS.zip VencordInstaller.app VencordInstallerCli-macOS

exit
