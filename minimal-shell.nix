{ pkgs
, shellHooks ? ""
, system ? pkgs.system ? builtins.currentSystem
, passthru ? { }
, shellPackages ? [ ]
, ...
}@args:
let
  stdenv = pkgs.writeTextFile {
    name = "naked-stdenv";
    destination = "/setup";
    text = ''
      # Fix for `nix develop`
      : ''${outputs:=out}
      runHook() {
        eval "$shellHook"
        unset runHook
      }
    '';
  };
  profile = pkgs.buildEnv {
    name = "lun-nixos-configs-shell-env";
    paths = [ ];
  };
  bashPath = "${args.pkgs.bashInteractive}/bin/bash";
in
derivation ({
  inherit stdenv;
  inherit (pkgs) system;
  args = [ "-ec" "${args.pkgs.coreutils}/bin/ln -s ${profile} $out; exit 0" ];
  name = "lun-nixos-configs";
  builder = bashPath;
  shellHook = ''
    if [[ "$SHELL" == "/noshell" ]]; then
      export SHELL=${bashPath}
    fi
    PS1="$(if [[ ''${EUID} == 0 ]]; then echo '\[\033[01;31m\]!DEVSHELL'; else echo '\[\033[01;32m\]\u!DEVSHELL'; fi)\[\033[01;34m\] \w \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\$\[\033[00m\] "

    ${shellHooks}

    # Remove all the unnecessary noise that is set by the build env
    unset NIX_BUILD_TOP NIX_BUILD_CORES NIX_STORE
    unset TEMP TEMPDIR TMP TMPDIR
    unset builder name out shellHook stdenv system
    # Flakes stuff
    unset dontAddDisableDepTrack outputs
    # don't need this to stick around, it gets added to PATH by this point
    unset nativeBuildInputs
  '';
  nativeBuildInputs = shellPackages;
} // passthru)
