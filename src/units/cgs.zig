const std = @import("std");
const defUnitFromUnit = @import("utils.zig").defUnitFromUnit;
const si = @import("si.zig");
const Unit = @import("unit.zig").Unit;

const PI_F64: f64 = std.math.pi;


const cm = si.cm;
const g = si.g;
const s = si.s;
const C = si.C;
const rad = si.rad;
const sr = si.sr;
const cd = si.cd;
const K = si.K;
const degC = si.degC;
const mol = si.mol;

// Acceleration
//
pub const Gal: Unit = defUnitFromUnit(cm.div(s.div(s)), 1, .initUniqueSymbol("Gal"));

// Energy
//
 pub const erg: Unit = defUnitFromUnit(g.mul(cm.pow(2).div(s.pow(2))), 1.0, .initUniqueSymbol("erg"));

// Force
//
pub const dyn: Unit = defUnitFromUnit(g.mul(cm).div(s.pow(2)), 1.0, .initUniqueSymbol("dyn"));

// Pressure
//
pub const Ba: Unit = defUnitFromUnit(g.div(cm.mul(s.pow(2))), 1.0, .initUniqueSymbol("Ba"));

// Dynamic viscosity
//
pub const P: Unit = defUnitFromUnit(g.div(cm.mul(s)), 1.0, .initUniqueSymbol("P"));

// Kinematic viscosity
//
pub const St: Unit = defUnitFromUnit(cm.pow(2).div(s), 1.0, .initUniqueSymbol("St"));

// Wavenumber
//
pub const k: Unit = defUnitFromUnit(cm.div(cm.pow(2)), 1.0, .initUniqueSymbol("k"));

// Electrical
//
pub const D: Unit = defUnitFromUnit(C.mul(si.m), (1/3) * 1e-29, .initUniqueSymbol("D"));
pub const Fr: Unit = defUnitFromUnit(g.sqrt().mul(cm.powByFraction(3, 2)).div(s), 1.0, .initUniqueSymbol("Fr"));
pub const statA: Unit = defUnitFromUnit(Fr.div(s), 1.0, .initUniqueSymbol("statA"));
pub const Bi: Unit = defUnitFromUnit(g.sqrt().mul(cm.sqrt()).div(s), 1.0, .initUniqueSymbol("Bi"));
pub const abC: Unit = defUnitFromUnit(Bi.mul(s), 1.0, .initUniqueSymbol("abC"));

// Magnetic
//
pub const G: Unit = defUnitFromUnit(si.T, 1e-4, .initUniqueSymbol("G"));
pub const Mx: Unit = defUnitFromUnit(si.Wb, 1e-8, .initUniqueSymbol("Mx"));
pub const Oe: Unit = defUnitFromUnit(si.A.div(si.m), 1e3 / (4 * PI_F64), .initUniqueSymbol("Oe"));




