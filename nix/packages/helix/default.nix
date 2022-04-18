{ fetchFromGitHub ? (import <nixpkgs> {  }).fetchFromGitHub,
  lib ? (import <nixpkgs> {  }).lib,
  rustPlatform ? (import <nixpkgs> {  }).rustPlatform,
  makeWrapper ? (import <nixpkgs> {  }).makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "22.03";

  src = fetchFromGitHub {
    owner = "helix-editor";
    repo = pname;
    rev = "${version}";
    fetchSubmodules = true;
    sha256 = "sha256-anUYKgr61QQmdraSYpvFY/2sG5hkN3a2MwplNZMEyfI=";
  };

  cargoSha256 = "sha256-zJQ+KvO+6iUIb0eJ+LnMbitxaqTxfqgu7XXj3j0GiX4=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/lib
    cp -r runtime $out/lib
  '';
  postFixup = ''
    wrapProgram $out/bin/hx --set HELIX_RUNTIME $out/lib/runtime
  '';

  meta = with lib; {
    description = "A post-modern modal text editor";
    homepage = "https://helix-editor.com";
    license = licenses.mpl20;
    mainProgram = "hx";
    maintainers = with maintainers; [ yusdacra ];
  };
}
