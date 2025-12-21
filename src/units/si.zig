const std = @import("std");
const testing = std.testing;
const dim = @import("dim.zig");
const Dim = dim.Dim;
const Unit = @import("unit.zig").Unit;

fn defUnitFromUnit(rootUnit: anytype, conversionScale: f64, symbole: []const u8) @TypeOf(rootUnit) {
    return Unit(rootUnit.dim()).init(conversionScale * rootUnit.scale, symbole);
}

// Length
//

pub const m = Unit(dim.length).init(1, "m");
pub const cm = Unit(dim.length).init(0.01, "cm");
pub const mm = Unit(dim.length).init(0.001, "mm");
pub const um = Unit(dim.length).init(0.000001, "um");
pub const nm = Unit(dim.length).init(0.000000001, "nm");
pub const AA = defUnitFromUnit(nm, 0.1, "AA");

// Area
//

pub const ha = Unit(dim.length.addInPlace(dim.length)).init(10000, "ha");

// Volume
//

pub const l = Unit(dim.length.addInPlace(dim.length).addInPlace(dim.length)).init(0.001, "l");

// Angluar
//

pub const rad = Unit(Dim.initDimensionless()).init(1, "rad");
pub const deg = defUnitFromUnit(rad, std.math.pi / 180, "deg");
pub const hourangle = defUnitFromUnit(deg, 15, "hourangle");
pub const arcmin = defUnitFromUnit(deg, 1.0 / 60.0, "arcmin");
pub const arcsec = defUnitFromUnit(deg, 1.0 / 3600.0, "arcsec");
pub const mas = defUnitFromUnit(arcsec, 0.001, "mas");
pub const uas = defUnitFromUnit(arcsec, 0.000001, "uas");
pub const sr = Unit(Dim.initDimensionless()).init(1, "sr");

// Time
//

pub const s = Unit(dim.time).init(1, "s");
pub const min = defUnitFromUnit(s, 60, "min");
pub const h = defUnitFromUnit(min, 60, "h");
pub const d = defUnitFromUnit(h, 24, "day");
pub const sday = defUnitFromUnit(s, 86164.09053, "sday");
pub const yr = defUnitFromUnit(d, 365.25, "yr");

// Frequency
//

const freqDim = Dim.initDimensionless().sub(dim.time);
pub const Hz = Unit(freqDim).init(1, "Hz");

// Mass
//

pub const kg = Unit(dim.mass).init(1, "kg");
pub const g = defUnitFromUnit(kg, 0.001, "g");
pub const t = defUnitFromUnit(kg, 1000, "t");

// Amount of substance
//

pub const mol = Unit(dim.amount).init(1, "mol");

// Temperature
//

pub const K = Unit(dim.temperature).init(1, "K");
pub const degC = Unit(dim.temperature).initAffine(1, 273.15, "degC");
