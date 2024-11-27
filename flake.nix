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
        config.allowUnfree = true;
      };
    in
    {
      overlays.default = final: prev: rec {
        dev-env = prev.callPackage ./pkgs/dev-env/package.nix { }; 
        ergogen = prev.callPackage ./pkgs/ergogen/package.nix { };
        hello-nix = prev.callPackage ./pkgs/hello-nix/package.nix { }; 
        hypre = prev.callPackage ./pkgs/hypre/package.nix { };
        mpi = prev.callPackage ./pkgs/mpi { };
        scotch = prev.callPackage ./pkgs/scotch/package.nix { };
        #libspatialindex = pkgs.callPackage ./pkgs/libspatialindex/package.nix { };
        petsc = prev.callPackage ./pkgs/petsc {
          inherit mpi;
        };
        petsc-project = prev.callPackage ./pkgs/petsc-project/package.nix { };
        petscrc-update = prev.callPackage ./pkgs/petscrc-update/package.nix { };
        waybar-weather = prev.callPackage ./pkgs/waybar-weather { };

        #petsc4py = prev.python311Packages.callPackage ./pkgs/petsc4py { inherit petsc; };
        
        #mpi4py = prev.python311Packages.callPackage ./pkgs/mpi4py { };
        python311 = prev.python311.override {
          packageOverrides = py-final: _: rec {
            fenicsx = py-final.callPackage ./pkgs/fenicsx {
              inherit mpi petsc petsc4py mpi4py;
            };

            mpi4py = py-final.callPackage ./pkgs/mpi4py { };
            petsc4py = py-final.callPackage ./pkgs/petsc4py { inherit petsc; };
          };
        };
#        pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
#          (python-final: python-prev: rec { 
#            fenicsx = python-final.callPackage ./pkgs/fenicsx {
#              inherit mpi petsc petsc4py mpi4py nanobind;
#            };
#            pylit = python-final.callPackage ./pkgs/pylit { };
#            mpi4py = python-final.callPackage ./pkgs/mpi4py { };
#            nanobind = python-final.callPackage ./pkgs/nanobind { };
#            petsc4py = python-final.callPackage ./pkgs/petsc4py {
#              inherit petsc;
#            };
#            recursivenodes = python-final.callPackage ./pkgs/recursivenodes { };
#            firedrake = python-final.callPackage ./pkgs/firedrake {
#              inherit mpi4py petsc pylit recursivenodes;}; 
#          })
#        ];
#        python3 =
#          let
#            self = prev.python3.override {
#              inherit self;
#              packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
#            }; in
#          self;
#        python3Packages = final.python3.pkgs;
      # Python extensions
#      pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
#        (python-final: python-prev: rec {
#          # Custom Python packages
#          fenicsx = python-prev.fenicsx.callPackage ./pkgs/fenicsx {
#            inherit mpi petsc petsc4py mpi4py nanobind;
#          };
#          pylit = python-final.callPackage ./pkgs/pylit { };
#          mpi4py = python-final.callPackage ./pkgs/mpi4py { };
#          #nanobind = python-final.callPackage ./pkgs/nanobind { };
#          petsc4py = python-final.callPackage ./pkgs/petsc4py { inherit petsc; };
#          recursivenodes = python-final.callPackage ./pkgs/recursivenodes { };
#          firedrake = python-final.callPackage ./pkgs/firedrake {
#            inherit mpi4py petsc pylit recursiven"odes;
#          };
#        })
#      ];
#      
#      # Extend Python 3 packages with the extensions
#      python3 = prev.python3.override {
#        packageOverrides = prev.lib.composeExtensions prev.pythonPackagesExtensions;
#      };
#      python3Packages = final.python3.pkgs;
    };

    packages.${system} = rec {
      hello-nix = pkgs.callPackage ./pkgs/hello-nix/package.nix { }; 
      numpy2 = pkgs.callPackage ./pkgs/numpy2 { };
      dev-env = pkgs.callPackage ./pkgs/dev-env/package.nix { };
      fenicsx = pkgs.python311Packages.callPackage ./pkgs/fenicsx {
        inherit mpi petsc petsc4py mpi4py nanobind;
      };
      ergogen = pkgs.callPackage ./pkgs/ergogen/package.nix { };
      hypre = pkgs.callPackage ./pkgs/hypre/package.nix { };
      scotch = pkgs.callPackage ./pkgs/scotch/package.nix { };
      libspatialindex = pkgs.callPackage ./pkgs/libspatialindex/package.nix { };
      mpi = pkgs.callPackage ./pkgs/mpi { };
      mpi4py = pkgs.python3Packages.callPackage ./pkgs/mpi4py { };
      nanobind = pkgs.python3Packages.callPackage ./pkgs/nanobind { };
      petsc = pkgs.callPackage ./pkgs/petsc { };
      petsc-project = pkgs.callPackage ./pkgs/petsc-project/package.nix { };
      petscrc-update = pkgs.callPackage ./pkgs/petscrc-update/package.nix { };
      petsc4py = pkgs.python3Packages.callPackage ./pkgs/petsc4py {
        inherit petsc; };
      pylit = pkgs.python3Packages.callPackage ./pkgs/pylit { };
      recursivenodes = pkgs.python3Packages.callPackage ./pkgs/recursivenodes { };
      firedrake = pkgs.python3Packages.callPackage ./pkgs/firedrake {
        inherit mpi4py petsc pylit recursivenodes nanobind; }; 
      waybar-weather = pkgs.callPackage ./pkgs/waybar-weather { };
    };
  };
}
