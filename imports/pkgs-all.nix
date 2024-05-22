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
      packages = {
        /* this is where you include packages that are
           not in the pkgs/by-name directory. For example:
           example2 = pkgs.callPackage ../pkgs/example2 { };
        */
      };
    };
}
