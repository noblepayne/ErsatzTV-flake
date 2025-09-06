{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    forAllPkgs = fn: (builtins.mapAttrs (_: pkgs: (fn pkgs)) nixpkgs.legacyPackages);
  in {
    formatter = forAllPkgs (pkgs: pkgs.alejandra);
    packages = forAllPkgs (pkgs: {
      ersatz = pkgs.callPackage ./package.nix {};
      default = self.packages.${pkgs.system}.ersatz;
    });
  };
}
