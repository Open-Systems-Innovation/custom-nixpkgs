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

      packages.${system} = rec {
        hello-nix = pkgs.callPackage ./pkgs/hello-nix/package.nix { }; 
        dev-env = pkgs.callPackage ./pkgs/dev-env/package.nix { };
        hypre = pkgs.callPackage ./pkgs/hypre/package.nix { };
        scotch = pkgs.callPackage ./pkgs/scotch/package.nix { };
        libspatialindex = pkgs.callPackage ./pkgs/libspatialindex/package.nix { };
        mpi4py = pkgs.python3Packages.callPackage ./pkgs/mpi4py { };
        petsc = pkgs.callPackage ./pkgs/petsc { inherit hypre scotch; };
        pylit = pkgs.callPackage ./pkgs/pylit { };
        recursivenodes = pkgs.python3Packages.callPackage ./pkgs/recursivenodes { };
        firedrake = pkgs.python3Packages.callPackage ./pkgs/firedrake { inherit mpi4py petsc libspatialindex pylit recursivenodes; }; 
      };
    };
}
