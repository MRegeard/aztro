const std = @import("std");

const file_path = "src/units.zig";

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const file = try std.fs.cwd().openFile(file_path, .{ .lock = .exclusive, .mode = .read_write });
    defer file.close();

    var buf: [1024]u8 = undefined;
    var file_reader = file.reader(&buf);
    const reader = &file_reader.interface;
    var file_writer = file.writer(&buf);
    const writer = &file_writer.interface;

    const write_pos: u64 = @intCast(getHeadPos(reader));
    const tail_size: u64 = @intCast(getTailPos(reader));
    const tail_pos = write_pos + tail_size;

    try file_reader.seekTo(tail_pos);
    const len_to_end = (try file.getEndPos() - tail_pos);
    const tail = try reader.readAlloc(allocator, len_to_end);

    try file_writer.seekTo(write_pos);
    try writer.writeByte('\n');
    try writer.writeAll(tail);
    try file.setEndPos(file_writer.pos);
    try writer.flush();
}

fn getHeadPos(reader: *std.Io.Reader) usize {
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
