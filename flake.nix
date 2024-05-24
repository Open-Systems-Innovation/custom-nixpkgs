{
  description = "Custom nixpkgs for OSI";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { flake-parts, systems, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
        ./imports/overlay.nix
        ./imports/formatter.nix
        ./imports/pkgs-by-name.nix
        ./imports/pkgs-all.nix
      ];
    };
}
