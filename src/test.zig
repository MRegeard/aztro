const std = @import("std");

pub inline fn expectApproxEqAbsIter(expected: anytype, actual: anytype, tolerance: anytype) ! void {
    inline for (0..expected.len) |i| {
        try std.testing.expectApproxEqAbs(expected[i], actual[i], tolerance);
    }
}
