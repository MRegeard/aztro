const std = @import("std");
const math = std.math;
const testing = std.testing;
const Unit = @import("unit.zig").Unit;
const si = @import("si.zig");

const QuantityError = error{UnitNotCompatibleError};

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

        pub fn to(self: Self, unit_type: Unit) QuantityError!Quantity(T, unit_type) {
            if (!U.dim.eql(unit_type.dim)) {
                return QuantityError.UnitNotCompatibleError;
            }
            const convert_scale = U.scale / unit_type.scale;
            const convert_offset = U.offset - unit_type.offset;

            return Quantity(T, unit_type).init(self.value * convert_scale + convert_offset);
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

test "to" {
    comptime {
        const size_m = Quantity(f64, si.m).init(3);
        const size_cm = try size_m.to(si.cm);
        try testing.expectEqual(300, size_cm.value);
        try testing.expectEqual(si.cm, @TypeOf(size_cm).unit);

        const mass_g = Quantity(f64, si.g).init(30);
        const mass_kg = try mass_g.to(si.kg);

        try testing.expectEqual(0.03, mass_kg.value);
        try testing.expectEqual(si.kg, @TypeOf(mass_kg).unit);

        const temp_C = Quantity(f64, si.degC).init(0);
        const temp_K = try temp_C.to(si.K);
        try testing.expectEqual(273.15, temp_K.value);
        try testing.expectEqual(si.K, @TypeOf(temp_K).unit);

        const temp_K_2 = Quantity(f64, si.K).init(0);
        const temp_C_2 = try temp_K_2.to(si.degC);
        try testing.expectEqual(-273.15, temp_C_2.value);
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
