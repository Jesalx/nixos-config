{ config, lib, ... }:
{
  options.userConfig = {
    profile = lib.mkOption {
      type = lib.types.str;
      default = "default";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "jesal";
    };
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
    };
    gitEmail = lib.mkOption {
      type = lib.types.str;
      default = "jesalx@users.noreply.github.com";
    };
  };
  config = { };
}
