{
  lib,
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

  basix = stdenv.mkDerivation rec {
    pname = "basix";
    version = "0.9.0";

    src = fetchFromGitHub {
      owner = "FEniCS";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-jLQMDt6zdl+oixd5Qevn4bvxBsXpTNcbH2Os6TC9sRQ=";
    };

    nativeBuildInputs = [
      cmake
    ];

    buildInputs = [
      blas
      nanobind
    ];

    meta = with lib; {
      description = "FEniCSx finite element basis evaluation library";
      homepage = "https://github.com/FEniCS/basix";
      license = licenses.mit;
      maintainers = with maintainers; [  ];
    };
  };

  cppdrv = stdenv.mkDerivation rec {
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
      hdf5
      mpi4py
      petsc
      petsc4py
      pkg-config
      pugixml
      scotch'
      spdlog
      basix
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
    cppdrv
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
