{
  description = "Custom nixpkgs for OSI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs,  ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      overlays.default = final: prev: {
        hello-nix = prev.callPackage ./pkgs/hello-nix/package.nix { }; 
        firedrake = prev.python3Packages.callPackage ./pkgs/firedrake { }; 
        dev-env = prev.callPackage ./pkgs/dev-env/package.nix { }; 
      };

      packages.${system} = {
        custom-libspatialindex = pkgs.callPackage ./pkgs/custom-libspatialindex/package.nix { };
        hello-nix = pkgs.callPackage ./pkgs/dev-env/package.nix { }; 
        firedrake = pkgs.python3Packages.callPackage ./pkgs/firedrake { }; 
        dev-env = pkgs.callPackage ./pkgs/dev-env/package.nix { }; 
      };

    };
}
