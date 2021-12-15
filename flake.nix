{
  description = "Minimalist replacement for pkgs.mkShell for devShells";

  outputs =
    { self, ... }@args:
    {
      lib = {
        minimal-shell = import ./minimal-shell.nix;
      };
    };
}
