const std = @import("std");

const constants = @import("../constants.zig");
const Constant = constants.Constant;
const Unit = @import("unit.zig").Unit;
const SymbolExpression = @import("symbol.zig").SymbolExpression;
const Dim = @import("dim.zig").Dim;
const si = @import("si.zig");

pub fn defUnitFromUnit(
    comptime root: Unit,
    conversion_scale: f64,
    symbol: SymbolExpression,
) Unit {
    @setEvalBranchQuota(2000);
    if (root.offset != null) {
        @compileError(
            "defUnitFromUnit() cannot be used with affine units (non-zero offset).",
        );
    }
    return Unit.init(root.dim, conversion_scale * root.scale, symbol);
}

pub fn defUnitFromConst(
    comptime constant: anytype,
    symbol: SymbolExpression,
) Unit {
    const unit: Unit = @TypeOf(constant.quantity).unit;
    return defUnitFromUnit(unit, constant.quantity.value, symbol);
}

pub fn compErrOrPanic(comptime msg: []const u8) void {
    if (@inComptime()) {
        @compileError(msg);
    } else {
        @panic(msg);
    }
}

pub fn isSpectralUnit(comptime unit: Unit) bool {
    const wavelength_dim: Dim = si.m.dim;
    const energy_dim: Dim = si.J.dim;
    const frequency_dim: Dim = si.Hz.dim;
    const wavenumber_spec_dim: Dim = si.m.pow(-1).dim;
    const wavenumber_ang_dim: Dim = si.rad.div(si.m).dim;
    return comptime unit.dim.eql(wavelength_dim) or
        unit.dim.eql(energy_dim) or
        unit.dim.eql(frequency_dim) or
        unit.dim.eql(wavenumber_spec_dim) or
        unit.dim.eql(wavenumber_ang_dim);
}

pub inline fn isQuantity(comptime T: type) bool {
    return (@hasDecl(T, "is_zali_quantity") and T.is_zali_quantity == true);
}

pub inline fn assertIsQuantity(comptime T: type) void {
    if (!isQuantity(T)) {
        @compileError("Expected a Quantity type, got " ++ @typeName(T));
    }
    return;
}

pub inline fn assertIsScalarQuantity(comptime T: type) void {
    assertIsQuantity(T);
    if (@typeInfo(T.value_type) != .float) {
        @compileError("Expected a Scalar Quantity type.");
    }
}
