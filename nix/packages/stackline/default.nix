{ stdenv ? (import <nixpkgs> {  }).stdenv
, fetchFromGitHub ? (import <nixpkgs> {  }).pkgs.fetchFromGitHub
, pkgs  ? (import <nixpkgs> {  }).pkgs }:

let
  pname = "stackline";
  version = "0.1.61";
in
stdenv.mkDerivation {
  pname = pname;
  version = version;

  src = fetchFromGitHub {
    owner = "AdamWagner";
    repo = "stackline";
    rev = "b02ffe763b2cdf3a8b73255937bea49f071e6bbd";
    sha256 = "sha256-oorQm+OpLOFh+aF4NDRimvnltS/bOlQYUZ1QqeeWlDY=";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p "$out"
    cp -pR * "$out/"
  '';

  meta = {
    description = "Visualize yabai window stacks on macOS. Works with yabai & hammerspoon.";
    homepage = "https://github.com/AdamWagner/stackline";
  };
}
