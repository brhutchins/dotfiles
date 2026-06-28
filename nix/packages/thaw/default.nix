{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "thaw";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/stonerl/Thaw/releases/download/${version}/Thaw_${version}.zip";
    hash = "sha256-1n9NMe+foFeEmphUC4EM+kLgvGYBnTYFq9CORcaaoG8=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    runHook preInstall

    unzip -qq "$src"
    mkdir -p "$out/Applications"
    cp -R "Thaw.app" "$out/Applications/"

    runHook postInstall
  '';

  meta = {
    description = "Menu bar manager for macOS";
    homepage = "https://github.com/stonerl/Thaw";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.darwin;
    mainProgram = "Thaw";
  };
}
