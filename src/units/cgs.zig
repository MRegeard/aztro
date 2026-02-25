const std = @import("std");
const defUnitFromUnit = @import("utils.zig").defUnitFromUnit;
const si = @import("si.zig");
const Unit = @import("unit.zig").Unit;

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

pub const Gal: Unit = defUnitFromUnit(cm.div(s.div(s)), 1, "Gal");
