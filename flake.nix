{
  description = "Custom nixpkgs for OSI";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { flake-parts,  ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ]; # also "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
        ./imports/overlay.nix
        ./imports/formatter.nix
        ./imports/pkgs-by-name.nix
        ./imports/pkgs-all.nix
      ];
    };
}
