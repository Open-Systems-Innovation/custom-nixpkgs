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
    sha256 = "sha256-6NHSpxyMM3oOXCh2I1EYeRrZQRfC/XNsNWNwrastVtE=";
  };

  dontUnpack = true;

  buildPhase = ''
    echo "WORKING DIRECTORY FOR NIX: "
    pwd
  '';
    
  installPhase = ''
    install -Dm755 ${./create_flake.py} $out/bin/${pname}
    mkdir -p $out/bin
    cp create_flake.py $out/bin/dev-env
    chmod +x $out/bin/dev-env
  '';
}
