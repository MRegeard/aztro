const std = @import("std");
const constant = @import("constant.zig");
const Constant = constant.Constant;
const codata = @import("codata2022.zig");
const units = @import("../units.zig");

const degToRad = std.math.degreesToRadians;
const deg_value: f64 = 1 / 3600;

// Distance
//
pub const au: Constant(f64, units.m) = .init(1.49597870700e11, "Astronomical Unit", .SI);
pub const pc: Constant(f64, units.m) = .init(au.quantity.value / degToRad(deg_value), "Parsec", .SI);
pub const kpc: Constant(f64, units.m) = .init(1000 * au.quantity.value / degToRad(deg_value), "Kiloparsec", .SI);
pub const L_bol0: Constant(f64, units.W) = .init(3.0128e28, "Luminosoty for absolute bolometric magnetide 0", .SI);

// Solar quantities
//
pub const L_sun: Constant(f64, units.W) = .init(3.828e26, "Nominal solar luminosity", .SI);
pub const GM_sun: Constant(f64, units.m.pow(3).div(units.s.pow(2))) = .init(1.3271244e20, "Nominal solar mass parameter", .SI);
pub const M_sun: Constant(f64, units.kg) = .init(GM_sun.quantity.value / codata.G.quantity.value, "Solar mass", .SI);
pub const R_sun: Constant(f64, units.m) = .init(6.957e8, "Nominal solar radius", .SI);

// Other solar system quantities
//
pub const GM_jup: Constant(f64, units.m.pow(3).div(units.s.pow(2))) = .init(1.2668653e17, "Nominal Jupiter mass parameter", .SI);
pub const M_jup: Constant(f64, units.kg) = .init(GM_jup.quantity.value / codata.G.quantity.value, "Jupiter mass", .SI);
pub const R_jup: Constant(f64, units.m) = .init(7.1492e7, "Nominal jupiter equatorial radius", .SI);

pub const GM_earth: Constant(f64, units.m.pow(3).div(units.s.pow(2))) = .init(3.986004e14, "Nominal Earth mass parameter", .SI);
pub const M_earth: Constant(f64, units.kg) = .init(GM_earth.quantity.value / codata.G.quantity.value, "Earth mass", .SI);
pub const R_earth: Constant(f64, units.m) = .init(6.3781e6, "Nominal Earth equatorial radius", .SI);
