{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux"];
    pkgsBySystem = nixpkgs.lib.getAttrs supportedSystems nixpkgs.legacyPackages;
    forAllPkgs = fn: nixpkgs.lib.mapAttrs (_: pkgs: (fn pkgs)) pkgsBySystem;
  in {
    formatter = forAllPkgs (pkgs: pkgs.alejandra);
    packages = forAllPkgs (pkgs: {
      ErsatzTV = pkgs.callPackage ./package.nix {};
      default = self.packages.${pkgs.system}.ErsatzTV;
    });
  };
}
