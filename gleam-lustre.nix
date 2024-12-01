{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
        devenv-test = self.devShells.${system}.default.config.test;
      });

      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                (
                  let
                    gleam-bin = "${pkgs.gleam}/bin/gleam";
                    linux-only-packages =
                      if pkgs.stdenv.isLinux
                      then [ pkgs.inotify-tools ]
                      else [ ];
                  in
                  {
                    packages = [
                      pkgs.deno
                      pkgs.nodejs-slim
                    ] ++ linux-only-packages;
                    languages.gleam.enable = true;
                    languages.erlang.package = pkgs.erlang_27;

                    scripts.lustre.exec = ''
                      ${gleam-bin} run -m lustre/dev "$@";
                    '';

                    scripts.dev.exec = ''
                      ${gleam-bin} run -m lustre/dev start;
                    '';

                    scripts.build.exec = ''
                      ${gleam-bin} run -m lustre/dev build;
                    '';

                    scripts.build-static.exec = ''
                      ${gleam-bin} run -m build;
                    '';

                    scripts.serve.exec = ''
                      ${pkgs.deno}/bin/deno --allow-net --allow-read --allow-sys https://deno.land/std/http/file_server.ts ./priv;
                    '';

                    scripts.clean.exec = ''
                      rm -rf priv;
                      rm -rf build;
                    '';

                    process.manager.implementation = "process-compose";
                    processes.lustre_dev_tools = {
                      exec = ''
                        ${gleam-bin} run -m lustre/dev start;
                      '';
                    };
                  }
                )
              ];
            };
          });
    };
}
