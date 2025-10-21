{
lib,
unzip,
autoPatchelfHook,
stdenv,
fetchurl,
xorg,
libgbm,
cairo,
libudev-zero,
libxkbcommon,
nspr,
nss,
libsForQt5,
libcupsfilters,
qt6,
pango
 }:

stdenv.mkDerivation rec {
    name = "Helium";
    version = "0.4.7.1";

    src = fetchurl {
	url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
        sha256 = "sha256:1a475cacdfdc900dbaa905a476f5ae82e9d62a30af735b92c456dbc3171b44b2";
    };

    nativeBuildInputs = [ 
        unzip
        autoPatchelfHook
    ];
    
    buildInputs = [
        unzip
        xorg.libxcb
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        libgbm
        cairo
        pango
        libudev-zero
        libxkbcommon
        nspr
        nss
        libsForQt5.qtbase
        qt6.full
        libcupsfilters
        qt6.wrapQtAppsHook
    ];

    installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        mv * $out/bin/
        mv $out/bin/chrome $out/bin/${name}
        mkdir -p $out/share/applications
        
        cat <<INI> $out/share/applications/${name}.desktop
[Desktop Entry]
Name=${name}
GenericName=Web Browser
Terminal=false
Icon=$out/bin/product_logo_256.png
Exec=$out/bin/${name}
Type=Application
Categories=Network;WebBrowser;
INI
        '';


    meta = with lib; {
        homepage = "https://github.com/imputnet/helium-linux";
        description = "A description of your application";
        platforms = platforms.linux;
    };
}
