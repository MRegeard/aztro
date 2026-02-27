const std = @import("std");
const fmt = std.fmt;
const math = std.math;
const mem = std.mem;
const testing = std.testing;
const dimMod = @import("dim.zig");
const Dim = dimMod.Dim;
const fraction = @import("fraction.zig");
const SymbolExpression = @import("symbol.zig").SymbolExpression;

const FractionError = fraction.FractionError;
const Fraction = fraction.Fraction;

pub const UNITLESS: Unit = .init(Dim.initDimensionless(), 1.0, "");

pub const Unit = struct {
    const Self = @This();

    dim: Dim,
    scale: f64 = 1.0,
    offset: ?f64 = null,
    symbol: SymbolExpression,

    pub fn init(dim: Dim, scale: f64, symbol: SymbolExpression) Self {
        return .{ .dim = dim, .scale = scale, .symbol = symbol, .offset = null };
    }

    pub fn initAffine(dim: Dim, scale: f64, offset: f64, symbol: SymbolExpression) Self {
        return .{ .dim = dim, .scale = scale, .offset = offset, .symbol = symbol };
    }

    // Compare symbols.
    pub fn eqlExact(self: Self, other: Self) bool {
        return self.dim.eql(other.dim) and
            self.scale == other.scale and
            self.offset == other.offset and
            self.symbol.eql(other.symbol);
    }

    // Do not compare symbols.
    pub fn eql(self: Self, other: Self) bool {
        return self.dim.eql(other.dim) and self.scale == other.scale and self.offset == other.offset;
    }

    pub fn tryMul(self: Self, other: Self) FractionError!Self {
        if (self.offset != null or other.offset != null) {
            if (@inComptime()) {
                @compileError("Cannot multiply affine units (non-zero offset).");
            } else {
                @panic("Cannot multiply affine units (non-zero offset).");
            }
        }
        return .{
            .dim = try self.dim.add(other.dim),
            .scale = self.scale * other.scale,
            .offset = null,
            .symbol = self.symbol.concatenate(other.symbol),
        };
    }

    pub fn mul(self: Self, other: Self) Self {
        const res = self.tryMul(other) catch unreachable;
        return res;
    }

    pub fn tryDiv(self: Self, other: Self) FractionError!Self {
        if (self.offset != null or other.offset != null) {
            if (@inComptime()) {
                @compileError("Cannot divide affine units (non-zero offset).");
            } else {
                @panic("Cannot divide affine units (non-zero offset).");
            }
        }
        return .{
            .dim = try self.dim.sub(other.dim),
            .scale = self.scale / other.scale,
            .offset = null,
            .symbol = self.symbol.concatenate(other.symbol.inv()),
        };
    }

    pub fn div(self: Self, other: Self) Self {
        return self.tryDiv(other) catch unreachable;
    }

    pub fn tryPow(self: Self, value: isize) FractionError!Self {
        if (self.offset != null) {
            if (@inComptime()) {
                @compileError("Cannot power affine units (non-zero offset).");
            } else {
                @panic("Cannot power affine units (non-zero offset).");
            }
        }
        const value_f: f64 = @floatFromInt(value);
        return .{
            .dim = try self.dim.mulScalar(value),
            .scale = math.pow(f64, self.scale, value_f),
            .offset = null,
            .symbol = self.symbol.mulFrac(.initInt(value)),
        };
    }

    pub fn pow(self: Self, value: isize) Self {
        return self.tryPow(value) catch unreachable;
    }

    pub fn trySqrt(self: Self) FractionError!Self {
        if (self.offset != null) {
            if (@inComptime()) {
                @compileError("Cannot square root affine units (non-zero offset).");
            } else {
                @panic("Cannot square root affine units (non-zero offset).");
            }
        }
        return .{
            .dim = try self.dim.divScalar(2),
            .scale = math.sqrt(self.scale),
            .offset = null,
            .symbol = self.symbol.divFrac(.initInt(2)),
        };
    }

    pub fn sqrt(self: Self) Self {
        return self.trySqrt() catch unreachable;
    }

    pub fn tryCbrt(self: Self) FractionError!Self {
        if (self.offset != null) {
            if (@inComptime()) {
                @compileError("Cannot cube root affine units (non-zero offset).");
            } else {
                @panic("Cannot cube root affine units (non-zero offset).");
            }
        }
        return .{
            .dim = try self.dim.divScalar(3),
            .scale = math.cbrt(self.scale),
            .offset = null,
            .symbol = self.symbol.divFrac(.initInt(3)),
        };
    }

    pub fn cbrt(self: Self) Self {
        return self.tryCbrt() catch unreachable;
    }

    pub fn tryPowByFraction(self: Self, num: isize, denum: isize) FractionError!Self {
        if (self.offset != null) {
            if (@inComptime()) {
                @compileError("Cannot power affine units (non-zero offset).");
            } else {
                @panic("Cannot power affine units (non-zero offset).");
            }
        }
        const frac = try Fraction(isize).init(num, denum);
        return .{
            .dim = try self.dim.mulFraction(frac),
            .scale = math.pow(f64, self.scale, frac.toFloat(f64)),
            .offset = null,
            .symbol = self.symbol.mulFrac(try .init(num, denum)),
        };
    }

    pub fn powByFraction(self: Self, num: isize, denum: isize) Self {
        return self.tryPowByFraction(num, denum) catch unreachable;
    }

    pub fn tryPowByAztroFraction(self: Self, frac: Fraction(isize)) FractionError!Self {
        if (self.offset != null) {
            if (@inComptime()) {
                @compileError("Cannot power affine units (non-zero offset).");
            } else {
                @panic("Cannot power affine units (non-zero offset).");
            }
        }
        return .{
            .dim = try self.dim.mulFraction(frac),
            .scale = math.pow(f64, self.scale, frac.toFloat(f64)),
            .offset = null,
            .symbol = self.symbol.mulFrac(frac),
        };
    }

    pub fn powByAztroFraction(self: Self, frac: Fraction(isize)) Self {
        return self.tryPowByAztroFraction(frac) catch unreachable;
    }
};

test "test init" {
    const meter: Unit = .init(dimMod.length, 1.0, try SymbolExpression.initFromString("m"));
    try testing.expectEqual(dimMod.length, meter.dim);
    try testing.expectEqual(1.0, meter.scale);
    try testing.expectEqualSlices(u8, "m", meter.symbol.terms[0].symbol);
    try testing.expect(meter.symbol.terms[0].exponent.eqlScalar(1));
    try testing.expectEqual(null, meter.offset);
}

test "test init affine" {
    const degC: Unit = .initAffine(dimMod.temperature, 1.0, 273.15, try SymbolExpression.initFromString("degC"));
    try testing.expectEqual(dimMod.temperature, degC.dim);
    try testing.expectEqual(1.0, degC.scale);
    try testing.expectEqualSlices(u8, "degC", degC.symbol.terms[0].symbol);
    try testing.expectEqual(273.15, degC.offset);
}

test "test multiply units" {
    const meter1: Unit = .init(dimMod.length, 1, try SymbolExpression.initFromString("m"));
    const meter2: Unit = .init(dimMod.length, 1, try SymbolExpression.initFromString("m"));
    const meter_square = try meter1.tryMul(meter2);
    try testing.expectEqual(1.0, meter_square.scale);
    try testing.expectEqual(null, meter_square.offset);
    try testing.expectEqual(1, meter_square.symbol.len);
    try testing.expectEqualSlices(u8, "m", meter_square.symbol.terms[0].symbol);
    try testing.expect(meter_square.symbol.terms[0].exponent.eqlScalar(2));
    try testing.expectEqual(try dimMod.length.add(dimMod.length), meter_square.dim);
}

test "test divid units" {
    const meter: Unit = .init(dimMod.length, 1, try SymbolExpression.initFromString("m"));
    const centimeter: Unit = .init(dimMod.length, 0.01, try SymbolExpression.initFromString("cm"));
    const meter_centimeter = try meter.tryDiv(centimeter);
    try testing.expectEqual(100, meter_centimeter.scale);
    try testing.expectEqual(null, meter_centimeter.offset);
    try testing.expectEqual(2, meter_centimeter.symbol.len);
    try testing.expect(meter_centimeter.symbol.terms[1].exponent.eqlScalar(-1));
    try testing.expectEqualSlices(u8, "m", meter_centimeter.symbol.terms[0].symbol);
    try testing.expectEqual(try dimMod.length.sub(dimMod.length), meter_centimeter.dim);
}

test "pow" {
    const cm: Unit = .init(dimMod.length, 0.01, try SymbolExpression.initFromString("cm"));
    const cm_cube = try cm.tryPow(3);
    try testing.expect(math.approxEqAbs(f64, 1e-6, cm_cube.scale, 1e-15));
    try testing.expectEqual(null, cm_cube.offset);
    try testing.expectEqual(try dimMod.length.add(try dimMod.length.add(dimMod.length)), cm_cube.dim);
    try testing.expectEqual(1, cm_cube.symbol.len);
    try testing.expect(cm_cube.symbol.terms[0].exponent.eqlScalar(3));
    try testing.expectEqualSlices(u8, "cm", cm_cube.symbol.terms[0].symbol);
}

test "sqrt" {
    const m2: Unit = .init(try dimMod.length.add(dimMod.length), 1, try SymbolExpression.initFromString("m2"));
    const m: Unit = .init(dimMod.length, 1, try SymbolExpression.initFromString("m"));
    const m2sqrt = try m2.trySqrt();
    try testing.expect(math.approxEqAbs(f64, m.scale, m2sqrt.scale, 1e-15));
    try testing.expectEqual(null, m2sqrt.offset);
    try testing.expectEqual(m.dim, m2sqrt.dim);
    try testing.expectEqual(1, m2sqrt.symbol.len);
    try testing.expect(m2sqrt.symbol.terms[0].exponent.eqlScalar(1));
    try testing.expectEqualSlices(u8, "m", m2sqrt.symbol.terms[0].symbol);
}

test "cbrt" {
    const m3: Unit = .init(try dimMod.length.mulScalar(3), 1, try SymbolExpression.initFromString("m3"));
    const m: Unit = .init(dimMod.length, 1, try SymbolExpression.initFromString("m"));
    const m3cbrt = try m3.tryCbrt();
    try testing.expect(math.approxEqAbs(f64, m.scale, m3cbrt.scale, 1e-15));
    try testing.expectEqual(null, m3cbrt.offset);
    try testing.expectEqual(m.dim, m3cbrt.dim);
    try testing.expectEqual(1, m3cbrt.symbol.len);
    try testing.expect(m3cbrt.symbol.terms[0].exponent.eqlScalar(1));
    try testing.expectEqualSlices(u8, "m", m3cbrt.symbol.terms[0].symbol);
}

test "powByFraction" {
    const m4: Unit = .init(try dimMod.length.mulScalar(4), 1, try SymbolExpression.initFromString("m4"));
    const m: Unit = .init(dimMod.length, 1, try SymbolExpression.initFromString("m"));
    const m4PowByFrac = try m4.tryPowByFraction(1, 4);
    try testing.expect(math.approxEqAbs(f64, m.scale, m4PowByFrac.scale, 1e-15));
    try testing.expectEqual(null, m4PowByFrac.offset);
    try testing.expectEqual(m.dim, m4PowByFrac.dim);
    try testing.expectEqual(1, m4PowByFrac.symbol.len);
    try testing.expect(m4PowByFrac.symbol.terms[0].exponent.eqlScalar(1));
    try testing.expectEqualSlices(u8, "m", m4PowByFrac.symbol.terms[0].symbol);
}

test "powByAztroFraction" {
    const frac = try Fraction(isize).init(1, 4);
    const m4: Unit = .init(try dimMod.length.mulScalar(4), 1, try SymbolExpression.initFromString("m4"));
    const m: Unit = .init(dimMod.length, 1, try SymbolExpression.initFromString("m"));
    const m4PowByFrac = try m4.tryPowByAztroFraction(frac);
    try testing.expect(math.approxEqAbs(f64, m.scale, m4PowByFrac.scale, 1e-15));
    try testing.expectEqual(null, m4PowByFrac.offset);
    try testing.expectEqual(m.dim, m4PowByFrac.dim);
    try testing.expectEqual(1, m4PowByFrac.symbol.len);
    try testing.expect(m4PowByFrac.symbol.terms[0].exponent.eqlScalar(1));
    try testing.expectEqualSlices(u8, "m", m4PowByFrac.symbol.terms[0].symbol);
}
