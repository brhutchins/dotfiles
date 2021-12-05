# Currently broken because undmg doesn't support signed dmgs
# TODO: fork undmg?

{ stdenv ? (import <nixpkgs> {  }).stdenv
, fetchurl ? (import <nixpkgs> {  }).fetchurl
, pkgs }:

stdenv.mkDerivation {
  pname = "kitty";
  version = "0.23.1";

  src = fetchurl {
    url = "https://github.com/kovidgoyal/kitty/releases/download/v0.23.1/kitty-0.23.1.dmg";
    sha256 = "03wyhddbsj16rp1j5hxb61bib5ma50qpl3wrwx8j4yj901ypm650";
  };

  buildInputs = with pkgs; [ undmg unzip  ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/Applications/Kitty.app
  '';

  meta = {
    description = "Cross-platform, fast, feature-rich, GPU based terminal";
    homepage = "https://sw.kovidgoyal.net/kitty/";
  };
}
