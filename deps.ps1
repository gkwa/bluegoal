# golang
choco install golang
$env:PATH+=';C:\Program Files\Go\bin'
go version

# git
choco install git
$env:PATH += ";C:\Program Files\Git\bin"
git --version

# gazelle
go install github.com/bazelbuild/bazel-gazelle/cmd/gazelle@latest

