#! /bin/sh -eu

# make gcroot for each dependency of shell and run nix-shell
#usage
# nix_shell_pin.sh SHELL_FILE [gcpath]
gcroot=${2:-$PWD}

mkdir -p $gcroot
nix-instantiate $1 --indirect --add-root $gcroot/.gcroots/shell.drv
nix-store --indirect --add-root $gcroot/.gcroots/shell.dep --realise $(nix-store --query --references $gcroot/.gcroots/shell.drv)
if type zsh; then
    exec nix-shell $(readlink $gcroot/.gcroots/shell.drv) --command "echo 'Entering zsh';zsh"
else
    exec nix-shell $(readlink $gcroot/.gcroots/shell.drv) --command "echo 'Entering bash';bash"
fi
