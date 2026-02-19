const std = @import("std");

pub fn isArrayList(comptime T: type) bool {
    if (@typeInfo(T) != .@"struct" or !@hasDecl(T, "Slice")) return false;

    const Slice = T.Slice;
    const ptr_info = switch (@typeInfo(Slice)) {
        .pointer => |info| info,
        else => return false,
    };

    return T == std.ArrayList(ptr_info.child);
}
