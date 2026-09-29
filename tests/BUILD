load("@bazel_lib//lib:testing.bzl", "assert_contains")
load("@bazel_skylib//rules:native_binary.bzl", "native_test")
load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("//:bazelrc-preset.bzl", "bazelrc_preset", "bazelrc_preset_test")
load("//private:diff.bzl", "hermetic_diff")
load(":extra_test_presets.bzl", "ALLOW_REPEATED_PRESETS", "EXTRA_TEST_PRESETS")

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

bazelrc_preset_test(
    name = "test_allow_repeated_flag",
    extra_presets = ALLOW_REPEATED_PRESETS,
)

assert_contains(
    name = "test_allow_repeated_flag_contains_the_first_value",
    actual = ":test_allow_repeated_flag",
    expected = "common --allow_repeated_flag=1",
)

assert_contains(
    name = "test_allow_repeated_flag_contains_the_second_value",
    actual = ":test_allow_repeated_flag",
    expected = "common --allow_repeated_flag=2",
)

write_file(
    name = "generated_diff_fixture",
    out = "generated_diff_fixture.txt",
    content = ["matching", ""],
)

hermetic_diff(
    name = "preset_diff_fixture",
    old_file = "preset_diff_fixture.txt",
    new_file = ":generated_diff_fixture",
)

native_test(
    name = "hermetic_diff_test",
    src = "//private:check_preset_diff.sh",
    args = ["--compare", "$(rootpath :preset_diff_fixture)", "//tests:preset.update"],
    data = [":preset_diff_fixture"],
)
