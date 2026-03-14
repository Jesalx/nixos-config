{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    rust.enable = lib.mkEnableOption "enables Rust development tools";
  };
  config = lib.mkIf config.rust.enable {
    home.packages = with pkgs; [
      rustc
      cargo
      rust-analyzer
      rustfmt
      clippy
      lld
    ];
  };
}
