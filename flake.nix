{
  description = "Nix flake for editing content";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          typst
          tinymist
        ];
        shellHook = ''
          exec fish
        '';
      };
    };
}