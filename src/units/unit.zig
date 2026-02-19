const std = @import("std");
const fmt = std.fmt;
const math = std.math;
const mem = std.mem;
const testing = std.testing;
const dimMod = @import("dim.zig");
const Dim = dimMod.Dim;
const fraction = @import("fraction.zig");
const si = @import("si.zig");

const FractionError = fraction.FractionError;
const Fraction = fraction.Fraction;

pub const UNITLESS: Unit = .init(Dim.initDimensionless(), 1.0, "");

pub const Unit = struct {
    const Self = @This();

    dim: Dim,
    scale: f64 = 1.0,
    offset: ?f64 = null,
    symbol: []const u8,

    pub fn init(dim: Dim, scale: f64, symbol: []const u8) Self {
        return .{ .dim = dim, .scale = scale, .symbol = symbol, .offset = null };
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

    pub fn tryMul(comptime self: Self, comptime other: Self) FractionError!Self {
        if (self.offset != null or other.offset != null) {
            @compileError("Cannot multiply affine units (non-zero offset).");
        }
        return .{
            .dim = try self.dim.add(other.dim),
            .scale = self.scale * other.scale,
            .offset = null,
            .symbol = fmt.comptimePrint("{s} {s}", .{ self.symbol, other.symbol }),
        };
    }

    pub fn mul(comptime self: Self, comptime other: Self) Self {
        const res = self.tryMul(other) catch unreachable;
        return res;
    }

    pub fn tryDiv(comptime self: Self, comptime other: Self) FractionError!Self {
        if (self.offset != null or other.offset != null) {
            @compileError("Cannot divide affine units (non-zero offset).");
        }
        return .{
            .dim = try self.dim.sub(other.dim),
            .scale = self.scale / other.scale,
            .offset = null,
            .symbol = fmt.comptimePrint("{s} ({s})-1", .{ self.symbol, other.symbol }),
        };
    }

    pub fn div(comptime self: Self, comptime other: Self) Self {
        return self.tryDiv(other) catch unreachable;
    }

    pub fn tryPow(comptime self: Self, value: i32) FractionError!Self {
        if (self.offset != null) {
            @compileError("Cannot power affine units (non-zero offset).");
        }
        return .{
            .dim = try self.dim.mulScalar(value),
            .scale = math.pow(f64, self.scale, value),
            .offset = null,
            .symbol = fmt.comptimePrint("({s}){d}", .{ self.symbol, value }),
        };
    }

    pub fn pow(comptime self: Self, value: i32) Self {
        return self.tryPow(value) catch {
            @compileError("Unit power failed");
        };
    }

    pub fn trySqrt(comptime self: Self) FractionError!Self {
        if (self.offset != null) {
            @compileError("Cannot square root affine units (non-zero offset).");
        }
        return .{
            .dim = try self.dim.divScalar(2),
            .scale = math.sqrt(self.scale),
            .offset = null,
            .symbol = fmt.comptimePrint("{s}1/2", .{self.symbol}),
        };
    }

    pub fn sqrt(comptime self: Self) Self {
        return self.trySqrt() catch {
            @compileError("Unit sqrt failed");
        };
    }

    pub fn tryCbrt(comptime self: Self) FractionError!Self {
        if (self.offset != null) {
            @compileError("Cannot cube root affine units (non-zero offset).");
        }
        return .{
            .dim = try self.dim.divScalar(3),
            .scale = math.cbrt(self.scale),
            .offset = null,
            .symbol = fmt.comptimePrint("{s}1/3", .{self.symbol}),
        };
    }

    pub fn cbrt(comptime self: Self) Self {
        return self.tryCbrt() catch {
            @compileError("Unit cbrt failed");
        };
    }

    pub fn tryPowByFraction(comptime self: Self, num: i32, denum: i32) FractionError!Self {
        if (self.offset != null) {
            @compileError("Cannot cube root affine units (non-zero offset).");
        }
        const frac = try Fraction(i32).init(num, denum);
        return .{
            .dim = try self.dim.mulFraction(frac),
            .scale = math.pow(f64, self.scale, frac.toFloat(f64)),
            .offset = null,
            .symbol = fmt.comptimePrint("({s}){d}/{d}", .{ self.symbol, frac.num, frac.denum }),
        };
    }

    pub fn powByFraction(comptime self: Self, num: i32, denum: i32) Self {
        return self.tryPowByFraction(num, denum) catch {
            @compileError("Unit power failed");
        };
    }

    pub fn tryPowByAztroFraction(comptime self: Self, frac: Fraction(i32)) FractionError!Self {
        if (self.offset != null) {
            @compileError("Cannot cube root affine units (non-zero offset).");
        }
        return .{
            .dim = try self.dim.mulFraction(frac),
            .scale = math.pow(f64, self.scale, frac.toFloat(f64)),
            .offset = null,
            .symbol = fmt.comptimePrint("({s}){d}/{d}", .{ self.symbol, frac.num, frac.denum }),
        };
    }

    pub fn powByAztroFraction(comptime self: Self, frac: Fraction(i32)) Self {
        return self.tryPowByAztroFraction(frac) catch {
            @compileError("Unit power failed");
        };
    }
};

test "test init" {
    const meter: Unit = .init(dimMod.length, 1.0, "m");
    try testing.expectEqual(meter.dim, dimMod.length);
    try testing.expectEqual(meter.scale, 1.0);
    try testing.expectEqual(meter.symbol, "m");
    try testing.expectEqual(meter.offset, null);
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
        const meterSquare = try meter1.tryMul(meter2);
        try testing.expectEqual(meterSquare.scale, 1.0);
        try testing.expectEqual(meterSquare.offset, null);
        try testing.expectEqual(meterSquare.symbol, "m m");
        try testing.expectEqual(meterSquare.dim, try dimMod.length.add(dimMod.length));
    }
}

test "test divid units" {
    comptime {
        const meter: Unit = .init(dimMod.length, 1, "m");
        const centimeter: Unit = .init(dimMod.length, 0.01, "cm");
        const meterCentimeter = try meter.tryDiv(centimeter);
        try testing.expectEqual(meterCentimeter.scale, 100);
        try testing.expectEqual(meterCentimeter.offset, null);
        try testing.expectEqual(meterCentimeter.symbol, "m (cm)-1");
        try testing.expectEqual(meterCentimeter.dim, try dimMod.length.sub(dimMod.length));
    }
}

test "pow" {
    comptime {
        const cm: Unit = .init(dimMod.length, 0.01, "cm");
        const cmCube = try cm.tryPow(3);
        try testing.expect(math.approxEqAbs(f64, cmCube.scale, 1e-6, 1e-15));
        try testing.expectEqual(null, cmCube.offset);
        try testing.expectEqual(try dimMod.length.add(try dimMod.length.add(dimMod.length)), cmCube.dim);
        try testing.expectEqual("(cm)3", cmCube.symbol);
    }
}

test "sqrt" {
    comptime {
        const m2: Unit = .init(try dimMod.length.add(dimMod.length), 1, "m2");
        const m: Unit = .init(dimMod.length, 1, "m");
        const m2sqrt = try m2.trySqrt();
        try testing.expect(math.approxEqAbs(f64, m.scale, m2sqrt.scale, 1e-15));
        try testing.expectEqual(null, m2sqrt.offset);
        try testing.expectEqual(m.dim, m2sqrt.dim);
    }
}

test "cbrt" {
    comptime {
        const m3: Unit = .init(try dimMod.length.mulScalar(3), 1, "m3");
        const m: Unit = .init(dimMod.length, 1, "m");
        const m3cbrt = try m3.tryCbrt();
        try testing.expect(math.approxEqAbs(f64, m.scale, m3cbrt.scale, 1e-15));
        try testing.expectEqual(null, m3cbrt.offset);
        try testing.expectEqual(m.dim, m3cbrt.dim);
    }
}

test "powByFraction" {
    comptime {
        const m4: Unit = .init(try dimMod.length.mulScalar(4), 1, "m4");
        const m: Unit = .init(dimMod.length, 1, "m");
        const m4PowByFrac = try m4.tryPowByFraction(1, 4);
        try testing.expect(math.approxEqAbs(f64, m.scale, m4PowByFrac.scale, 1e-15));
        try testing.expectEqual(null, m4PowByFrac.offset);
        try testing.expectEqual(m.dim, m4PowByFrac.dim);
    }
}

test "powByAztroFraction" {
    comptime {
        const frac = try Fraction(i32).init(1, 4);
        const m4: Unit = .init(try dimMod.length.mulScalar(4), 1, "m4");
        const m: Unit = .init(dimMod.length, 1, "m");
        const m4PowByFrac = try m4.tryPowByAztroFraction(frac);
        try testing.expect(math.approxEqAbs(f64, m.scale, m4PowByFrac.scale, 1e-15));
        try testing.expectEqual(null, m4PowByFrac.offset);
        try testing.expectEqual(m.dim, m4PowByFrac.dim);
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
