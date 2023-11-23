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
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          release-plz = pkgs.release-plz;
          default = pkgs.release-plz;
        };
    }) // {
    overlays.default = final: prev: {
      release-plz = prev.callPackage ./package.nix { };
    };
  };
}
