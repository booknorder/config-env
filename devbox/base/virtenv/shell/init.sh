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
(return 0 2>/dev/null) && _SOURCED="1" || _SOURCED="0"

_DIR_ROOT="$(__repo_shell_root_dir "$REPO_DEVBOX_VIRTENV_DIR")"
_DIR_SOURCES="$REPO_DEVBOX_VIRTENV_DIR/shell"

export REPO_ROOT="$_DIR_ROOT"
export REPO_DEVBOX_VIRTENV

#>>-------------------------------------------------------------------------
#>>-  Init: Functions
#>>-------------------------------------------------------------------------

function __repo_init_defaults() {
  #!! Cant use sourced functions here

  export REPO_ENV="${REPO_ENV-dev}"
  export REPO_DEVBOX_PROFILE="$REPO_ROOT/.devbox/nix/profile/default"
  export REPO_DEVBOX_BIN="$REPO_DEVBOX_PROFILE/bin"
  export REPO_DEVBOX_RUN="${REPO_DEVBOX_RUN-0}"

  if [[ "$_SOURCED" == "1" && "$REPO_DEVBOX_RUN" == "0" ]]; then
    export REPO_SCRIPT_DEBUG="${REPO_SCRIPT_DEBUG-1}"
  else
    export REPO_SCRIPT_DEBUG="${REPO_SCRIPT_DEBUG-0}"
  fi

  # Check if this is being invoked by `devbox run ...`
  # [[ -n "${DEVBOX_RUN_CMD-}" ]] && IS_DEVBOX_RUN="1"

  #>- Vendor
  export HELM_PLUGINS="$REPO_ROOT/.devbox/helm/plugins"
  export CI="${CI-false}"

}

function __repo_init_sources() {
  #!! Cant use sourced functions here

  #>- Functions
  source "$_DIR_SOURCES/00.ansi.sh"
  source "$_DIR_SOURCES/01.base.sh"
  source "$_DIR_SOURCES/02.env.sh"

  #>- Init
  source "$_DIR_SOURCES/03.ssh.sh"
}

function __repo_init_env() {
  if [[ "$REPO_ENV" != "dev" && "$REPO_ENV" != "prod" ]]; then
    log_step_error "Variable REPO_ENV is not a valid value - ${REPO_ENV}"
    exit 1
  fi

  if [[ "${_SOURCED}" == "1" ]]; then
    #>- Set script permissions to executable
    log_step "Set executable permissions on $REPO_DEVBOX_VIRTENV_DIR/shell/*"
    __fs_glob_chmod_exec "$REPO_DEVBOX_VIRTENV_DIR/shell"

    log_step "Set executable permissions on $REPO_DEVBOX_VIRTENV_DIR/bin/*"
    __fs_glob_chmod_exec "$REPO_DEVBOX_VIRTENV_DIR/bin"
  fi

  #>- Dotenv: Base
  log_step "Load dotenv files"
  __dotenv_load "$REPO_ROOT/.env.repo"
  __dotenv_load "$REPO_ROOT/.env"

  #>- Dotenv: Development
  #  ➤ Must load `.env.local` to override values from `.env.repo`
  [[ "$REPO_ENV" != "prod" ]] && __dotenv_load "$REPO_ROOT/.env.local"

  #>- Other
  [[ -z "${PNPM_HOME-}" ]] && export PNPM_HOME="$HOME/.local/share/pnpm"
  [[ -z "${KREW_ROOT-}" ]] && export KREW_ROOT="$HOME/.krew"

  #>- $PATH
  log_step "Update PATH"
  #  ➤ Must come after dotenv files loaded as some vars depend on it
  [[ -n "${GCLOUD_BIN-}" ]] && __path_add_top "$GCLOUD_BIN"
  __path_add_top "$KREW_ROOT/bin"
  __path_add_top "$REPO_DEVBOX_VIRTENV_DIR/bin"
}

function __repo_init_env_nix() {
  #>- Load completions
  if [[ "${_SOURCED}" == "1" && "$REPO_DEVBOX_RUN" == "0" && "$CI" != "true" ]]; then
    log_step "Load completions"
    __nix_completions_load
  fi

  #>- Fix $PATH
  log_step "Fix Nix/Devbox PATH environment"
  __nix_env_fix
}

function __repo_init_helm() {
  if [[ "${REPO_HELM_PLUGINS_INSTALL-0}" == "1" ]]; then
    log_step "Helm: Install Plugins"

    log_step_sub "Ensure: s3 ➜ $HELM_PLUGIN_S3_VERSION"
    __helm_plugin_ensure "s3" "$HELM_PLUGIN_S3_VERSION" "https://github.com/hypnoglow/helm-s3.git"

    log_step_sub "Ensure: diff ➜ $HELM_PLUGIN_DIFF_VERSION"
    __helm_plugin_ensure "diff" "$HELM_PLUGIN_DIFF_VERSION" "https://github.com/databus23/helm-diff"

    log_step_sub "Ensure: secrets ➜ $HELM_PLUGIN_SECRETS_VERSION"
    __helm_plugin_ensure "secrets" "$HELM_PLUGIN_SECRETS_VERSION" "https://github.com/jkroepke/helm-secrets"

    log_step_sub "Ensure: helm-git ➜ $HELM_PLUGIN_GIT_VERSION"
    __helm_plugin_ensure "helm-git" "$HELM_PLUGIN_GIT_VERSION" "https://github.com/aslafy-z/helm-git"

    log_step_sub "Ensure: mapkubeapis ➜ $HELM_PLUGIN_MAPKUBEAPIS_VERSION"
    __helm_plugin_ensure "mapkubeapis" "$HELM_PLUGIN_MAPKUBEAPIS_VERSION" "https://github.com/helm/helm-mapkubeapis"

    if [[ "$CI" != "true" ]]; then
      log_step_sub "Ensure: dashboard ➜ $HELM_PLUGIN_DASHBOARD_VERSION"
      __helm_plugin_ensure "dashboard" "$HELM_PLUGIN_DASHBOARD_VERSION" "https://github.com/komodorio/helm-dashboard.git"
    fi
  fi
}

#>>-------------------------------------------------------------------------
#>>-  Run: Functions
#>>-------------------------------------------------------------------------

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Initializing Devbox: Base"
echo "   ➜ REPO_ROOT: $REPO_ROOT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

function time_func() {
  local func=$1 # Capture the function name
  TIMEFORMAT=" ➜ ⌚ $func: %Rs"
  time $func # Execute the function
}

#>- Execute Functions (order matters)
time_func __repo_init_defaults
time_func __repo_init_sources
time_func __repo_init_env
time_func __repo_init_env_nix
time_func __repo_init_helm

#>>-------------------------------------------------------------------------
#>>-  Run: Cleanup
#>>-------------------------------------------------------------------------

__repo_shell_opts_unset
