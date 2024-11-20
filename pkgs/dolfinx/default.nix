{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  python3,
  mpi,
  hdf5-mpi,
}:

let
  hdf5 = (hdf5-mpi.override { inherit mpi; });

  cppdrv = stdenv.mkDerivation {
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

  src = fetchFromGitlab {
    owner = "FEniCS";
    repo = "dolfinx";
    rev = version;
    hash = "sha256-kXiWRRccv3ZI0v6efJRLYJ2Swx60W3QUtM1AEF6IMpo=";
  };

  buildInputs = [
    cppdrv
    python312Packages.cffi
    python312Packages.nanobind
    numpy
    scikit-build-core
    mpi4py
  ];

  meta = {
    maintainers = with lib.maintainers; [ Open-Systems-Innovation ];
  };
}
