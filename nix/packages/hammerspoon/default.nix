{ stdenv ? (import <nixpkgs> {  }).stdenv
, fetchzip ? (import <nixpkgs> {  }).fetchzip }:

stdenv.mkDerivation {
  pname = "hammerspoon";
  version = "0.9.91";

  src = fetchzip {
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/0.9.97/Hammerspoon-0.9.97.zip";
    sha256 = "sha256-13cGdXjWeig0hUTdiCmiQdq3wcnbPOjnRRAA7hMn690=";
  };

  installPhase = ''
    mkdir -p $out/Applications/Hammerspoon.app
    mv ./* $out/Applications/Hammerspoon.app
    chmod +x "$out/Applications/Hammerspoon.app/Contents/MacOS/Hammerspoon";
  '';

  meta = {
    description = "Staggeringly powerful macOS desktop automation with Lua";
    homepage = "https://www.hammerspoon.org";
  };
}
