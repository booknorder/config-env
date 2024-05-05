#!/usr/bin/env bash

#>>== Purpose ==<
#-➤  Start SSH Agent
#-➤  Load identities into SSH Agent

#>>== Prefined Variables (init.sh)
#-➤ _SOURCED
#-➤ _DIR_SOURCES
#-➤ REPO_ROOT

#>>- Skip if CI environment
if [ "${CI-false}" != "true" ]; then
  #@ Adjust shell options as starting ssh may fail
  set +e

  #@ Check if SSH agent is running
  ssh-add -l &>/dev/null

  #@ If agent not running, start it
  if [ "$?" == 2 ]; then
    echo "SSH: Could not open a connection to your authentication agent"
    echo "SSH: Load stored agent connection info"
    test -r ~/.ssh-agent &&
      eval "$(<~/.ssh-agent)" >/dev/null

    ssh-add -l &>/dev/null
    if [ "$?" == 2 ]; then
      echo "SSH: Start agent and store agent connection info."
      (
        umask 066
        ssh-agent >~/.ssh-agent
      )
      eval "$(<~/.ssh-agent)" >/dev/null
    fi
  fi

  #@ Add identities to SSH agent
  ssh-add ~/.ssh/id_rsa &>/dev/null
  ssh-add ~/.ssh/insecure &>/dev/null

  # Load SSH identities
  # ssh-add -l &>/dev/null
  # if [ "$?" == 1 ]; then
  #     # The agent has no identities.
  #     # Time to add one.
  #     ssh-add ~/.ssh/id_rsa
  #     ssh-add ~/.ssh/insecure
  #     echo "SSH ADDED"
  # fi

  #@ Reset shell behaviour
  set -e
fi
