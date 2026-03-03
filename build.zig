const std = @import("std");

const available_dev_tools_str: []const u8 =
    \\Available dev-tools are:
    \\    export-units
    \\    export-constants
    \\    export-all
    \\    prefix-units
    \\    clean-units
    \\    clean-constants
    \\    clean-all
;

const dev_tools_invoke_str: []const u8 = "dev-tools invoked without arguments.";
const dev_tools_unknown_str: []const u8 = "Unknown dev-tools `{s}`.";

const dev_tools_no_args_msg: []const u8 = dev_tools_invoke_str ++ " " ++ available_dev_tools_str;

const dev_tools_unknown_msg: []const u8 = dev_tools_unknown_str ++ " " ++ available_dev_tools_str;

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

        // Export units
        //
        const exe_units = b.addExecutable(.{
            .name = "reexport_units",
            .root_module = b.createModule(.{
                .root_source_file = b.path("dev/tools/reexport_units.zig"),
                .target = targetOption,
                .optimize = optimizeOption,
            }),
        });
        exe_units.root_module.addImport("aztro", module);
        const run_units = b.addRunArtifact(exe_units);

        // Export constants
        //
        const exe_constants = b.addExecutable(.{
            .name = "reexport_constants",
            .root_module = b.createModule(.{
                .root_source_file = b.path("dev/tools/reexport_constants.zig"),
                .target = targetOption,
                .optimize = optimizeOption,
            }),
        });
        exe_constants.root_module.addImport("aztro", module);
        const run_constants = b.addRunArtifact(exe_constants);

        // Clean units export
        //
        const exe_clean_units = b.addExecutable(.{
            .name = "clean_units",
            .root_module = b.createModule(.{
                .root_source_file = b.path("dev/tools/clean_export_units.zig"),
                .target = targetOption,
                .optimize = optimizeOption,
            }),
        });
        const run_clean_units = b.addRunArtifact(exe_clean_units);

        // Clean constants export
        //
        const exe_clean_constants = b.addExecutable(.{
            .name = "clean_constants",
            .root_module = b.createModule(.{
                .root_source_file = b.path("dev/tools/clean_export_constants.zig"),
                .target = targetOption,
                .optimize = optimizeOption,
            }),
        });
        const run_clean_constants = b.addRunArtifact(exe_clean_constants);

        const dev_tools_no_args = b.addFail(dev_tools_no_args_msg);

        const exe_prefix_units = b.addExecutable(.{
            .name = "prefix_units",
            .root_module = b.createModule(.{
                .root_source_file = b.path("dev/tools/prefix_builder.zig"),
                .target = targetOption,
                .optimize = optimizeOption,
            }),
        });
        exe_prefix_units.root_module.addImport("aztro", module);
        const run_prefix_units = b.addRunArtifact(exe_prefix_units);

        if (b.args) |args| {
            if (args.len == 0) {
                dev_tools.dependOn(&dev_tools_no_args.step);
            } else {
                for_loop: for (args) |arg| {
                    if (std.mem.eql(u8, arg, "prefix-units")) {
                        dev_tools.dependOn(&run_prefix_units.step);
                        break :for_loop;
                    }
                    if (std.mem.eql(u8, arg, "export-all")) {
                        dev_tools.dependOn(&run_units.step);
                        dev_tools.dependOn(&run_constants.step);
                        break :for_loop;
                    }
                    if (std.mem.eql(u8, arg, "export-units")) {
                        dev_tools.dependOn(&run_units.step);
                        break :for_loop;
                    }
                    if (std.mem.eql(u8, arg, "export-constants")) {
                        dev_tools.dependOn(&run_constants.step);
                        break :for_loop;
                    }
                    if (std.mem.eql(u8, arg, "clean-all")) {
                        dev_tools.dependOn(&run_clean_units.step);
                        dev_tools.dependOn(&run_clean_constants.step);
                        break :for_loop;
                    }
                    if (std.mem.eql(u8, arg, "clean-units")) {
                        dev_tools.dependOn(&run_clean_units.step);
                        break :for_loop;
                    }
                    if (std.mem.eql(u8, arg, "clean-constants")) {
                        dev_tools.dependOn(&run_clean_constants.step);
                        break :for_loop;
                    } else {
                        var buf: [256]u8 = undefined;
                        const msg = std.fmt.bufPrint(&buf, dev_tools_unknown_msg, .{arg}) catch {
                            std.debug.panic(dev_tools_unknown_msg, .{arg});
                        };
                        const dev_tools_unknown_arg = b.addFail(msg);
                        dev_tools.dependOn(&dev_tools_unknown_arg.step);
                    }
                }
            }
        } else {
            dev_tools.dependOn(&dev_tools_no_args.step);
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
