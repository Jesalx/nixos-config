# NixOS Configuration

This repository contains my personal Nix configurations for:

- Personal x86 desktop running NixOS
- Personal Apple Silicon MacBook using Home Manager
- Work Apple Silicon MacBook using Home Manager

## Installation

### NixOS

To install on a NixOS system:

```bash
git clone git@github.com:Jesalx/nixos-config.git ~/nixos-config
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#default
```

### macOS

For macOS systems, first install the Nix package manager. You have two options:

1. [Official Nix installer](https://nixos.org/download/#download-nixos)
2. [Determinate Systems Nix installer](https://github.com/DeterminateSystems/nix-installer) (Recommended)

Using the Determinate Systems installer should eliminate the need for extra experimental features flags in the following commands.

Next, [install Home Manager](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone):

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

After installing Nix and Home Manager, set up the configuration:

```bash
git clone git@github.com:Jesalx/nixos-config.git ~/nixos-config
cd ~/nixos-config
home-manager switch -b backup --flake .#PROFILE --extra-experimental-features nix-command --extra-experimental-features flakes
```

Replace `PROFILE` with the appropriate profile name for the device.

## Next Steps

### SSH Keys

If you haven't already, then you should generate an SSH key pair.

```bash
ssh-keygen -t ed25519 -C "mail@jesal.dev"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

## Useful Commands

For convenience, several custom commands that wrap the regular nix commands are available to help manage your Nix environment:

| Command     | Description                                                                                           |
| ----------- | ----------------------------------------------------------------------------------------------------- |
| `jp-test`   | Tests the current configuration without making retaining changes on reboot.                           |
| `jp-switch` | Builds and activates the current configuration, making it the new default at boot.                    |
| `jp-update` | Update the flake and apply changes (equivalent to running `nix flake update` followed by `jp-switch`) |
| `jp-clean`  | Cleans up old generations of your nix/home-manager profiles and optimizes the Nix store.              |
