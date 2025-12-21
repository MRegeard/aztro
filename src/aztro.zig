const std = @import("std");
const testing = std.testing;
const units = @import("units.zig");

test {
    testing.refAllDecls(@This());
    _ = units;
}
