{
  #** For help, see:
  #* https://ryantm.github.io/nixpkgs/builders/fetchers/

  description = "https://github.com/mutagen-io/mutagen";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        #@@ Variables: Base
        pkgs = import nixpkgs { inherit system; };
        stdenv = pkgs.stdenv;

        #@@ Programs
        programs = {
          # https://release.ariga.io/atlas/atlas-linux-amd64-v0.24.0
          atlas-go = {
            name = "atlas-go";
            repo = "https://release.ariga.io/atlas";
            version = "v0.24.0";
            tag = "v0.24.0";
            archMap = {
              aarch64-darwin = {
                hash = "sha256-MqwTLEYwKJHfOXWJW8SQ6asweZTX7Ki45Jj2EQuf5ts=";
                name = "darwin-arm64";
                ext = "";
              };
              x86_64-darwin = {
                hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
                name = "darwin-amd64";
                ext = "";
              };
              x86_64-linux = {
                hash = "sha256-v080WO4zcA8CCKIr0v/Sh2mlKz47nS/jfGoaWHELwQ4=";
                name = "linux-amd64";
                ext = "";
              };
              x86_64-windows = {
                hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
                name = "windows-amd64";
                ext = ".exe";
              };
            };
          };
          hasura-cli = {
            name = "hasura-cli";
            repo = "https://github.com/hasura/graphql-engine";
            version = "v2.38.0";
            tag = "v2.38.0";
            archMap = {
              aarch64-darwin = {
                hash = "sha256-MqwTLEYwKJHfOXWJW8SQ6asweZTX7Ki45Jj2EQuf5ts=";
                name = "darwin-arm64";
                ext = "";
              };
              x86_64-darwin = {
                hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
                name = "darwin-amd64";
                ext = "";
              };
              x86_64-linux = {
                hash = "sha256-v080WO4zcA8CCKIr0v/Sh2mlKz47nS/jfGoaWHELwQ4=";
                name = "linux-amd64";
                ext = "";
              };
              x86_64-windows = {
                hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
                name = "windows-amd64";
                ext = ".exe";
              };
            };
          };
          mutagen = {
            name = "mutagen";
            repo = "https://github.com/mutagen-io/mutagen";
            version = "v0.17.5";
            tag = "v0.17.5";
            archMap = {
              aarch64-darwin = {
                hash = "sha256-nvvhd/Q20E2OOO5tvSP0a9TRgC3qKFYWbPKVlUPY1A0=";
                name = "darwin_arm64";
                ext = ".tar.gz";
              };
              x86_64-darwin = {
                hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
                name = "darwin_amd64";
                ext = ".tar.gz";
              };
              x86_64-linux = {
                hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
                name = "linux_amd64";
                ext = ".tar.gz";
              };
              x86_64-windows = {
                hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
                name = "windows_amd64";
                ext = ".zip";
              };
            };
          };
        };
      in
      {
        packages = rec {
          #>>- AtlasGo
          ${programs.atlas-go.name} =
            let
              pkg = programs.atlas-go;
              arch = programs.atlas-go.archMap.${system} or (throw "Unsupported system: ${system}");
            in
            stdenv.mkDerivation rec {
              name = "${pkg.name}-${pkg.version}";
              src = pkgs.fetchurl {
                url = "${pkg.repo}/atlas/atlas-${arch.name}-${pkg.version}${arch.ext}";
                hash = "${arch.hash}";
              };
              unpackPhase = ":";
              buildPhase = ":";
              installPhase =
                ''
                  mkdir -p $out/bin
                  cp $src $out/bin/atlas
                  chmod +x $out/bin/atlas
                '';
            };

          #>>- Hasura CLI
          ${programs.hasura-cli.name} =
            let
              pkg = programs.hasura-cli;
              arch = programs.hasura-cli.archMap.${system} or (throw "Unsupported system: ${system}");
            in
            stdenv.mkDerivation rec {
              name = "${pkg.name}-${pkg.version}";
              src = pkgs.fetchurl {
                url = "${pkg.repo}/releases/download/${pkg.tag}/cli-hasura-${arch.name}${arch.ext}";
                hash = "${arch.hash}";
              };
              unpackPhase = ":";
              buildPhase = ":";
              installPhase =
                ''
                  mkdir -p $out/bin
                  cp $src $out/bin/hasura
                  chmod +x $out/bin/hasura
                '';
            };

          #>>- Mutagen
          ${programs.mutagen.name} =
            let
              pkg = programs.mutagen;
              arch = programs.mutagen.archMap.${system} or (throw "Unsupported system: ${system}");
            in
            stdenv.mkDerivation rec {
              name = "${pkg.name}-${pkg.version}";
              src = pkgs.fetchzip {
                name = "${pkg.name}-${pkg.version}";
                url = "${pkg.repo}/releases/download/${pkg.tag}/mutagen_${arch.name}_${pkg.version}${arch.ext}";
                stripRoot = false;
                hash = "${arch.hash}";
              };
              # unpackPhase = "true";
              buildPhase = "true";
              installPhase =
                ''
                  mkdir -p $out/bin
                  ln -s $src/mutagen $out/bin/
                  ln -s $src/mutagen-agents.tar.gz $out/bin/
                '';
            };
        };
      });
}
