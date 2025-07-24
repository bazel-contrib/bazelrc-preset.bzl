load("@aspect_bazel_lib//lib:testing.bzl", "assert_contains")
load("@bazel_skylib//rules:native_binary.bzl", "native_test")
load("//:bazelrc-preset.bzl", "bazelrc_preset", "bazelrc_preset_test")
load(":extra_test_presets.bzl", "EXTRA_TEST_PRESETS")

bazelrc_preset(
    name = "preset",
    tags = ["manual"],
)

# To inspect the changes to presets when contributors send a PR
native_test(
    name = "test",
    src = "cat.sh",
    args = ["$(rootpath :preset)"],
    data = [":preset"],
)

bazelrc_preset(
    name = "preset_with_extra_presets",
    extra_presets = EXTRA_TEST_PRESETS | {
        "extra_preset_as_dict": {
            "command": "common:bar",
            "default": True,
            "description": """\
            Extra preset that can be provided by the user.
            """,
        },
    },
    tags = ["manual"],
)

assert_contains(
    name = "test_with_extra_presets_as_struct",
    actual = ":preset_with_extra_presets",
    expected = "common:foo --extra_preset_as_struct",
)

assert_contains(
    name = "test_with_extra_presets_as_dict",
    actual = ":preset_with_extra_presets",
    expected = "common:bar --extra_preset_as_dict",
)

bazelrc_preset_test(name = "test_default_preset")

bazelrc_preset_test(
    name = "test_strict_preset",
    strict = True,
)

bazelrc_preset_test(
    name = "test_preset_with_extra_presets",
    extra_presets = EXTRA_TEST_PRESETS | {
        "extra_preset_as_dict": {
            "command": "common:bar",
            "default": True,
            "description": """\
            Extra preset that can be provided by the user.
            """,
        },
    },
)

bazelrc_preset_test(
    name = "test_strict_preset_with_extra_presets",
    extra_presets = EXTRA_TEST_PRESETS,
    strict = True,
)
