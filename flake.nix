{
  description = "green-design flake";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, utils, ... }:
    let
      # put devShell and any other required packages into local overlay
      localOverlay = import ./nix/overlay.nix;

      # if you have additional overlays from other flakes, you may add them here
      allOverlays = [
        localOverlay # this should expose devShell
        (_: _: { repoSrc = toString ./.; } )
      ];

      pkgsForSystem = system: import nixpkgs {
        overlays = allOverlays;
        inherit system;
      };
    # https://github.com/numtide/flake-utils#usage for more examples
    in utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ] (system: rec {
      legacyPackages = pkgsForSystem system;
      packages = utils.lib.flattenTree {
        inherit (legacyPackages) green-design;
      };
      inherit (legacyPackages) devShells;
      defaultPackage = packages.green-design;
      apps.green-design = utils.lib.mkApp { drv = packages.green-design; };  # use as `nix run .#green-design`
      hydraJobs = { inherit (legacyPackages) green-design; };
      checks = { inherit (legacyPackages) green-design; };              # items to be ran as part of `nix flake check`
  }) // {
    # non-system suffixed items should go here
    overlays = {
      local = localOverlay;
    };
    # expose overlay which contains all dependent overlays
    overlay = final: prev: (nixpkgs.lib.composeManyExtensions allOverlays) final prev;
    nixosModule = { config, ... }: { options = {}; config = {};}; # export single module
    nixosModules = {}; # attr set or list
    nixosConfigurations.hostname = { config, pkgs, ... }: {};
  };
}
