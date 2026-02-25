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

    // dev-tools
    {
        const dev_tools = b.step("dev-tools", "Run dev tool: zig build dev-tools -- <name|all>");

        const exe_units = b.addExecutable(.{
            .name = "reexport_units",
            .root_module = b.createModule(.{
                .root_source_file = b.path("dev/tools/reexport_units.zig"),
                .target = targetOption,
                .optimize = optimizeOption,
            }),
        });
        const run_units = b.addRunArtifact(exe_units);
        const step_units = b.step("reexport_units", "Re-export defined units to src/units.zig file");
        step_units.dependOn(&run_units.step);

        const exe_constants = b.addExecutable(.{
            .name = "reexport_constants",
            .root_module = b.createModule(.{
                .root_source_file = b.path("dev/tools/reexport_constants.zig"),
                .target = targetOption,
                .optimize = optimizeOption,
            }),
        });
        const run_constants = b.addRunArtifact(exe_constants);
        const step_constants = b.step("reexport_constants", "Re-export defined constants to srd/constants.zig");
        step_constants.dependOn(&run_constants.step);

        if (b.args) |args| {
            if (args.len == 0) {
                dev_tools.dependOn(step_units);
                dev_tools.dependOn(step_constants);
            } else {
                for_loop: for (args) |arg| {
                    if (std.mem.eql(u8, arg, "all")) {
                        dev_tools.dependOn(step_units);
                        dev_tools.dependOn(step_constants);
                        break :for_loop;
                    }
                    if (std.mem.eql(u8, arg, "units")) {
                        dev_tools.dependOn(step_units);
                        break :for_loop;
                    }
                    if (std.mem.eql(u8, arg, "constants")) {
                        dev_tools.dependOn(step_constants);
                        break :for_loop;
                    } else {
                        std.debug.panic("Unknown dev tool '{s}'. Available dev-tools are:\n    all\n    units\n    constants\n", .{arg});
                    }
                }
            }
        } else {
            dev_tools.dependOn(step_units);
            dev_tools.dependOn(step_constants);
        }
    }

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
