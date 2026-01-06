const std = @import("std");
const fmt = std.fmt;
const math = std.math;
const mem = std.mem;
const testing = std.testing;
const dimMod = @import("dim.zig");
const Dim = dimMod.Dim;
const fraction = @import("fraction.zig");

const FractionError = fraction.FractionError;
const Fraction = fraction.Fraction;

pub fn returnTypeOfUnitOperation(comptime unit_1: Unit, comptime unit_2: Unit, func: fn (Unit, Unit) FractionError!Unit) type {
    const funcRes = func(unit_1, unit_2) catch |err| {
        @compileError("Unit operation failed with: " ++ @errorName(err));
    };
    return @TypeOf(funcRes);
}

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

    pub fn mul(self: Self, other: Self) FractionError!Self {
        if (self.offset != 0.0 or other.offset != 0.0) {
            @compileError("Cannot multiply affine units (non-zero offset).");
        }
        return .{
            .dim = try self.dim.add(other.dim),
            .scale = self.scale * other.scale,
            .offset = 0.0,
            .symbol = fmt.comptimePrint("{s} {s}", .{ self.symbol, other.symbol }),
        };
    }

    pub fn div(self: Self, other: Self) FractionError!Self {
        if (self.offset != 0.0 or other.offset != 0.0) {
            @compileError("Cannot divide affine units (non-zero offset).");
        }
        return .{
            .dim = try self.dim.sub(other.dim),
            .scale = self.scale / other.scale,
            .offset = 0.0,
            .symbol = fmt.comptimePrint("{s} ({s})-1", .{ self.symbol, other.symbol }),
        };
    }

    pub fn pow(self: Self, value: i32) FractionError!Self {
        if (self.offset != 0.0) {
            @compileError("Cannot power affine units (non-zero offset).");
        }
        return .{
            .dim = try self.dim.mulScalar(value),
            .scale = math.pow(f64, self.scale, value),
            .offset = 0.0,
            .symbol = fmt.comptimePrint("({s}){d}", .{ self.symbol, value }),
        };
    }

    pub fn sqrt(self: Self) FractionError!Self {
        if (self.offset != 0.0) {
            @compileError("Cannot square root affine units (non-zero offset).");
        }
        return .{
            .dim = try self.dim.divScalar(2),
            .scale = math.sqrt(self.scale),
            .offset = 0.0,
            .symbol = fmt.comptimePrint("{s}1/2", .{self.symbol}),
        };
    }

    pub fn cbrt(self: Self) FractionError!Self {
        if (self.offset != 0.0) {
            @compileError("Cannot cube root affine units (non-zero offset).");
        }
        return .{
            .dim = try self.dim.divScalar(3),
            .scale = math.cbrt(self.scale),
            .offset = 0.0,
            .symbol = fmt.comptimePrint("{s}1/3", .{self.symbol}),
        };
    }

    pub fn powByFraction(self: Self, num: i32, denum: i32) FractionError!Self {
        if (self.offset != 0.0) {
            @compileError("Cannot cube root affine units (non-zero offset).");
        }
        const frac = try Fraction(i32).init(num, denum);
        return .{
            .dim = try self.dim.mulFraction(frac),
            .scale = math.pow(f64, self.scale, frac.toFloat(f64)),
            .offset = 0.0,
            .symbol = fmt.comptimePrint("({s}){d}/{d}", .{ self.symbol, frac.num, frac.denum }),
        };
    }

    pub fn powByAztroFraction(self: Self, frac: Fraction(i32)) FractionError!Self {
        if (self.offset != 0.0) {
            @compileError("Cannot cube root affine units (non-zero offset).");
        }
        return .{
            .dim = try self.dim.mulFraction(frac),
            .scale = math.pow(f64, self.scale, frac.toFloat(f64)),
            .offset = 0.0,
            .symbol = fmt.comptimePrint("({s}){d}/{d}", .{ self.symbol, frac.num, frac.denum }),
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
        const meterSquare = try meter1.mul(meter2);
        try testing.expectEqual(meterSquare.scale, 1.0);
        try testing.expectEqual(meterSquare.offset, 0.0);
        try testing.expectEqual(meterSquare.symbol, "m m");
        try testing.expectEqual(meterSquare.dim, try dimMod.length.add(dimMod.length));
    }
}

test "test divid units" {
    comptime {
        const meter: Unit = .init(dimMod.length, 1, "m");
        const centimeter: Unit = .init(dimMod.length, 0.01, "cm");
        const meterCentimeter = try meter.div(centimeter);
        try testing.expectEqual(meterCentimeter.scale, 100);
        try testing.expectEqual(meterCentimeter.offset, 0.0);
        try testing.expectEqual(meterCentimeter.symbol, "m (cm)-1");
        try testing.expectEqual(meterCentimeter.dim, try dimMod.length.sub(dimMod.length));
    }
}

test "pow" {
    comptime {
        const cm: Unit = .init(dimMod.length, 0.01, "cm");
        const cmCube = try cm.pow(3);
        try testing.expect(math.approxEqAbs(f64, cmCube.scale, 1e-6, 1e-15));
        try testing.expectEqual(0.0, cmCube.offset);
        try testing.expectEqual(try dimMod.length.add(try dimMod.length.add(dimMod.length)), cmCube.dim);
        try testing.expectEqual("(cm)3", cmCube.symbol);
    }
}

test "sqrt" {
    comptime {
        const m2: Unit = .init(try dimMod.length.add(dimMod.length), 1, "m2");
        const m: Unit = .init(dimMod.length, 1, "m");
        const m2sqrt = try m2.sqrt();
        try testing.expect(math.approxEqAbs(f64, m.scale, m2sqrt.scale, 1e-15));
        try testing.expectEqual(0.0, m2sqrt.offset);
        try testing.expectEqual(m.dim, m2sqrt.dim);
    }
}

test "cbrt" {
    comptime {
        const m3: Unit = .init(try dimMod.length.mulScalar(3), 1, "m3");
        const m: Unit = .init(dimMod.length, 1, "m");
        const m3cbrt = try m3.cbrt();
        try testing.expect(math.approxEqAbs(f64, m.scale, m3cbrt.scale, 1e-15));
        try testing.expectEqual(0.0, m3cbrt.offset);
        try testing.expectEqual(m.dim, m3cbrt.dim);
    }
}

test "powByFraction" {
    comptime {
        const m4: Unit = .init(try dimMod.length.mulScalar(4), 1, "m4");
        const m: Unit = .init(dimMod.length, 1, "m");
        const m4PowByFrac = try m4.powByFraction(1, 4);
        try testing.expect(math.approxEqAbs(f64, m.scale, m4PowByFrac.scale, 1e-15));
        try testing.expectEqual(0.0, m4PowByFrac.offset);
        try testing.expectEqual(m.dim, m4PowByFrac.dim);
    }
}

test "powByAztroFraction" {
    comptime {
        const frac = try Fraction(i32).init(1, 4);
        const m4: Unit = .init(try dimMod.length.mulScalar(4), 1, "m4");
        const m: Unit = .init(dimMod.length, 1, "m");
        const m4PowByFrac = try m4.powByAztroFraction(frac);
        try testing.expect(math.approxEqAbs(f64, m.scale, m4PowByFrac.scale, 1e-15));
        try testing.expectEqual(0.0, m4PowByFrac.offset);
        try testing.expectEqual(m.dim, m4PowByFrac.dim);
    }
}

test "returnTypeOfUnitOperation" {
    comptime {
        const m: Unit = .init(dimMod.length, 1, "m");
        const m2: Unit = .init(try dimMod.length.add(dimMod.length), 1, "m2");
        try testing.expectEqual(@TypeOf(m2), returnTypeOfUnitOperation(m, m, Unit.mul));
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
