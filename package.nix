{ pkgs, ... }:
let
  lib = pkgs.lib;
  pname = "release-plz";
  version = "0.3.30";
in
with pkgs;
with lib;
rustPlatform.buildRustPackage rec {
  name = pname;
  inherit version;
  src = fetchFromGitHub {
    owner = "MarcoIeni";
    repo = pname;
    rev = "${pname}-v${version}";
    sha256 = "sha256-LVsvS/bmjdFVHq5r0T9g05Vd/uBL7fl7LE0rGqrWWlU=";
  };

  cargoSha256 = "sha256-LeD2pvazy872T8DTFbUCiC1JD35YfCqMCCQ1omhsabk=";

  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl.dev
    curl
  ] ++ (lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [
    Security
    SystemConfiguration
  ]));

  dontCheck = true;
}
