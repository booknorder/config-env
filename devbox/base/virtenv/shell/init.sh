#!/usr/bin/env bash

#>>-------------------------------------------------------------------------
#>>-  Essentials
#>>-------------------------------------------------------------------------

function __repo_shell_opts_untrap() {
  trap - ERR EXIT SIGINT SIGTERM
}
function __repo_shell_opts_unset() {
  set +e
  set +u
  set +o pipefail
  __repo_shell_opts_untrap
}
function __repo_shell_opts_set() {
  set -e
  set -u
  set -o pipefail
  trap __repo_shell_opts_unset ERR EXIT SIGINT SIGTERM
}
function __repo_shell_root_dir() {
  local current="$1"
  # While not at the root directory
  while [[ "$current" != "/" ]]; do
    # Check if devbox.json file found (repo root)
    if [[ -f "$current/devbox.json" ]]; then
      echo "$current"
      return 0
    else
      # Move up to the parent directory
      current=$(dirname "$current")
    fi
  done
  return 1
}

#>>-------------------------------------------------------------------------
#>>-  Init
#>>-------------------------------------------------------------------------

__repo_shell_opts_set
(return 0 2> /dev/null) && _SOURCED="1" || _SOURCED="0"

_DIR_ROOT="$(__repo_shell_root_dir "$REPO_DEVBOX_VIRTENV_DIR")"
_DIR_SOURCES="$REPO_DEVBOX_VIRTENV_DIR/shell"

#>>-------------------------------------------------------------------------
#>>-  Init: Defaults
#>>-------------------------------------------------------------------------

export REPO_ROOT="$_DIR_ROOT"
export REPO_DEVBOX_VIRTENV
export REPO_ENV="${REPO_ENV-dev}"
export REPO_DEVBOX_PROFILE="$REPO_ROOT/.devbox/nix/profile/default"
export REPO_DEVBOX_BIN="$REPO_DEVBOX_PROFILE/bin"
export REPO_DEVBOX_RUN="${REPO_DEVBOX_RUN-0}"

if [[ "$_SOURCED" == "1" && "$REPO_DEVBOX_RUN" == "0" ]]; then
  export REPO_SCRIPT_DEBUG="${REPO_SCRIPT_DEBUG-1}"
else
  export REPO_SCRIPT_DEBUG="${REPO_SCRIPT_DEBUG-0}"
fi

#>- Vendor
export HELM_PLUGINS="$REPO_ROOT/.devbox/virtenv/helm/plugins"
export KREW_ROOT="$REPO_ROOT/.devbox/virtenv/krew"

#! Check if this is being invoked by `devbox run ...`
# [[ -n "${DEVBOX_RUN_CMD-}" ]] && IS_DEVBOX_RUN="1"

#! This can disable certain things such as a terminal colors, simply by being defined
# export CI="${CI-false}"

#>>-------------------------------------------------------------------------
#>>-  Init: Functions
#>>-------------------------------------------------------------------------

function __repo_init_sources() {
  #!! Cant use sourced functions here

  #>- Functions
  source "$_DIR_SOURCES/00.ansi.sh"
  source "$_DIR_SOURCES/01.base.sh"
  source "$_DIR_SOURCES/02.env.sh"

  #>- Init
  source "$_DIR_SOURCES/03.ssh.sh"
}

function __repo_init_perms() {
  if [[ "${_SOURCED}" == "1" ]]; then
    #>- Set script permissions to executable
    log_step "Set executable permissions on $REPO_DEVBOX_VIRTENV_DIR/shell/*"
    __fs_glob_chmod_exec "$REPO_DEVBOX_VIRTENV_DIR/shell"

    log_step "Set executable permissions on $REPO_DEVBOX_VIRTENV_DIR/bin/*"
    __fs_glob_chmod_exec "$REPO_DEVBOX_VIRTENV_DIR/bin"
  fi
}

function __repo_init_env() {
  local var_key
  local var_value
  local var_name
  local prod_env_local_vars=("SOPS_AGE_KEY" "GCLOUD_BIN")

  log_step "Load dotenv files"
  __dotenv_load "${REPO_ROOT}/.env.repo"
  __dotenv_load "${REPO_ROOT}/.env.repo.${REPO_ENV}"
  __dotenv_load "${REPO_ROOT}/.env"

  #>- .env.local
  #  ➤ [dev] Must load `.env.local` to apply developer-specific config
  #  ➤ [prod] Load only select variables, if not set

  if [ ! -f "$REPO_ROOT/.env.local" ]; then
    log_step "Skipping .env.local (not found)"
    return 0
  fi

  if [[ "$REPO_ENV" != "prod" ]]; then
    __dotenv_load "$REPO_ROOT/.env.local"
    return 0
  fi

  while IFS='=' read -r var_key var_value; do
    #>= Skip empty lines and comments
    [[ -z "$var_key" || "$var_key" == \#* ]] && continue

    #>= Check if the variable in the array and not set
    for var_name in "${prod_env_local_vars[@]}"; do
      # " ${prod_env_local_vars[*]} " =~ " $var_key "
      if [[ "$var_name" == "$var_key" && -z "${!var_key:-}" ]]; then
        export "$var_key=${var_value//\"/}"
        log_step_sub "Loaded variable (.env.local): $var_key"
      fi
    done
  done < "$REPO_ROOT/.env.local"
}

function __repo_init_env_full() {
  if [[ "$REPO_ENV" != "dev" && "$REPO_ENV" != "prod" ]]; then
    log_step_error "Variable REPO_ENV is not a valid value - ${REPO_ENV}"
    exit 1
  fi

  #>- Dotenv
  __repo_init_env

  #>- Other
  [[ -z "${PNPM_HOME-}" ]] && export PNPM_HOME="$HOME/.local/share/pnpm"

  mkdir -p "$HELM_PLUGINS"
  mkdir -p "$KREW_ROOT"

  #>- Deno
  local DENO_GLOBAL_BIN="$HOME/.deno/bin"
  mkdir -p "$DENO_GLOBAL_BIN"
  __path_add_top "$DENO_GLOBAL_BIN"
}

function __repo_init_path() {
  log_step "Update PATH"
  #  ➤ Must come after dotenv files loaded as some vars depend on it
  [[ -n "${GCLOUD_BIN-}" ]] && __path_add_top "$GCLOUD_BIN"
  __path_add_top "$KREW_ROOT/bin"
  __path_add_top "$REPO_DEVBOX_VIRTENV_DIR/bin"
}

function __repo_init_nix() {
  #>- Load completions
  if [[ "${_SOURCED}" == "1" && "$REPO_DEVBOX_RUN" == "0" && "${CI-false}" != "true" ]]; then
    log_step "Load completions"
    __nix_completions_load
  fi

  #>- Fix $PATH
  log_step "Fix Nix/Devbox PATH environment"
  __nix_env_fix
}

function __repo_init_helm() {
  export HELM_PLUGIN_S3_VERSION="${HELM_PLUGIN_S3_VERSION-0.16.0}"
  export HELM_PLUGIN_DIFF_VERSION="${HELM_PLUGIN_DIFF_VERSION-3.9.7}"
  export HELM_PLUGIN_DASHBOARD_VERSION="${HELM_PLUGIN_DASHBOARD_VERSION-1.3.3}"
  export HELM_PLUGIN_SECRETS_VERSION="${HELM_PLUGIN_SECRETS_VERSION-4.6.0}"
  export HELM_PLUGIN_GIT_VERSION="${HELM_PLUGIN_GIT_VERSION-0.16.0}"
  export HELM_PLUGIN_MAPKUBEAPIS_VERSION="${HELM_PLUGIN_MAPKUBEAPIS_VERSION-0.4.1}"

  if [[ "$REPO_DEVBOX_RUN" == "0" && "${REPO_HELM_PLUGINS_INSTALL-0}" == "1" ]]; then
    log_step "Helm: Install Plugins"

    log_step_sub "Ensure: s3 ➜ $HELM_PLUGIN_S3_VERSION"
    __helm_plugin_ensure "s3" "https://github.com/hypnoglow/helm-s3.git" "$HELM_PLUGIN_S3_VERSION"

    log_step_sub "Ensure: diff ➜ $HELM_PLUGIN_DIFF_VERSION"
    __helm_plugin_ensure "diff" "https://github.com/databus23/helm-diff" "$HELM_PLUGIN_DIFF_VERSION"

    log_step_sub "Ensure: secrets ➜ $HELM_PLUGIN_SECRETS_VERSION"
    __helm_plugin_ensure "secrets" "https://github.com/jkroepke/helm-secrets" "$HELM_PLUGIN_SECRETS_VERSION"

    log_step_sub "Ensure: helm-git ➜ $HELM_PLUGIN_GIT_VERSION"
    __helm_plugin_ensure "helm-git" "https://github.com/aslafy-z/helm-git" "$HELM_PLUGIN_GIT_VERSION"

    log_step_sub "Ensure: mapkubeapis ➜ $HELM_PLUGIN_MAPKUBEAPIS_VERSION"
    __helm_plugin_ensure "mapkubeapis" "https://github.com/helm/helm-mapkubeapis" "$HELM_PLUGIN_MAPKUBEAPIS_VERSION"

    if [[ "${CI-false}" != "true" ]]; then
      log_step_sub "Ensure: dashboard"
      __helm_plugin_ensure "dashboard" "https://github.com/komodorio/helm-dashboard.git"
      # log_step_sub "Ensure: dashboard ➜ $HELM_PLUGIN_DASHBOARD_VERSION"
      # __helm_plugin_ensure "dashboard" "$HELM_PLUGIN_DASHBOARD_VERSION" "https://github.com/komodorio/helm-dashboard.git"
    fi
  fi
}

#>>-------------------------------------------------------------------------
#>>-  Run: Functions
#>>-------------------------------------------------------------------------

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Initializing Devbox: Base"
echo "   ➜ REPO_ENV: $REPO_ENV"
echo "   ➜ REPO_ROOT: $REPO_ROOT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

function time_func() {
  local func=$1 # Capture the function name
  if [[ "${REPO_SCRIPT_DEBUG-1}" == "1" ]]; then
    TIMEFORMAT=" ➜ ⌚ $func: %Rs"
    time $func # Execute the function
  else
    $func # Execute the function
  fi
}

#>- Execute Functions (order matters)
time_func __repo_init_sources
time_func __repo_init_perms
time_func __repo_init_env_full
time_func __repo_init_path
time_func __repo_init_nix
time_func __repo_init_helm

#>>-------------------------------------------------------------------------
#>>-  Run: Cleanup
#>>-------------------------------------------------------------------------

__repo_shell_opts_unset

#>>-------------------------------------------------------------------------
#>>-  Exports
#>>-------------------------------------------------------------------------

export -f __repo_shell_opts_untrap
export -f __repo_shell_opts_unset
export -f __repo_shell_opts_set
export -f __repo_shell_root_dir

export -f __repo_init_env
