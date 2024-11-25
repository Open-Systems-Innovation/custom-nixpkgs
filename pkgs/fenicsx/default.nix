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
  python312Packages
}:

let
  version = "0.9.0";

  hdf5 = (hdf5-mpi.override { inherit mpi; });

  scotch' = (scotch.override { inherit mpi; });

#  basix-cpp-core = stdenv.mkDerivation rec {
#    pname = "basix";
#    inherit version;
#
#    src = fetchFromGitHub {
#      owner = "FEniCS";
#      repo = pname;
#      rev = "v${version}";
#      sha256 = "sha256-jLQMDt6zdl+oixd5Qevn4bvxBsXpTNcbH2Os6TC9sRQ=";
#    };
#
#    sourceRoot = "${src.name}/cpp";
#
#    nativeBuildInputs = [
#      cmake
#      ninja
#    ];
#
#    propagatedBuildInputs = [
#      blas
#      nanobind
#    ];
#
#    cmakeFlags = [
#      "-DCMAKE_BUILD_TYPE=Release"
#    ];
#
#    meta = with lib; {
#      description = "FEniCSx finite element basis evaluation library";
#      homepage = "https://github.com/FEniCS/basix";
#      license = licenses.mit;
#      maintainers = with maintainers; [  ];
#    };
# };

 # basix = buildPythonPackage rec {
 #   pname = "basix";
 #   inherit version;

 #   src = basix-cpp-core.src;

 #   sourceRoot = "${src.name}/python";

 #   format = "pyproject";

 #   build-system = [ setuptools ];

 #   propagatedBuildInputs = [
 #     basix-cpp-core
 #     scikit-build-core
 #     pathspec
 #     pyproject-metadata
 #     numpy
 #   ];
 #
 #   nativeBuildInputs = [
 #     cmake
 #     ninja
 #   ];   

 #  ## postPatch = ''
 #  ##   sed -i 's|\.\./COPYING*|COPYING|' pyproject.toml
 #  ##   cp ../COPYING* .
 #  ## '';

 #   preBuild = ''
 #     cd ..
 #   '';

 #   meta = with lib; {
 #     description = "Next generation FEniCS Form Compiler for finite element forms";
 #     homepage = "https://github.com/FEniCS/ffcx";
 #     maintainers = with maintainers; [  ];
 #   };
 # };
  
  basix = buildPythonPackage rec {
    pname = "fenics_basix";
    inherit version;

    format = "pyproject";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-KiHhWo7Y86kZRnUq/QWBYIWaL1YE32WlOya8lsMsDtQ=";
    };

    build-system = [ setuptools ];

    propagatedBuildInputs = [
      #basix-cpp-core
      python3
      nanobind
      blas
      scikit-build-core
      pathspec
      pyproject-metadata
      numpy
    ];

    nativeBuildInputs = [
      cmake
      ninja
    ];   

    preBuild = ''
      cd ..
    '';

    meta = with lib; {
      description = "Next generation FEniCS Form Compiler for finite element forms";
      homepage = "https://github.com/FEniCS/ffcx";
      maintainers = with maintainers; [  ];
    };
  };

  ufl = buildPythonPackage rec {
    pname = "ufl";
    version = "2024.2.0";

    format = "pyproject";
    
    src = fetchFromGitHub {
      owner = "FEniCS";
      repo = pname;
      rev = version;
      sha256 = "sha256-YKLTXkN9cIKR545/JRN7zA7dNoVZEVIyO+JaL1V5ajU=";
    };
    
    build-system = [ setuptools ];
    
    propagatedBuildInputs = [ basix ];
    
    pythonImportsCheck = [ "ufl" ];
    
    meta = with lib; {
      description = "UFL - Unified Form Language";
      homepage = "https://github.com/FEniCS/ufl";
      maintainers = with maintainers; [  ];
    };
  };
  
  ffcx = buildPythonPackage rec {
    pname = "fenics_ffcx";
    inherit version;

    format = "pyproject";
    
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-VpBDL9hmTPLTGIU4gxXJyESyG6VYFG7gEixNbvMitM8=";
    };
    
    build-system = [ setuptools ];
    
    propagatedBuildInputs = [
      cffi
      basix
      ufl
    ];
    
    nativeBuildInputs = [
      basix
    ];   
    
    pythonImportsCheck = [ "ffcx" ];
    
    meta = with lib; {
      description = "Next generation FEniCS Form Compiler for finite element forms";
      homepage = "https://github.com/FEniCS/ffcx";
      maintainers = with maintainers; [  ];
    };
  };

  dolfinx-cpp-core = stdenv.mkDerivation rec {
    pname = "dolfinx";
    inherit version;
    
    src = fetchFromGitHub {
      owner = "FEniCS";
      repo = "dolfinx";
      rev = "v${version}";
      hash = "sha256-1MM04Z3C3gD2Bb+Emg8PoHmgsXq0n6RkhFdwNlCJSh4=";
    };
 
    sourceRoot = "${src.name}/cpp";

    propagatedBuildInputs = [
      boost
      ffcx
      hdf5
      mpi4py
      petsc
      petsc4py
      pkg-config
      pugixml
      spdlog
      scotch
    ];
 
    nativeBuildInputs = [
      cmake
    ];

    cmakeFlags = [
      "-DDOLFINX_SKIP_BUILD_TESTS=on" # or else it cant find Scotch
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ];
  };

  dolfinx = buildPythonPackage rec {
    pname = "dolfinx";
    inherit version;

    NIX_DEBUG = 3;
    format = "pyproject";

    src = dolfinx-cpp-core.src;

    sourceRoot = "${src.name}/python";

    propagatedBuildInputs = [
      dolfinx-cpp-core
      mpi
    ];
    
    nativeBuildInputs = [
      cmake
      ninja
    ];

    postPatch = ''
      sed -i 's|\.\./COPYING*|COPYING|' pyproject.toml
      cp ../COPYING* .
    '';

    #dontUseCmakeConfigure = true;

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
    ];

    preBuild = ''
      echo @@@@@@@@@@@@@@@@@@@ PREBUILD @@@@@@@@@@@@@@@@@@@@@
      pwd
      ls
      cd ..
    '';

    meta = {
      description = "Next generation FEniCS problem solving environment";
      homepage = "https://github.com/FEniCS/dolfinx";
      maintainers = with lib.maintainers; [ Open-Systems-Innovation ];
    };
  };
in
dolfinx
