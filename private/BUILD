load("@bazel_lib//:bzl_library.bzl", "bzl_library")

bzl_library(
    name = "parse",
    srcs = ["parse.bzl"],
)

bzl_library(
    name = "util",
    srcs = ["util.bzl"],
    visibility = ["//:__pkg__"],
    deps = [
        ":parse",
        "@bazel_features_version//:version",
    ],
)
