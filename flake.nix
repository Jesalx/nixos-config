{
  description = "Jesal's NixOS configuration flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS hardware
    hardware.url = "github:NixOS/nixos-hardware/master";

    # AMD microcode updates
    ucodenix.url = "github:e-tho/ucodenix";

    # Neovim nightly
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    userConfig = {
      default = {
        profile = "default";
        user = "jesal";
        hostName = "nixos";
        gitEmail = "mail@jesal.dev";
      };
    };
    overlays = {
      helium = final: _: {
        helium = final.callPackage ./packages/helium {};
      };
    };
  in {
    inherit overlays;

    homeManagerModules = ./modules/home;

    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          userConfig = userConfig.default;
        };
        modules = [./hosts/default/configuration.nix];
      };
    };
  };
}
