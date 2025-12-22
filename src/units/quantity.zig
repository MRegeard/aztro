const std = @import("std");
const math = std.math;
const testing = std.testing;
const Unit = @import("unit.zig").Unit;
const si = @import("si.zig");

pub fn Quantity(comptime T: type, comptime U: Unit) type {
    return struct {
        const Self = @This();

        pub const unit = U;

        value: T,

        pub fn init(value: T) Self {
            return .{ .value = value };
        }

        pub fn add(self: Self, other: Self) Self {
            return Quantity(T, U).init(self.value + other.value);
        }

        pub fn addInPlace(self: *Self, other: Self) void {
            self.value += other.value;
        }

        pub fn sub(self: Self, other: Self) Self {
            return Quantity(T, U).init(self.value - other.value);
        }

        pub fn subInPlace(self: *Self, other: Self) void {
            self.value -= other.value;
        }

        pub fn mul(self: Self, other: anytype) Quantity(T, U.mul(@TypeOf(other).unit)) {
            if (@TypeOf(other.value) != T) {
                @compileError("To multiply quantity, value type must match.");
            }
            return .init(self.value * other.value);
        }

        pub fn div(self: Self, other: anytype) Quantity(T, U.div(@TypeOf(other).unit)) {
            if (@TypeOf(other.value) != T) {
                @compileError("To divide quantity, value type must match.");
            }
            return .init(self.value / other.value);
        }
    };
}


test "init" {
    comptime {
        const size = Quantity(f64, si.m).init(3.1415);
        try testing.expectEqual(size.value, 3.1415);
        try testing.expectEqual(@TypeOf(size).unit, si.m);
    }
}

test "add" {
    comptime {
        const time1 = Quantity(u64, si.s).init(10);
        const time2 = Quantity(u64, si.s).init(15);
        const timeRes = time1.add(time2);
        try testing.expectEqual(timeRes.value, 25);
    }
}

test "addInPlace" {
    comptime {
        var time1 = Quantity(u32, si.s).init(15);
        const time2 = Quantity(u32, si.s).init(5);
        time1.addInPlace(time2);
        try testing.expectEqual(time1.value, 20);
    }
}

test "sub" {
    comptime {
        const size1 = Quantity(u8, si.AA).init(12);
        const size2 = Quantity(u8, si.AA).init(3);
        const sizeRes = size1.sub(size2);
        try testing.expectEqual(sizeRes.value, 9);
    }
}

test "subInPlace" {
    comptime {
        var freq1 = Quantity(i32, si.Hz).init(50);
        const freq2 = Quantity(i32, si.Hz).init(70);
        freq1.subInPlace(freq2);
        try testing.expectEqual(freq1.value, -20);
    }
}

test "mul" {
    comptime {
        const size1 = Quantity(f64, si.m).init(10);
        const size2 = Quantity(f64, si.m).init(3);
        const area = size1.mul(size2);
        try testing.expectEqual(area.value, 30);
        try testing.expectEqual(si.m.mul(si.m), @TypeOf(area).unit);
    }
}

test "div" {
    comptime {
        const size = Quantity(f64, si.m).init(5);
        const time = Quantity(f64, si.s).init(2);
        const speed = size.div(time);
        try testing.expectEqual(2.5, speed.value);
        try testing.expectEqual(si.m.div(si.s), @TypeOf(speed).unit);
    }
}


// No setup for comptime error at the moment
//test "Errors" {
//    comptime {
//        const size = Quantity(u8, si.m).init(10);
//        const time = Quantity(u16, si.s).init(3);
//        _ = size.add(time);
//        _ = size.mul(time);
//    }
//}

