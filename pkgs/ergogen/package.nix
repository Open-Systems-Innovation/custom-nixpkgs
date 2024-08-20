{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "ergogen";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "ergogen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Y4Ri5nLxbQ78LvyGARPxsvoZ9gSMxY14QuxZJg6Cu3Y=";
  };

  npmDepsHash = "sha256-BQbf/2lWLYnrSjwWjDo6QceFyR+J/vhDcVgCaytGfl0=";

  forceGitDeps = true;
  makeCacheWritable = true;
  
  meta = {
    description = "Ergonomic Keyboard Generator";
    homepage = "https://docs.ergogen.xyz/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ opensourceinnovations ];
  };
}
