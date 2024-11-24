{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,

  blas,
  cmake,
  setuptools,
  nanobind,
  scikit-build-core,
  ninja,
  pathspec,
  pyproject-metadata,
  numpy
}:

let
  basix-cpp = stdenv.mkDerivation rec {
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
      ninja
    ];

    buildInputs = [
      blas
      nanobind
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
    ];

    meta = with lib; {
      description = "FEniCSx finite element basis evaluation library";
      homepage = "https://github.com/FEniCS/basix";
      license = licenses.mit;
      maintainers = with maintainers; [  ];
    };
  };
in
buildPythonPackage rec {
    pname = "fenics_basix";
    version = "0.9.0";
    format = "pyproject";
    
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-KiHhWo7Y86kZRnUq/QWBYIWaL1YE32WlOya8lsMsDtQ=";
    };

    preBuild = ''
      cd ..
    '';

    build-system = [ setuptools ];

    buildInputs = [
      basix-cpp
      scikit-build-core
      nanobind
      blas
      pathspec
      pyproject-metadata
      numpy
    ];
 
    nativeBuildInputs = [
      cmake
      ninja
    ];   

    nativeCheckInputs = [ ];

    meta = with lib; {
      description = "Next generation FEniCS Form Compiler for finite element forms";
      homepage = "https://github.com/FEniCS/ffcx";
      maintainers = with maintainers; [  ];
    };
}
