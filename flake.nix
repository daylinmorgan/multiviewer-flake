{
  description = "multiviewer";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs.lib) genAttrs;
      systems = [ "x86_64-linux" ]; # "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
      forSystem = f: system: f system (import nixpkgs { inherit system; });
      forAllSystems = f: genAttrs systems (forSystem f);
    in
    {
      packages = forAllSystems (
        system: pkgs: {
          multiviewer = pkgs.callPackage ./default.nix { };
          default = self.packages.${system}.multiviewer;
        }
      );
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
