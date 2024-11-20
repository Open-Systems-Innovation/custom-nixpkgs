{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  boost,
  mpi4py,
  parmetis,
  petsc,
  petsc4py,
  cmake,
  python3,
  pkg-config,
  pugixml,
  spdlog,
  mpi,
  hdf5-mpi,
  cffi,
  nanobind,
  numpy,
  scikit-build-core,
}:

let
  hdf5 = (hdf5-mpi.override { inherit mpi; });

  cppdrv = stdenv.mkDerivation rec {
    pname = "fenics";
    version = "v0.9.0";
    
    src = fetchFromGitHub {
      owner = "FEniCS";
      repo = "dolfinx";
      rev = "${version}";
      hash = "sha256-abxk1hD1SO1PfzrqLCYd2lbHiZE+7ahOzIau3OW95U4=";
    };

    buildInputs = [
      boost
      cmake
      hdf5
      mpi4py
      parmetis
      petsc
      petsc4py
      pkg-config
      pugixml
      spdlog
    ];

    nativeBuildInputs = [
      cmake
    ];

  };
in

buildPythonPackage rec {
  pname = "";
  version = "";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FEniCS";
    repo = "dolfinx";
    rev = version;
    hash = "sha256-kXiWRRccv3ZI0v6efJRLYJ2Swx60W3QUtM1AEF6IMpo=";
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
    maintainers = with lib.maintainers; [ Open-Systems-Innovation ];
  };
}
