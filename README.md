# NixOS Configuration

This repository contains my personal Nix configurations for:

- Personal x86 desktop running NixOS

## Installation

### NixOS

To install on a NixOS system:

```bash
git clone git@github.com:Jesalx/nixos-config.git ~/nixos-config
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#default
```

## Next Steps

### SSH Keys

If you haven't already, then you should generate an SSH key pair.

```bash
ssh-keygen -t ed25519 -C "mail@jesal.dev"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```
