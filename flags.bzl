"Database of Bazel flags which apply across every Bazel use-case"

load("//private:util.bzl", "ge", "ge_same_major", "lt")

# buildifier: keep-sorted
FLAGS = {
    "announce_rc": struct(
        command = "common:ci",
        default = True,
        description = """\
        On CI, announce all announces command options read from the bazelrc file(s) when starting up at the
        beginning of each Bazel invocation. This is very useful on CI to be able to inspect which flags
        are being applied on each run based on the order of overrides.
        """,
    ),
    "build_runfile_links": [
        struct(
            default = False,
            description = """\
            Avoid creating a runfiles tree for binaries or tests until it is needed.
            See https://github.com/bazelbuild/bazel/issues/6627
            This may break local workflows that `build` a binary target, then run the resulting program outside of `bazel run`.
            In those cases, the script will need to call `bazel build --build_runfile_links //my/binary:target` and then execute the resulting program.
            """,
        ),
        struct(
            if_bazel_version = lt("8.0.0rc1"),
            default = True,
            command = "coverage",
            description = """\
            See https://github.com/bazelbuild/bazel/issues/20577
            """,
        ),
    ],
    "cache_test_results": struct(
        command = "common:debug",
        default = False,
        description = """\
        Always run tests even if they have cached results.
        This ensures tests are executed fresh each time, useful for debugging and ensuring test reliability.
        """,
    ),
    "check_direct_dependencies": struct(
        command = "common:ruleset",
        default = "off",
        description = """\
        Don’t encourage a rules author to update their deps if not needed.
        These bazel_dep calls should indicate the minimum version constraint of the ruleset.
        If the author instead updates to the newest of any of their transitives, as this flag would suggest,
        then they'll also force their dependents to a newer version.
        Context:
        https://bazelbuild.slack.com/archives/C014RARENH0/p1691158021917459?thread_ts=1691156601.420349&cid=C014RARENH0
        """,
    ),
    "color": struct(
        command = "common:ci",
        default = "yes",
        description = """\
        On CI, use colors to highlight output on the screen. Set to `no` if your CI does not display colors.
        """,
    ),
    "curses": struct(
        command = "common:ci",
        default = "yes",
        description = """\
        On CI, use cursor controls in screen output.
        """,
    ),
    "enable_platform_specific_config": struct(
        default = True,
        description = """\
        Bazel picks up host-OS-specific config lines from bazelrc files. For example, if the host OS is
        Linux and you run bazel build, Bazel picks up lines starting with build:linux. Supported OS
        identifiers are `linux`, `macos`, `windows`, `freebsd`, and `openbsd`. Enabling this flag is
        equivalent to using `--config=linux` on Linux, `--config=windows` on Windows, etc.
        """,
    ),
    "experimental_allow_tags_propagation": struct(
        default = True,
        if_bazel_version = ge_same_major("6.0.0"),
        description = """\
        Allow tags to be propagated to external repositories.
        Flipped to true in Bazel 7, see https://github.com/bazelbuild/bazel/commit/d0625f5b37e7cfe4ecfcff02b15f634c53d7440c
        """,
    ),
    "experimental_check_external_repository_files": struct(
        default = False,
        description = """\
        Speed up all builds by not checking if external repository files have been modified.
        For reference: https://github.com/bazelbuild/bazel/blob/1af61b21df99edc2fc66939cdf14449c2661f873/src/main/java/com/google/devtools/build/lib/bazel/repository/RepositoryOptions.java#L244
        """,
    ),
    "experimental_fetch_all_coverage_outputs": struct(
        default = True,
        description = """\
        Always download coverage files for tests from the remote cache. By default, coverage files are not
        downloaded on test result cache hits when --remote_download_minimal is enabled, making it impossible
        to generate a full coverage report.
        """,
    ),
    "experimental_remote_cache_eviction_retries": struct(
        default = 5,
        if_bazel_version = ge("6.2.0") and lt("8.0.0rc1"),
        description = """\
        This flag was added in Bazel 6.2.0 with a default of zero:
        https://github.com/bazelbuild/bazel/commit/24b45890c431de98d586fdfe5777031612049135
        For Bazel 8.0.0rc1 the default was changed to 5:
        https://github.com/bazelbuild/bazel/commit/739e37de66f4913bec1a55b2f2a162e7db6f2d0f
        Back-port the updated flag default value to older Bazel versions.
        """,
    ),
    "experimental_repository_downloader_retries": struct(
        default = 5,
        if_bazel_version = ge("5.0.0") and lt("8.0.0"),
        description = """\
        This flag was added in Bazel 5.0.0 with a default of zero:
        https://github.com/bazelbuild/bazel/commit/a1137ec1338d9549fd34a9a74502ffa58c286a8e
        For Bazel 8.0.0 the default was changed to 5:
        https://github.com/bazelbuild/bazel/commit/9335cf989ee6a678ca10bc4da72214634cef0a57
        Back-port the updated flag default value to older Bazel versions.
        """,
    ),
    "flaky_test_attempts": struct(
        command = "test:ci",
        default = 2,
        description = """\
        Set this flag to enable re-tries of failed tests on CI.
        When any test target fails, try one or more times. This applies regardless of whether the "flaky"
        tag appears on the target definition.
        This is a tradeoff: legitimately failing tests will take longer to report,
        but we can "paper over" flaky tests that pass most of the time.

        An alternative is to mark every flaky test with the `flaky = True` attribute, but this requires
        the buildcop to make frequent code edits.
        This flag is not recommended for local builds: flakiness is more likely to get fixed if it is
        observed during development.

        Note that when passing after the first attempt, Bazel will give a special "FLAKY" status rather than "PASSED".
        """,
    ),
    "grpc_keepalive_time": struct(
        command = "common:ci",
        default = "30s",
        description = """\
        Fixes builds hanging on CI that get the TCP connection closed without sending RST packets.
        """,
    ),
    "heap_dump_on_oom": struct(
        default = True,
        description = """\
        Output a heap dump if an OOM is thrown during a Bazel invocation
        (including OOMs due to `--experimental_oom_more_eagerly_threshold`).
        The dump will be written to `<output_base>/<invocation_id>.heapdump.hprof`.
        You should configure CI to upload this artifact for later inspection.
        """,
    ),
    "host_jvm_args": struct(
        default = "-DBAZEL_TRACK_SOURCE_DIRECTORIES=1",
        command = "startup",
        description = """\
        Allow the Bazel server to check directory sources for changes. Ensures that the Bazel server
        notices when a directory changes, if you have a directory listed in the srcs of some target.
        Recommended when using [copy_directory](https://github.com/bazel-contrib/bazel-lib/blob/main/docs/copy_directory.md)
        and [rules_js](https://github.com/aspect-build/rules_js) since npm package are source directories inputs to copy_directory actions.
        """,
    ),
    "incompatible_default_to_explicit_init_py": struct(
        default = True,
        description = """\
        By default, Bazel automatically creates __init__.py files for py_binary and py_test targets.
        From https://github.com/bazelbuild/bazel/issues/10076:
        > It is magic at a distance.
        > Python programmers are already used to creating __init__.py files in their source trees,
        > so doing it behind their backs introduces confusion and changes the semantics of imports
        """,
    ),
    "incompatible_disallow_empty_glob": struct(
        default = True,
        if_bazel_version = lt("8.0.0rc1"),
        description = """\
        Disallow empty glob patterns.
        The glob() function tends to be error-prone, because any typo in a path will silently return an empty list.
        This flag was added in Bazel 0.27 and flipped in Bazel 8: https://github.com/bazelbuild/bazel/issues/8195
        """,
    ),
    "incompatible_exclusive_test_sandboxed": struct(
        default = True,
        if_bazel_version = lt("7.0.0rc1"),
        description = """\
        This behavior was not intended and was a leftover from open-sourcing Bazel.
        See https://github.com/bazelbuild/bazel/issues/16871.
        """,
    ),
    "incompatible_merge_fixed_and_default_shell_env": struct(
        default = True,
        if_bazel_version = ge_same_major("6.4.0"),
        description = """\
        Actions registered with ctx.actions.run{_shell} with both 'env' and 'use_default_shell_env = True' specified
        use an environment obtained from the default shell environment by overriding with the values passed in to 'env'.
        See https://github.com/bazelbuild/bazel/pull/19319.
        """,
    ),
    "incompatible_strict_action_env": struct(
        default = True,
        description = """\
        Make builds more reproducible by using a static value for PATH and not inheriting LD_LIBRARY_PATH.
        Use `--action_env=ENV_VARIABLE` if you want to inherit specific variables from the environment where Bazel runs.
        Note that doing so can prevent cross-user caching if a shared cache is used.
        See https://github.com/bazelbuild/bazel/issues/2574 for more details.
        """,
    ),
    "legacy_external_runfiles": struct(
        default = False,
        if_bazel_version = lt("8.0.0rc1"),
        description = """\
        Performance improvement: avoid laying out a second copy of the runfiles tree.
        See https://github.com/bazelbuild/bazel/issues/23574.
        This flag was flipped for Bazel 8.
        """,
    ),
    "remote_download_outputs": struct(
        command = "common:ci",
        if_bazel_version = ge("7.0.0rc1"),
        default = "minimal",
        description = """\
        On CI, don't download remote outputs to the local machine.
        Most CI pipelines don't need to access the files and they can remain at rest on the remote cache.
        Significant time can be spent on needless downloads, which is especially noticeable on fully-cached builds.

        If you do need to download files, the fastest options are:
        - (preferred) Use `remote_download_regex` to specify the files to download.
        - Use the Remote Output Service (https://blog.bazel.build/2024/07/23/remote-output-service.html)
          to lazy-materialize specific files after the build completes.
        - Perform a second bazel command with specific targets and override this flag with the `toplevel` value.
        - To copy executable targets, you can use `bazel run --run_under=cp //some:binary_target <destination path>`.
        """,
    ),
    "remote_local_fallback": struct(
        command = "common:ci",
        default = True,
        description = """\
        On CI, fall back to standalone local execution strategy if remote execution fails.
        Otherwise, when a grpc remote cache connection fails, it would fail the build.
        """,
    ),
    "remote_timeout": struct(
        command = "common:ci",
        default = 3600,
        description = """\
        On CI, extend the maximum amount of time to wait for remote execution and cache calls.
        """,
    ),
    "remote_upload_local_results": [
        struct(
            default = False,
            description = """\
            Do not upload locally executed action results to the remote cache.
            This should be the default for local builds so local builds cannot poison the remote cache.

            Note that this flag is flipped to True under --config=ci, see below.
            """,
        ),
        struct(
            command = "common:ci",
            default = True,
            description = """\
            On CI, upload locally executed action results to the remote cache.
            """,
        ),
    ],
    "repo_env": struct(
        default = "JAVA_HOME=../bazel_tools/jdk",
        description = """\
        Repository rules, such as rules_jvm_external: put Bazel's JDK on the path.
        Avoids non-hermeticity from dependency on a JAVA_HOME pointing at a system JDK
        see https://github.com/bazelbuild/rules_jvm_external/issues/445
        """,
    ),
    "reuse_sandbox_directories": struct(
        default = True,
        description = """\
        Reuse sandbox directories between invocations.
        Directories used by sandboxed non-worker execution may be reused to avoid unnecessary setup costs.
        Saves time on sandbox creation and deletion when many of the same kind of action is spawned during the build.
        """,
    ),
    "sandbox_default_allow_network": struct(
        default = False,
        description = """\
        Don't allow network access for build actions in the sandbox by default.
        Avoids accidental non-hermeticity in actions/tests which depend on remote services.
        Developers should tag targets with `tags=["requires-network"]` to be explicit that they need network access.
        Note that the sandbox cannot print a message to the console if it denies network access,
        so failures under this flag appear as application errors in the networking layer.
        """,
    ),
    "show_progress_rate_limit": struct(
        command = "common:ci",
        default = 60,
        description = """\
        Only show progress every 60 seconds on CI.
        We want to find a compromise between printing often enough to show that the build isn't stuck,
        but not so often that we produce a long log file that requires a lot of scrolling.
        """,
    ),
    "show_result": struct(
        default = 20,
        description = """\
        The printed files are convenient strings for copy+pasting to the shell, to execute them.
        This option requires an integer argument, which is the threshold number of targets above which result information is not printed.
        Show the output files created by builds that requested more than one target.
        This helps users locate the build outputs in more cases.
        """,
    ),
    "show_timestamps": struct(
        command = "common:ci",
        default = True,
        description = """\
        On CI, add a timestamp to each message generated by Bazel specifying the time at which the message was displayed.
        This makes it easier to reason about what were the slowest steps on CI.
        """,
    ),
    "terminal_columns": struct(
        command = "common:ci",
        default = 143,
        description = """\
        The terminal width in columns. Configure this to override the default value based on what your CI system renders.
        """,
    ),
    "test_output": [
        struct(
            default = "errors",
            description = """\
            Output test errors to stderr so users don't have to `cat` or open test failure log files when test fail.
            This makes the log noisier in exchange for reducing the time-to-feedback on test failures for users.
            """,
        ),
        struct(
            command = "common:debug",
            default = "streamed",
            description = """\
            Stream stdout/stderr output from each test in real-time.
            This provides immediate feedback during test execution, useful for debugging test failures.
            """,
        ),
    ],
    "test_strategy": struct(
        command = "common:debug",
        default = "exclusive",
        description = """\
        Run one test at a time in exclusive mode.
        This prevents test interference and provides clearer output when debugging test issues.
        """,
    ),
    "test_summary": struct(
        command = "test:ci",
        default = "terse",
        description = """\
        The default test_summary ("short") prints a result for every test target that was executed.
        In a large repo this amounts to hundreds of lines of additional log output when testing a broad wildcard pattern like //...
        This value means to print information only about unsuccessful tests that were run.
        """,
    ),
    "test_timeout": struct(
        command = "common:debug",
        default = 9999,
        description = """\
        Prevent long running tests from timing out.
        Set to a high value to allow tests to complete even if they take longer than expected.
        """,
    ),
}

# Flags being flipped in the next Major release
# Based on https://github.com/bazelbuild/bazel/issues?q=is%3Aissue%20state%3Aopen%20label%3Amigration-ready
# buildifier: keep-sorted
MIGRATIONS = {
    "incompatible_auto_exec_groups": struct(
        default = True,
        if_bazel_version = ge_same_major("8.0.0"),
        description = """\
        Automatic execution groups select an execution platform for each toolchain type.
        In other words, one target can have multiple execution platforms without defining execution groups.
        Migration requires setting a toolchain parameter inside ctx.actions.{run, run_shell} for actions which use tool or executable from a toolchain.

        See https://github.com/bazelbuild/bazel/issues/17134
        """,
    ),
    "incompatible_autoload_externally": struct(
        default = "",
        if_bazel_version = ge_same_major("8.0.0"),
        description = """\
        Language specific rules (Protos, Java, C++, Android) are being rewritten to Starlark and moved from Bazel into their rules repositories
        (protobuf, rules_java, rules_cc, rules_android, apple_support).
        Because of the move the rules need to be loaded from their repositories.
        This requires adding load statements to all bzl and BUILD files that are using those rules.

        See https://github.com/bazelbuild/bazel/issues/23043
        """,
    ),
    "incompatible_config_setting_private_default_visibility": struct(
        default = True,
        if_bazel_version = ge_same_major("8.0.0"),
        description = """\
        Visibility on config_setting isn't historically enforced. This is purely for legacy reasons.
        There's no philosophical reason to distinguish them.
        Treat all config_settings as if they follow standard visibility logic at https://docs.bazel.build/versions/master/visibility.html:
        have them set visibility explicitly if they'll be used anywhere outside their own package.

        See https://github.com/bazelbuild/bazel/issues/12933
        """,
    ),
    "incompatible_disable_native_repo_rules": struct(
        default = True,
        if_bazel_version = ge_same_major("8.0.0"),
        description = """\
        When set to `true`, native repo rules cannot be used in WORKSPACE; their Starlark counterparts must be used. Native repo rules already can't be used in Bzlmod.

        See https://github.com/bazelbuild/bazel/issues/22080
        """,
    ),
    "incompatible_disable_non_executable_java_binary": struct(
        default = True,
        if_bazel_version = ge_same_major("8.0.0"),
        description = """\
        Removes create_executable attribute from java_binary.
        Migration to java_single_jar is needed.

        See https://github.com/bazelbuild/bazel/issues/19687
        """,
    ),
    "incompatible_disable_starlark_host_transitions": struct(
        default = True,
        if_bazel_version = ge_same_major("8.0.0"),
        description = """\
        Changes this syntax to be illegal: cfg = "host"
        Instead use: cfg = "exec"

        See https://github.com/bazelbuild/bazel/issues/17032
        """,
    ),
    "incompatible_exclusive_test_sandboxed": struct(
        default = True,
        if_bazel_version = ge_same_major("6.0.0"),
        description = """\
         Allow exclusive tests to run in the sandbox.
         Fixes a bug where Bazel doesn't enable sandboxing for tests with `tags=["exclusive"]`.

        See https://github.com/bazelbuild/bazel/issues/16871
        """,
    ),
    "incompatible_repo_env_ignores_action_env": struct(
        default = True,
        if_bazel_version = ge_same_major("8.3.0"),
        description = """\
        Address a counterintuitive interaction with --action_env and it's affect on repository environments.

        Note that this will implicitly affect other features which inherit the repository environment such as:
        - Credential managers
        - Download manager
        - And possibly more.

        See https://github.com/bazelbuild/bazel/issues/26222
        """,
    ),
}
