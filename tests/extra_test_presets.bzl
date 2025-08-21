"""Extra test presets for bazelrc-preset"""

EXTRA_TEST_PRESETS = {
    "extra_preset_as_struct": struct(
        command = "common:foo",
        default = True,
        description = """\
        Extra preset that can be provided by the user.
        For instance to predefine https://github.com/aspect-build/toolchains_protoc?tab=readme-ov-file#ensure-protobuf-and-grpc-never-built.
        """,
    ),
}

ALLOW_REPEATED_PRESETS = {
    "allow_repeated_flag": [
        struct(
            default = 1,
            description = "Value number one.",
        ),
        struct(
            default = 2,
            allow_repeated = True,
            description = "Value number two. Allows multiple commands to be specified.",
        ),
    ],
}
