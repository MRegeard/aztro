const std = @import("std");
const fmt = std.fmt;
const math = std.math;
const mem = std.mem;
const testing = std.testing;
const dimMod = @import("dim.zig");
const Dim = dimMod.Dim;

pub const Unit = struct {
    const Self = @This();

    dim: Dim,
    scale: f64 = 1.0,
    offset: f64 = 0.0,
    symbol: []const u8,

    pub fn init(dim: Dim, scale: f64, symbol: []const u8) Self {
        return .{ .dim = dim, .scale = scale, .symbol = symbol };
    }

    pub fn initAffine(dim: Dim, scale: f64, offset: f64, symbol: []const u8) Self {
        return .{ .dim = dim, .scale = scale, .offset = offset, .symbol = symbol };
    }

    pub fn eqlExact(self: Self, other: Self) bool {
        return self.dim.eql(other.dim) and
            self.scale == other.scale and
            self.offset == other.offset and
            mem.eql(u8, self.symbol, other.symbol);
    }

    pub fn mul(self: Self, other: Self) Self {
        if (self.offset != 0.0 or other.offset != 0.0) {
            @compileError("Cannot multiply affine units (non-zero offset).");
        }
        return .{
            .dim = self.dim.add(other.dim),
            .scale = self.scale * other.scale,
            .offset = 0.0,
            .symbol = fmt.comptimePrint("{s} {s}", .{ self.symbol, other.symbol }),
        };
    }

    pub fn div(self: Self, other: Self) Self {
        if (self.offset != 0.0 or other.offset != 0.0) {
            @compileError("Cannot divide affine units (non-zero offset).");
        }
        return .{
            .dim = self.dim.sub(other.dim),
            .scale = self.scale / other.scale,
            .offset = 0.0,
            .symbol = fmt.comptimePrint("{s} ({s})-1", .{ self.symbol, other.symbol }),
        };
    }

    pub fn pow(self: Self, comptime y: isize) Self {
        if (self.offset != 0.0) {
            @compileError("Cannot divide affine units (non-zero offset).");
        }
        return .{
            .dim = self.dim.selfMul(y),
            .scale = std.math.pow(f64, self.scale, y),
            .offset = 0.0,
            .symbol = fmt.comptimePrint("({s}){d}", .{ self.symbol, y }),
        };
    }

};

test "test init" {
    const meter: Unit = .init(dimMod.length, 1.0, "m");
    try testing.expectEqual(meter.dim, dimMod.length);
    try testing.expectEqual(meter.scale, 1.0);
    try testing.expectEqual(meter.symbol, "m");
    try testing.expectEqual(meter.offset, 0.0);
}

test "test init affine" {
    const degC: Unit = .initAffine(dimMod.temperature, 1.0, 273.15, "degC");
    try testing.expectEqual(degC.dim, dimMod.temperature);
    try testing.expectEqual(degC.scale, 1.0);
    try testing.expectEqual(degC.symbol, "degC");
    try testing.expectEqual(degC.offset, 273.15);
}

test "test multiply units" {
    comptime {
        const meter1: Unit = .init(dimMod.length, 1, "m");
        const meter2: Unit = .init(dimMod.length, 1, "m");
        const meterSquare = meter1.mul(meter2);
        try testing.expectEqual(meterSquare.scale, 1.0);
        try testing.expectEqual(meterSquare.offset, 0.0);
        try testing.expectEqual(meterSquare.symbol, "m m");
        try testing.expectEqual(meterSquare.dim, dimMod.length.add(dimMod.length));
    }
}

test "test divid units" {
    comptime {
        const meter: Unit = .init(dimMod.length, 1, "m");
        const centimeter: Unit = .init(dimMod.length, 0.01, "cm");
        const meterCentimeter = meter.div(centimeter);
        try testing.expectEqual(meterCentimeter.scale, 100);
        try testing.expectEqual(meterCentimeter.offset, 0.0);
        try testing.expectEqual(meterCentimeter.symbol, "m (cm)-1");
        try testing.expectEqual(meterCentimeter.dim, dimMod.length.sub(dimMod.length));
    }
}

test "pow" {
    comptime {
        const cm: Unit = .init(dimMod.length, 0.01, "m");
        const cmCube = cm.pow(3);
        try testing.expect(math.approxEqAbs(f64, cmCube.scale, 1e-6, 1e-15));
        try testing.expectEqual(0.0, cmCube.offset);
        try testing.expectEqual(dimMod.length.add(dimMod.length.add(dimMod.length)), cmCube.dim);
        try testing.expectEqual("(m)3", cmCube.symbol);
    }
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
