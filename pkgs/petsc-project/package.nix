{ pkgs,
  ...}:

let
  flakeNixContent = builtins.readFile ./petsc_flake.nix;
  envrcContent = builtins.readFile ./petsc_envrc;
  makefileContent = builtins.readFile ./petsc_makefile;
  mainContent = builtins.readFile ./petsc_main.c;
in
pkgs.writeShellScriptBin "petsc-project" ''
  cat <<'EOF' > flake.nix
    ${flakeNixContent}
  EOF
  cat <<'EOF' > .envrc
    ${envrcContent}
  EOF
  cat <<'EOF' > makefile
    ${makefileContent}
  EOF
  cat <<'EOF' > main.c
    ${mainContent}
  EOF
  direnv allow
''
