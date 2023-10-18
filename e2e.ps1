# Set-PSDebug -Trace 1

if (-not $env:APPVEYOR) {
    # golang
    choco install --no-progress golang
    $env:PATH+=';C:\Program Files\Go\bin'
    go version

    # git
    choco install --no-progress git
    $env:PATH += ";C:\Program Files\Git\bin"
    git --version
}


# https://github.com/bazelbuild/rules_go/releases/tag/v0.42.0

@'
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "91585017debb61982f7054c9688857a2ad1fd823fc3f9cb05048b0025c47d023",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.42.0/rules_go-v0.42.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.42.0/rules_go-v0.42.0.zip",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.20.7")
'@ | Out-File -Encoding ASCII WORKSPACE

# install bazel wrapper
choco install --no-progress bazelisk
$env:PATH += ";C:\ProgramData\chocolatey\bin"

# install bazel
$result = &bazelisk

Write-Host $result

# gazelle
go install github.com/bazelbuild/bazel-gazelle/cmd/gazelle@latest
$env:PATH += ";$env:USERPROFILE\go\bin"

# https://github.com/bazelbuild/rules_go#initial-project-setup

# cd $env:USERPROFILE\bluegoal

gazelle -go_prefix github.com/taylormonacelli/bluegoal

bazel run :bluegoal
bazel build :bluegoal
bazel shutdown
