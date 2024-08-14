{ pkgs,
  ...}:

let
  flakeNixContent = builtins.readFile ./dev_flake.nix;
  envrcContent = builtins.readFile ./dev_envrc;
  makefileContent = builtins.readFile ./petsc_makefile;
  mainContent = builtins.readFile ./petsc_make.c;
in
pkgs.writeShellScriptBin "dev-env" ''
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
