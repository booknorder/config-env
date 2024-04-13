def main [--dir: string] {
    let version = ($env.REPO_ROOT | path join "package.json" | open | get version)
    let input = ($dir | path join "plugin.yaml")
    let output = ($dir | path join "plugin.json")

    let plugin = (open $input | upsert version $version)
    $plugin | to yaml | save --force $input
    $plugin | to json | save --force $output
}

####
# def "main version" [--inc: string = "patch"] {
#     let file = ($env.REPO_ROOT | path join "version")
#     let current = ($file | open)
#     let parsed = ($current | parse "{major}.{minor}.{patch}" | get 0)
#     mut major = ($parsed | get major | into int)
#     mut minor = ($parsed | get minor | into int)
#     mut patch = ($parsed | get patch | into int)
#     match $inc {
#         'major' => {
#             $major = (1 + $major)
#             $minor = 0
#             $patch = 0
#         }
#         'minor' => {
#             $minor = (1 + $minor)
#             $patch = 0
#         }
#         'patch' => {
#             $patch = (1 + ($patch | into int))
#         }
#         _ => {
#             print $"Invalid increment - ($inc)"
#             exit 1
#         }
#     }
#     let version = $"($major).($minor).($patch)"
#
#     print $"Updated: ($version)"
#
#     $version | save --force $file
# }
