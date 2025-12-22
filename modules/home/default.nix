{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./cli/default.nix
    ./gui/default.nix
    ./extra/default.nix
  ];
}
