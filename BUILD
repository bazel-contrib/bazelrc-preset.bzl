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
