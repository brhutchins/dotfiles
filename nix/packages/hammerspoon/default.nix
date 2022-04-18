{ stdenv ? (import <nixpkgs> {  }).stdenv
, fetchzip ? (import <nixpkgs> {  }).fetchzip }:

stdenv.mkDerivation {
  pname = "hammerspoon";
  version = "0.9.91";

  src = fetchzip {
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/0.9.94/Hammerspoon-0.9.94.zip";
    sha256 = "sha256-l2oTMujRpZre/NOO7uHJfxd8wFdRHLEVtfSQ0gj5C5U=";
  };

  installPhase = ''
    # mkdir -p $out/bin
    # cp ./Contents/Resources/extensions/hs/ipc/bin/hs $out/bin
    mkdir -p $out/Applications/Hammerspoon.app
    mv ./* $out/Applications/Hammerspoon.app
    chmod +x "$out/Applications/Hammerspoon.app/Contents/MacOS/Hammerspoon";
  '';

  meta = {
    description = "Staggeringly powerful macOS desktop automation with Lua";
    homepage = "https://www.hammerspoon.org";
  };
}
