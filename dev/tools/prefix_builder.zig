const std = @import("std");
const zali = @import("zali");
const units = zali.units;
const Unit = units.Unit;
const si = units.si;
const cgs = units.cgs;
const astrophys = units.astrophys;
const misc = units.misc;
const imperial = units.imperial;
const photometric = units.photometric;
const prefix_table = @import("prefix_table.zig");
const UnitPrefixPair = prefix_table.UnitPrefixPair;

const UPP = prefix_table.UPP;

const mods = .{ si, cgs, photometric, astrophys, misc, imperial };

const file_path = "src/units/units_storage.zig";

const imports: []const u8 =
    \\const std = @import("std");
    \\const Unit = @import("unit.zig").Unit;
    \\const utils = @import("utils.zig");
    \\const defUnitFromUnit = utils.defUnitFromUnit;
    \\const si = @import("si.zig");
    \\const cgs = @import("cgs.zig");
    \\const astrophys = @import("astrophys.zig");
    \\const misc = @import("misc.zig");
    \\const imperial = @import("imperial.zig");
    \\const photometric = @import("photometric.zig");
    \\
;

const separator: []const u8 = "//////////////////////////////////////////////////////\n";

const file_comment: []const u8 =
    \\//! This module file is being generated automatically by
    \\//! dev-tools (see dev/tools/prefix_builder).
    \\
;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const file = try std.fs.cwd().openFile(file_path, .{ .lock = .exclusive, .mode = .read_write });
    defer file.close();

    var buf: [128]u8 = undefined;
    var file_writer = file.writer(&buf);
    const writer = &file_writer.interface;

    try writer.writeAll(file_comment);
    try writer.writeByte('\n');

    try writer.writeAll(imports);
    try writer.writeByte('\n');
    try writer.writeByte('\n');

    inline for (mods) |mod| {
        const full_module_name = @typeName(mod);
        const dot_index = std.mem.indexOf(u8, full_module_name, ".") orelse @panic("No '.' found while triming module name");
        const module_name = full_module_name[dot_index + 1 ..];
        const upper_module_name = try std.ascii.allocUpperString(allocator, module_name);
        const comments_write = try std.fmt.allocPrint(allocator, "// {s}\n", .{upper_module_name});
        try writer.writeAll(separator);
        try writer.writeAll(comments_write);
        try writer.writeAll(separator);
        try writer.writeByte('\n');

        inline for (@typeInfo(mod).@"struct".decls) |decl| {
            const prefix_comment = try std.fmt.allocPrint(allocator, "// {s}\n", .{decl.name});
            try writer.writeAll(prefix_comment);
            const base_unit_str = try std.fmt.allocPrint(allocator, "pub const {s} = {s}.{s};\n", .{ decl.name, module_name, decl.name });
            try writer.writeAll(base_unit_str);
            const unit = @field(mod, decl.name);

            if (getUnitPrefixPair(unit)) |pair| {
                for (0..pair.prefs.len) |pref_idx| {
                    const pref = pair.prefs.list[pref_idx];
                    const pref_str = try std.fmt.allocPrint(
                        allocator,
                        "pub const {s}{s}: Unit = defUnitFromUnit({s}.{s}, {e}, .initUniqueSymbol(\"{s}{s}\"));\n",
                        .{ @tagName(pref), decl.name, module_name, decl.name, pref.value(), @tagName(pref), decl.name },
                    );
                    try writer.writeAll(pref_str);
                }
            }
            try writer.writeByte('\n');
        }
    }

    try writer.flush();
    try file_writer.end();
}

pub fn getUnitPrefixPair(unit: Unit) ?UnitPrefixPair {
    for (UPP) |pair| {
        if (pair.unit.eqlExact(unit)) return pair;
    }
    return null;
}
