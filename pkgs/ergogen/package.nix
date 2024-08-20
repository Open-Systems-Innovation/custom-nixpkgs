{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "ergoname";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "ergogen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BR+ZGkBBfd0dSQqAvujsbgsEPFYw/ThrylxUbOksYxM=";
  };

  meta = {
    description = "Ergonomic Keyboard Generator";
    homepage = "https://docs.ergogen.xyz/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ opensourceinnovations ];
  };
}
