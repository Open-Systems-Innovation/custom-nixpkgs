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
        hello-nix = prev.callPackage ./pkgs/by-name/hello-nix/package.nix { }; 
        firedrake = prev.callPackage ./pkgs/by-name/firedrake { }; 
        dev-env = prev.callPackage ./pkgs/by-name/dev-env/package.nix { }; 
      };

      packages.${system} = {
        hello-nix = pkgs.callPackage ./pkgs/by-name/hello-nix/package.nix { }; 
        firedrake = pkgs.callPackage ./pkgs/by-name/firedrake { };
        dev-env = pkgs.callPackage ./pkgs/by-name/dev-env/package.nix { };
      };

    };
}
