{
  description = "Minimalist replacement for pkgs.mkShell for devShells";

  outputs = flake-args:
    {
      lib = {
        minimal-shell = import ./minimal-shell.nix;
      };
    };
}
