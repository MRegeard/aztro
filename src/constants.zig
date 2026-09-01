//! Public entry point for physical constants. Re-exports the `Constant` type and the
//! source namespaces (`codata2022`, `iau2015`).
//!
//! The flat list between the EXPORT ANCHOR markers is generated, lifting each
//! constant to the top level (e.g. `constants.c` instead of `constants.codata2022.c`).
//! Each constant's value, unit, and provenance is documented at its definition.
const std = @import("std");
const testing = std.testing;
pub const constant = @import("constants/constant.zig");
pub const Constant = constant.Constant;
pub const codata2022 = @import("constants/codata2022.zig");
pub const iau2015 = @import("constants/iau2015.zig");

// EXPORT ANCHOR

// codata2022
pub const h = codata2022.h;
pub const hbar = codata2022.hbar;
pub const k_B = codata2022.k_B;
pub const c = codata2022.c;
pub const G = codata2022.G;
pub const g0 = codata2022.g0;
pub const m_p = codata2022.m_p;
pub const m_n = codata2022.m_n;
pub const m_e = codata2022.m_e;
pub const u = codata2022.u;
pub const sigma_sb = codata2022.sigma_sb;
pub const e = codata2022.e;
pub const eps0 = codata2022.eps0;
pub const N_A = codata2022.N_A;
pub const R = codata2022.R;
pub const Ryd = codata2022.Ryd;
pub const a0 = codata2022.a0;
pub const muB = codata2022.muB;
pub const alpha = codata2022.alpha;
pub const atm = codata2022.atm;
pub const mu0 = codata2022.mu0;
pub const sigma_T = codata2022.sigma_T;
pub const b_wien = codata2022.b_wien;
pub const e_esu = codata2022.e_esu;
pub const e_emu = codata2022.e_emu;
pub const e_gauss = codata2022.e_gauss;

// iau2015
pub const au = iau2015.au;
pub const pc = iau2015.pc;
pub const kpc = iau2015.kpc;
pub const L_bol0 = iau2015.L_bol0;
pub const L_sun = iau2015.L_sun;
pub const GM_sun = iau2015.GM_sun;
pub const M_sun = iau2015.M_sun;
pub const R_sun = iau2015.R_sun;
pub const GM_jup = iau2015.GM_jup;
pub const M_jup = iau2015.M_jup;
pub const R_jup = iau2015.R_jup;
pub const GM_earth = iau2015.GM_earth;
pub const M_earth = iau2015.M_earth;
pub const R_earth = iau2015.R_earth;

// EXPORT ANCHOR END

test {
    testing.refAllDecls(@This());
}
