{ pkgs,
  ...}:

let
  flakeNixContent = builtins.readFile ./dev_flake.nix;
in
pkgs.writeShellScriptBin "dev-env" ''
  echo "${flakeNixContent}" > flake.nix
  echo "use flake" > .envrc
''
