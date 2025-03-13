{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      devShells.default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          kubectl
          kubernetes-helm
          cilium-cli
          istioctl
          talosctl
          fluxcd
          opentofu
          curl
          jq
          age
          sops
          nodePackages.prettier
        ];
      };
    });
}
