const std = @import("std");

pub fn build(b: *std.Build) void {
    const targetOption = b.standardTargetOptions(.{});
    const optimizeOption = b.standardOptimizeOption(.{});

    const module = b.addModule("aztro", .{
        .root_source_file = b.path("src/aztro.zig"),
        .target = targetOption,
        .optimize = optimizeOption,
    });

    const tests = b.addTest(.{
        .root_module = module,
    });

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_tests.step);

    // Docs
    {
        const lib = b.addLibrary(.{
            .linkage = .static,
            .name = "aztro",
            .root_module = module,
        });
        b.installArtifact(lib);

        const install_docs = b.addInstallDirectory(.{
            .source_dir = lib.getEmittedDocs(),
            .install_dir = .prefix,
            .install_subdir = "docs",
        });

        const docs_step = b.step("docs", "Install docs into zig-out/docs");
        docs_step.dependOn(&install_docs.step);
    }
}
