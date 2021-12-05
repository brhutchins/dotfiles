{ stdenv ? (import <nixpkgs> {  }).stdenv
, fetchurl ? (import <nixpkgs> {  }).fetchurl
, pkgs  ? (import <nixpkgs> {  }).pkgs }:

stdenv.mkDerivation {
  pname = "bitwarden";
  version = "1.29.1";

  src = fetchurl {
    url = "https://github.com/bitwarden/desktop/releases/download/v1.29.1/Bitwarden-1.29.1.dmg";
    sha256 = "01hsalmiq4s6y9fd265lb8pkbyp8v9zgzxkyhkx5d9zgd093vh7h";
  };

  buildInputs = with pkgs; [ undmg unzip  ];

  sourceRoot = "./Bitwarden.app";

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p "$out/Applications/Bitwarden.app"
    cp -pR * "$out/Applications/Bitwarden.app"
  '';

  meta = {
    description = "The desktop vault (Windows, macOS, & Linux).";
    homepage = "https://bitwarden.com/";
  };
}
