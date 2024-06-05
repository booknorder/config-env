#!/usr/bin/env nu

def main [
  --name: string
  --repo: string
  --version?: string
] {
  let files = (glob $"($env.HELM_PLUGINS)/*/plugin.yaml")
  let plugins = ($files | each {|f| (open $f) })
  let search = ($plugins | find name $name)

  if ($version == null) {
    if ($search | length) == 0 {
      let proc = (do { helm plugin install $"($repo)" } | complete)
      log-msg $"($proc.stdout) [($proc.exit_code)]"
    }
    return
  }

  if ($search | length) == 0 {
    log-msg $"Helm: installing plugin - ($name) / v($version)"
    plugin-install --name $name --version $version --repo $repo
    return
  }

  let plugin = ($search | get 0)

  if $"($plugin.version)" != $version {
    log-msg $"Helm: updating plugin - ($name) / v($plugin.version) -> v($version)"
    plugin-uninstall --name $name --version $version --repo $repo
    plugin-install --name $name --version $version --repo $repo
  } else {
    log-msg $"Helm: plugin up-to-date - ($name) / v($version)"
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
  print $"[nu:helm-plugins] ($title)"
}

def log-msg [msg] {
  print $"[nu:helm-plugins]   ➤ ($msg)"
}