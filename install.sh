#!/bin/sh

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install

xcode-select --install

nix run nix-darwin -- switch --flake .#work
