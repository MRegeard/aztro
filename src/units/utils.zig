const std = @import("std");
const Unit = @import("unit.zig").Unit;

pub fn defUnitFromUnit(
    comptime root: Unit,
    conversion_scale: f64,
    symbol: []const u8,
) Unit {
    if (root.offset != null) {
        @compileError(
            "defUnitFromUnit() cannot be used with affine units (non-zero offset).",
        );
    }
    return Unit.init(root.dim, conversion_scale * root.scale, symbol);
}
