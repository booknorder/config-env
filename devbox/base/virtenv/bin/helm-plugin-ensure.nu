#!/usr/bin/env nu

def main [
  --name: string
  --version: string
  --repo: string
] {
  let files = (glob $"($env.HELM_PLUGINS)/*/plugin.yaml")
  let plugins = ($files | each {|f| (open $f) })
  let search = ($plugins | find name $name)

  if ($search | length) == 0 {
    log-title $"Helm: installing plugin - ($name) / v($version)"
    plugin-install --name $name --version $version --repo $repo
    return
  }

  let plugin = ($search | get 0)

  if $"($plugin.version)" != $version {
    log-title $"Helm: updating plugin - ($name) / v($plugin.version) -> v($version)"
    plugin-uninstall --name $name --version $version --repo $repo
    plugin-install --name $name --version $version --repo $repo
  } else {
    log-title $"Helm: plugin up-to-date - ($name) / v($version)"
  }
}


def plugin-install [
  --name: string
  --version: string
  --repo: string
] {
  let proc = (do { helm plugin install $"($repo)" --version $"($version)" } | complete)
  if $proc.exit_code != 0 {
    log-msg $"Failed to install plugin ($name) / v($version)"
    print $proc.stderr
    exit $proc.exit_code
  }
}

def plugin-uninstall [
  --name: string
  --version: string
  --repo: string
] {
  let proc = (do { helm plugin uninstall $"($name)" } | complete)
  if $proc.exit_code != 0 {
    log-msg $"Failed to uninstall plugin ($name) / v($version)"
    print $proc.stderr
    exit $proc.exit_code
  }
}

def log-title [title] {
  if ('REPO_SCRIPT_DEBUG' in $env) and ($env.REPO_SCRIPT_DEBUG == "1") {
    # print $"[nu:helm-plugins] ($title)"
  }
}

def log-msg [msg] {
  if ('REPO_SCRIPT_DEBUG' in $env) and ($env.REPO_SCRIPT_DEBUG == "1") {
    # print $"[nu:helm-plugins]   ➤ ($msg)"
  }
}