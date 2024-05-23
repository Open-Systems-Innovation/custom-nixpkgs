{pkgs, ...}:

pkgs.stdenv.mkDerivation {
  pname = "dev-env";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "Open-Systems-Innovation";
    repo = "dev-env";
    rev = "main";
    sha256 = "sha256-6NHSpxyMM3oOXCh2I1EYeRrZQRfC/XNsNWNwrastVtE=";
  };

  nativeBuildInputs = [ pkgs.python3 pkgs.direnv ];

  installPhase = ''
    mkdir -p $out/bin
    cp create_flake.py $out/bin/dev-env
    chmod +x $out/bin/dev-env
  '';
}
