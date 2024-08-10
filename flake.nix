{
  description = "Jesal's NixOS configuration flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS hardware
    hardware.url = "github:NixOS/nixos-hardware/master";

    # AMD microcode updates
    ucodenix.url = "github:e-tho/ucodenix";
    ucodenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hosts/default/configuration.nix
            ./modules/nixos/default.nix
          ];
        };
      };
      homeManagerModules.default = ./modules/home/default.nix;

      # MacOS home manager configuration
      homeConfigurations = {
        "work" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            (
              { pkgs, ... }:
              {
                nix.package = pkgs.nix;
                home.username = "patel";
                home.homeDirectory = "/Users/patel";
                imports = [ ./hosts/work/home.nix ];
              }
            )
          ];
        };
      };
    };
}
