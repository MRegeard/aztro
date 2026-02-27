const std = @import("std");
const dim = @import("dim.zig");
const Dim = dim.Dim;
const Unit = @import("unit.zig").Unit;
const defUnitFromUnit = @import("utils.zig").defUnitFromUnit;

// Length
//

pub const m: Unit = Unit.init(dim.length, 1.0, .initUniqueSymbol("m"));
pub const cm: Unit = Unit.init(dim.length, 0.01, .initUniqueSymbol("cm"));
pub const mm: Unit = Unit.init(dim.length, 0.001, .initUniqueSymbol("mm"));
pub const um: Unit = Unit.init(dim.length, 0.000_001, .initUniqueSymbol("um"));
pub const nm: Unit = Unit.init(dim.length, 0.000_000_001, .initUniqueSymbol("nm"));
pub const AA: Unit = defUnitFromUnit(nm, 0.1, .initUniqueSymbol("AA"));

// Area
//

const dim_ha = dim.length.add(dim.length) catch unreachable;
pub const ha: Unit = Unit.init(dim_ha, 10_000.0, .initUniqueSymbol("ha"));

// Volume
//

const dim_l = dim_ha.add(dim.length) catch unreachable;
pub const l: Unit = Unit.init(dim_l, 0.001, .initUniqueSymbol("l"));

// Angular
//

pub const rad: Unit = Unit.init(Dim.initDimensionless(), 1.0, .initUniqueSymbol("rad"));
pub const deg: Unit = defUnitFromUnit(rad, std.math.pi / 180.0, .initUniqueSymbol("deg"));
pub const hourangle: Unit = defUnitFromUnit(deg, 15.0, .initUniqueSymbol("hourangle"));
pub const arcmin: Unit = defUnitFromUnit(deg, 1.0 / 60.0, .initUniqueSymbol("arcmin"));
pub const arcsec: Unit = defUnitFromUnit(deg, 1.0 / 3600.0, .initUniqueSymbol("arcsec"));
pub const mas: Unit = defUnitFromUnit(arcsec, 0.001, .initUniqueSymbol("mas"));
pub const uas: Unit = defUnitFromUnit(arcsec, 0.000_001, .initUniqueSymbol("uas"));
pub const sr: Unit = Unit.init(Dim.initDimensionless(), 1.0, .initUniqueSymbol("sr"));

// Time
//

pub const s: Unit = Unit.init(dim.time, 1.0, .initUniqueSymbol("s"));
pub const min: Unit = defUnitFromUnit(s, 60.0, .initUniqueSymbol("min"));
pub const h: Unit = defUnitFromUnit(min, 60.0, .initUniqueSymbol("h"));
pub const d: Unit = defUnitFromUnit(h, 24.0, .initUniqueSymbol("day"));
pub const sday: Unit = defUnitFromUnit(s, 86_164.090_53, .initUniqueSymbol("sday"));
pub const yr: Unit = defUnitFromUnit(d, 365.25, .initUniqueSymbol("yr"));

// Frequency
//

const freq_dim: Dim = Dim.initDimensionless().sub(dim.time) catch unreachable;
pub const Hz: Unit = Unit.init(freq_dim, 1.0, .initUniqueSymbol("Hz"));

// Mass
//

pub const kg: Unit = Unit.init(dim.mass, 1.0, .initUniqueSymbol("kg"));
pub const g: Unit = defUnitFromUnit(kg, 0.001, .initUniqueSymbol("g"));
pub const t: Unit = defUnitFromUnit(kg, 1000.0, .initUniqueSymbol("t"));

// Amount of substance
//

pub const mol: Unit = Unit.init(dim.amount, 1.0, .initUniqueSymbol("mol"));
const dim_kat = dim.amount.sub(dim.time) catch unreachable;
pub const kat: Unit = .init(dim_kat, 1, .initUniqueSymbol("kat"));

// Temperature
//

pub const K: Unit = Unit.init(dim.temperature, 1.0, .initUniqueSymbol("K"));
pub const degC: Unit = Unit.initAffine(dim.temperature, 1.0, 273.15, .initUniqueSymbol("degC"));

// Force
//

pub const N: Unit = defUnitFromUnit(kg.mul(m.div(s.pow(2))), 1, .initUniqueSymbol("N"));

// Energy
//

pub const J: Unit = defUnitFromUnit(N.mul(m), 1, .initUniqueSymbol("J"));

// Pressure
//

pub const Pa: Unit = defUnitFromUnit(J.mul(m.pow(-3)), 1, .initUniqueSymbol("Pa"));

// Power
//

pub const W: Unit = defUnitFromUnit(J.div(s), 1, .initUniqueSymbol("W"));

// Electrical
//

pub const A: Unit = .init(dim.electricCurrent, 1, .initUniqueSymbol("A"));
pub const C: Unit = defUnitFromUnit(A.mul(s), 1, .initUniqueSymbol("C"));
pub const V: Unit = defUnitFromUnit(J.div(C), 1, .initUniqueSymbol("V"));
pub const Ohm: Unit = defUnitFromUnit(V.div(A), 1, .initUniqueSymbol("Ohm"));
pub const S: Unit = defUnitFromUnit(A.div(V), 1, .initUniqueSymbol("S"));
pub const F: Unit = defUnitFromUnit(C.div(V), 1, .initUniqueSymbol("F"));

// Magentic
//

pub const Wb: Unit = defUnitFromUnit(V.mul(s), 1, .initUniqueSymbol("Wb"));
pub const T: Unit = defUnitFromUnit(Wb.mul(m.pow(-2)), 1, .initUniqueSymbol("T"));
pub const H: Unit = defUnitFromUnit(Wb.div(A), 1, .initUniqueSymbol("H"));

// Illumination
//

pub const cd: Unit = .init(dim.luminousIntensity, 1, .initUniqueSymbol("cd"));
pub const lm: Unit = defUnitFromUnit(cd.mul(sr), 1, .initUniqueSymbol("lm"));
pub const lx: Unit = defUnitFromUnit(lm.div(m.pow(2)), 1, .initUniqueSymbol("lx"));

// Radioactivity
//

pub const Bq: Unit = defUnitFromUnit(s.pow(-1), 1, .initUniqueSymbol("Bq"));
pub const Ci: Unit = defUnitFromUnit(Bq, 3.7e-10, .initUniqueSymbol("Ci"));
pub const Gy: Unit = defUnitFromUnit(J.mul(kg), 1, .initUniqueSymbol("Gy"));
pub const Sv: Unit = defUnitFromUnit(J.mul(kg), 1, .initUniqueSymbol("Sv"));
