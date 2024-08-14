{ pkgs,
  ...}:

let
  flakeNixContent = builtins.readFile ./dev_flake.nix;
  envrcContent = builtins.readFile ./dev_envrc;
  makefileContent = builtins.readFile ./petsc_makefile;
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
  direnv allow
''
