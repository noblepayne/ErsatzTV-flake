{
  description = "A flake for ErsatzTV: Stream custom live channels using your own media.";
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
    overlays.default = final: prev: {
      ersatztv = final.callPackage ./package.nix {};
    };
    packages = forAllPkgs (pkgs: {
      ersatztv = (self.overlays.default pkgs pkgs).ersatztv;
      default = self.packages.${pkgs.system}.ersatztv;
    });
    nixosModules = {
      default = {
        options,
        config,
        pkgs,
        ...
      }: {
        imports = [./module.nix];
        config.services.ersatztv.package = self.packages.${pkgs.system}.default;
      };
    };
  };
}
