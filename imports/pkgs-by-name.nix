{ inputs, lib, ... }:
{

  perSystem =
    {
      config,
      self',
      inputs',
      pkgs,
      system,
      ...
    }:
    {
      packages =
        # the following will automatically add any
        # package from custom-nixpkgs/pkgs/by-name/ 
        let
          scope = lib.makeScope pkgs.newScope (self: {
            inherit inputs;
          });
        in
        lib.filesystem.packagesFromDirectoryRecursive {
          inherit (scope) callPackage;
          directory = ../pkgs/by-name;
        };
    };
}
