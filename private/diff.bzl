"""Compare files with the hermetic diff.bzl toolchain."""

def hermetic_diff(name, old_file, new_file, **kwargs):
    attrs = dict(kwargs)
    toolchains = attrs.pop("toolchains", [])

    # diff.bzl's diff rule references a private options target on Bazel 6.
    # Its public toolchain exposes DIFF_BIN to genrules without that dependency.
    native.genrule(
        name = name,
        srcs = [old_file, new_file],
        outs = [name + ".patch"],
        cmd = "status=0; \"$(DIFF_BIN)\" \"$(execpath {})\" \"$(execpath {})\" > \"$@\" || status=$$?; [ $$status -lt 2 ]".format(old_file, new_file),
        toolchains = ["@diff.bzl//diff/toolchain:execution_type"] + list(toolchains),
        **attrs
    )
