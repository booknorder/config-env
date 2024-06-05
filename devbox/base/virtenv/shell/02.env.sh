#!/usr/bin/env bash

#>>== Prefined Variables (init.sh)
#-➤ _SOURCED
#-➤ _DIR_SOURCES
#-➤ REPO_ROOT

#>>-------------------------------------------
#>>-  PATH
#>>-------------------------------------------

function __path_print() {
  # echo "$1" | tr ':' '\n' | xargs -I {} log_step "{}"
  while IFS= read -r line; do
    log_step_sub "$line"
  done < <(echo "$1" | tr ':' '\n')
}

function __path_add_top() {
  log_step_sub "Add (Top): $1"
  export PATH="$1:$PATH"
}

#>>-------------------------------------------
#>>-  Dotenv
#>>-------------------------------------------

function __dotenv_load() {
  local file="$1"
  if [[ -f "$1" ]]; then
    set -a && source "$file" && set +a
    # if [[ "${CI-false}" = "true" ]]; then
    #   cat "$file" | xargs -0 -I {} echo {} >>"$GITHUB_ENV"
    # fi
    log_step_sub "Loaded: $file"
  #% else
  #%   log_step_err "Doesnt exist: $file"
  fi
}

function __dotenv_create_from_sops() {
  #>- Variables
  #- <file_key> - key to extract within the SOPS yaml file
  #- <file_dest> - the output file to write

  local input_file="$1"
  local input_key="$2"

  local file_dest="$REPO_ROOT/$input_key"

  local SOPS_PATH="$REPO_DEVBOX_BIN/sops"
  #% local SOPS_DOTENV_FILE="$REPO_ROOT/config/secrets/dotenv.yaml"

  log_step_sub "Secrets: Generate '$input_key'"

  #>- Remove the dest file if exists
  rm -f "$file_dest"

  #>- Extract secrets from SOPS and write to dest file
  if output=$("$SOPS_PATH" -d --extract "[\"${input_key}\"]" "$input_file"); then
    echo "$output" >>"$file_dest"
  fi
}

#>>-------------------------------------------
#>>-  Nix / Devbox
#>>-------------------------------------------

function __devbox_clean() {
  rm -rf "$REPO_ROOT/.devbox"
}

function __devbox_plugin_clean() {
  rm -rf "$REPO_ROOT/.devbox/virtenv"
}

function __nix_env_path_fix() {
  local dir
  local scope="$1"
  local file="$2"

  dir="$(dirname "$file")"

  if [[ -d "$dir" && -r "$file" ]]; then
    log_step_sub "Trim 'nix print-dev-env' entries from 'PATH' ($scope)"
    nix_path="$(jq -r '.Variables.PATH.Value' <"$file")"
    nix_path_fixed=$(echo "$PATH" | tr ':' '\n' | grep -v -F -x -f <(echo "$nix_path" | tr ':' '\n') | tr '\n' ':' | sed 's/:$//')
    export PATH="$nix_path_fixed"
  fi
}

function __nix_env_fix() {
  local nixEnvFileCache=".nix-print-dev-env-cache"
  __nix_env_path_fix "Repo" "$REPO_ROOT/.devbox/$nixEnvFileCache"
  __nix_env_path_fix "User" "$HOME/.local/share/devbox/global/default/.devbox/$nixEnvFileCache"
}

function __nix_completions_load() {
  local
  local filename

  for file in "$REPO_ROOT"/.devbox/nix/profile/default/share/bash-completion/completions/*; do
    if [ -r "$file" ]; then
      filename="$(basename "$file")"
      log_step_sub "$filename"
      source "$file"
      # cargo needs to be loaded only after rust installed (manually)
      # if [[ "$filename" != "cargo" ]]; then
      #   source "$file"
      # fi
    fi
  done
}

#>>-------------------------------------------
#>>-  Helm
#>>-------------------------------------------

function __helm_plugin_ensure() {
  local name="$1"
  local repo="$2"
  local version="$3"
  # Check if the version is empty
  if [[ "${version-}" == "" ]]; then
    nu "$REPO_DEVBOX_VIRTENV_DIR/bin/helm-plugin-ensure.nu" \
      --name="$name" \
      --repo="$repo"
  else
    nu "$REPO_DEVBOX_VIRTENV_DIR/bin/helm-plugin-ensure.nu" \
      --name="$name" \
      --repo="$repo" \
      --version="$version"
  fi
}

#>>-------------------------------------------
#>>-  Exports
#>>-------------------------------------------

export -f __path_print
export -f __path_add_top
export -f __dotenv_load
export -f __dotenv_create_from_sops
export -f __helm_plugin_ensure
