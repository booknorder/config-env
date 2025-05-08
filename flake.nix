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
            # URL: https://release.ariga.io/atlas/atlas-*
            # - https://release.ariga.io/atlas/atlas-darwin-arm64-v0.28.0
            # - https://release.ariga.io/atlas/atlas-linux-amd64-v0.28.0
            name = "atlas-go";
            repo = "https://release.ariga.io";
            version = "v0.28.0"; # v0.24.0
            tag = "v0.28.0"; # v0.24.0
            archMap = {
              aarch64-darwin = {
                hash = "sha256-x49P3X4DFfp9Fze0fVBv6h05uovYMQrBK+s2EbalLLU=";
                name = "darwin-arm64";
                ext = "";
              };
              x86_64-linux = {
                hash = "sha256-9DvV7M7bK3GReKoTLNrA80WQORNDaM+eOqPQpMqFL5s=";
                name = "linux-amd64";
                ext = "";
              };
              # x86_64-darwin = {
              #   hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
              #   name = "darwin-amd64";
              #   ext = "";
              # };
              # x86_64-windows = {
              #   hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
              #   name = "windows-amd64";
              #   ext = ".exe";
              # };
            };
          };
          atlas-go-community = {
            # URL: https://release.ariga.io/atlas/atlas-community-*
            # - https://release.ariga.io/atlas/atlas-community-darwin-arm64-v0.28.0
            # - https://release.ariga.io/atlas/atlas-community-linux-amd64-v0.28.0
            name = "atlas-go-community";
            repo = "https://release.ariga.io";
            version = "v0.28.0"; # v0.24.0
            tag = "v0.28.0"; # v0.24.0
            archMap = {
              aarch64-darwin = {
                hash = "sha256-i9M5ZWvGyGFAQuPqw8EGT/98YGnHlhkZYstLVDqF+is=";
                name = "darwin-arm64";
                ext = "";
              };
              x86_64-linux = {
                hash = "sha256-SG82kFtLDUl4lp0Q1X4oKsHeClrhjAns35Z/hbo+Y0s=";
                name = "linux-amd64";
                ext = "";
              };
              # x86_64-darwin = {
              #   hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
              #   name = "darwin-amd64";
              #   ext = "";
              # };
              # x86_64-windows = {
              #   hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
              #   name = "windows-amd64";
              #   ext = ".exe";
              # };
            };
          };
          deno = {
            name = "deno";
            repo = "https://github.com/denoland/deno";
            version = "v2.0.0";
            tag = "v2.0.0";
            archMap = {
              aarch64-darwin = {
                hash = "sha256-03fJO1fbunRBmdKrQYt9VdNhYetGvf/xwrn+EneoARI=";
                name = "deno-aarch64-apple-darwin";
                ext = ".zip";
              };
              x86_64-linux = {
                hash = "sha256-0gG4ErvGzCVlAS5SwqnLmWXXaK/Si7wroprmZ79yUKY=";
                name = "deno-x86_64-unknown-linux-gnu";
                ext = ".zip";
              };
              # x86_64-windows = {
              #   hash = "sha256-NOpSXuquPvLrcuX3wjf7+ET6kA5rjmZsXbJVP1b504I=";
              #   name = "deno-x86_64-pc-windows-msvc";
              #   ext = ".zip";
              # };
            };
          };
          hasura-cli = {
            name = "hasura-cli";
            repo = "https://github.com/hasura/graphql-engine";
            version = "v2.44.0"; # v2.38.0
            tag = "v2.44.0"; # v2.38.0
            archMap = {
              aarch64-darwin = {
                hash = "sha256-WMunpTbMFGyqVWALv3UEYQNL3FzziygrVmmvttMH6ag=";
                name = "darwin-arm64";
                ext = "";
              };
              x86_64-linux = {
                hash = "sha256-yYVl0peQzHt5uEz3RYEuQ64/Ju2WvmuioNzpXQkpKGI=";
                name = "linux-amd64";
                ext = "";
              };
              # x86_64-darwin = {
              #   hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
              #   name = "darwin-amd64";
              #   ext = "";
              # };
              # x86_64-windows = {
              #   hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
              #   name = "windows-amd64";
              #   ext = ".exe";
              # };
            };
          };
          mutagen = {
            name = "mutagen";
            repo = "https://github.com/mutagen-io/mutagen";
            version = "v0.18.0";
            tag = "v0.18.0";
            archMap = {
              aarch64-darwin = {
                hash = "sha256-fjASF+tNjw7VH+hcecA+rwUDhHUslCfhYxLrkiLp+XU=";
                name = "darwin_arm64";
                ext = ".tar.gz";
              };
              x86_64-linux = {
                hash = "sha256-yCveDs04EGUAh6j9mei69KMRm4WpyxQVWg2SCWADdNQ=";
                name = "linux_amd64";
                ext = ".tar.gz";
              };
              # x86_64-darwin = {
              #   hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
              #   name = "darwin_amd64";
              #   ext = ".tar.gz";
              # };
              # x86_64-windows = {
              #   hash = "sha256-0jSRnqDWMdZmqzGkZxPq3gpDoJFQR/ShZq0f07eZPaw=";
              #   name = "windows_amd64";
              #   ext = ".zip";
              # };
            };
          };
          pkl = {
            name = "pkl";
            repo = "https://github.com/apple/pkl";
            tag = "0.28.1";
            archMap = {
              aarch64-darwin = {
                filename = "pkl-macos-aarch64";
                hash = "sha256-05Pe2qcGfrXJb/mciec/RjqW9ktOIxv+7kK5hUexD+A=";
              };
              x86_64-linux = {
                filename = "pkl-linux-amd64";
                hash = "sha256-/edD7Spf2hzCTOLJkC6g0bxekRot94R8dKd84TBWvzk=";
              };
              # x86_64-darwin = {
              #   filename = "pkl-macos-amd64";
              #   hash = "sha256-gKe6BkOcbAlGj4MXP473LAQhRKFBSu4NLGwEPWkfj6Q=";
              # };
              # x86_64-windows = {
              #   filename = "pkl-windows-amd64.exe";
              #   hash = "sha256-deAok6HgDOZDDrElxiTsLqFG5kZbLZUSdm4jhGo8rz4=";
              # };
            };
          };
          tailwindcss = {
            name = "tailwindcss";
            repo = "https://github.com/tailwindlabs/tailwindcss";
            tag = "v4.1.5";
            archMap = {
              aarch64-darwin = {
                filename = "tailwindcss-macos-arm64";
                hash = "sha256-j9ogIXTCFNcg6v5J7bra+u18udASidJEYtktLCYDeH4=";
              };
              x86_64-linux = {
                filename = "tailwindcss-linux-x64";
                hash = "sha256-nSWKd4bCL4VyrqIO01hI+MvvHQYnfk5rl62FYf/CHgc=";
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

          #>>- Deno
          ${programs.deno.name} =
            let
              pkg = programs.deno;
              arch = programs.deno.archMap.${system} or (throw "Unsupported system: ${system}");
            in
            pkgs.runCommand "${pkg.name}-${pkg.version}" {
              nativeBuildInputs = [ pkgs.installShellFiles ];
              src = pkgs.fetchzip {
                name = "${pkg.name}-${pkg.version}";
                url = "${pkg.repo}/releases/download/${pkg.tag}/${arch.name}${arch.ext}";
                stripRoot = false;
                hash = "${arch.hash}";
              };
            } ''
              mkdir -p $out/bin
              cp $src/deno $out/bin/deno
              chmod +x $out/bin/deno
              installShellCompletion --cmd deno \
                --bash <($out/bin/deno completions bash) \
                --fish <($out/bin/deno completions fish) \
                --zsh <($out/bin/deno completions zsh)
            '';

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

          #>>- Tailwind CSS
          ${programs.tailwindcss.name} =
            let
              pkg = programs.tailwindcss;
              arch = programs.tailwindcss.archMap.${system} or (throw "Unsupported system: ${system}");
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
                  cp $src $out/bin/tailwindcss
                  chmod +x $out/bin/tailwindcss
                '';
            };

        };
      });
}
