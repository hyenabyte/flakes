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
    templates = {
      gleam = {
        path = ./gleam;
        description = "A flake with devenv and gleam enabled";
      };
    };
    templates = {
      gleam-lustre = {
        path = ./gleam-lustre;
        description = "A flake with devenv and gleam + lustre enabled";
      };
    };


  };
}
