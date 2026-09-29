"""Compare files with the hermetic diff.bzl toolchain."""

_DIFFUTILS_TOOLCHAIN_TYPE = "@diff.bzl//diff/toolchain:execution_type"

def _hermetic_diff_impl(ctx):
    diff_bin = ctx.toolchains[_DIFFUTILS_TOOLCHAIN_TYPE].diffutilsinfo.diff_bin
    patch = ctx.outputs.patch

    ctx.actions.run_shell(
        inputs = [ctx.file.old_file, ctx.file.new_file],
        tools = [diff_bin],
        outputs = [patch],
        arguments = [diff_bin.path, ctx.file.old_file.path, ctx.file.new_file.path, patch.path],
        command = 'status=0; "$1" "$2" "$3" > "$4" || status=$?; [ "$status" -lt 2 ]',
        mnemonic = "HermeticDiff",
        toolchain = _DIFFUTILS_TOOLCHAIN_TYPE,
    )

    return DefaultInfo(files = depset([patch]))

# diff.bzl 0.5.8's diff rule references a private options target on Bazel 6.
# Use its public toolchain directly until that rule supports Bazel 6 consumers.
_hermetic_diff = rule(
    implementation = _hermetic_diff_impl,
    attrs = {
        "old_file": attr.label(allow_single_file = True, mandatory = True),
        "new_file": attr.label(allow_single_file = True, mandatory = True),
        "patch": attr.output(mandatory = True),
    },
    toolchains = [_DIFFUTILS_TOOLCHAIN_TYPE],
)

def hermetic_diff(name, old_file, new_file, **kwargs):
    _hermetic_diff(
        name = name,
        old_file = old_file,
        new_file = new_file,
        patch = name + ".patch",
        **kwargs
    )
