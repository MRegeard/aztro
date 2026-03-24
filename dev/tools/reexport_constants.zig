const std = @import("std");
const zali = @import("zali");
const csts = zali.constants;
const codata2022 = csts.codata2022;
const iau2015 = csts.iau2015;

const mods = .{ codata2022, iau2015 };

const file_path = "src/constants.zig";

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const file = try std.fs.cwd().openFile(file_path, .{ .mode = .read_write, .lock = .exclusive });
    defer file.close();

    var buf: [1024]u8 = undefined;
    var file_reader = file.reader(&buf);
    const reader = &file_reader.interface;
    var file_writer = file.writer(&buf);
    const writer = &file_writer.interface;

    const write_pos: u64 = @intCast(getWritePos(reader));

    const tail_size: u64 = @intCast(getTailPos(reader));
    const tail_pos: u64 = tail_size + write_pos;
    const len_to_end = (try file.getEndPos()) - tail_pos;

    try file_reader.seekTo(tail_pos);
    const tail = try reader.readAlloc(allocator, len_to_end);

    try file_writer.seekTo(write_pos);
    try writeExport(allocator, writer, mods);
    try writer.writeAll(tail);

    try writer.flush();
}

fn writeExport(allocator: std.mem.Allocator, writer: *std.Io.Writer, modules: anytype) !void {
    try writer.writeByte('\n');
    inline for (modules) |m| {
        const full_module_name = @typeName(m);
        const dot_index = std.mem.indexOf(u8, full_module_name, ".") orelse @panic("No '.' found while triming module name");
        const module_name = full_module_name[dot_index + 1 ..];
        const comments_write = try std.fmt.allocPrint(allocator, "// {s}\n", .{module_name});
        try writer.writeAll(comments_write);
        inline for (@typeInfo(m).@"struct".decls) |dec| {
            const to_write = try std.fmt.allocPrint(allocator, "pub const {s} = {s}.{s};\n", .{ dec.name, module_name, dec.name });
            try writer.writeAll(to_write);
        }
        try writer.writeByte('\n');
    }
}

fn getWritePos(reader: *std.Io.Reader) usize {
    var counts: usize = 0;
    while (true) {
        const line = reader.takeDelimiterInclusive('\n') catch break;
        if (std.mem.startsWith(u8, line, "// EXPORT ANCHOR")) {
            counts += line.len;
            return counts;
        }
        counts += line.len;
    }
    @panic("Anchor not found");
}

fn getTailPos(reader: *std.Io.Reader) usize {
    var counts: usize = 0;
    while (true) {
        const line = reader.takeDelimiterInclusive('\n') catch break;
        if (std.mem.startsWith(u8, line, "// EXPORT ANCHOR END")) {
            return counts;
        }
        counts += line.len;
    }
    @panic("Anchor not found");
}
