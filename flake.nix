{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem
    (system: {

      packages =
        let
          pkgs = import nixpkgs { inherit system; };
          lib = pkgs.lib;
          pname = "release-plz";
          version = "0.3.30";
        in
        with pkgs;
        with lib;
        rec {
          release-plz = pkgs.rustPlatform.buildRustPackage
            rec {
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
            };

          default = release-plz;
        };
    });
}
