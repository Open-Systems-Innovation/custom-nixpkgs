{ pkgs,
  python3Packages,
  ...}:

python3Packages.buildPythonApplication rec {
  pname = "dev-env";
  version = "0.0.1";
  format = "other";

  src = pkgs.fetchFromGitHub {
    owner = "Open-Systems-Innovation";
    repo = "dev-env";
    rev = "main";
    sha256 = "sha256-DTpyiXApr1+f3cFGTt096FjRES33pZlN7onsNhjzjOg=";
    
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src/create_flake.py $out/bin/${pname}
    cp flake.nix $out/bin/flake.nix
  '';
}
