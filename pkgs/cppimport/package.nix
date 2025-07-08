{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "cppimport";
  version = "2024.04.28"; # Update this to the desired version/tag

  src = fetchFromGitHub {
    owner = "tbenthompson";
    repo = "cppimport";
    rev = "9d9c8ef61bb37b2cd76ac5f3154ffbcdf5df7b71"; # Corresponding commit or tag
    sha256 = "sha256-RANDOMPLACEHOLDER=="; # Replace with actual sha256 from `nix-prefetch` or let Nix fail and show it
  };

  format = "pyproject";

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
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

