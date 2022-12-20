# nix-minimal-shell

nix-minimal-shell provides a small devShell implementation that sets a minimal set of environment variables.

This is useful if you want to use a devShell in your flake with direnv and don't want to clutter the env with a pile of Nix specific vars.

```
$ direnv reload
direnv: export ~PATH ~XDG_DATA_DIRS
```

## Usage

```nix
{
    devShell.${system} = flakeArgs.minimal-shell.lib.minimal-shell {
      inherit pkgs;
      # add the shell hook from pre-commit-check so pre-commit is applied in this shell
      # and sets up hooks
      shellHooks = self.checks.${system}.pre-commit-check.shellHook;
      # add nixpkgs-fmt so it's available in the shell
      shellPackages = [ perSystemSelf.pkgs.nixpkgs-fmt ];
    };
}
```
