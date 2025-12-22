{
  stdenv,
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem,
}: let
  pname = "helium-browser";
  version = "0.5.8.1";

  architectures = {
    "x86_64-linux" = {
      arch = "x86_64";
      hash = "sha256-d8kwLEU6qgEgp7nlEwdfRevB1JrbEKHRe8+GhGpGUig=";
    };
    "aarch64-linux" = {
      arch = "arm64";
      hash = "sha256-KfQlOT4mMKQ40B8hWl+GlmRNVhZnEln59ptfXN0XCLc=";
    };
  };

  src = let
    inherit (architectures.${stdenv.hostPlatform.system}) arch hash;
  in
    fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${arch}.AppImage";
      inherit hash;
    };

  desktopItem = makeDesktopItem {
    name = "Helium";
    exec = pname;
    icon = pname;
    desktopName = "Helium";
    genericName = "Web Browser";
    categories = ["Network" "WebBrowser"];
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      install -Dm444 ${desktopItem}/share/applications/* $out/share/applications/
    '';

    meta = {
      description = "A Chromium-based browser focused on privacy";
      homepage = "https://github.com/imputnet/helium-linux";
      platforms = lib.attrNames architectures;
    };
  }
