# haskell-flake configuration goes in this module.

{ root, inputs, ... }:
{
  imports = [
    inputs.haskell-flake.flakeModule
    ../../../flake-module.nix
  ];
  perSystem = { self', lib, config, pkgs, ... }: {
    haskellProjects.default = {
      # To avoid unnecessary rebuilds, we filter projectRoot:
      # https://community.flake.parts/haskell-flake/local#rebuild
      projectRoot = builtins.toString (lib.fileset.toSource {
        inherit root;
        fileset = lib.fileset.unions [
          (root + /src)
          (root + /hint-nix.cabal)
          (root + /LICENSE)
          (root + /README.md)
        ];
      });

      # Add your package overrides here
      settings = {
        hint-nix = {
          stan = true;
        };
      };

      # What should haskell-flake add to flake outputs?
      autoWire = [ "packages" "apps" "checks" ]; # Wire all but the devShell
    };

    # Default package.
    packages.default = self'.packages.hint-nix;
  };
}
