load("@bazel_skylib//rules:common_settings.bzl", "bool_flag")

bool_flag(
    name = "strict",
    build_setting_default = False,
    visibility = ["//visibility:public"],
)

config_setting(
    name = "strict.true",
    flag_values = {
        ":strict": "true",
    },
)
