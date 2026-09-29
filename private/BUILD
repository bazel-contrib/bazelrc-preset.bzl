load("@bazel_lib//:bzl_library.bzl", "bzl_library")

exports_files(["check_preset_diff.sh"], visibility = ["//visibility:public"])

bzl_library(
    name = "diff",
    srcs = ["diff.bzl"],
    visibility = ["//visibility:public"],
)

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
