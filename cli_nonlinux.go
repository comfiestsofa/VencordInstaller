//go:build !linux

package main

func ParseDiscordNew(p, branch string, isFlatpak bool) *DiscordInstall {
	return nil;
}
