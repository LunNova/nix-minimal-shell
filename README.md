# nix-minimal-shell

nix-minimal-shell provides a small devShell implementation that sets a minimal set of environment variables.

This is useful if you want to use a devShell in your flake with direnv and don't want to clutter the env with a pile of Nix specific vars.

```
$ direnv reload
direnv: export ~PATH ~XDG_DATA_DIRS
```

## Usage

Use something like this. For non-flake users you can fetch this repo and `import ${fetch...}/minimal-shell.nix` to get the same function.

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

[Here's an example usage in my nixos-configs flake.](https://github.com/LunNova/nixos-configs/blob/d6c22273f42f6f5abb56a7b56cfeb1c0438f9b51/per-system.nix#L70-L74)
