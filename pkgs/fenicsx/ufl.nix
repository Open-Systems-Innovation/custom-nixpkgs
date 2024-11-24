{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
}:

buildPythonPackage rec {
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

  buildInputs = [
    numpy
  ];
  
  pythonImportsCheck = [ "ufl" ];

  meta = with lib; {
    description = "UFL - Unified Form Language";
    homepage = "https://github.com/FEniCS/ufl";
    maintainers = with maintainers; [  ];
  };
}

