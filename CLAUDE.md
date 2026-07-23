# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal NixOS configuration flake for a single x86 desktop (hostname `nixos`,
AMD CPU/GPU, Hyprland/Wayland desktop). Built with `nixpkgs` unstable +
`home-manager` (as a NixOS module). A shared `dotfiles/` tree also supports
bootstrapping a bare macOS machine without Nix.

## Commands

This repo uses [Task](https://taskfile.dev) (`task <name>`); all tasks run
`git add --intent-to-add .` first because a flake only sees files git tracks.

- `task test` — build the config without activating (`nh os test`).
- `task switch` — build and activate (`nh os switch`).
- `task update` — update the flake lockfile and switch (`nh os switch -u`).
  Use `task update:fallback` if binary substitutes fail and you need to build
  from source.
- `task lint` — the full check suite (run before proposing a change is done):
  `alejandra --check`, `statix check`, `deadnix --fail`, `stylua --check` and
  `selene` (over `dotfiles/nvim`), `actionlint`, and `nix flake check --no-build`.
  `hosts/default/hardware-configuration.nix` is excluded from statix/deadnix.
- `task clean` — garbage-collect old generations.

`hardware-configuration.nix` is machine-generated; do not hand-edit or lint it.
Raw equivalents: `nixos-rebuild switch --flake .#default` or `nh os switch`.

## Architecture

`flake.nix` is the single entry point. It defines:
- `userConfig` — a small attrset (`user`, `hostName`, `gitEmail`, `profile`)
  threaded to every module via `specialArgs` / `extraSpecialArgs`, so hardcoded
  usernames/paths should instead read from `userConfig`.
- `overlays.helium` — exposes `packages/helium` as `pkgs.helium`.
- `homeManagerModules = ./modules/home` — the home-manager module tree, imported
  by `hosts/default/home.nix` via `outputs.homeManagerModules`.
- `nixosConfigurations.default` — the one host, built from
  `hosts/default/configuration.nix`.

Two module trees, same conventions:
- `modules/nixos/` — system-level config, imported by `configuration.nix`, which
  also wires home-manager in as a NixOS module (`useGlobalPkgs`,
  `useUserPackages`).
- `modules/home/` — home-manager config, split into `cli/`, `gui/`, `extra/`.

### Module pattern

Every leaf module defines a top-level `<name>.enable` option and gates its body
on it. Note options live at the config root (e.g. `go.enable`), NOT under
`programs`/`services`:

```nix
{ pkgs, lib, config, ... }: {
  options.go.enable = lib.mkEnableOption "enables Go development tools";
  config = lib.mkIf config.go.enable {
    home.packages = with pkgs; [ go_1_26 gopls ];
  };
}
```

Each directory's `default.nix` imports its leaf modules and turns them on with
`<name>.enable = lib.mkDefault true;`. To add a module: create the file with its
`enable` option, then add both an import and a `mkDefault` line to the sibling
`default.nix`.

### Dotfiles are symlinked, not copied

Configs under `dotfiles/` (nvim, claude, zsh) are linked into `$HOME` with
`config.lib.file.mkOutOfStoreSymlink` (see `modules/home/cli/neovim.nix`,
`claude.nix`). Edits to those files take effect immediately without a rebuild,
since the symlink points at the working tree rather than the Nix store. Prefer
this pattern for editor/tool configs you iterate on frequently.

### Custom packages

`packages/<name>/default.nix` holds derivations for things not in nixpkgs (e.g.
the Helium browser AppImage). Surface them to the system through an overlay in
`flake.nix` and the `nixpkgs.overlays` list in `configuration.nix`.
