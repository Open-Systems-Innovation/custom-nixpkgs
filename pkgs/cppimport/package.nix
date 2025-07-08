{
  lib,
  python311Packages,
  buildPythonPackage,
  fetchPypi
}:

buildPythonPackage rec {
  pname = "cppimport";
  version = "22.8.2"; # Update this to the desired version/tag
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u7SVcQLbQbyZrXLCM7zpL50f2RvjUvwHh4xDYQM6QB8="; # Replace with actual sha256 from `nix-prefetch` or let Nix fail and show it
  };

  propagatedBuildInputs = with python311Packages; [
    mako
    pybind11
    filelock
  ];

  # Optional: if tests are available and desired
  doCheck = false; # set to true if you want to run tests
  pythonImportsCheck = [ "cppimport" ];

  meta = with lib; {
    description = "Import C++ files directly from Python!";
    homepage = "https://github.com/tbenthompson/cppimport";
    license = licenses.mit;
  };
}

