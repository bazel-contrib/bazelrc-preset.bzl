# Used only under Bazel 6 or earlier
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_skylib",
    sha256 = "bc283cdfcd526a52c3201279cda4bc298652efa898b10b4db0837dc51652756f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

http_archive(
    name = "aspect_bazel_lib",
    sha256 = "9a44f457810ce64ec36a244cc7c807607541ab88f2535e07e0bf2976ef4b73fe",
    strip_prefix = "bazel-lib-2.19.4",
    url = "https://github.com/bazel-contrib/bazel-lib/releases/download/v2.19.4/bazel-lib-v2.19.4.tar.gz",
)

http_archive(
    name = "bazel_lib",
    sha256 = "46960e9fa6c9352d883768280951ac388dba8cb9ff0256182fb77925eae2b6ac",
    strip_prefix = "bazel-lib-3.0.0-beta.1",
    url = "https://github.com/bazel-contrib/bazel-lib/releases/download/v3.0.0-beta.1/bazel-lib-v3.0.0-beta.1.tar.gz",
)

load("@bazel_lib//lib:repositories.bzl", "bazel_lib_dependencies")

bazel_lib_dependencies()

http_archive(
    name = "package_metadata",
    integrity = "sha256-W9DMdZTqUo/Sj5jYJFfxV4J9SMwg4HvP27VgcvNcj2c=",
    strip_prefix = "supply-chain-0.0.6/metadata",
    url = "https://github.com/bazel-contrib/supply-chain/releases/download/v0.0.6/supply-chain-v0.0.6.tar.gz",
)

http_archive(
    name = "diff.bzl",
    sha256 = "c9d44bc578563d0489f5d45a41515648dc870ffdf2eac7401f7372e637121513",
    strip_prefix = "diff.bzl-0.5.8",
    url = "https://github.com/kormide/diff.bzl/releases/download/v0.5.8/diff.bzl-v0.5.8.tar.gz",
)

load("@diff.bzl//diff:repositories.bzl", "diffutils_register_toolchains")

diffutils_register_toolchains(
    name = "diffutils",
    diffutils_version = "3.12",
)

http_archive(
    name = "bazel_features",
    sha256 = "07bd2b18764cdee1e0d6ff42c9c0a6111ffcbd0c17f0de38e7f44f1519d1c0cd",
    strip_prefix = "bazel_features-1.32.0",
    url = "https://github.com/bazel-contrib/bazel_features/releases/download/v1.32.0/bazel_features-v1.32.0.tar.gz",
)

load("@bazel_features//:deps.bzl", "bazel_features_deps")

bazel_features_deps()
