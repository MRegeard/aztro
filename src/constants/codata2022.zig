const std = @import("std");
const constant = @import("constant.zig");
const Constant = constant.Constant;
const aztro = @import("aztro");
const units = aztro.units;

const PI_F64: f64 = std.math.pi;

fn pow(x: f64, y: f64) f64 {
    return std.math.pow(f64, x, y);
}

pub const h: Constant(f64, units.J.mul(units.s)) = .init(6.62607015e-34, "Planck constant", .SI);

pub const hbar: Constant(f64, units.J.mul(units.s)) = .init(h.quantity.value / (2 * PI_F64), "Reduced Planck constant", .SI);

pub const k_B: Constant(f64, units.J.div(units.K)) = .init(1.380649e-23, "Boltzmann constant", .SI);

pub const c: Constant(f64, units.m.div(units.s)) = .init(299792458.0, "Speed of light in vacuum", .SI);

pub const G: Constant(f64, units.m.pow(3).div(units.kg.mul(units.s.pow(2)))) = .init(6.67430e-11, "Gravitational constant", .SI);

pub const g0: Constant(f64, units.m.div(units.s.pow(2))) = .init(9.80665, "Standard acceleartion of gravity", .SI);

pub const m_p: Constant(f64, units.kg) = .init(1.67262192595e-27, "Proton mass", .SI);

pub const m_n: Constant(f64, units.kg) = .init(1.67492750056e-27, "Neutron mass", .SI);

pub const m_e: Constant(f64, units.kg) = .init(9.1093837139e-31, "Electron mass", .SI);

pub const u: Constant(f64, units.kg) = .init(1.66053906892e-27, "Atomic mass", .SI);

pub const sigma_sb: Constant(f64, units.W.div(units.K.pow(4).mul(units.m.pow(2)))) = .init(
    2 * pow(PI_F64, 5) * pow(k_B.quantity.value, 4) / (15 * pow(h.quantity.value, 3) * pow(c.quantity.value, 2)),
    "Stefan-Boltzmann constant",
    .SI,
);

pub const e: Constant(f64, units.C) = .init(1.602176634e-19, "Electron charge", .SI);

pub const eps0: Constant(f64, units.F.div(units.m)) = .init(8.8541878188e-12, "Vacuum electric permittivity", .SI);

pub const N_A: Constant(f64, units.mol.div(units.mol.pow(2))) = .init(6.02214076e23, "Avogadro's number", .SI);

pub const R: Constant(f64, units.J.div(units.K.mul(units.mol))) = .init(k_B.quantity.value * N_A.quantity.value, "Gas constant", .SI);

pub const Ryd: Constant(f64, units.m.div(units.m.pow(2))) = .init(10973731.568157, "Rydberg constant", .SI);

pub const a0: Constant(f64, units.m) = .init(5.29177210544e-11, "Bohr radius", .SI);

pub const muB: Constant(f64, units.J.div(units.T)) = .init(9.2740100657e-24, "Bohr magneton", .SI);

pub const alpha: Constant(f64, units.unit.UNITLESS) = .init(7.2973525643e-3, "Fine-structure constant", .SI);

pub const atm: Constant(f64, units.Pa) = .init(101325, "Standard atmosphere", .SI);

pub const mu0: Constant(f64, units.N.div(units.A.pow(2))) = .init(1.25663706127e-6, "Vacuum magnetic permeability", .SI);

pub const sigma_T: Constant(f64, units.m.pow(2)) = .init(6.6524587051e-29, "Thomson scattering cross-section", .SI);

// Comment from astropy:
// Formula taken from NIST wall chart.
// The numerical factor is from a numerical solution to the equation for the
// maximum. See https://en.wikipedia.org/wiki/Wien%27s_displacement_law;
pub const b_wien: Constant(f64, units.m.mul(units.K)) = .init(
    h.quantity.value * c.quantity.value / (k_B.quantity.value * 4.965114231744276),
    "Wien wavelength displacement law constant",
    .SI,
);

// Comment from astropy:
// CGS cosntants.
// Only constants that cannot be converted directly from S.I. are defined here.
// Because both e and c are exact, these are also exact by definition.
pub const e_esu: Constant(f64, units.Fr) = .init(
    e.quantity.value * c.quantity.value * 10,
    "Electron Charge", .ESU
);

pub const e_emu: Constant(f64, units.abC) = .init(e.quantity.value / 10, "Electron charge", .EMU);

pub const e_gauss: Constant(f64, units.Fr) = .init(e.quantity.value * c.quantity.value * 10.0, "Electron charge", .GAUSS);
