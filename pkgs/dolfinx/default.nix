{
  lib,
  callPackage,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,

  boost,
  blas,
  mpi4py,
  petsc,
  petsc4py,
  cmake,
  python3,
  pkg-config,
  pugixml,
  setuptools,
  spdlog,
  scotch,
  mpi,
  hdf5-mpi,
  cffi,
  nanobind,
  numpy,
  scikit-build-core,
}:

let
  hdf5 = (hdf5-mpi.override { inherit mpi; });

  scotch' =
    (scotch.override {
      inherit mpi;
      #withIntSize64 = with64BitIndices;
    }).overrideAttrs
      (attrs: {
        buildFlags = [ "ptesmumps esmumps" ];
      });

  basix = callPackage ./basix.nix { inherit nanobind; };

  ffcx = callPackage ./ffcx.nix { };

  cpp-core = stdenv.mkDerivation rec {
    pname = "dolfinx";
    version = "v0.9.0";
    
    src = fetchFromGitHub {
      owner = "FEniCS";
      repo = "dolfinx";
      rev = version;
      hash = "sha256-1MM04Z3C3gD2Bb+Emg8PoHmgsXq0n6RkhFdwNlCJSh4=";
    };
 
    prePatch = ''
      cd cpp
    '';
 
    buildInputs = [
      boost
      ffcx
      hdf5
      mpi4py
      petsc
      petsc4py
      pkg-config
      pugixml
      scotch'
      spdlog
      basix
      #basix-cpp
    ];
 
    nativeBuildInputs = [
      cmake
    ];
 
 };
in

buildPythonPackage rec {
  pname = "dolfinx";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FEniCS";
    repo = "dolfinx";
    rev = "v${version}";
    hash = "sha256-1MM04Z3C3gD2Bb+Emg8PoHmgsXq0n6RkhFdwNlCJSh4=";
  };

  buildInputs = [
    cpp-core
    cffi
    nanobind
    numpy
    scikit-build-core
    mpi4py
  ];

  meta = {
    description = "Next generation FEniCS problem solving environment";
    homepage = "https://github.com/FEniCS/dolfinx";
    maintainers = with lib.maintainers; [ Open-Systems-Innovation ];
  };
}
