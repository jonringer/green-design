prev: final: {
  green-design = prev.callPackage ./green-design.nix { };

  devShells.default = prev.callPackage ./dev-shell.nix { };
}
