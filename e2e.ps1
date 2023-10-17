# golang
choco install golang
$env:PATH+=';C:\Program Files\Go\bin'
go version

# git
choco install git
$env:PATH += ";C:\Program Files\Git\bin"
git --version

# install bazel wrapper
choco install bazelisk

# install bazel
bazelisk

# gazelle
go install github.com/bazelbuild/bazel-gazelle/cmd/gazelle@latest
$env:PATH += ";$env:USERPROFILE\go\bin"

# https://github.com/bazelbuild/rules_go#initial-project-setup

cd $env:USERPROFILE\bluegoal

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
'@ | Out-File -Encoding ASCII $env:USERPROFILE\bluegoal\WORKSPACE

bazel run :bluegoal
bazel shutdown

cd $env:USERPROFILE
Remove-Item -Force -Recurse $env:USERPROFILE\bluegoal
