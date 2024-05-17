#!/usr/bin/env bash

#>>== Prefined Variables (init.sh)
#-➤ _SOURCED
#-➤ _DIR_SOURCES
#-➤ REPO_ROOT

#>>-------------------------------------------
#>>-  Utilities
#>>-------------------------------------------

function c() {
  clear
}
function br() {
  exec $SHELL
}
function brc() {
  clear
  exec $SHELL
}
function pp() {
  echo "$PATH" | tr ':' '\n'
}
function sshconf() {
  code ~/.ssh/config
}
function hosts() {
  code /etc/hosts
}
function kubeconf() {
  code ~/.kube/config
}
function kubeconf_perms() {
  chmod 600 ~/.kube/config
}

#>>-------------------------------------------
#>>-  Filesystem
#>>-------------------------------------------

function __fs_glob_chmod_exec() {
  chmod +x "$1"/*
}

#>>-------------------------------------------
#>>-  Logging
#>>-------------------------------------------

function __log_echo() {
  if [[ "${REPO_SCRIPT_DEBUG-1}" == "1" ]]; then
    echo "$1"
  fi
}

#--< Top Level
function log_divider() {
  __log_echo "$(ansi_color 246)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(ansir)"
}
function log_header() {
  local prefix="${2:+${1:+[$1] }}"
  local msg="${2:-$1}"
  log_divider
  __log_echo "   $(ansi_color 254)${prefix}${msg}$(ansir)"
  log_divider
}

#--< Section
function log_title() {
  local prefix="${2:+${1:+[$1] }}"
  local msg="${2:-$1}"
  [[ "$prefix" != "" ]] && prefix="$(ansi_bgColor 238)$prefix$(ansir)"
  [[ "$prefix" == "" ]] && prefix="$(ansi_bgColor 238) $(ansir)"
  __log_echo "${prefix}$(ansi_bgColor 238)${msg} $(ansir)"
}

#--< Section: Message
function log_msg() {
  local prefix="${2:+${1:+[$1] }}"
  local msg="${2:-$1}"
  __log_echo "${prefix}${msg}"
}
function log_info() {
  __log_echo "$(ansi_blue)$(log_msg "${1-}" "${2-}")$(ansir)"
}
function log_success() {
  __log_echo "$(ansi_green)$(log_msg "${1-}" "${2-}")$(ansir)"
}
function log_warn() {
  __log_echo "$(ansi_yellow)$(log_msg "${1-}" "${2-}")$(ansir)"
}
function log_error() {
  __log_echo "$(ansi_red)$(log_msg "${1-}" "<ERROR> ${2-}")$(ansir)"
}

#--< Section: Steps
function log_step() {
  local prefix="${2:+${1:+[$1] }}"
  local msg="${2:-$1}"
  __log_echo "${prefix} ➜ ${msg}"
}
function log_step_info() {
  __log_echo "$(ansi_blue)$(log_step "${1-}" "${2-}")$(ansir)"
}
function log_step_success() {
  __log_echo "$(ansi_green)$(log_step "${1-}" "${2-}")$(ansir)"
}
function log_step_warn() {
  __log_echo "$(ansi_yellow)$(log_step "${1-}" "${2-}")$(ansir)"
}
function log_step_error() {
  __log_echo "$(ansi_red)$(log_step "${1-}" "<ERROR> ${2-}")$(ansir)"
}

#--< Section: Steps (Sub)
function log_step_sub() {
  local prefix="${2:+${1:+[$1] }}"
  local msg="${2:-$1}"
  __log_echo "${prefix}  • ${msg}"
}
function log_step_sub_info() {
  __log_echo "$(ansi_blue)$(log_step_sub "${1-}" "${2-}")$(ansir)"
}
function log_step_sub_success() {
  __log_echo "$(ansi_green)$(log_step_sub "${1-}" "${2-}")$(ansir)"
}
function log_step_sub_warn() {
  __log_echo "$(ansi_yellow)$(log_step_sub "${1-}" "${2-}")$(ansir)"
}
function log_step_sub_error() {
  __log_echo "$(ansi_red)$(log_step_sub "${1-}" "<ERROR> ${2-}")$(ansir)"
}

#--< Testing
function __log_test() {
  source "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/00.ansi.sh"

  echo ""
  log_header "${1-}" "Bootstrapping Cluster"

  log_msg "${1-}" "Being the process"
  log_title "${1-}" "Creating cluster using K3D"

  log_msg "${1-}" "See the levels"
  log_info "${1-}" "This may not acutally go too well..."
  log_success "${1-}" "This may not acutally go too well..."
  log_warn "${1-}" "This may not acutally go too well..."
  log_error "${1-}" "This may not acutally go too well..."

  log_step "${1-}" "Creating 'tarun' cluster"
  log_step_sub "${1-}" "Created docker container"

  log_title "${1-}" "See the step levels"
  log_step "${1-}" "Creating 'tarun' cluster"
  log_step_info "${1-}" "Creating 'tarun' cluster"
  log_step_success "${1-}" "Creating 'tarun' cluster"
  log_step_warn "${1-}" "Creating 'tarun' cluster"
  log_step_error "${1-}" "Creating 'tarun' cluster"

  log_title "${1-}" "See the sub step levels"
  log_step "${1-}" "Creating 'tarun' cluster"
  log_step_sub_info "${1-}" "Creating 'tarun' cluster"
  log_step_sub_success "${1-}" "Creating 'tarun' cluster"
  log_step_sub_warn "${1-}" "Creating 'tarun' cluster"
  log_step_sub_error "${1-}" "Creating 'tarun' cluster"
}
# __log_test ""
# __log_test "pre"

#>>- Exports
export -f log_divider
export -f log_header
export -f log_title
export -f log_msg
export -f log_info
export -f log_success
export -f log_warn
export -f log_error
export -f log_step
export -f log_step_info
export -f log_step_success
export -f log_step_warn
export -f log_step_error
export -f log_step_sub
export -f log_step_sub_info
export -f log_step_sub_success
export -f log_step_sub_warn
export -f log_step_sub_error
