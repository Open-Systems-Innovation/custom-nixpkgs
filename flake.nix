{
  description = "Custom nixpkgs for OSI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs,  ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      overlays.default = final: prev: {
        hello-nix = prev.pkgs.callPackage ./pkgs/by-name/hello-nix/package.nix { }; 
      };

      packages.${system} = {
        hello-nix = pkgs.callPackage ./pkgs/by-name/hello-nix/package.nix { }; 
      };

      #packages =
      #  # the following will automatically add any
      #  # package from custom-nixpkgs/pkgs/by-name/ 
      #  let
      #    scope = nixpkgs.lib.makeScope nixpkgs.newScope (self: {
      #      inherit inputs;
      #    });
      #  in
      #  nixpkgs.lib.filesystem.packagesFromDirectoryRecursive {
      #    inherit (scope) callPackage;
      #    directory = ../pkgs/by-name;
      #  }

      #imports = [
      #  ./imports/formatter.nix
      #  ./imports/pkgs-by-name.nix
      #  ./imports/pkgs-all.nix
      #];
    };
}
