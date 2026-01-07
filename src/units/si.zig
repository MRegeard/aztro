const std = @import("std");
const dim = @import("dim.zig");
const Dim = dim.Dim;
const Unit = @import("unit.zig").Unit;

fn defUnitFromUnit(
    comptime root: Unit,
    conversion_scale: f64,
    symbol: []const u8,
) Unit {
    if (root.offset != 0.0) {
        @compileError(
            "defUnitFromUnit() cannot be used with affine units (non-zero offset).",
        );
    }
    return Unit.init(root.dim, conversion_scale * root.scale, symbol);
}

// Length
//

pub const m: Unit = Unit.init(dim.length, 1.0, "m");
pub const cm: Unit = Unit.init(dim.length, 0.01, "cm");
pub const mm: Unit = Unit.init(dim.length, 0.001, "mm");
pub const um: Unit = Unit.init(dim.length, 0.000_001, "um");
pub const nm: Unit = Unit.init(dim.length, 0.000_000_001, "nm");
pub const AA: Unit = defUnitFromUnit(nm, 0.1, "AA");

// Area
//

pub const ha: Unit = Unit.init(dim.length.add(dim.length), 10_000.0, "ha");

// Volume
//

pub const l: Unit = Unit.init(
    dim.length.add(dim.length).add(dim.length),
    0.001,
    "l",
);

// Angular
//

pub const rad: Unit = Unit.init(Dim.initDimensionless(), 1.0, "rad");
pub const deg: Unit = defUnitFromUnit(rad, std.math.pi / 180.0, "deg");
pub const hourangle: Unit = defUnitFromUnit(deg, 15.0, "hourangle");
pub const arcmin: Unit = defUnitFromUnit(deg, 1.0 / 60.0, "arcmin");
pub const arcsec: Unit = defUnitFromUnit(deg, 1.0 / 3600.0, "arcsec");
pub const mas: Unit = defUnitFromUnit(arcsec, 0.001, "mas");
pub const uas: Unit = defUnitFromUnit(arcsec, 0.000_001, "uas");
pub const sr: Unit = Unit.init(Dim.initDimensionless(), 1.0, "sr");

// Time
//

pub const s: Unit = Unit.init(dim.time, 1.0, "s");
pub const min: Unit = defUnitFromUnit(s, 60.0, "min");
pub const h: Unit = defUnitFromUnit(min, 60.0, "h");
pub const d: Unit = defUnitFromUnit(h, 24.0, "day");
pub const sday: Unit = defUnitFromUnit(s, 86_164.090_53, "sday");
pub const yr: Unit = defUnitFromUnit(d, 365.25, "yr");

// Frequency
//

const freq_dim: Dim = Dim.initDimensionless().sub(dim.time) catch unreachable;
pub const Hz: Unit = Unit.init(freq_dim, 1.0, "Hz");

// Mass
//

pub const kg: Unit = Unit.init(dim.mass, 1.0, "kg");
pub const g: Unit = defUnitFromUnit(kg, 0.001, "g");
pub const t: Unit = defUnitFromUnit(kg, 1000.0, "t");

// Amount of substance
//

pub const mol: Unit = Unit.init(dim.amount, 1.0, "mol");

// Temperature
//

pub const K: Unit = Unit.init(dim.temperature, 1.0, "K");
pub const degC: Unit = Unit.initAffine(dim.temperature, 1.0, 273.15, "degC");
