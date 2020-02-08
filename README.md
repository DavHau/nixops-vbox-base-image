# Virtualbox Base Image Derivation for NixOps
## Define your own up to date virtualbox base image declaratively for NixOps

### Example Usage in NixOps
```nix
let
  base-image = import (builtins.fetchGit {
    url = "https://github.com/DavHau/nixops-vbox-base-image";
    ref = "v1.0.0";
    rev = "54bad1f546919404c105d1a734d599de87740f56";
  }) {
    pkgs = import <nixpkgs> {};
    # define nixpkgs channel and revision for the base image
    nixpkgs_branch = "nixos-19.09";
    nixpkgs_rev = "c49da6435f314e04fc58ca29807221817ac2ac6b";
  };
in
{
  machine = 
    { config, pkgs, nodes, ... }:
    { deployment.targetEnv = "virtualbox";
      deployment.virtualbox.disks.disk1.baseImage = base-image;
    };
}
```