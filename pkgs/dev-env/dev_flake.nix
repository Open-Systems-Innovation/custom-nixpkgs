{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    custom-nixpkgs.url = "github:Open-Systems-Innovation/custom-nixpkgs";
  };

  outputs = { self, nixpkgs, custom-nixpkgs, ... }:
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ custom-nixpkgs.overlays.default ];
        };
      in
        {
          devShells.\${system}.default = pkgs.mkShell {
            name = "default";
               
            packages = [
            # General packages
              pkgs.hello-nix

              # Python packages
              #(pkgs.python3.withPackages (python-pkgs: [
              #  # packages for formatting/ IDE
              #  python-pkgs.pip
              #  python-pkgs.python-lsp-server
              #  # packages for code
              #  python-pkgs.gmsh
              #  python-pkgs.matplotlib
              #  python-pkgs.meshio
              #  python-pkgs.numpy
              #]))
            ];

            shellHook = ''
                export PS1="\[\e[0;32m\][dev-shell]$\[\e[0;36m\] "
            '';
          };
        };
}