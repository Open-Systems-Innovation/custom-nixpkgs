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
  ninja,
  pathspec,
  pyproject-metadata,
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

  ufl = callPackage ./ufl.nix { };
  
  ffcx = callPackage ./ffcx.nix { inherit basix ufl; };

  cpp-core = stdenv.mkDerivation rec {
    pname = "dolfinx-cpp";
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
      spdlog
      basix
    ];
 
    nativeBuildInputs = [
      cmake
      scotch
    ];
  
    cmakeFlags = [
      "-DDOLFINX_SKIP_BUILD_TESTS=on"
      "-DCMAKE_BUILD_TYPE=Release"
    ];

    fixupPhase = ''
    pwd
    ls
   '';
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

  preBuild = ''
    pwd
    ls
    cd ../../python
  '';

  buildInputs = [
    cpp-core
    cffi
    nanobind
    numpy
    scikit-build-core
    mpi4py
    scotch
    pathspec
    pyproject-metadata
    mpi
    spdlog
    pugixml
    boost
    basix
    hdf5
    ffcx
    ufl
    pkg-config
    petsc4py
    petsc
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    "-DDOLFINX_SKIP_BUILD_TESTS=on"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  preConfigure = ''
    pwd
    ls
    cd cpp
  '';

  installPhase = ''
    echo SSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
    pwd
    ls
  '';
  meta = {
    description = "Next generation FEniCS problem solving environment";
    homepage = "https://github.com/FEniCS/dolfinx";
    maintainers = with lib.maintainers; [ Open-Systems-Innovation ];
  };
}
