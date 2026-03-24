const std = @import("std");
const zali = @import("zali");
const unitMod = zali.units.unit;
const Unit = unitMod.Unit;
const si = zali.units.si;
const cgs = zali.units.cgs;
const ap = zali.units.astrophys;
const mc = zali.units.misc;
const pm = zali.units.photometric;

pub const ap_ptr = ALL_PREFIX;

pub const UPP = [_]UnitPrefixPair{
    // SI
    .init(si.m, .initAllExclude(@constCast(&[_]SiPrefix{ .c, .n, .u, .m }))),
    .init(si.AA, .init(@constCast(&[_]SiPrefix{.m}))),
    .init(si.l, ap_ptr),
    .init(si.rad, ap_ptr),
    .init(si.deg, ap_ptr),
    .init(si.arcmin, ap_ptr),
    .init(si.arcsec, ap_ptr),
    .init(si.sr, ap_ptr),
    .init(si.s, ap_ptr),
    .init(si.min, ap_ptr),
    .init(si.h, .initAllExclude(@constCast(&[_]SiPrefix{.p}))),
    .init(si.d, .initAllExclude(@constCast(&[_]SiPrefix{ .c, .y }))),
    .init(si.a, .initAllExclude(@constCast(&[_]SiPrefix{ .P, .h }))),
    .init(si.yr, ap_ptr),
    .init(si.Hz, ap_ptr),
    .init(si.g, .initAllExclude(@constCast(&[_]SiPrefix{.k}))),
    .init(si.mol, ap_ptr),
    .init(si.kat, ap_ptr),
    .init(si.K, ap_ptr),
    .init(si.N, ap_ptr),
    .init(si.J, ap_ptr),
    .init(si.Pa, ap_ptr),
    .init(si.W, ap_ptr),
    .init(si.A, ap_ptr),
    .init(si.C, ap_ptr),
    .init(si.Ohm, ap_ptr),
    .init(si.S, ap_ptr),
    .init(si.F, ap_ptr),
    .init(si.Wb, ap_ptr),
    .init(si.T, ap_ptr),
    .init(si.H, ap_ptr),
    .init(si.S, ap_ptr),
    .init(si.cd, ap_ptr),
    .init(si.lm, ap_ptr),
    .init(si.lx, ap_ptr),
    .init(si.Bq, ap_ptr),
    .init(si.Ci, ap_ptr),
    .init(si.Gy, ap_ptr),
    .init(si.Sv, ap_ptr),

    // CGS
    .init(cgs.Gal, ap_ptr),
    .init(cgs.erg, ap_ptr),
    .init(cgs.dyn, ap_ptr),
    .init(cgs.Ba, ap_ptr),
    .init(cgs.P, ap_ptr),
    .init(cgs.St, ap_ptr),
    .init(cgs.k, ap_ptr),
    .init(cgs.D, ap_ptr),
    .init(cgs.G, ap_ptr),
    .init(cgs.Oe, ap_ptr),

    // Astrophys
    .init(ap.au, ap_ptr),
    .init(ap.pc, .initAllExclude(@constCast(&[_]SiPrefix{.k}))),
    .init(ap.lyr, ap_ptr),
    .init(ap.ph, ap_ptr),
    .init(ap.Jy, ap_ptr),
    .init(ap.R, ap_ptr),
    .init(ap.ct, .initAllExclude(@constCast(&[_]SiPrefix{.p}))),

    // misc
    .init(mc.barn, ap_ptr),
    .init(mc.bar, .init(@constCast(&[_]SiPrefix{.m}))),
    .init(mc.Torr, .init(@constCast(&[_]SiPrefix{.m}))),
    .init(mc.u, .initAllExclude(@constCast(&[_]SiPrefix{ .a, .da }))),
    .init(mc.eV, ap_ptr),
    .init(mc.Ry, ap_ptr),
    // TODO Binary prefix for computer units

    // Photometric
    .init(pm.mgy, ap_ptr),

    // Imperial
};

pub const UnitPrefixPair = struct {
    const Self = @This();

    unit: Unit,
    prefs: PrefixList,

    pub fn init(unit: Unit, prefs: PrefixList) Self {
        return .{ .unit = unit, .prefs = prefs };
    }
};

pub const ALL_PREFIX: PrefixList = .init(@constCast(&all_prefix_array));

pub const all_prefix_array: [24]SiPrefix = .{
    .Q,
    .R,
    .Y,
    .Z,
    .E,
    .P,
    .T,
    .G,
    .M,
    .k,
    .h,
    .da,
    .d,
    .c,
    .m,
    .u,
    .n,
    .p,
    .f,
    .a,
    .z,
    .y,
    .r,
    .q,
};

pub const PrefixList = struct {
    const Self = @This();

    list: [24]SiPrefix = undefined,
    len: usize = 0,

    pub fn init(list: []SiPrefix) Self {
        var result = Self{};
        for (0..list.len) |i| {
            result.list[i] = list[i];
        }
        result.len = list.len;
        return result;
    }

    pub fn initAllExclude(exclude_list: []SiPrefix) Self {
        var result = ALL_PREFIX;
        for (exclude_list) |pref| {
            if (result.getIdx(pref)) |idx| {
                result.pop(idx);
            } else @panic("Unknow prefix");
        }
        return result;
    }

    pub fn pop(self: *Self, idx: usize) void {
        if (idx < self.len - 1) {
            for (idx..self.len - 1) |i| {
                self.list[i] = self.list[i + 1];
            }
            self.len -= 1;
        }
    }

    pub fn getIdx(self: Self, pref: SiPrefix) ?usize {
        if (self.len == 0) return null;
        for (0..self.len) |i| {
            if (self.list[i] == pref) return i;
        }
        return null;
    }
};

pub const SiPrefix = enum {
    const Self = @This();

    Q,
    R,
    Y,
    Z,
    E,
    P,
    T,
    G,
    M,
    k,
    h,
    da,
    d,
    c,
    m,
    u,
    n,
    p,
    f,
    a,
    z,
    y,
    r,
    q,

    pub fn value(self: Self) f64 {
        switch (self) {
            .Q => return 1e30,
            .R => return 1e27,
            .Y => return 1e24,
            .Z => return 1e21,
            .E => return 1e18,
            .P => return 1e15,
            .T => return 1e12,
            .G => return 1e9,
            .M => return 1e6,
            .k => return 1e3,
            .h => return 1e2,
            .da => return 10,
            .d => return 1e-1,
            .c => return 1e-2,
            .m => return 1e-3,
            .u => return 1e-6,
            .n => return 1e-9,
            .p => return 1e-12,
            .f => return 1e-15,
            .a => return 1e-18,
            .z => return 1e-21,
            .y => return 1e-24,
            .r => return 1e-27,
            .q => return 1e-30,
        }
    }
};
