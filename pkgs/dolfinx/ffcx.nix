{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cffi,
  numpy,
  basix,
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

#  ffcx = stdenv.mkDerivation rec {
#    pname = "ffcx";
#    version = "0.9.0";
#    
#    src = fetchFromGitHub {
#      owner = "FEniCS";
#      repo = pname;
#      rev = "v${version}";
#      sha256 = "sha256-eAV//RLbrxyhqgbZ2DiR7qML7xfgPn0/Seh+2no0x8w=";
#    };
# 
#    prePatch = ''
#      cd cmake
#    '';   
#
#    buildInputs = [ ];
# 
#    nativeBuildInputs = [
#      cmake
#    ];   
}
