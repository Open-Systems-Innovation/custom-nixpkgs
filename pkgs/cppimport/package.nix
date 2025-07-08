{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, mako
, pybind11
, filelock
}:

buildPythonPackage rec {
  pname = "cppimport";
  version = "22.8.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u7SVcQLbQbyZrXLCM7zpL50f2RvjUvwHh4xDYQM6QB8=";
  };

  propagatedBuildInputs = [ mako pybind11 filelock ];

  doCheck = false;
  pythonImportsCheck = [ "cppimport" ];

  meta = with lib; {
    description = "Import C++ files directly from Python!";
    homepage = "https://github.com/tbenthompson/cppimport";
    license = licenses.mit;
  };
}

