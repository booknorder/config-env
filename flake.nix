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
          atlas-go = {
            name = "atlas-go";
            repo = "https://release.ariga.io";
            version = "v0.24.0";
            tag = "v0.24.0";
            archMap = {
              aarch64-darwin = {
                hash = "sha256-Udh+EMNN5FlWT4Z7pzyX6R8YXZc7DqpM80LhI79SV2I=";
                name = "darwin-arm64";
                ext = "";
              };
              x86_64-darwin = {
                hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
                name = "darwin-amd64";
                ext = "";
              };
              x86_64-linux = {
                hash = "sha256-V6K6c9RvqBdUPSKt8uWr5LXeCc74B+At4+r5NpExk1s=";
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
          atlas-go-community = {
            name = "atlas-go-community";
            repo = "https://release.ariga.io";
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
                hash = "sha256-KcNDCUdlbUkiA+A2jekqP6sqtcMuQwh9HEQ2aPX1wLE=";
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
          pkl = {
            name = "pkl";
            repo = "https://github.com/apple/pkl";
            tag = "0.26.1";
            archMap = {
              aarch64-darwin = {
                filename = "pkl-macos-aarch64";
                hash = "sha256-KRNAU2dpTTrDflggAJW5mmrmH+UKKz7F9cn0nPBUhOI=";
              };
              x86_64-darwin = {
                filename = "pkl-macos-amd64";
                hash = "sha256-JmjT9jmNy6zcxjO8DMpxdB/2SuaCSiIecZ2ls95yqjk=";
              };
              x86_64-linux = {
                filename = "pkl-linux-amd64";
                hash = "sha256-nJaSyFhf8+/9ik+cGtpiuZspKkBSWoARRVYKVicw+UY=";
              };
              x86_64-windows = {
                filename = "pkl-windows-amd64.exe";
                hash = "sha256-FGINZX+lTS8MFjh+7yYvIrh5sBEzGfeQ2NlG5pynSf8=";
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

          #>>- AtlasGo Community
          ${programs.atlas-go-community.name} =
            let
              pkg = programs.atlas-go-community;
              arch = programs.atlas-go-community.archMap.${system} or (throw "Unsupported system: ${system}");
            in
            stdenv.mkDerivation rec {
              name = "${pkg.name}-${pkg.version}";
              src = pkgs.fetchurl {
                url = "${pkg.repo}/atlas/atlas-community-${arch.name}-${pkg.version}${arch.ext}";
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

          #>>- PKL
          ${programs.pkl.name} =
            let
              pkg = programs.pkl;
              arch = programs.pkl.archMap.${system} or (throw "Unsupported system: ${system}");
            in
            stdenv.mkDerivation rec {
              name = "${pkg.name}-v${pkg.tag}";
              src = pkgs.fetchurl {
                url = "${pkg.repo}/releases/download/${pkg.tag}/${arch.filename}";
                hash = "${arch.hash}";
              };
              unpackPhase = ":";
              buildPhase = ":";
              installPhase =
                ''
                  mkdir -p $out/bin
                  cp $src $out/bin/pkl
                  chmod +x $out/bin/pkl
                '';
            };

        };
      });
}
