{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  userConfig,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.home-manager.nixosModules.home-manager

    ../../modules/nixos/default.nix

    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use most recent linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs = {
    overlays = [ ];
    # Configure your nixpkgs instance
    config = {
      # Allow unfree packages
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        warn-dirty = false;
        experimental-features = "nix-command flakes";
        flake-registry = "";
      };
      # Opinionated: disable channels
      channel.enable = false;

      # TODO: Update nix config so that if nh module is enabled then it will use
      # nh's garbage collection service, otherwise it will nix's default garbage
      # collection service.

      optimise = {
        automatic = true;
        dates = [ "03:45" ];
      };

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    dates = "03:00";
    randomizedDelaySec = "45min";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  networking.hostName = userConfig.hostName;
  networking.networkmanager.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users = {
    ${userConfig.user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "audio"
      ];
      shell = pkgs.zsh;
    };
  };

  services.getty.autologinUser = userConfig.user;

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs userConfig;
    };
    users = {
      ${userConfig.user} = import ./home.nix;
    };
  };

  # Install zsh
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    curl
    git
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ ];
  };

  programs.dconf.enable = true;
  services.tailscale.enable = true;

  hyprland.enable = false;
  steam.enable = false;

  microcode = {
    enable = true;
    cpuSerialNumber = "00A6-0F12-0000-0000-0000-0000";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
