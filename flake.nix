{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Everything your flake provides
  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        # This combined with the flake-utils package abstracts what architecture you are building for
        pkgs = import nixpkgs { inherit system; };

        # Its not in nixpkgs so we have to fetch from source
        rigol-dgx_pkg = pkgs.python3.pkgs.buildPythonPackage {
          pname = "rigol-dgx"; # So it knows what to build
          version = "0.1.0"; # Meta data stuffs
          pyproject = true; # So it knows how to build
          sourceRoot = "source/rigol-dgx"; # So it knows where it needs to build from

          src = "./"

          buildInputs = with pkgs.python3.pkgs; [
            wheel
          ];

          # Optional data for nix tooling stuffs
          meta = with pkgs.lib; {
            description = "Python automation API for Rigol DGX series AWGs";
            homepage = "idk";
            license = licenses.mit;
          };

          doCheck = false; # TODO: Add tests?
        };

        # Shrimple dev shell to allow for local debug
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3.pkgs; [
            wheel
          ];

          packages = [
            rigol-dgx_pkg
          ];

          shellHook = ''
            echo "Dev shell for rigol-dgx ready"
          '';
        };

        # Overlay to extend nixpkgs in other flakes
        overlay = final: prev: {
          # The // is merging the prev version of python3Packages and exporting the merge as the final version
          python3Packages = prev.python3Packages // {
            rigol-dgx = rigol-dgx_pkg;
          };
        };

      in {
        packages.default = rigol-dgx_pkg;
        devShells.default = devShell;
        overlays.default = overlay;
      }
    );
}
