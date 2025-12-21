const std = @import("std");
const testing = std.testing;
const unit = @import("unit.zig");
const Unit = unit.Unit;
const si = @import("si.zig");

fn getUnit(comptime symbole: []const u8) @TypeOf(@field(si, symbole)) {
    if (!@hasDecl(si, symbole)) {
        @compileError("Unknown SI unit: " ++ symbole);
    }
    return @field(si, symbole);
}

pub fn QuantityFromUnitString(comptime T: type, comptime symbole: []const u8) Quantity(T, @TypeOf(@field(si, symbole))) {
    return Quantity(T, getUnit(symbole));
}

pub fn Quantity(comptime T: type, comptime u: anytype) type {
    if (!unit.isUnitType(@TypeOf(u))) {
        @compileError("u must be a aztro.Unit type.");
    }
    return struct {
        const Self = @This();

        value: T,
        const __is_aztro_quantity = true;

        const __unit = u;

        pub fn init(value: T) Self {
            return .{ .value = value };
        }

        pub fn unit(self: Self) @TypeOf(Self.__unit) {
            return @TypeOf(self).__unit;
        }

        pub fn valueType(self: Self) type {
            return @TypeOf(self.value);
        }

        pub fn add(comptime self: Self, comptime other: anytype) Self {
            const otherType = @TypeOf(other);
            if (!isQuantityType(otherType)) {
                @compileError("other is not a valid Quantity type.");
            }
            if (self.eql(other)) {
                const resQuantity = Quantity(self.valueType(), self.unit());
                return resQuantity.init(self.value + other.value);
            } else {
                @compileError("To add, both Quantity must have the same Unit.");
            }
        }

        pub fn addInPlace(comptime self: *Self, comptime other: anytype) void {
            const otherType = @TypeOf(other);
            if (!isQuantityType(otherType)) {
                @compileError("other is not a valid Quantity type.");
            }
            if (self.eql(other)) {
                self.value += other.value;
            } else {
                @compileError("To add, both Quantity must have the same Unit.");
            }
        }

        pub fn sub(comptime self: Self, comptime other: anytype) Self {
            const otherType = @TypeOf(other);
            if (!isQuantityType(otherType)) {
                @compileError("other is not a valid Quantity type.");
            }
            if (self.eql(other)) {
                const resQuantity = Quantity(self.valueType(), self.unit());
                return resQuantity.init(self.value - other.value);
            } else {
                @compileError("To substract, both Quantity must have the same Unit.");
            }
        }

        pub fn subInPlace(comptime self: *Self, comptime other: anytype) void {
            const otherType = @TypeOf(other);
            if (!isQuantityType(otherType)) {
                @compileError("other is not a valid Quantity type.");
            }
            if (self.eql(other)) {
                self.value -= other.value;
            } else {
                @compileError("To substract, both Quantity must have the same Unit.");
            }
        }

        pub fn mul(self: Self, other: anytype) Quantity(self.valueType(), self.unit().mul(other.unit())) {
            const otherType = @TypeOf(other);
            if (!isQuantityType(otherType)) {
                @compileError("other is not a valid Quantity type.");
            }
            if (self.valueType() == other.valueType()) {
                const resQuantity = Quantity(self.valueType(), self.unit().mul(other.unit()));
                return resQuantity.init(self.value * other.value);
            } else {
                @compileError("To multiply, both Quantity must have the same value type.");
            }
        }

        pub fn div(self: Self, other: anytype) Quantity(self.valueType(), self.unit().div(other.unit())) {
            const otherType = @TypeOf(other);
            if (!isQuantityType(otherType)) {
                @compileError("other is not a valid Quantity type.");
            }
            if (self.valueType() == other.valueType()) {
                const resQuantity = Quantity(self.valueType(), self.unit().div(other.unit()));
                return resQuantity.init(self.value / other.value);
            } else {
                @compileError("To multiply, both Quantity must have the same value type.");
            }
        }

        pub fn eql(comptime self: Self, comptime other: anytype) bool {
            const otherType = @TypeOf(other);
            if (!isQuantityType(otherType)) {
                @compileError("other is not a valid Quantity type.");
            }
            if (self.unit().eql(other.unit()) and self.valueType() == other.valueType()) {
                return true;
            } else {
                return false;
            }
        }
    };
}

pub fn isQuantityType(comptime T: type) bool {
    return @typeInfo(T) == .@"struct" and @hasDecl(T, "__is_aztro_quantity");
}

test "init" {
    comptime {
        const size = Quantity(f64, si.m).init(3.1415);
        try testing.expectEqual(size.value, 3.1415);
        try testing.expectEqual(size.unit(), si.m);
    }
}

test "add" {
    comptime {
        const time1 = Quantity(u64, si.s).init(10);
        const time2 = Quantity(u64, si.s).init(15);
        const timeRes = time1.add(time2);
        try testing.expectEqual(timeRes.value, 25);
        try testing.expectEqual(timeRes.unit(), si.s);
    }
}

test "addInPlace" {
    comptime {
        var time1 = Quantity(u32, si.s).init(15);
        const time2 = Quantity(u32, si.s).init(5);
        time1.addInPlace(time2);
        try testing.expectEqual(time1.value, 20);
        try testing.expectEqual(time1.unit(), si.s);
    }
}

test "sub" {
    comptime {
        const size1 = Quantity(u8, si.AA).init(12);
        const size2 = Quantity(u8, si.AA).init(3);
        const sizeRes = size1.sub(size2);
        try testing.expectEqual(sizeRes.value, 9);
        try testing.expectEqual(sizeRes.unit(), si.AA);
    }
}

test "subInPlace" {
    comptime {
        var freq1 = Quantity(i32, si.Hz).init(50);
        const freq2 = Quantity(i32, si.Hz).init(70);
        freq1.subInPlace(freq2);
        try testing.expectEqual(freq1.value, -20);
        try testing.expectEqual(freq1.unit(), si.Hz);
    }
}

test "mul" {
    comptime {
        const size1 = Quantity(f64, si.m).init(10);
        const size2 = Quantity(f64, si.m).init(3);
        const area = size1.mul(size2);
        try testing.expectEqual(area.value, 30);
        try testing.expectEqual(area.unit(), si.m.mul(si.m));
    }
}

test "div" {
    comptime {
        const size = Quantity(f64, si.m).init(5);
        const time = Quantity(f64, si.s).init(2);
        const speed = size.div(time);
        try testing.expectEqual(speed.value, 2.5);
        try testing.expectEqual(speed.unit(), si.m.div(si.s));
    }
}

test "getUnit" {
    comptime {
        const meter = getUnit("m");
        try testing.expectEqual(meter, si.m);
    }
}
