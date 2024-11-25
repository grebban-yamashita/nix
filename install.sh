#!/bin/sh

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install  --determinate

xcode-select --install

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

nix run nix-darwin -- switch --flake .#work
