{
  description = "A collection of hyenas flake templates";


  outputs = { self }: {

    templates = {
      typescript = {
        path = ./typescript;
        description = "A flake with devenv and typescript enabled";
      };

      gleam = {
        path = ./gleam;
        description = "A flake with devenv and gleam enabled";
      };

      gleam-lustre = {
        path = ./gleam-lustre;
        description = "A flake with devenv and gleam + lustre enabled";
      };
    };

    defaultTemplate = self.templates.typescript;
  };
}
