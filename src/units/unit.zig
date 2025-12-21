const std = @import("std");
const testing = std.testing;
const dim = @import("dim.zig");
const Dim = dim.Dim;

pub fn Unit(comptime inputDim: Dim) type {
    return struct {
        const Self = @This();

        const __dim = inputDim;
        const __is_aztro_unit = true;
        scale: f64 = 1.0,
        offset: f64 = 0.0,
        symbol: []const u8,

        pub fn init(scale: f64, symbol: []const u8) Self {
            return .{ .scale = scale, .symbol = symbol };
        }

        pub fn initAffine(scale: f64, offset: f64, symbol: []const u8) Self {
            return .{ .scale = scale, .offset = offset, .symbol = symbol };
        }

        pub fn dim(self: Self) Dim {
            return @TypeOf(self).__dim;
        }

        pub fn eql(comptime self: Self, comptime other: anytype) bool {
            const otherType = @TypeOf(other);
            if (!isUnitType(otherType)) {
                @compileError("other is not a valid Unit type.");
            }
            if ((self.dim().eql(other.dim())) and (self.scale == other.scale) and (self.offset == other.offset) and std.mem.eql(u8, self.symbol, other.symbol)) {
                return true;
            } else {
                return false;
            }
        }

        pub fn mul(comptime self: Self, comptime other: anytype) Unit(self.dim().add(other.dim())) {
            const otherType = @TypeOf(other);
            if (!isUnitType(otherType)) {
                @compileError("other is not a valide Unit type.");
            }
            if (self.offset != 0.0 or other.offset != 0.0) {
                @compileError("Cannot multiply affine units (non-zero offset).");
            }
            const returnUnit = Unit(self.dim().add(other.dim()));
            return returnUnit.init(
                self.scale * other.scale,
                std.fmt.comptimePrint("{s} {s}", .{ self.symbol, other.symbol }),
            );
        }

        pub fn div(self: Self, other: anytype) Unit(self.dim().sub(other.dim())) {
            const otherType = @TypeOf(other);
            if (!isUnitType(otherType)) {
                @compileError("other is not a valide Unit type.");
            }
            if (self.offset != 0.0 or other.offset != 0.0) {
                @compileError("Cannot divide affine units (non-zero offset).");
            }
            const returnUnit = Unit(self.dim().sub(other.dim()));
            return returnUnit.init(
                self.scale / other.scale,
                std.fmt.comptimePrint("{s} ({s})-1", .{ self.symbol, other.symbol }),
            );
        }

        pub fn pow(self: Self, comptime y: isize) Unit(self.dim().selfMul(y)) {
            const returnUnit = Unit(self.dim().unitPow(y));
            return returnUnit.init(
                std.math.pow(f64, self.scale, y),
                std.fmt.comptimePrint("({s}){d}", .{ self.symbol, y }),
            );
        }
    };
}

pub fn isUnitType(comptime T: type) bool {
    return @typeInfo(T) == .@"struct" and @hasDecl(T, "__is_aztro_unit");
}

test "test init" {
    const lengthUnit = Unit(dim.length);
    const meter = lengthUnit.init(1.0, "m");
    try testing.expectEqual(meter.dim(), dim.length);
    try testing.expectEqual(meter.scale, 1.0);
    try testing.expectEqual(meter.symbol, "m");
    try testing.expectEqual(meter.offset, 0.0);
}

test "test init affine" {
    const tempUnit = Unit(dim.temperature);
    const degC = tempUnit.initAffine(1.0, 273.15, "degC");
    try testing.expectEqual(degC.dim(), dim.temperature);
    try testing.expectEqual(degC.scale, 1.0);
    try testing.expectEqual(degC.symbol, "degC");
    try testing.expectEqual(degC.offset, 273.15);
}

test "test multiply units" {
    comptime {
        const lengthUnit = Unit(dim.length);
        const meter1 = lengthUnit.init(1, "m");
        const meter2 = lengthUnit.init(1, "m");
        const meterSquare = meter1.mul(meter2);
        try testing.expectEqual(meterSquare.scale, 1.0);
        try testing.expectEqual(meterSquare.offset, 0.0);
        try testing.expectEqual(meterSquare.symbol, "m m");
        try testing.expectEqual(meterSquare.dim(), dim.length.add(dim.length));
    }
}

test "test divid units" {
    comptime {
        const lengthUnit = Unit(dim.length);
        const meter = lengthUnit.init(1, "m");
        const centimeter = lengthUnit.init(0.01, "cm");
        const meterCentimeter = meter.div(centimeter);
        try testing.expectEqual(meterCentimeter.scale, 100);
        try testing.expectEqual(meterCentimeter.offset, 0.0);
        try testing.expectEqual(meterCentimeter.symbol, "m (cm)-1");
        try testing.expectEqual(meterCentimeter.dim(), dim.length.sub(dim.length));
    }
}

test "equals" {
    comptime {
        const lengthUnit = Unit(dim.length);
        const meter = lengthUnit.init(1, "m");
        const meter2 = lengthUnit.init(1, "m");
        const massUnit = Unit(dim.mass);
        const kilogram = massUnit.init(1, "kg");
        try testing.expectEqual(meter.eql(meter2), true);
        try testing.expectEqual(meter.eql(kilogram), false);
    }
}

test "isUnitType" {
    const lengthUnit = Unit(dim.length);
    const meter = lengthUnit.init(1, "m");
    try testing.expectEqual(isUnitType(@TypeOf(meter)), true);
    try testing.expectEqual(isUnitType(f64), false);
}

//At the moment there is no setup to test compile error.
//test "compile errors" {
//    comptime {
//        const lengthUnit = Unit(dim.length);
//        const tempUnit = Unit(dim.temperature);
//        const meter = lengthUnit.init(1, "m");
//        const degC = tempUnit.initAffine(1.0, 273.15, "degC");
//        _ = meter.mul(degC);
//    }
//}
