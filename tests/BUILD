load("@aspect_bazel_lib//lib:testing.bzl", "assert_contains")
load("@bazel_skylib//rules:native_binary.bzl", "native_test")
load("//:bazelrc-preset.bzl", "bazelrc_preset")
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
    extra_presets = EXTRA_TEST_PRESETS,
    tags = ["manual"],
)

assert_contains(
    name = "test_with_extra_presets",
    actual = ":preset_with_extra_presets",
    expected = "common:foo --extra_preset_test",
)
