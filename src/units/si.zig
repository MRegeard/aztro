const std = @import("std");
const dim = @import("dim.zig");
const Dim = dim.Dim;
const Unit = @import("unit.zig").Unit;
const defUnitFromUnit = @import("utils.zig").defUnitFromUnit;

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
pub const kat: Unit = .init(dim.amount.sub(dim.time), 1, "kat");

// Temperature
//

pub const K: Unit = Unit.init(dim.temperature, 1.0, "K");
pub const degC: Unit = Unit.initAffine(dim.temperature, 1.0, 273.15, "degC");

// Force
//

pub const N: Unit = .init(dim.mass.add(dim.length.sub(dim.time.mulScalar(2))), 1, "N");

// Energy
//

pub const J: Unit = defUnitFromUnit(N.mul(m), 1, "J");

// Pressure
//

pub const Pa: Unit = defUnitFromUnit(J.mul(m.pow(-3)), 1, "Pa");

// Power
//

pub const W: Unit = defUnitFromUnit(J.div(s), 1, "W");

// Electrical
//

pub const A: Unit = .init(dim.electricCurrent, 1, "A");
pub const C: Unit = defUnitFromUnit(C.mul(s), 1, "C");
pub const V: Unit = defUnitFromUnit(J.div(C), 1, "V");
pub const Ohm: Unit = defUnitFromUnit(V.div(A), 1, "Ohm");
pub const S: Unit = defUnitFromUnit(A.div(V), 1, "S");
pub const F: Unit = defUnitFromUnit(C.div(V), 1, "F");

// Magentic
//

pub const Wb: Unit = defUnitFromUnit(V.mul(s), 1, "Wb");
pub const T: Unit = defUnitFromUnit(Wb.mul(m.pow(-2)), 1, "T");
pub const H: Unit = defUnitFromUnit(Wb.div(A), 1, "H");

// Illumination
//

pub const cd: Unit = .init(dim.luminousIntensity, 1, "cd");
pub const lm: Unit = defUnitFromUnit(cd.mul(sr), 1, "lm");
pub const lx: Unit = defUnitFromUnit(lm.div(m.pow(2)), 1, "lx");

// Radioactivity
//

pub const Bq: Unit = defUnitFromUnit(s.pow(-1), 1, "Bq");
pub const Ci: Unit = defUnitFromUnit(Bq, 3.7e-10, "Ci");
pub const Gy: Unit = defUnitFromUnit(J.mul(kg), 1, "Gy");
pub const Sv: Unit = defUnitFromUnit(J.mul(kg), 1, "Sv");
