{ pkgs ? import <nixpkgs> {},
  nixpkgs_branch ? "nixos-19.09",
  nixpkgs_rev ? "274e095f761b2da76a376d105c41591739350b14"
}:

let
  nixpkgs_vbox_src = builtins.fetchGit {
    url="https://github.com/NixOS/nixpkgs";
    rev=nixpkgs_rev;
    ref=nixpkgs_branch;
  };
  machine = import "${nixpkgs_vbox_src}/nixos" {
    system = "x86_64-linux";
    configuration = import "${pkgs.nixops}/share/nix/nixops/virtualbox-image-nixops.nix";
  };
  ova = machine.config.system.build.virtualBoxOVA;

in
pkgs.runCommand 
  "virtualbox-nixops-image-${machine.config.system.nixos.version}"
  { nativeBuildInputs = [ ova ]; }
  ''
    mkdir ova
    tar -xf ${ova}/*.ova -C ova
    mv ova/nixos*.vmdk $out
  ''

