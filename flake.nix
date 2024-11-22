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
      userConfig = {
        default = {
          profile = "default";
          user = "jesal";
          hostName = "nixos";
          gitEmail = "mail@jesal.dev";
        };
        mac = {
          profile = "mac";
          user = "jesal";
          hostName = "jesals-mbp";
          gitEmail = "mail@jesal.dev";
        };
        work = {
          profile = "work";
          user = "patel";
          hostName = "patel-MBP";
          gitEmail = "mail@jesal.dev";
        };
      };
    in
    {
      homeManagerModules = ./modules/home;

      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            userConfig = userConfig.default;
          };
          modules = [ ./hosts/default/configuration.nix ];
        };
      };

      # MacOS home manager configuration
      homeConfigurations = {
        "mac" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit inputs;
            userConfig = userConfig.mac;
          };
          modules = [ ./hosts/mac/configuration.nix ];
        };
        "work" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit inputs;
            userConfig = userConfig.work;
          };
          modules = [ ./hosts/work/configuration.nix ];
        };
      };
    };
}
