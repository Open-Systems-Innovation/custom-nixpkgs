{
  description = "Custom nixpkgs for OSI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
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
      overlays.default = final: prev: rec {
        hello-nix = prev.callPackage ./pkgs/hello-nix/package.nix { }; 
        dev-env = prev.callPackage ./pkgs/dev-env/package.nix { }; 
        hypre = pkgs.callPackage ./pkgs/hypre/package.nix { };
        scotch = pkgs.callPackage ./pkgs/scotch/package.nix { };
        #libspatialindex = pkgs.callPackage ./pkgs/libspatialindex/package.nix { };
        petsc = pkgs.callPackage ./pkgs/petsc { };
        petsc-project = prev.callPackage ./pkgs/petsc-project/package.nix { };
        pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
          (python-final: python-prev: rec { 
            pylit = pkgs.python3Packages.callPackage ./pkgs/pylit { };
            mpi4py = pkgs.python3Packages.callPackage ./pkgs/mpi4py { };
            petsc4py = pkgs.python3Packages.callPackage ./pkgs/petsc4py {
              inherit petsc; };
            recursivenodes = pkgs.python3Packages.callPackage ./pkgs/recursivenodes { };
            firedrake = prev.python3Packages.callPackage ./pkgs/firedrake {
              inherit mpi4py petsc pylit recursivenodes;}; 
          })
        ];
      
        python3 =
          let
            self = prev.python3.override {
              inherit self;
              packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
            }; in
          self;

  python3Packages = final.python3.pkgs;
      };

      packages.${system} = rec {
        hello-nix = pkgs.callPackage ./pkgs/hello-nix/package.nix { }; 
        dev-env = pkgs.callPackage ./pkgs/dev-env/package.nix { };
        hypre = pkgs.callPackage ./pkgs/hypre/package.nix { };
        scotch = pkgs.callPackage ./pkgs/scotch/package.nix { };
        libspatialindex = pkgs.callPackage ./pkgs/libspatialindex/package.nix { };
        mpi4py = pkgs.python3Packages.callPackage ./pkgs/mpi4py { };
        petsc = pkgs.callPackage ./pkgs/petsc { };
        petsc4py = pkgs.callPackage ./pkgs/petsc4py {
          inherit petsc; };
        pylit = pkgs.python3Packages.callPackage ./pkgs/pylit { };
        recursivenodes = pkgs.python3Packages.callPackage ./pkgs/recursivenodes { };
        firedrake = pkgs.python3Packages.callPackage ./pkgs/firedrake {
          inherit mpi4py petsc pylit recursivenodes; }; 
      };
    };
}
