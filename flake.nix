{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    templates = {
      typescript = {
        path = ./typescript;
        description = "A flake with devenv and typescript enabled";
      };
    };


  };
}
