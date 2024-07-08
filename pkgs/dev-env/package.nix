{ pkgs,
  ...}:

let
  flakeNixContent = builtins.readFile ./dev_flake.nix;
  envrcContent = builtins.readFile ./dev_envrc;
in
pkgs.writeShellScriptBin "dev-env" ''
  cat <<'EOF' > flake.nix
    ${flakeNixContent}
  EOF
  cat <<'EOF' > .envrc
    ${envrcContent}
  EOF
  direnv allow
''
