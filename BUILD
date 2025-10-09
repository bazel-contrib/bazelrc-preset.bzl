load("@bazel_lib//:bzl_library.bzl", "bzl_library")
load("@bazel_skylib//rules:common_settings.bzl", "bool_flag")

package(default_visibility = ["//visibility:public"])

bool_flag(
    name = "strict",
    build_setting_default = False,
)

config_setting(
    name = "strict.true",
    flag_values = {
        ":strict": "true",
    },
)

bzl_library(
    name = "bazelrc_preset",
    srcs = ["bazelrc-preset.bzl"],
    deps = [
        ":flags",
        "@bazel_features_version//:version",
        "@bazel_lib//lib:testing",
        "@bazel_lib//lib:utils",
        "@bazel_lib//lib:write_source_files",
        "@bazel_skylib//lib:new_sets",
    ],
)

bzl_library(
    name = "flags",
    srcs = [
        "flags.bzl",
    ],
    deps = [
        "//private:util",
    ],
)
