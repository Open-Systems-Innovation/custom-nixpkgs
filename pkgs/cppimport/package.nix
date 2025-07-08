{ lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  mako,
  pybind11,
  filelock,
  setuptools_scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "cppimport";
  version = "22.8.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u7SVcQLbQbyZrXLCM7zpL50f2RvjUvwHh4xDYQM6QB8=";
  };

  build-system = [
    setuptools
    setuptools_scm
    wheel
  ];

  propagatedBuildInputs = [ mako pybind11 filelock ];

  doCheck = false;
  pythonImportsCheck = [ "cppimport" ];

  meta = with lib; {
    description = "Import C++ files directly from Python!";
    homepage = "https://github.com/tbenthompson/cppimport";
    license = licenses.mit;
  };
}

