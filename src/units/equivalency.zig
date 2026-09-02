//! Physical equivalencies: conversions between units of *different* dimensions that
//! are related by a physical law or convention (frequency <-> wavelength, mass <->
//! energy, redshift <-> velocity, and so on). Ordinary same-dimension conversions
//! are handled by `Quantity.to`; these are the cross-dimension cases that astropy
//! exposes through its `equivalencies` mechanism.
//!
//! Each equivalency is a namespaced struct exposing a `convert` function. Most use a
//! hub-and-spoke design: the input is first converted to a single canonical unit
//! (the "hub"), then from the hub to the requested output. This keeps the number of
//! branches linear in the number of supported units rather than quadratic. The
//! `Equivalency` enum at the bottom ties them together for use from
//! `Quantity.toWithEquivalency`.
//!
//! Equivalencies that need extra information (a rest frequency, a beam area, a
//! zero-point flux, ...) take a comptime-checked `args` tuple; those that don't
//! ignore it. Argument validation lives in each struct's `checkArgs`, which emits a
//! `@compileError` on misuse.

const std = @import("std");
const testing = std.testing;
const dim_mod = @import("dim.zig");
const Dim = dim_mod.Dim;
const unit_mod = @import("unit.zig");
const Unit = unit_mod.Unit;
const UNITLESS = unit_mod.UNITLESS;
const quantity_mod = @import("quantity.zig");
const Quantity = quantity_mod.Quantity;
const utils = @import("utils.zig");
const si = @import("si.zig");
const photo = @import("photometric.zig");
const misc = @import("misc.zig");
const cst = @import("../constants.zig");
const imperial = @import("imperial.zig");
const us = @import("units_storage.zig");

/// Spectral equivalency: converts between the various ways of locating a point in a
/// spectrum -- frequency, wavelength, energy, spectroscopic wavenumber (m-1), and
/// angular wavenumber (rad/m). Hub unit is Hz.
///
/// Relations (with c the speed of light, h the Planck constant):
///   nu = c / lambda,  E = h nu,  nu = c * wavenumber_spec,  nu = c * k / (2 pi)
pub const spectral_equivalency = struct {
    const Hz: Unit = si.Hz;
    const dim_freq: Dim = Hz.dim;
    const dim_length: Dim = si.m.dim;
    const dim_energy: Dim = si.J.dim;
    const dim_wavenumber_spec: Dim = si.m.pow(-1).dim;
    const dim_wavenumber_ang: Dim = si.rad.div(si.m).dim;

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit) Quantity(T, U_out) {
        const as_Hz: Quantity(T, Hz) = toHz(T, U_in, input_quantity);
        return fromHz(T, &as_Hz, U_out);
    }

    pub fn convertInto(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit, out: *Quantity(T, U_out)) void {
        var temp_Hz: Quantity(T, si.Hz) = .init(out.value);
        toHzInto(T, U_in, input_quantity, &temp_Hz);
        fromHzInto(T, &temp_Hz, U_out, out);
    }

    fn toHz(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in)) Quantity(T, si.Hz) {
        const two_pi: Quantity(T, si.rad) = .initScalarValue(2 * std.math.pi);
        const h: Quantity(T, cst.h.quantity.getUnit()) = .initScalarValue(cst.h.quantity.value);
        const c: Quantity(T, cst.c.quantity.getUnit()) = .initScalarValue(cst.c.quantity.value);
        if (comptime U_in.dim.eql(dim_freq)) return input_quantity.to(Hz);
        if (comptime U_in.dim.eql(dim_length)) return input_quantity.pow(-1).mul(c).to(Hz);
        if (comptime U_in.dim.eql(dim_energy)) return input_quantity.div(h).to(Hz);
        if (comptime U_in.dim.eql(dim_wavenumber_spec)) return input_quantity.mul(c).to(Hz);
        if (comptime U_in.dim.eql(dim_wavenumber_ang)) return input_quantity.mul(c).div(two_pi).to(Hz);
        if (@inComptime()) @compileError("Unknown spectral equivalency conversion.");
        unreachable;
    }

    fn toHzInto(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), out: *Quantity(T, Hz)) void {
        const two_pi: Quantity(f64, si.rad) = .init(2 * std.math.pi);
        const h = cst.h.quantity;
        const c = cst.c.quantity;
        if (comptime U_in.dim.eql(dim_freq)) {
            input_quantity.toInto(Hz, out);
        } else if (comptime U_in.dim.eql(dim_length)) {
            var temp_pow: Quantity(T, U_in.pow(-1)) = .init(out.value);
            input_quantity.powInto(-1, &temp_pow);
            var temp_mul_c: Quantity(T, temp_pow.getUnit().mul(c.getUnit())) = .init(temp_pow.value);
            temp_pow.mulScalarInto(c, &temp_mul_c);
            temp_mul_c.toInto(Hz, out);
        } else if (comptime U_in.dim.eql(dim_energy)) {
            var temp_div_h: Quantity(T, U_in.div(h.getUnit())) = .init(out.value);
            input_quantity.divScalarInto(h, &temp_div_h);
            temp_div_h.toInto(Hz, out);
        } else if (comptime U_in.dim.eql(dim_wavenumber_spec)) {
            var temp_mul_c: Quantity(T, U_in.mul(c.getUnit())) = .init(out.value);
            input_quantity.mulScalarInto(c, &temp_mul_c);
            temp_mul_c.toInto(Hz, out);
        } else if (comptime U_in.dim.eql(dim_wavenumber_ang)) {
            const c_div_two_pi = c.div(two_pi);
            var temp_mul: Quantity(T, U_in.mul(c_div_two_pi.getUnit())) = .init(out.value);
            input_quantity.mulScalarInto(c_div_two_pi, &temp_mul);
            temp_mul.toInto(Hz, out);
        } else {
            @compileError("Unknown spectral equivalency conversion.");
        }
    }

    fn fromHz(comptime T: type, input_quantity: *const Quantity(T, Hz), comptime U_out: Unit) Quantity(T, U_out) {
        const two_pi: Quantity(T, si.rad) = .initScalarValue(2 * std.math.pi);
        const h: Quantity(T, cst.h.quantity.getUnit()) = .initScalarValue(cst.h.quantity.value);
        const c: Quantity(T, cst.c.quantity.getUnit()) = .initScalarValue(cst.c.quantity.value);
        if (comptime U_out.dim.eql(dim_freq)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(dim_length)) return input_quantity.pow(-1).mul(c).to(U_out);
        if (comptime U_out.dim.eql(dim_energy)) return input_quantity.mul(h).to(U_out);
        if (comptime U_out.dim.eql(dim_wavenumber_spec)) return input_quantity.div(c).to(U_out);
        if (comptime U_out.dim.eql(dim_wavenumber_ang)) return input_quantity.mul(two_pi).div(c).to(U_out);
        if (@inComptime()) @compileError("Unknown spectral equivalency conversion.");
        unreachable;
    }

    fn fromHzInto(comptime T: type, input_quantity: *const Quantity(T, Hz), comptime U_out: Unit, out: *Quantity(T, U_out)) void {
        const two_pi: Quantity(f64, si.rad) = .init(2 * std.math.pi);
        const c = cst.c.quantity;
        const h = cst.h.quantity;
        if (comptime U_out.dim.eql(dim_freq)) {
            input_quantity.toInto(U_out, out);
        } else if (comptime U_out.dim.eql(dim_length)) {
            var temp_pow: Quantity(T, Hz.pow(-1)) = .init(out.value);
            input_quantity.powInto(-1, &temp_pow);
            var temp_mul_c: Quantity(T, Hz.pow(-1).mul(c.getUnit())) = .init(out.value);
            temp_pow.mulScalarInto(c, &temp_mul_c);
            temp_mul_c.toInto(U_out, out);
        } else if (comptime U_out.dim.eql(dim_energy)) {
            var temp_mul_h: Quantity(T, Hz.mul(h.getUnit())) = .init(out.value);
            input_quantity.mulScalarInto(h, &temp_mul_h);
            temp_mul_h.toInto(U_out, out);
        } else if (comptime U_out.dim.eql(dim_wavenumber_spec)) {
            var temp_div_c: Quantity(T, Hz.div(c.getUnit())) = .init(out.value);
            input_quantity.divScalarInto(c, &temp_div_c);
            temp_div_c.toInto(U_out, out);
        } else if (comptime U_out.dim.eql(dim_wavenumber_ang)) {
            const two_pi_div_c = two_pi.div(c);
            var temp_mul: Quantity(T, Hz.mul(two_pi_div_c.getUnit())) = .init(out.value);
            input_quantity.mulScalarInto(two_pi_div_c, &temp_mul);
            temp_mul.toInto(U_out, out);
        } else {
            @compileError("Unknown spectral equivalency conversion.");
        }
    }
};

/// Mass-energy equivalency: converts between mass and energy via E = m c^2.
/// Hub unit is the joule.
// TODO: Support generalise equivalency as Astropy does such as kg m-2 <-> J m-2 (??).
pub const mass_energy_equivalency = struct {
    const J: Unit = si.J;
    const dim_energy: Dim = si.J.dim;
    const dim_mass: Dim = si.kg.dim;

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit) Quantity(T, U_out) {
        const as_J: Quantity(T, J) = toJ(T, U_in, input_quantity);
        return fromJ(T, &as_J, U_out);
    }

    fn toJ(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in)) Quantity(T, J) {
        const c: Quantity(T, cst.c.quantity.getUnit()) = .initScalarValue(cst.c.quantity.value);
        if (comptime U_in.dim.eql(dim_energy)) return input_quantity.to(J);
        if (comptime U_in.dim.eql(dim_mass)) return input_quantity.mul(c.pow(2)).to(J);
        if (@inComptime()) @compileError("Unknown mass-energy equivalency conversion.");
        unreachable;
    }

    fn fromJ(comptime T: type, input_quantity: *const Quantity(T, J), comptime U_out: Unit) Quantity(T, U_out) {
        const c: Quantity(T, cst.c.quantity.getUnit()) = .initScalarValue(cst.c.quantity.value);
        if (comptime U_out.dim.eql(dim_energy)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(dim_mass)) return input_quantity.div(c.pow(2)).to(U_out);
        if (@inComptime()) @compileError("Unknown mass-energy equivalency conversion.");
        unreachable;
    }
};

/// Temperature-energy equivalency: converts between thermal energy and temperature
/// via E = k_B T, where k_B is the Boltzmann constant. Hub unit is the joule.
/// Temperature inputs are first normalized to kelvin so offset scales (e.g. Celsius)
/// are handled correctly before the physics is applied.
pub const temperature_energy_equivalency = struct {
    const J: Unit = si.J;
    const dim_energy: Dim = si.J.dim;
    const dim_temp: Dim = si.K.dim;

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit) Quantity(T, U_out) {
        const as_J: Quantity(T, J) = toJ(T, U_in, input_quantity);
        return fromJ(T, &as_J, U_out);
    }

    fn toJ(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in)) Quantity(T, J) {
        const k_B: Quantity(T, cst.k_B.quantity.getUnit()) = .initScalarValue(cst.k_B.quantity.value);
        if (comptime U_in.dim.eql(dim_energy)) return input_quantity.to(J);
        if (comptime U_in.dim.eql(dim_temp)) return input_quantity.to(si.K).mul(k_B).to(J);
        if (@inComptime()) @compileError("Unknown temperature-energy equivalency conversion.");
        unreachable;
    }

    fn fromJ(comptime T: type, input_quantity: *const Quantity(T, J), comptime U_out: Unit) Quantity(T, U_out) {
        const k_B: Quantity(T, cst.k_B.quantity.getUnit()) = .initScalarValue(cst.k_B.quantity.value);
        if (comptime U_out.dim.eql(dim_energy)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(dim_temp)) return input_quantity.div(k_B).to(U_out);
        if (@inComptime()) @compileError("Unknown temperature-energy equivalency conversion.");
        unreachable;
    }
};

// In astropy, this equivalency is required because offset-based units (°C, °F)
// are not handled by regular .to(). In this implementation, offset handling is
// built into the unit system, so this equivalency simply delegates to .to().
/// Temperature equivalency: provided for API parity with astropy, where it is needed
/// because offset scales (Celsius, Fahrenheit) are otherwise incompatible. Here unit
/// offsets are built into `Quantity.to`, so this simply delegates to it.
pub const temperature_equivalency = struct {
    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit) Quantity(T, U_out) {
        return input_quantity.to(U_out);
    }
};

/// Molar-mass / atomic-mass-unit equivalency: converts between a molar mass (g/mol)
/// and an atomic mass (u), related by Avogadro's number N_A (1 u corresponds to
/// 1 g/mol). Hub unit is the atomic mass unit.
pub const molar_mass_amu_equivalency = struct {
    const molar_mass: Unit = si.g.div(si.mol);
    const molar_mass_dim: Dim = molar_mass.dim;
    const amu: Unit = misc.u;
    const amu_dim: Dim = amu.dim;

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit) Quantity(T, U_out) {
        const as_amu: Quantity(T, amu) = toAmu(T, U_in, input_quantity);
        return fromAmu(T, &as_amu, U_out);
    }

    fn toAmu(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in)) Quantity(T, amu) {
        const N_A: Quantity(T, cst.N_A.quantity.getUnit()) = .initScalarValue(cst.N_A.quantity.value);
        if (comptime U_in.dim.eql(amu_dim)) return input_quantity.to(amu);
        if (comptime U_in.dim.eql(molar_mass_dim)) return input_quantity.div(N_A).to(amu);
        if (@inComptime()) @compileError("Unknown molar-mass-amu equivalency conversion.");
        unreachable;
    }

    fn fromAmu(comptime T: type, input_quantity: *const Quantity(T, amu), comptime U_out: Unit) Quantity(T, U_out) {
        const N_A: Quantity(T, cst.N_A.quantity.getUnit()) = .initScalarValue(cst.N_A.quantity.value);
        if (comptime U_out.dim.eql(amu_dim)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(molar_mass_dim)) return input_quantity.mul(N_A).to(U_out);
        if (@inComptime()) @compileError("Unknown molar-mass-amu equivalency conversion.");
        unreachable;
    }
};

/// Doppler-redshift equivalency: converts between dimensionless redshift z and radial
/// velocity using the relativistic relation. Hub unit is km/s.
///   z -> v:  v = c * ((z+1)^2 - 1) / ((z+1)^2 + 1)
///   v -> z:  z = sqrt((1 + beta)/(1 - beta)) - 1,  with beta = v/c
pub const doppler_redshift_equivalency = struct {
    const rv_unit: Unit = us.km.div(si.s);
    const rv_dim: Dim = rv_unit.dim;

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit) Quantity(T, U_out) {
        const as_rv: Quantity(T, rv_unit) = toRv(T, U_in, input_quantity);
        return fromRv(T, &as_rv, U_out);
    }

    fn toRv(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in)) Quantity(T, rv_unit) {
        const c_kms: Quantity(T, rv_unit) = .initScalarValue(cst.c.quantity.to(rv_unit).value);
        const one: Quantity(T, UNITLESS) = .initScalarValue(1);
        if (comptime U_in.dim.eql(rv_dim)) return input_quantity.to(rv_unit);
        if (comptime U_in.dim.eql(UNITLESS.dim)) {
            const zponesq = input_quantity.add(one).pow(2);
            return c_kms.mul(zponesq.sub(one)).div(zponesq.add(one)).to(rv_unit);
        }
        if (@inComptime()) @compileError("Unknown doppler redshift equivalency conversion.");
        unreachable;
    }

    fn fromRv(comptime T: type, input_quantity: *const Quantity(T, rv_unit), comptime U_out: Unit) Quantity(T, U_out) {
        const c_kms: Quantity(T, rv_unit) = .initScalarValue(cst.c.quantity.to(rv_unit).value);
        const one: Quantity(T, UNITLESS) = .initScalarValue(1);
        if (comptime U_out.dim.eql(rv_dim)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(UNITLESS.dim)) {
            const beta = input_quantity.div(c_kms).to(UNITLESS);
            return beta.add(one).div(one.sub(beta)).sqrt().sub(one).to(U_out);
        }
        if (@inComptime()) @compileError("Unknown doppler redshift equivalency conversion.");
        unreachable;
    }
};

/// Dimensionless-angles equivalency: lets angular quantities (radians, degrees, ...)
/// be treated as dimensionless and vice versa, normalizing through radians. Useful
/// because angle is dimensionless in SI but tracked as a dimension here. Hub is the
/// dimensionless value (with the angle stripped to / restored from radians).
pub const dimensionless_angles_equivalency = struct {
    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit) Quantity(T, U_out) {
        const as_unitless: Quantity(T, UNITLESS) = toUnitless(T, U_in, input_quantity);
        return fromUnitless(T, &as_unitless, U_out);
    }

    fn toUnitless(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in)) Quantity(T, UNITLESS) {
        const u_in_dim: Dim = U_in.dim;
        if (comptime U_in.eqlExact(UNITLESS)) return input_quantity.*;
        if (comptime u_in_dim.l.eqlScalar(0) and
            u_in_dim.m.eqlScalar(0) and
            u_in_dim.t.eqlScalar(0) and
            u_in_dim.i.eqlScalar(0) and
            u_in_dim.th.eqlScalar(0) and
            u_in_dim.n.eqlScalar(0) and
            u_in_dim.j.eqlScalar(0) and
            !u_in_dim.a.eqlScalar(0)) return .init(input_quantity.to(si.rad).value);
        if (@inComptime()) @compileError("Unknown dimensionless angles conversion.");
        unreachable;
    }

    fn fromUnitless(comptime T: type, input_quantity: *const Quantity(T, UNITLESS), comptime U_out: Unit) Quantity(T, U_out) {
        const u_out_dim: Dim = U_out.dim;
        if (comptime U_out.eqlExact(UNITLESS)) return input_quantity.*;
        if (comptime u_out_dim.l.eqlScalar(0) and
            u_out_dim.m.eqlScalar(0) and
            u_out_dim.t.eqlScalar(0) and
            u_out_dim.i.eqlScalar(0) and
            u_out_dim.th.eqlScalar(0) and
            u_out_dim.n.eqlScalar(0) and
            u_out_dim.j.eqlScalar(0) and
            !u_out_dim.a.eqlScalar(0)) return Quantity(T, si.rad).init(input_quantity.value).to(U_out);
        if (@inComptime()) @compileError("Unknown dimensionless angles conversion.");
        unreachable;
    }
};

// NOTE: At the moment, contrary to Astropy, this conversion gives negative angles and negative
// distances, instead of NaN.
/// Parallax equivalency: converts between a parallax angle and a distance via the
/// reciprocal relation p[arcsec] = 1 / d[pc]. Hub unit is the arcsecond.
pub const parallax_equivalency = struct {
    const as: Unit = si.arcsec;
    const as_dim: Dim = as.dim;
    const pc: Unit = us.pc;
    const pc_dim: Dim = pc.dim;

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit) Quantity(T, U_out) {
        const as_arcsec: Quantity(T, si.arcsec) = toArcsec(T, U_in, input_quantity);
        return fromArcsec(T, &as_arcsec, U_out);
    }

    fn toArcsec(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in)) Quantity(T, as) {
        const one: Quantity(T, pc) = .initScalarValue(1);
        if (comptime U_in.dim.eql(as_dim)) return input_quantity.to(as);
        if (comptime U_in.dim.eql(pc_dim)) return .init(one.div(input_quantity.to(pc)).value);
        if (@inComptime()) @compileError("Unknown parallax equivalency conversion.");
        unreachable;
    }

    fn fromArcsec(comptime T: type, input_quantity: *const Quantity(T, as), comptime U_out: Unit) Quantity(T, U_out) {
        const one: Quantity(T, as) = .initScalarValue(1);
        if (comptime U_out.dim.eql(as_dim)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(pc_dim)) return Quantity(T, pc).init(one.div(input_quantity.*).value).to(U_out);
        if (@inComptime()) @compileError("Unknown parallax equivalency conversion.");
        unreachable;
    }
};

/// Zero-point-flux equivalency: converts between a linear flux and a "maggy" (a
/// dimensionless flux ratio relative to a reference), via f = F / F0. Requires one
/// argument: the zero-point flux F0 (e.g. 3631 Jy for the AB system). Only two units
/// are involved (flux and dimensionless maggy), so this is a direct conversion rather
/// than hub-and-spoke.
pub const zero_point_flux_equivalency = struct {
    fn checkArgs(args: anytype) void {
        const ArgsType = @TypeOf(args);
        const args_fields = @typeInfo(ArgsType).@"struct".fields;

        if (comptime args_fields.len != 1) {
            @compileError("Zero point flux equivalency expect 1 argument: the zero-point flux.");
        }
        const ArgType = args_fields[0].type;
        utils.assertIsQuantity(ArgType);

        if (comptime ArgType.unit.dim.eql(UNITLESS.dim)) {
            @compileError("Zero point flux equivalency argument must be a flux Quantity, not dimensionless.");
        }
    }

    // TODO: check that the args is in the right "value" type (T) or else make it. To be done after
    // the quantity type refinement is done.
    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit, args: anytype) Quantity(T, U_out) {
        checkArgs(args);
        const flux0 = args.@"0";
        const Flux0Type = @TypeOf(args.@"0");
        const flux0_dim: Dim = comptime Flux0Type.unit.dim;
        const maggy_dim: Dim = UNITLESS.dim;

        if (comptime U_in.dim.eql(maggy_dim) and U_out.dim.eql(flux0_dim)) {
            return input_quantity.mul(flux0).to(U_out);
        }

        if (comptime U_in.dim.eql(flux0_dim) and U_out.dim.eql(maggy_dim)) {
            return input_quantity.div(flux0).to(U_out);
        }
        if (@inComptime()) @compileError("Unknown zero point flux equivalency conversion.");
        unreachable;
    }
};

/// Relativistic Doppler equivalency: converts a spectral coordinate (frequency,
/// wavelength, energy, wavenumber) to/from radial velocity using the exact
/// relativistic formula, given a rest spectral location. Requires one argument: the
/// rest value as any spectral-compatible Quantity (normalized to Hz internally).
/// Hub unit is km/s; spectral inputs/outputs route through `spectral_equivalency`.
///   f -> v:  v = c * (f0^2 - f^2) / (f0^2 + f^2)
///   v -> f:  f = f0 * sqrt(1 - beta^2) / (1 + beta),  beta = v/c
pub const doppler_relativistic_equivalency = struct {
    const wavelength_dim: Dim = si.m.dim;
    const energy_dim: Dim = si.J.dim;
    const frequency_dim: Dim = si.Hz.dim;
    const wavenumber_spec_dim: Dim = si.m.pow(-1).dim;
    const wavenumber_ang_dim: Dim = si.rad.div(si.m).dim;
    const rv_unit: Unit = us.km.div(si.s);
    const rv_dim: Dim = rv_unit.dim;

    fn checkArgs(args: anytype) void {
        const ArgsType = @TypeOf(args);
        const args_fields = @typeInfo(ArgsType).@"struct".fields;

        if (comptime args_fields.len != 1) {
            @compileError("Doppler relativistic equivalency expect 1 argument.");
        }
        const ArgType = args_fields[0].type;
        utils.assertIsQuantity(ArgType);

        if (comptime !utils.isSpectralUnit(ArgType.unit)) {
            @compileError("Doppler relativistic equivalency argument must be a spectral compatible Quantity.");
        }
    }

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit, args: anytype) Quantity(T, U_out) {
        checkArgs(args);
        const rest = args.@"0";
        const RestType = @TypeOf(args.@"0");
        const rest_unit = comptime RestType.unit;
        const rest_hz = spectral_equivalency.convert(T, rest_unit, &rest, si.Hz);
        const as_rv: Quantity(T, rv_unit) = toRv(T, U_in, input_quantity, &rest_hz);
        return fromRv(T, &as_rv, U_out, &rest_hz);
    }

    fn toRv(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), rest: *const Quantity(T, si.Hz)) Quantity(T, rv_unit) {
        const c_kms: Quantity(T, rv_unit) = .initScalarValue(cst.c.quantity.to(rv_unit).value);
        if (comptime U_in.dim.eql(rv_dim)) return input_quantity.to(rv_unit);
        if (comptime U_in.dim.eql(frequency_dim)) {
            const f = input_quantity.to(si.Hz);
            return fToRv(T, &f, rest, &c_kms);
        }
        if (comptime U_in.dim.eql(wavelength_dim) or
            U_in.dim.eql(energy_dim) or
            U_in.dim.eql(wavenumber_spec_dim) or
            U_in.dim.eql(wavenumber_ang_dim))
        {
            const f = spectral_equivalency.convert(T, U_in, input_quantity, si.Hz);
            return fToRv(T, &f, rest, &c_kms);
        }
        if (@inComptime()) @compileError("Unknown doppler relativistic equivalency conversion.");
        unreachable;
    }

    fn fromRv(comptime T: type, input_quantity: *const Quantity(T, rv_unit), comptime U_out: Unit, rest: *const Quantity(T, si.Hz)) Quantity(T, U_out) {
        const c_kms: Quantity(T, rv_unit) = .initScalarValue(cst.c.quantity.to(rv_unit).value);
        if (comptime U_out.dim.eql(rv_dim)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(frequency_dim)) {
            const f: Quantity(T, si.Hz) = rvToF(T, input_quantity, rest, &c_kms);
            return f.to(U_out);
        }
        if (comptime U_out.dim.eql(energy_dim) or
            U_out.dim.eql(wavelength_dim) or
            U_out.dim.eql(wavenumber_spec_dim) or
            U_out.dim.eql(wavenumber_ang_dim))
        {
            const f: Quantity(T, si.Hz) = rvToF(T, input_quantity, &rest, &c_kms);
            return spectral_equivalency.convert(T, si.Hz, &f, U_out);
        }
        if (@inComptime()) @compileError("Unknown doppler relativistic equivalency conversion.");
        unreachable;
    }

    fn fToRv(comptime T: type, freq: *const Quantity(T, si.Hz), rest: *const Quantity(T, si.Hz), c_kms: *const Quantity(T, rv_unit)) Quantity(T, rv_unit) {
        const f0sq = rest.pow(2);
        const fsq = freq.pow(2);
        return c_kms.mul(f0sq.sub(fsq)).div(f0sq.add(fsq)).to(rv_unit);
    }

    fn rvToF(comptime T: type, rv: *const Quantity(T, rv_unit), rest: *const Quantity(T, si.Hz), c_kms: *const Quantity(T, rv_unit)) Quantity(T, si.Hz) {
        const one: Quantity(T, UNITLESS) = .initScalarValue(1);
        const beta = rv.div(c_kms.*).to(UNITLESS);
        return rest.mul(one.sub(beta.pow(2)).sqrt()).div(one.add(beta));
    }
};

/// Optical Doppler equivalency: converts a spectral coordinate to/from radial
/// velocity using the optical convention (linear in wavelength). Requires the rest
/// value as a spectral-compatible Quantity. Hub unit is km/s.
///   f -> v:  v = c * (f0 - f) / f
///   v -> f:  f = f0 / (1 + v/c)
pub const doppler_optical_equivalency = struct {
    const wavelength_dim: Dim = si.m.dim;
    const energy_dim: Dim = si.J.dim;
    const frequency_dim: Dim = si.Hz.dim;
    const wavenumber_spec_dim: Dim = si.m.pow(-1).dim;
    const wavenumber_ang_dim: Dim = si.rad.div(si.m).dim;
    const rv_unit: Unit = us.km.div(si.s);
    const rv_dim: Dim = rv_unit.dim;

    fn checkArgs(args: anytype) void {
        const ArgsType = @TypeOf(args);
        const args_fields = @typeInfo(ArgsType).@"struct".fields;

        if (comptime args_fields.len != 1) {
            @compileError("Doppler optical equivalency expect 1 argument.");
        }
        const ArgType = args_fields[0].type;
        utils.assertIsQuantity(ArgType);

        if (comptime !utils.isSpectralUnit(ArgType.unit)) {
            @compileError("Doppler optical equivalency argument must be a spectral compatible Quantity.");
        }
    }

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit, args: anytype) Quantity(T, U_out) {
        checkArgs(args);
        const rest = args.@"0";
        const RestType = @TypeOf(args.@"0");
        const rest_unit = comptime RestType.unit;
        const rest_hz = spectral_equivalency.convert(T, rest_unit, &rest, si.Hz);
        const as_rv: Quantity(T, rv_unit) = toRv(T, U_in, input_quantity, &rest_hz);
        return fromRv(T, &as_rv, U_out, &rest_hz);
    }

    fn toRv(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), rest: *const Quantity(T, si.Hz)) Quantity(T, rv_unit) {
        const c_kms: Quantity(T, rv_unit) = .initScalarValue(cst.c.quantity.to(rv_unit).value);
        if (comptime U_in.dim.eql(rv_dim)) return input_quantity.to(rv_unit);
        if (comptime U_in.dim.eql(frequency_dim)) {
            const f = input_quantity.to(si.Hz);
            return fToRv(T, &f, rest, &c_kms);
        }
        if (comptime U_in.dim.eql(wavelength_dim) or
            U_in.dim.eql(energy_dim) or
            U_in.dim.eql(wavenumber_spec_dim) or
            U_in.dim.eql(wavenumber_ang_dim))
        {
            const f = spectral_equivalency.convert(T, U_in, input_quantity, si.Hz);
            return fToRv(T, &f, rest, &c_kms);
        }
        if (@inComptime()) @compileError("Unknown doppler optical equivalency conversion.");
        unreachable;
    }

    fn fromRv(comptime T: type, input_quantity: *const Quantity(T, rv_unit), comptime U_out: Unit, rest: *const Quantity(T, si.Hz)) Quantity(T, U_out) {
        const c_kms: Quantity(T, rv_unit) = .initScalarValue(cst.c.quantity.to(rv_unit).value);
        if (comptime U_out.dim.eql(rv_dim)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(frequency_dim)) {
            const f = rvToF(T, input_quantity, rest, &c_kms);
            return f.to(U_out);
        }
        if (comptime U_out.dim.eql(energy_dim) or
            U_out.dim.eql(wavelength_dim) or
            U_out.dim.eql(wavenumber_spec_dim) or
            U_out.dim.eql(wavenumber_ang_dim))
        {
            const f = rvToF(T, input_quantity, rest, &c_kms);
            return spectral_equivalency.convert(T, si.Hz, &f, U_out);
        }
        if (@inComptime()) @compileError("Unknown doppler optical equivalency conversion.");
        unreachable;
    }

    fn fToRv(comptime T: type, freq: *const Quantity(T, si.Hz), rest: *const Quantity(T, si.Hz), c_kms: *const Quantity(T, rv_unit)) Quantity(T, rv_unit) {
        // v = c * (f0 - f) / f
        return c_kms.mul(rest.sub(freq.*)).div(freq.*).to(rv_unit);
    }

    fn rvToF(comptime T: type, rv: *const Quantity(T, rv_unit), rest: *const Quantity(T, si.Hz), c_kms: *const Quantity(T, rv_unit)) Quantity(T, si.Hz) {
        // f = f0 / (1 + v/c)
        const one: Quantity(T, UNITLESS) = .initScalarValue(1);
        const beta = rv.div(c_kms.*).to(UNITLESS);
        return rest.div(one.add(beta));
    }
};

/// Radio Doppler equivalency: converts a spectral coordinate to/from radial velocity
/// using the radio convention (linear in frequency). Requires the rest value as a
/// spectral-compatible Quantity. Hub unit is km/s.
///   f -> v:  v = c * (f0 - f) / f0
///   v -> f:  f = f0 * (1 - v/c)
pub const doppler_radio_equivalency = struct {
    const wavelength_dim: Dim = si.m.dim;
    const energy_dim: Dim = si.J.dim;
    const frequency_dim: Dim = si.Hz.dim;
    const wavenumber_spec_dim: Dim = si.m.pow(-1).dim;
    const wavenumber_ang_dim: Dim = si.rad.div(si.m).dim;
    const rv_unit: Unit = us.km.div(si.s);
    const rv_dim: Dim = rv_unit.dim;

    fn checkArgs(args: anytype) void {
        const ArgsType = @TypeOf(args);
        const args_fields = @typeInfo(ArgsType).@"struct".fields;

        if (comptime args_fields.len != 1) {
            @compileError("Doppler radio equivalency expect 1 argument.");
        }
        const ArgType = args_fields[0].type;
        utils.assertIsQuantity(ArgType);

        if (comptime !utils.isSpectralUnit(ArgType.unit)) {
            @compileError("Doppler radio equivalency argument must be a spectral compatible Quantity.");
        }
    }

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit, args: anytype) Quantity(T, U_out) {
        checkArgs(args);
        const rest = args.@"0";
        const RestType = @TypeOf(args.@"0");
        const rest_unit = comptime RestType.unit;
        const rest_hz = spectral_equivalency.convert(T, rest_unit, &rest, si.Hz);
        const as_rv: Quantity(T, rv_unit) = toRv(T, U_in, input_quantity, &rest_hz);
        return fromRv(T, &as_rv, U_out, &rest_hz);
    }

    fn toRv(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), rest: *const Quantity(T, si.Hz)) Quantity(T, rv_unit) {
        const c_kms: Quantity(T, rv_unit) = .initScalarValue(cst.c.quantity.to(rv_unit).value);
        if (comptime U_in.dim.eql(rv_dim)) return input_quantity.to(rv_unit);
        if (comptime U_in.dim.eql(frequency_dim)) {
            const f = input_quantity.to(si.Hz);
            return fToRv(T, &f, rest, &c_kms);
        }
        if (comptime U_in.dim.eql(wavelength_dim) or
            U_in.dim.eql(energy_dim) or
            U_in.dim.eql(wavenumber_spec_dim) or
            U_in.dim.eql(wavenumber_ang_dim))
        {
            const f = spectral_equivalency.convert(T, U_in, input_quantity, si.Hz);
            return fToRv(T, &f, rest, &c_kms);
        }
        if (@inComptime()) @compileError("Unknown doppler radio equivalency conversion.");
        unreachable;
    }

    fn fromRv(comptime T: type, input_quantity: *const Quantity(T, rv_unit), comptime U_out: Unit, rest: *const Quantity(T, si.Hz)) Quantity(T, U_out) {
        const c_kms: Quantity(T, rv_unit) = .initScalarValue(cst.c.quantity.to(rv_unit).value);
        if (comptime U_out.dim.eql(rv_dim)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(frequency_dim)) {
            const f = rvToF(T, input_quantity, rest, &c_kms);
            return f.to(U_out);
        }
        if (comptime U_out.dim.eql(energy_dim) or
            U_out.dim.eql(wavelength_dim) or
            U_out.dim.eql(wavenumber_spec_dim) or
            U_out.dim.eql(wavenumber_ang_dim))
        {
            const f = rvToF(T, input_quantity, rest, &c_kms);
            return spectral_equivalency.convert(T, si.Hz, &f, U_out);
        }
        if (@inComptime()) @compileError("Unknown doppler radio equivalency conversion.");
        unreachable;
    }

    fn fToRv(comptime T: type, freq: *const Quantity(T, si.Hz), rest: *const Quantity(T, si.Hz), c_kms: *const Quantity(T, rv_unit)) Quantity(T, rv_unit) {
        // v = c * (f0 - f) / f0
        return c_kms.mul(rest.sub(freq.*)).div(rest.*).to(rv_unit);
    }

    fn rvToF(comptime T: type, rv: *const Quantity(T, rv_unit), rest: *const Quantity(T, si.Hz), c_kms: *const Quantity(T, rv_unit)) Quantity(T, si.Hz) {
        // f = f0 * (1 - v/c)
        const one: Quantity(T, UNITLESS) = .initScalarValue(1);
        const beta = rv.div(c_kms.*).to(UNITLESS);
        return rest.mul(one.sub(beta));
    }
};

/// Magnetic flux-field equivalency: converts between the H-field (A/m) and the
/// B-field (tesla) via B = mu_0 mu_r H. Takes an optional argument: the relative
/// permeability mu_r as a dimensionless Quantity (defaults to 1, i.e. vacuum).
/// Hub unit is the tesla.
pub const magnetic_flux_field_equivalency = struct {
    const H_field_dim: Dim = si.A.div(si.m).dim;
    const B_field_dim: Dim = si.T.dim;

    fn checkArgsAndGetMuR(comptime T: type, args: anytype) Quantity(T, UNITLESS) {
        const ArgsType = @TypeOf(args);
        const args_fields = @typeInfo(ArgsType).@"struct".fields;

        if (comptime args_fields.len > 1) {
            @compileError("Magnetic flux field equivalency expect at most 1 argument.");
        }

        if (comptime args_fields.len == 0) {
            return .initScalarValue(1);
        }

        const ArgType = args_fields[0].type;
        utils.assertIsQuantity(ArgType);
        if (comptime !ArgType.unit.dim.eql(UNITLESS.dim)) {
            @compileError("Magnetic flux field equivalency argument must be a unitless Quantity.");
        }
        return .init(args.@"0".value);
    }

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit, args: anytype) Quantity(T, U_out) {
        const mu_r = checkArgsAndGetMuR(T, args);
        const as_T = toT(T, U_in, input_quantity, &mu_r);
        return fromT(T, &as_T, U_out, &mu_r);
    }

    fn toT(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), mu_r: *const Quantity(T, UNITLESS)) Quantity(T, si.T) {
        const mu_0: Quantity(T, cst.mu0.quantity.getUnit()) = .initScalarValue(cst.mu0.quantity.value);
        if (comptime U_in.dim.eql(B_field_dim)) return input_quantity.to(si.T);
        if (comptime U_in.dim.eql(H_field_dim)) return input_quantity.mul(mu_0).mul(mu_r.*).to(si.T);
        if (@inComptime()) @compileError("Unknown magnetic field flux equivalency conversion.");
        unreachable;
    }

    fn fromT(comptime T: type, input_quantity: *const Quantity(T, si.T), comptime U_out: Unit, mu_r: *const Quantity(T, UNITLESS)) Quantity(T, U_out) {
        const mu_0: Quantity(T, cst.mu0.quantity.getUnit()) = .initScalarValue(cst.mu0.quantity.value);
        if (comptime U_out.dim.eql(B_field_dim)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(H_field_dim)) return input_quantity.div(mu_0.mul(mu_r.*)).to(U_out);
        if (@inComptime()) @compileError("Unknown magnetic field flux equivalency conversion.");
        unreachable;
    }
};

// NOTE: In astropy, this conversion also support Jy/beam unit. In Zali at the moment we do not
// support beam unit which is a dimensionless unit that seems misleading to me.
/// Brightness-temperature equivalency: converts between specific intensity / flux
/// density and brightness temperature using the Rayleigh-Jeans law. Hub unit is the
/// kelvin. Takes one or two arguments: the spectral location (frequency, required),
/// and a beam solid angle (required only when the flux side is per-beam Jy rather
/// than per-steradian Jy/sr).
///   S_nu = 2 k_B T_B nu^2 Omega / c^2   (Omega = beam solid angle)
pub const brightness_temperature_equivalency = struct {
    const sterad_dim: Dim = si.sr.dim;
    const Jy: Unit = us.Jy;
    const Jy_dim: Dim = Jy.dim;
    const K_dim: Dim = si.K.dim;
    const JySr: Unit = us.Jy.div(si.sr);
    const JySr_dim: Dim = JySr.dim;

    fn checkArgs(args: anytype) void {
        const ArgsType = @TypeOf(args);
        const args_fields = @typeInfo(ArgsType).@"struct".fields;

        if (comptime args_fields.len != 1 and args_fields.len != 2) {
            @compileError("Brightness temperature equivalency expect 1 or 2 argument.");
        }
        inline for (args_fields) |field| {
            const ArgType = field.type;
            utils.assertIsQuantity(ArgType);
        }

        if (comptime !utils.isSpectralUnit(args_fields[0].type.unit)) {
            @compileError("Brightness temperature equivalency first argument must be a spectral compatible Quantity.");
        }
        if (comptime args_fields.len == 2 and !args_fields[1].type.unit.dim.eql(sterad_dim)) {
            @compileError("Brightness temperature equivalency second arguement must be in angular units, i.e. steradian equivalent.");
        }
    }

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit, args: anytype) Quantity(T, U_out) {
        checkArgs(args);
        const arg_number: usize = @typeInfo(@TypeOf(args)).@"struct".fields.len;
        const spectral_quantity = args.@"0";
        const spectral_quantity_unit = comptime @TypeOf(spectral_quantity).unit;
        const freq: Quantity(T, si.Hz) = spectral_equivalency.convert(T, spectral_quantity_unit, &spectral_quantity, si.Hz);
        if (comptime arg_number == 2) {
            const beam = args.@"1".to(si.sr);
            const as_K = toK(T, U_in, arg_number, input_quantity, &freq, &beam);
            return fromK(T, &as_K, U_out, arg_number, &freq, &beam);
        }
        const as_K = toK(T, U_in, arg_number, input_quantity, &freq, {});
        return fromK(T, &as_K, U_out, arg_number, &freq, {});
    }

    fn toK(
        comptime T: type,
        comptime U_in: Unit,
        comptime n_args: usize,
        input_quantity: *const Quantity(T, U_in),
        freq: *const Quantity(T, si.Hz),
        beam: if (n_args == 2) *const Quantity(T, si.sr) else void,
    ) Quantity(T, si.K) {
        const c2: Quantity(T, cst.c.quantity.getUnit().pow(2)) = .initScalarValue(cst.c.quantity.pow(2).value);
        const two_kb: Quantity(T, cst.k_B.quantity.getUnit()) = .initScalarValue(cst.k_B.quantity.mulValue(2).value);
        const nu2 = freq.pow(2);
        const one_sr: Quantity(T, si.sr) = .initScalarValue(1);
        if (comptime U_in.dim.eql(K_dim)) return input_quantity.to(si.K);
        if (comptime U_in.dim.eql(Jy_dim) and n_args == 2) {
            if (comptime n_args != 2) @compileError("Converting Jy to K required a beam area as a second argument.");
            return input_quantity.to(Jy).mul(c2).div(two_kb.mul(nu2).mul(beam.*)).mul(one_sr).to(si.K);
        }
        if (comptime U_in.dim.eql(JySr_dim)) {
            return input_quantity.to(JySr).mul(c2).div(two_kb.mul(nu2)).mul(one_sr).to(si.K);
        }
        if (@inComptime()) @compileError("Unknown brightness temperature flux equivalency conversion.");
        unreachable;
    }

    fn fromK(
        comptime T: type,
        input_quantity: *const Quantity(T, si.K),
        comptime U_out: Unit,
        comptime n_args: usize,
        freq: *const Quantity(T, si.Hz),
        beam: if (n_args == 2) *const Quantity(T, si.sr) else void,
    ) Quantity(T, U_out) {
        const c2: Quantity(T, cst.c.quantity.getUnit().pow(2)) = .initScalarValue(cst.c.quantity.pow(2).value);
        const two_kb: Quantity(T, cst.k_B.quantity.getUnit()) = .initScalarValue(cst.k_B.quantity.mulValue(2).value);
        const one_sr: Quantity(T, si.sr) = .initScalarValue(1);
        const nu2 = freq.pow(2);
        if (comptime U_out.dim.eql(K_dim)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(Jy_dim)) {
            if (comptime n_args != 2) @compileError("Converting K to Jy required a beam area as a second argument.");
            return two_kb.mul(input_quantity.*).mul(nu2).mul(beam.*).div(c2).div(one_sr).to(U_out);
        }
        if (comptime U_out.dim.eql(JySr_dim)) return two_kb.mul(input_quantity.*).mul(nu2).div(c2).div(one_sr).to(U_out);
        if (@inComptime()) @compileError("Unknown brightness temperature flux equivalency conversion.");
        unreachable;
    }
};

/// Plate-scale equivalency: converts between a focal-plane length and an angle on the
/// sky, given a plate scale in length/angle (e.g. m/rad). Direct two-way conversion.
///   length = angle * plate_scale,   angle = length / plate_scale
pub const plate_scale_equivalency = struct {
    const plate_scale_unit: Unit = si.m.div(si.rad);
    const plate_scale_dim: Dim = plate_scale_unit.dim;
    const length_dim: Dim = dim_mod.length;
    const angle_dim: Dim = dim_mod.angle;

    fn checkArgs(args: anytype) void {
        const ArgsType = @TypeOf(args);
        const args_fields = @typeInfo(ArgsType).@"struct".fields;

        if (comptime args_fields.len != 1) {
            @compileError("Plate scale equivalency requires one argument.");
        }

        const ArgType = args_fields[0].type;
        utils.assertIsQuantity(ArgType);
        if (comptime !ArgType.unit.dim.eql(plate_scale_dim)) {
            @compileError("Plate scale equivalency argument must be in units of length / angle.");
        }
    }

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit, args: anytype) Quantity(T, U_out) {
        checkArgs(args);
        const plate_scale = args.@"0";
        if (comptime U_in.dim.eql(length_dim) and U_out.dim.eql(angle_dim)) return input_quantity.div(plate_scale).to(U_out);
        if (comptime U_in.dim.eql(angle_dim) and U_out.dim.eql(length_dim)) return input_quantity.mul(plate_scale).to(U_out);
        if (@inComptime()) @compileError("Unknown plate scale equivalency conversion.");
        unreachable;
    }
};

/// Pixel-scale equivalency: converts between pixels and a physical quantity (an angle
/// or a length), given a pixel scale such as arcsec/pixel or pixel/cm. Because pixel
/// is dimensionless, the conversion is driven by inspecting the pixel exponent in the
/// scale's symbol rather than by dimension alone.
pub const pixel_scale_equivalency = struct {
    fn checkArgs(args: anytype) void {
        const ArgsType = @TypeOf(args);
        const args_fields = @typeInfo(ArgsType).@"struct".fields;

        if (comptime args_fields.len != 1) {
            @compileError("Pixel scale equivalency requires one argument.");
        }

        const ArgType = args_fields[0].type;
        utils.assertIsQuantity(ArgType);
    }

    fn getPixelPower(comptime unit: Unit) isize {
        const symbol = unit.symbol;
        if (comptime symbol.indexOfSymbol(misc.pix.symbol.terms[0])) |idx| {
            const pixel_power_frac = symbol.terms[idx].exponent;
            if (comptime pixel_power_frac.eqlScalar(-1)) return -1;
            if (comptime pixel_power_frac.eqlScalar(1)) return 1;
        }
        if (@inComptime()) @compileError("Pixel scale equivalency argument must have pixel dimensionality of 1 or -1.");
        unreachable;
    }

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit, args: anytype) Quantity(T, U_out) {
        checkArgs(args);
        const pixel_scale = args.@"0";
        const pixel_scale_type = @TypeOf(pixel_scale);
        const pixel_power = comptime getPixelPower(pixel_scale_type.unit);

        const physical_unit: Unit = comptime blk: {
            if (pixel_power == -1) break :blk pixel_scale_type.unit.mul(misc.pix);
            break :blk pixel_scale_type.unit.div(misc.pix).pow(-1);
        };

        const scale: Quantity(T, UNITLESS) = .initScalarValue(if (comptime pixel_power == -1)
            pixel_scale.to(physical_unit.div(misc.pix)).value
        else
            pixel_scale.to(misc.pix.div(physical_unit)).value);

        // pix → physical
        if (comptime U_in.dim.eql(misc.pix.dim) and U_out.dim.eql(physical_unit.dim)) {
            if (comptime pixel_power == -1)
                return Quantity(T, physical_unit).init(input_quantity.value).mul(scale).to(U_out)
            else
                return Quantity(T, physical_unit).init(input_quantity.value).div(scale).to(U_out);
        }
        // physical → pix
        if (comptime U_in.dim.eql(physical_unit.dim) and U_out.dim.eql(misc.pix.dim)) {
            if (comptime pixel_power == -1)
                return Quantity(T, misc.pix).init(input_quantity.to(physical_unit).value).div(scale).to(U_out)
            else
                return Quantity(T, misc.pix).init(input_quantity.to(physical_unit).value).mul(scale).to(U_out);
        }
        if (@inComptime()) @compileError("Unknown pixel scale equivalency conversion.");
        unreachable;
    }
};

/// Spectral-density equivalency: converts between per-frequency and per-wavelength
/// spectral densities (and their nu*F_nu integrated form) at a given spectral
/// location, applying the Jacobian dnu/dlambda = c/lambda^2. Supports four families,
/// each with its own per-frequency hub:
///   - flux density           (F_nu  <-> F_lambda  <-> nu F_nu)
///   - luminosity density     (L_nu  <-> L_lambda  <-> nu L_nu)
///   - surface brightness     (S_nu  <-> S_lambda  <-> nu S_nu),      per steradian
///   - luminosity surface br. (SL_nu <-> SL_lambda <-> nu SL_nu),     per steradian
/// The Jacobian is identical across families; only the extra dimensions differ.
/// Requires one argument: the spectral location as a spectral-compatible Quantity.
// TODO: support photon base units
pub const spectral_density_equivalency = struct {
    // Flux
    const Fnu: Unit = si.kg.div(si.s.pow(2));
    const Flamb: Unit = si.kg.div(si.m.mul(si.s.pow(3)));
    const nuFnu: Unit = si.kg.div(si.s.pow(3));
    const Fnu_dim: Dim = Fnu.dim;
    const Flamb_dim: Dim = Flamb.dim;
    const nuFnu_dim: Dim = nuFnu.dim;

    // Luminosity
    const Lnu: Unit = si.W.div(si.Hz);
    const Llamb: Unit = si.W.div(si.m);
    const nuLnu: Unit = si.W;
    const Lnu_dim: Dim = Lnu.dim;
    const Llamb_dim: Dim = Llamb.dim;
    const nuLnu_dim: Dim = nuLnu.dim;

    // Surface brightness
    const Snu: Unit = si.W.div(si.m.pow(2)).div(si.Hz).div(si.sr);
    const Slamb: Unit = si.W.div(si.m.pow(3)).div(si.sr);
    const nuSnu: Unit = si.W.div(si.m.pow(2)).div(si.sr);
    const Snu_dim: Dim = Snu.dim;
    const Slamb_dim: Dim = Slamb.dim;
    const nuSnu_dim: Dim = nuSnu.dim;

    // Luminosity surface brightness
    const SLnu: Unit = si.W.div(si.Hz).div(si.sr);
    const SLlamb: Unit = si.W.div(si.m).div(si.sr);
    const nuSLnu: Unit = si.W.div(si.sr);
    const SLnu_dim: Dim = SLnu.dim;
    const SLlamb_dim: Dim = SLlamb.dim;
    const nuSLnu_dim: Dim = nuSLnu.dim;

    fn checkArgs(args: anytype) void {
        const ArgsType = @TypeOf(args);
        const args_fields = @typeInfo(ArgsType).@"struct".fields;

        if (comptime args_fields.len != 1) {
            @compileError("Spectral density equivalency expect one argument.");
        }

        const ArgType = args_fields[0].type;
        utils.assertIsQuantity(ArgType);
        if (comptime !utils.isSpectralUnit(ArgType.unit)) {
            @compileError("Spectral density equivalency argument must be a spectral compatible Quantity.");
        }
    }

    pub fn convert(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit, args: anytype) Quantity(T, U_out) {
        checkArgs(args);
        const spectral_quantity = args.@"0";
        const spectral_quantity_unit = comptime @TypeOf(spectral_quantity).unit;
        const freq: Quantity(T, si.Hz) = spectral_equivalency.convert(T, spectral_quantity_unit, &spectral_quantity, si.Hz);
        if (comptime U_in.dim.eql(Fnu_dim) or U_in.dim.eql(Flamb_dim) or U_in.dim.eql(nuFnu_dim)) {
            const as_Fnu = toFnu(T, U_in, input_quantity, &freq);
            return fromFnu(T, &as_Fnu, U_out, &freq);
        }
        if (comptime U_in.dim.eql(Lnu_dim) or U_in.dim.eql(Llamb_dim) or U_in.dim.eql(nuLnu_dim)) {
            const as_Lnu = toLnu(T, U_in, input_quantity, &freq);
            return fromLnu(T, &as_Lnu, U_out, &freq);
        }
        if (comptime U_in.dim.eql(Snu_dim) or U_in.dim.eql(Slamb_dim) or U_in.dim.eql(nuSnu_dim)) {
            const as_Snu = toSnu(T, U_in, input_quantity, &freq);
            return fromSnu(T, &as_Snu, U_out, &freq);
        }
        if (comptime U_in.dim.eql(SLnu_dim) or U_in.dim.eql(SLlamb_dim) or U_in.dim.eql(nuSLnu_dim)) {
            const as_SLnu = toSLnu(T, U_in, input_quantity, &freq);
            return fromSLnu(T, &as_SLnu, U_out, &freq);
        }
        if (@inComptime()) @compileError("Unknown spectral density equivalency conversion.");
        unreachable;
    }

    fn toFnu(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), freq: *const Quantity(T, si.Hz)) Quantity(T, Fnu) {
        const c: Quantity(T, cst.c.quantity.getUnit()) = .initScalarValue(cst.c.quantity.value);
        if (comptime U_in.dim.eql(Fnu_dim)) return input_quantity.to(Fnu);
        if (comptime U_in.dim.eql(Flamb_dim)) return input_quantity.mul(c).div(freq.pow(2)).to(Fnu);
        if (comptime U_in.dim.eql(nuFnu_dim)) return input_quantity.div(freq.*).to(Fnu);
        if (@inComptime()) @compileError("Unknown spectral density equivalency conversion.");
        unreachable;
    }

    fn fromFnu(comptime T: type, input_quantity: *const Quantity(T, Fnu), comptime U_out: Unit, freq: *const Quantity(T, si.Hz)) Quantity(T, U_out) {
        const c: Quantity(T, cst.c.quantity.getUnit()) = .initScalarValue(cst.c.quantity.value);
        if (comptime U_out.dim.eql(Fnu_dim)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(Flamb_dim)) return input_quantity.mul(freq.pow(2)).div(c).to(U_out);
        if (comptime U_out.dim.eql(nuFnu_dim)) return input_quantity.mul(freq.*).to(U_out);
        if (@inComptime()) @compileError("Unknown spectral density equivalency conversion.");
        unreachable;
    }

    fn toLnu(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), freq: *const Quantity(T, si.Hz)) Quantity(T, Lnu) {
        const c: Quantity(T, cst.c.quantity.getUnit()) = .initScalarValue(cst.c.quantity.value);
        if (comptime U_in.dim.eql(Lnu_dim)) return input_quantity.to(Lnu);
        if (comptime U_in.dim.eql(Llamb_dim)) return input_quantity.mul(c).div(freq.pow(2)).to(Lnu);
        if (comptime U_in.dim.eql(nuLnu_dim)) return input_quantity.div(freq.*).to(Lnu);
        if (@inComptime()) @compileError("Unknown spectral density equivalency conversion.");
        unreachable;
    }

    fn fromLnu(comptime T: type, input_quantity: *const Quantity(T, Lnu), comptime U_out: Unit, freq: *const Quantity(T, si.Hz)) Quantity(T, U_out) {
        const c: Quantity(T, cst.c.quantity.getUnit()) = .initScalarValue(cst.c.quantity.value);
        if (comptime U_out.dim.eql(Lnu_dim)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(Llamb_dim)) return input_quantity.mul(freq.pow(2)).div(c).to(U_out);
        if (comptime U_out.dim.eql(nuLnu_dim)) return input_quantity.mul(freq.*).to(U_out);
        if (@inComptime()) @compileError("Unknown spectral density equivalency conversion.");
        unreachable;
    }

    fn toSnu(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), freq: *const Quantity(T, si.Hz)) Quantity(T, Snu) {
        const c: Quantity(T, cst.c.quantity.getUnit()) = .initScalarValue(cst.c.quantity.value);
        if (comptime U_in.dim.eql(Snu_dim)) return input_quantity.to(Snu);
        if (comptime U_in.dim.eql(Slamb_dim)) return input_quantity.mul(c).div(freq.pow(2)).to(Snu);
        if (comptime U_in.dim.eql(nuSnu_dim)) return input_quantity.div(freq.*).to(Snu);
        if (@inComptime()) @compileError("Unknown spectral density equivalency conversion.");
        unreachable;
    }

    fn fromSnu(comptime T: type, input_quantity: *const Quantity(T, Snu), comptime U_out: Unit, freq: *const Quantity(T, si.Hz)) Quantity(T, U_out) {
        const c: Quantity(T, cst.c.quantity.getUnit()) = .initScalarValue(cst.c.quantity.value);
        if (comptime U_out.dim.eql(Snu_dim)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(Slamb_dim)) return input_quantity.mul(freq.pow(2)).div(c).to(U_out);
        if (comptime U_out.dim.eql(nuSnu_dim)) return input_quantity.mul(freq.*).to(U_out);
        if (@inComptime()) @compileError("Unknown spectral density equivalency conversion.");
        unreachable;
    }

    fn toSLnu(comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), freq: *const Quantity(T, si.Hz)) Quantity(T, SLnu) {
        const c: Quantity(T, cst.c.quantity.getUnit()) = .initScalarValue(cst.c.quantity.value);
        if (comptime U_in.dim.eql(SLnu_dim)) return input_quantity.to(SLnu);
        if (comptime U_in.dim.eql(SLlamb_dim)) return input_quantity.mul(c).div(freq.pow(2)).to(SLnu);
        if (comptime U_in.dim.eql(nuSLnu_dim)) return input_quantity.div(freq.*).to(SLnu);
        if (@inComptime()) @compileError("Unknown spectral density equivalency conversion.");
        unreachable;
    }

    fn fromSLnu(comptime T: type, input_quantity: *const Quantity(T, SLnu), comptime U_out: Unit, freq: *const Quantity(T, si.Hz)) Quantity(T, U_out) {
        const c: Quantity(T, cst.c.quantity.getUnit()) = .initScalarValue(cst.c.quantity.value);
        if (comptime U_out.dim.eql(SLnu_dim)) return input_quantity.to(U_out);
        if (comptime U_out.dim.eql(SLlamb_dim)) return input_quantity.mul(freq.pow(2)).div(c).to(U_out);
        if (comptime U_out.dim.eql(nuSLnu_dim)) return input_quantity.mul(freq).to(U_out);
        if (@inComptime()) @compileError("Unknown spectral density equivalency conversion.");
        unreachable;
    }
};

// Yet to be implemnted:
//
// "beam_angular_area", -> This requires a beam unit defined in astropy in "astrophys". But this is
// a bit misleading in my opinion.
// "logarithmic",
// "thermodynamic_temperature" -> requires cosmology
/// The set of named equivalencies, used as a comptime selector by
/// `Quantity.toWithEquivalency`. Each variant maps to the correspondingly named
/// equivalency struct above.
pub const Equivalency = enum {
    const Self = @This();

    spectral,
    mass_energy,
    temperature_energy,
    temperature,
    molar_mass_amu,
    doppler_redshift,
    dimensionless_angles,
    parallax,
    zero_point_flux,
    doppler_relativistic,
    doppler_optical,
    doppler_radio,
    magnetic_flux_field,
    brightness_temperature,
    plate_scale,
    pixel_scale,
    spectral_density,

    /// Dispatches to the selected equivalency's `convert`. `self` is comptime so the
    /// switch compiles only the chosen branch, which is why equivalencies that take
    /// no `args` never see the (possibly empty) tuple. The `args` tuple is forwarded
    /// only to the equivalencies that require it.
    pub fn convert(comptime self: Self, comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit, args: anytype) Quantity(T, U_out) {
        const ArgsType = @TypeOf(args);
        const args_type_info = @typeInfo(ArgsType);
        if (args_type_info != .@"struct") {
            @compileError("Expected tuple or struct argument, found " ++ @typeName(ArgsType));
        }
        return switch (self) {
            .spectral => spectral_equivalency.convert(T, U_in, input_quantity, U_out),
            .mass_energy => mass_energy_equivalency.convert(T, U_in, input_quantity, U_out),
            .temperature_energy => temperature_energy_equivalency.convert(T, U_in, input_quantity, U_out),
            .temperature => temperature_equivalency.convert(T, U_in, input_quantity, U_out),
            .molar_mass_amu => molar_mass_amu_equivalency.convert(T, U_in, input_quantity, U_out),
            .doppler_redshift => doppler_redshift_equivalency.convert(T, U_in, input_quantity, U_out),
            .dimensionless_angles => dimensionless_angles_equivalency.convert(T, U_in, input_quantity, U_out),
            .parallax => parallax_equivalency.convert(T, U_in, input_quantity, U_out),
            .zero_point_flux => zero_point_flux_equivalency.convert(T, U_in, input_quantity, U_out, args),
            .doppler_relativistic => doppler_relativistic_equivalency.convert(T, U_in, input_quantity, U_out, args),
            .doppler_optical => doppler_optical_equivalency.convert(T, U_in, input_quantity, U_out, args),
            .doppler_radio => doppler_radio_equivalency.convert(T, U_in, input_quantity, U_out, args),
            .magnetic_flux_field => magnetic_flux_field_equivalency.convert(T, U_in, input_quantity, U_out, args),
            .brightness_temperature => brightness_temperature_equivalency.convert(T, U_in, input_quantity, U_out, args),
            .plate_scale => plate_scale_equivalency.convert(T, U_in, input_quantity, U_out, args),
            .pixel_scale => pixel_scale_equivalency.convert(T, U_in, input_quantity, U_out, args),
            .spectral_density => spectral_density_equivalency.convert(T, U_in, input_quantity, U_out, args),
        };
    }

    pub fn convertInto(comptime self: Self, comptime T: type, comptime U_in: Unit, input_quantity: *const Quantity(T, U_in), comptime U_out: Unit, out: *Quantity(T, U_out), args: anytype) void {
        const ArgsType = @TypeOf(args);
        const args_type_info = @typeInfo(ArgsType);
        if (args_type_info != .@"struct") {
            @compileError("Expected tuple or struct argument, found " ++ @typeName(ArgsType));
        }
        return switch (self) {
            .spectral => spectral_equivalency.convertInto(T, U_in, input_quantity, U_out, out),
            else => @panic("TODO"),
        };
    }
};

test "spectral equivalency" {
    // Wavelength <-> Hz
    const green_wl: Quantity(f64, si.nm) = .init(550);
    const green_freq = spectral_equivalency.convert(f64, si.nm, &green_wl, si.Hz);
    try testing.expectApproxEqRel(5.45077196e14, green_freq.value, 1e-8);
    try testing.expectEqual(si.Hz, green_freq.getUnit());
    const green_wl_back = spectral_equivalency.convert(f64, si.Hz, &green_freq, si.nm);
    try testing.expectApproxEqAbs(green_wl.value, green_wl_back.value, 1e-15);

    // Wavelength <-> Energy
    const lyman: Quantity(f64, si.nm) = .init(121.567);
    const lyman_en = spectral_equivalency.convert(f64, si.nm, &lyman, us.eV);
    try testing.expectApproxEqRel(10.19883673, lyman_en.value, 1e-8);
    try testing.expectEqual(us.eV, lyman_en.getUnit());
    const lyman_back = spectral_equivalency.convert(f64, us.eV, &lyman_en, si.nm);
    try testing.expectApproxEqRel(lyman.value, lyman_back.value, 1e-15);

    // Hz <-> Energy
    const co_line: Quantity(f64, us.GHz) = .init(115.271);
    const co_line_energy = spectral_equivalency.convert(f64, us.GHz, &co_line, si.J);
    try testing.expectApproxEqRel(7.63793732e-23, co_line_energy.value, 1e-8);
    try testing.expectEqual(si.J, co_line_energy.getUnit());
    const co_line_back = spectral_equivalency.convert(f64, si.J, &co_line_energy, us.GHz);
    try testing.expectApproxEqRel(co_line.value, co_line_back.value, 1e-15);

    // Wavelength <-> Wavenumber spectroscopic
    const mir: Quantity(f64, us.um) = .init(10);
    const mir_wn_spec = spectral_equivalency.convert(f64, us.um, &mir, si.cm.pow(-1));
    try testing.expectApproxEqAbs(1000, mir_wn_spec.value, 1e-15);
    try testing.expectEqual(si.cm.pow(-1), mir_wn_spec.getUnit());
    const mir_back = spectral_equivalency.convert(f64, si.cm.pow(-1), &mir_wn_spec, us.um);
    try testing.expectApproxEqRel(mir.value, mir_back.value, 1e-15);

    // Wavelength <-> Wavenumber angular
    const green_wn_ang = spectral_equivalency.convert(f64, us.nm, &green_wl, si.rad.div(si.cm));
    try testing.expectApproxEqRel(114239.73285781, green_wn_ang.value, 1e-8);
    try testing.expectEqual(si.rad.div(si.cm), green_wn_ang.getUnit());
    const green_wl_back_ang = spectral_equivalency.convert(f64, si.rad.div(si.cm), &green_wn_ang, us.nm);
    try testing.expectApproxEqRel(green_wl.value, green_wl_back_ang.value, 1e-15);
}

test "spectral equivalency Into" {
    @panic("TODO");
}

test "mass energy equivalency" {
    const m_p_energy = mass_energy_equivalency.convert(f64, si.kg, &cst.m_p.quantity, si.J);
    try testing.expectApproxEqRel(1.50327762e-10, m_p_energy.value, 1e-8);
    try testing.expectEqual(si.J, m_p_energy.getUnit());
    const m_p_back = mass_energy_equivalency.convert(f64, si.J, &m_p_energy, si.kg);
    try testing.expectApproxEqRel(cst.m_p.quantity.value, m_p_back.value, 1e-15);
}

test "temperature energy equivalency" {
    const temp: Quantity(f64, si.K) = .init(300);
    const to_en = temperature_energy_equivalency.convert(f64, si.K, &temp, si.J);
    try testing.expectApproxEqRel(4.141947e-21, to_en.value, 1e-8);
    try testing.expectEqual(si.J, to_en.getUnit());
    const temp_back = temperature_energy_equivalency.convert(f64, si.J, &to_en, si.K);
    try testing.expectApproxEqRel(temp.value, temp_back.value, 1e-15);
}

test "molar mass amu equivalency" {
    const amu: Quantity(f64, misc.u) = .init(1);
    const amu_to_mm = molar_mass_amu_equivalency.convert(f64, misc.u, &amu, si.g.div(si.mol));
    try testing.expectApproxEqRel(1.0, amu_to_mm.value, 1e-8);
    try testing.expectEqual(si.g.div(si.mol), amu_to_mm.getUnit());
    const amu_back = molar_mass_amu_equivalency.convert(f64, si.g.div(si.mol), &amu_to_mm, misc.u);
    try testing.expectApproxEqRel(1.0, amu_back.value, 1e-15);
}

test "doppler redshift equivalency" {
    const cmb_z: Quantity(f64, UNITLESS) = .init(1089);
    const cmb_v = doppler_redshift_equivalency.convert(f64, UNITLESS, &cmb_z, us.km.div(si.s));
    try testing.expectApproxEqRel(299791.9533418, cmb_v.value, 1e-8);
    try testing.expectEqual(us.km.div(si.s), cmb_v.getUnit());
    const cmb_z_back = doppler_redshift_equivalency.convert(f64, us.km.div(si.s), &cmb_v, UNITLESS);
    try testing.expectApproxEqRel(cmb_z.value, cmb_z_back.value, 1e-8);
}

test "dimensionless angles equivalency" {
    const pi_rad: Quantity(f64, si.rad) = .init(std.math.pi);
    const pi_dimless = dimensionless_angles_equivalency.convert(f64, si.rad, &pi_rad, UNITLESS);
    try testing.expectApproxEqAbs(std.math.pi, pi_dimless.value, 1e-15);
    try testing.expectEqual(UNITLESS, pi_dimless.getUnit());
    const pi_rad_back = dimensionless_angles_equivalency.convert(f64, UNITLESS, &pi_dimless, si.rad);
    try testing.expectApproxEqAbs(std.math.pi, pi_rad_back.value, 1e-15);
    try testing.expectEqual(si.rad, pi_rad_back.getUnit());

    const one_rad: Quantity(f64, si.rad) = .init(1);
    const one_dimless = dimensionless_angles_equivalency.convert(f64, si.rad, &one_rad, UNITLESS);
    try testing.expectApproxEqAbs(1.0, one_dimless.value, 1e-15);
    const one_rad_back = dimensionless_angles_equivalency.convert(f64, UNITLESS, &one_dimless, si.rad);
    try testing.expectApproxEqAbs(1.0, one_rad_back.value, 1e-15);

    const deg_180: Quantity(f64, si.deg) = .init(180);
    const deg_180_dimless = dimensionless_angles_equivalency.convert(f64, si.deg, &deg_180, UNITLESS);
    try testing.expectApproxEqAbs(std.math.pi, deg_180_dimless.value, 1e-15);
    try testing.expectEqual(UNITLESS, deg_180_dimless.getUnit());
    const deg_180_back = dimensionless_angles_equivalency.convert(f64, UNITLESS, &deg_180_dimless, si.deg);
    try testing.expectApproxEqAbs(180, deg_180_back.value, 1e-15);
    try testing.expectEqual(si.deg, deg_180_back.getUnit());
}

test "parallax equivalency" {
    const as_1: Quantity(f64, si.arcsec) = .init(1);
    const pc = parallax_equivalency.convert(f64, si.arcsec, &as_1, us.pc);
    try testing.expectApproxEqAbs(1.0, pc.value, 1e-15);
    try testing.expectEqual(us.pc, pc.getUnit());
    const as_1_back = parallax_equivalency.convert(f64, us.pc, &pc, si.arcsec);
    try testing.expectApproxEqAbs(1.0, as_1_back.value, 1e-15);
}

test "zero point flux equivalency" {
    const mag: Quantity(f64, photo.mgy) = .init(1);
    const flux0: Quantity(f64, us.Jy) = .init(3631);
    const mag_to_flux = zero_point_flux_equivalency.convert(f64, photo.mgy, &mag, us.Jy, .{flux0});
    try testing.expectApproxEqAbs(3631, mag_to_flux.value, 1e-15);
    try testing.expectEqual(us.Jy, mag_to_flux.getUnit());
    const mag_back = zero_point_flux_equivalency.convert(f64, us.Jy, &mag_to_flux, photo.mgy, .{flux0});
    try testing.expectApproxEqAbs(1, mag_back.value, 1e-15);
    try testing.expectEqual(photo.mgy, mag_back.getUnit());
}

test "doppler relativistic equivalency" {
    const v_unit: Unit = comptime us.km.div(si.s);
    const f0: Quantity(f64, us.MHz) = .init(1420.405751768);
    const v1000: Quantity(f64, v_unit) = .init(1000);
    const v1000_f = doppler_relativistic_equivalency.convert(f64, v_unit, &v1000, us.MHz, .{f0});
    try testing.expectApproxEqAbs(1415.67566395, v1000_f.value, 1e-8);
    try testing.expectEqual(us.MHz, v1000_f.getUnit());
    const v1000_back = doppler_relativistic_equivalency.convert(f64, us.MHz, &v1000_f, v_unit, .{f0});
    try testing.expectApproxEqRel(1000, v1000_back.value, 1e-8);

    const v_09c: Quantity(f64, v_unit) = .init(270_000);
    const v_09c_f = doppler_relativistic_equivalency.convert(f64, v_unit, &v_09c, us.MHz, .{f0});
    try testing.expectApproxEqAbs(324.79343469, v_09c_f.value, 1e-8);
    const v_09c_back = doppler_relativistic_equivalency.convert(f64, us.MHz, &v_09c_f, v_unit, .{f0});
    try testing.expectApproxEqRel(270_000, v_09c_back.value, 1e-15);

    const wl_21: Quantity(f64, si.cm) = .init(21.106);
    const wl_21f_v = doppler_relativistic_equivalency.convert(f64, si.cm, &wl_21, v_unit, .{f0});
    try testing.expectApproxEqAbs(-1.62003622, wl_21f_v.value, 1e-8);
}

test "doppler optical equivalency" {
    const v_unit: Unit = comptime us.km.div(si.s);
    const f0: Quantity(f64, us.MHz) = .init(1420.405751768);
    const v_1000: Quantity(f64, v_unit) = .init(1000);
    const v_1000_f = doppler_optical_equivalency.convert(f64, v_unit, &v_1000, us.MHz, .{f0});
    try testing.expectApproxEqAbs(1415.6835397776715, v_1000_f.value, 1e-8);
    try testing.expectEqual(us.MHz, v_1000_f.getUnit());
    const v_1000_back = doppler_optical_equivalency.convert(f64, us.MHz, &v_1000_f, v_unit, .{f0});
    try testing.expectApproxEqRel(1000, v_1000_back.value, 1e-8);
}

test "doppler radio equivalency" {
    const v_unit: Unit = comptime us.km.div(si.s);
    const f0: Quantity(f64, us.MHz) = .init(1420.405751768);
    const v_1000: Quantity(f64, v_unit) = .init(1000);
    const v_1000_f = doppler_radio_equivalency.convert(f64, v_unit, &v_1000, us.MHz, .{f0});
    try testing.expectApproxEqAbs(1415.66778817, v_1000_f.value, 1e-8);
    try testing.expectEqual(us.MHz, v_1000_f.getUnit());
    const v_1000_back = doppler_radio_equivalency.convert(f64, us.MHz, &v_1000_f, v_unit, .{f0});
    try testing.expectApproxEqRel(1000, v_1000_back.value, 1e-8);
}

test "magnetic flux field equivalency" {
    const mu_r: Quantity(f64, UNITLESS) = .init(1);
    const H: Quantity(f64, us.Oe) = .init(1);
    const B_G = magnetic_flux_field_equivalency.convert(f64, us.Oe, &H, us.G, .{mu_r});
    try testing.expectApproxEqAbs(1.0, B_G.value, 1e-8);
    const H_from_B_G = magnetic_flux_field_equivalency.convert(f64, us.G, &B_G, us.Oe, .{mu_r});
    try testing.expectApproxEqRel(H.value, H_from_B_G.value, 1e-15);

    const B_T = magnetic_flux_field_equivalency.convert(f64, us.Oe, &H, us.T, .{mu_r});
    try testing.expectApproxEqAbs(1e-4, B_T.value, 1e-8);
    const H_from_B_T = magnetic_flux_field_equivalency.convert(f64, us.T, &B_T, us.Oe, .{mu_r});
    try testing.expectApproxEqRel(H.value, H_from_B_T.value, 1e-15);
}

test "brightness temperature equivalency" {
    // TODO: Check properly the reason why increasing the branch quota is needed.
    // This could be improve or solved, maybe.
    @setEvalBranchQuota(2000);
    const wb: Quantity(f64, si.arcsec.pow(2)) = .init(std.math.pi * 2 * 2500);
    const jy_q: Quantity(f64, us.Jy) = .init(1);
    const jy_sr_q = jy_q.div(wb).to(us.Jy.div(si.sr));
    const nu: Quantity(f64, us.GHz) = .init(5);
    const as_K = brightness_temperature_equivalency.convert(f64, us.Jy.div(si.sr), &jy_sr_q, si.K, .{nu});
    try testing.expectApproxEqAbs(3.52629392, as_K.value, 1e-8);
    const jy_sr_back = brightness_temperature_equivalency.convert(f64, si.K, &as_K, us.Jy.div(si.sr), .{nu});
    try testing.expectApproxEqRel(jy_sr_q.value, jy_sr_back.value, 1e-15);

    // VLA
    const bmin: Quantity(f64, si.arcsec) = .init(15);
    const bmaj = bmin;
    const fwhm_to_sig: Quantity(f64, UNITLESS) = .init(1.0 / @sqrt(8.0 * @log(2.0)));
    const wb_2: Quantity(f64, si.sr) = fwhm_to_sig.pow(2).mul(bmin).mul(bmaj).mulValue(2 * std.math.pi).to(si.sr);
    const jans: Quantity(f64, us.Jy) = .init(1);
    const as_K_2 = brightness_temperature_equivalency.convert(f64, us.Jy, &jans, si.K, .{ nu, wb_2 });
    try testing.expectApproxEqAbs(217.26583888, as_K_2.value, 1e-8);
    const jans_back = brightness_temperature_equivalency.convert(f64, si.K, &as_K_2, us.Jy, .{ nu, wb_2 });
    try testing.expectApproxEqRel(jans.value, jans_back.value, 1e-15);
}

test "plate scale equivalency" {
    const angle: Quantity(f64, si.arcsec) = .init(1);
    const plate_scale: Quantity(f64, si.m.div(si.rad)) = .init(10);
    const as_length = plate_scale_equivalency.convert(f64, si.arcsec, &angle, si.m, .{plate_scale});
    try testing.expectApproxEqAbs(4.84813681e-05, as_length.value, 1e-8);
    const angle_back = plate_scale_equivalency.convert(f64, si.m, &as_length, si.arcsec, .{plate_scale});
    try testing.expectApproxEqRel(angle.value, angle_back.value, 1e-15);
}

test "pixel scale equivalency" {
    {
        const pixscale: Quantity(f64, si.arcsec.div(misc.pix)) = .init(0.4);
        const pix: Quantity(f64, misc.pix) = .init(240);
        const as_angle = pixel_scale_equivalency.convert(f64, misc.pix, &pix, si.arcmin, .{pixscale});
        try testing.expectApproxEqAbs(1.6, as_angle.value, 1e-8);
        const pix_back = pixel_scale_equivalency.convert(f64, si.arcmin, &as_angle, misc.pix, .{pixscale});
        try testing.expectApproxEqRel(240, pix_back.value, 1e-15);
    }
    {
        const pixscale: Quantity(f64, misc.pix.div(us.cm)) = .init(100);
        const pix: Quantity(f64, misc.pix) = .init(1024);
        const as_cm = pixel_scale_equivalency.convert(f64, misc.pix, &pix, si.cm, .{pixscale});
        try testing.expectApproxEqAbs(10.24, as_cm.value, 1e-8);
        const pix_back = pixel_scale_equivalency.convert(f64, si.cm, &as_cm, misc.pix, .{pixscale});
        try testing.expectApproxEqRel(pix.value, pix_back.value, 1e-15);
    }
}

test "spectral density equivalency" {
    const nu_w: Quantity(f64, si.AA) = .init(3500);
    const spe = spectral_density_equivalency;
    // Flux
    {
        const f: Quantity(f64, us.Jy) = .init(1.5);
        const as_nuFnu = spe.convert(f64, us.Jy, &f, si.W.div(si.m.pow(2)), .{nu_w});
        try testing.expectApproxEqRel(1.28482482e-11, as_nuFnu.value, 1e-8);
        const f_back = spe.convert(f64, si.W.div(si.m.pow(2)), &as_nuFnu, us.Jy, .{nu_w});
        try testing.expectApproxEqRel(f.value, f_back.value, 1e-15);
    }
    // Luminosity density
    {
        const L: Quantity(f64, si.W.div(si.Hz)) = .init(1.5);
        const as_pow = spe.convert(f64, si.W.div(si.Hz), &L, si.W, .{nu_w});
        try testing.expectApproxEqRel(1.28482482e+15, as_pow.value, 1e-8);
        const L_back = spe.convert(f64, si.W, &as_pow, si.W.div(si.Hz), .{nu_w});
        try testing.expectApproxEqRel(L.value, L_back.value, 1e-15);
    }
    // Surface brightness
    {
        const sb: Quantity(f64, spe.Snu) = .init(1.5);
        const as_nuSnu = spe.convert(f64, spe.Snu, &sb, spe.nuSnu, .{nu_w});
        try testing.expectApproxEqRel(1.28482482e+15, as_nuSnu.value, 1e-8);
        const sb_back = spe.convert(f64, spe.nuSnu, &as_nuSnu, spe.Snu, .{nu_w});
        try testing.expectApproxEqRel(sb.value, sb_back.value, 1e-15);
    }
    // Luminosity surface brightness
    {
        const lsb: Quantity(f64, spe.SLnu) = .init(1.5);
        const as_SLlamb = spe.convert(f64, spe.SLnu, &lsb, spe.SLlamb, .{nu_w});
        try testing.expectApproxEqRel(3.67092806e+21, as_SLlamb.value, 1e-8);
        const lsb_back = spe.convert(f64, spe.SLlamb, &as_SLlamb, spe.SLnu, .{nu_w});
        try testing.expectApproxEqRel(lsb.value, lsb_back.value, 1e-15);
    }
}
