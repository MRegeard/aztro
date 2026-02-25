const std = @import("std");

pub const System = enum {
    const Self = @This();

    SI,
    CGS,
};
