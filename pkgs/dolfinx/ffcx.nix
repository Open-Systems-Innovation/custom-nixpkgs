{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cffi,
  numpy,
  basix,
  ufl,
}:

buildPythonPackage rec {
  pname = "fenics_ffcx";
  version = "0.9.0";
  format = "pyproject";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VpBDL9hmTPLTGIU4gxXJyESyG6VYFG7gEixNbvMitM8=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    cffi
    numpy
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
}
