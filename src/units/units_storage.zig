//! This module file is being generated automatically by
//! dev-tools (see dev/tools/prefix_builder).

const std = @import("std");
const Unit = @import("unit.zig").Unit;
const utils = @import("utils.zig");
const defUnitFromUnit = utils.defUnitFromUnit;
const si = @import("si.zig");
const cgs = @import("cgs.zig");
const astrophys = @import("astrophys.zig");
const misc = @import("misc.zig");
const imperial = @import("imperial.zig");
const photometric = @import("photometric.zig");


//////////////////////////////////////////////////////
// SI
//////////////////////////////////////////////////////

// m
pub const m = si.m;
pub const Qm: Unit = defUnitFromUnit(si.m, 1e30, .initUniqueSymbol("Qm"));
pub const Rm: Unit = defUnitFromUnit(si.m, 1e27, .initUniqueSymbol("Rm"));
pub const Ym: Unit = defUnitFromUnit(si.m, 1e24, .initUniqueSymbol("Ym"));
pub const Zm: Unit = defUnitFromUnit(si.m, 1e21, .initUniqueSymbol("Zm"));
pub const Em: Unit = defUnitFromUnit(si.m, 1e18, .initUniqueSymbol("Em"));
pub const Pm: Unit = defUnitFromUnit(si.m, 1e15, .initUniqueSymbol("Pm"));
pub const Tm: Unit = defUnitFromUnit(si.m, 1e12, .initUniqueSymbol("Tm"));
pub const Gm: Unit = defUnitFromUnit(si.m, 1e9, .initUniqueSymbol("Gm"));
pub const Mm: Unit = defUnitFromUnit(si.m, 1e6, .initUniqueSymbol("Mm"));
pub const km: Unit = defUnitFromUnit(si.m, 1e3, .initUniqueSymbol("km"));
pub const hm: Unit = defUnitFromUnit(si.m, 1e2, .initUniqueSymbol("hm"));
pub const dam: Unit = defUnitFromUnit(si.m, 1e1, .initUniqueSymbol("dam"));
pub const dm: Unit = defUnitFromUnit(si.m, 1e-1, .initUniqueSymbol("dm"));
pub const pm: Unit = defUnitFromUnit(si.m, 1e-12, .initUniqueSymbol("pm"));
pub const fm: Unit = defUnitFromUnit(si.m, 1e-15, .initUniqueSymbol("fm"));
pub const am: Unit = defUnitFromUnit(si.m, 1e-18, .initUniqueSymbol("am"));
pub const zm: Unit = defUnitFromUnit(si.m, 1e-21, .initUniqueSymbol("zm"));
pub const ym: Unit = defUnitFromUnit(si.m, 1e-24, .initUniqueSymbol("ym"));
pub const rm: Unit = defUnitFromUnit(si.m, 1e-27, .initUniqueSymbol("rm"));
pub const qm: Unit = defUnitFromUnit(si.m, 1e-30, .initUniqueSymbol("qm"));

// cm
pub const cm = si.cm;

// mm
pub const mm = si.mm;

// um
pub const um = si.um;

// nm
pub const nm = si.nm;

// AA
pub const AA = si.AA;
pub const mAA: Unit = defUnitFromUnit(si.AA, 1e-3, .initUniqueSymbol("mAA"));

// ha
pub const ha = si.ha;

// l
pub const l = si.l;
pub const Ql: Unit = defUnitFromUnit(si.l, 1e30, .initUniqueSymbol("Ql"));
pub const Rl: Unit = defUnitFromUnit(si.l, 1e27, .initUniqueSymbol("Rl"));
pub const Yl: Unit = defUnitFromUnit(si.l, 1e24, .initUniqueSymbol("Yl"));
pub const Zl: Unit = defUnitFromUnit(si.l, 1e21, .initUniqueSymbol("Zl"));
pub const El: Unit = defUnitFromUnit(si.l, 1e18, .initUniqueSymbol("El"));
pub const Pl: Unit = defUnitFromUnit(si.l, 1e15, .initUniqueSymbol("Pl"));
pub const Tl: Unit = defUnitFromUnit(si.l, 1e12, .initUniqueSymbol("Tl"));
pub const Gl: Unit = defUnitFromUnit(si.l, 1e9, .initUniqueSymbol("Gl"));
pub const Ml: Unit = defUnitFromUnit(si.l, 1e6, .initUniqueSymbol("Ml"));
pub const kl: Unit = defUnitFromUnit(si.l, 1e3, .initUniqueSymbol("kl"));
pub const hl: Unit = defUnitFromUnit(si.l, 1e2, .initUniqueSymbol("hl"));
pub const dal: Unit = defUnitFromUnit(si.l, 1e1, .initUniqueSymbol("dal"));
pub const dl: Unit = defUnitFromUnit(si.l, 1e-1, .initUniqueSymbol("dl"));
pub const cl: Unit = defUnitFromUnit(si.l, 1e-2, .initUniqueSymbol("cl"));
pub const ml: Unit = defUnitFromUnit(si.l, 1e-3, .initUniqueSymbol("ml"));
pub const ul: Unit = defUnitFromUnit(si.l, 1e-6, .initUniqueSymbol("ul"));
pub const nl: Unit = defUnitFromUnit(si.l, 1e-9, .initUniqueSymbol("nl"));
pub const pl: Unit = defUnitFromUnit(si.l, 1e-12, .initUniqueSymbol("pl"));
pub const fl: Unit = defUnitFromUnit(si.l, 1e-15, .initUniqueSymbol("fl"));
pub const al: Unit = defUnitFromUnit(si.l, 1e-18, .initUniqueSymbol("al"));
pub const zl: Unit = defUnitFromUnit(si.l, 1e-21, .initUniqueSymbol("zl"));
pub const yl: Unit = defUnitFromUnit(si.l, 1e-24, .initUniqueSymbol("yl"));
pub const rl: Unit = defUnitFromUnit(si.l, 1e-27, .initUniqueSymbol("rl"));
pub const ql: Unit = defUnitFromUnit(si.l, 1e-30, .initUniqueSymbol("ql"));

// rad
pub const rad = si.rad;
pub const Qrad: Unit = defUnitFromUnit(si.rad, 1e30, .initUniqueSymbol("Qrad"));
pub const Rrad: Unit = defUnitFromUnit(si.rad, 1e27, .initUniqueSymbol("Rrad"));
pub const Yrad: Unit = defUnitFromUnit(si.rad, 1e24, .initUniqueSymbol("Yrad"));
pub const Zrad: Unit = defUnitFromUnit(si.rad, 1e21, .initUniqueSymbol("Zrad"));
pub const Erad: Unit = defUnitFromUnit(si.rad, 1e18, .initUniqueSymbol("Erad"));
pub const Prad: Unit = defUnitFromUnit(si.rad, 1e15, .initUniqueSymbol("Prad"));
pub const Trad: Unit = defUnitFromUnit(si.rad, 1e12, .initUniqueSymbol("Trad"));
pub const Grad: Unit = defUnitFromUnit(si.rad, 1e9, .initUniqueSymbol("Grad"));
pub const Mrad: Unit = defUnitFromUnit(si.rad, 1e6, .initUniqueSymbol("Mrad"));
pub const krad: Unit = defUnitFromUnit(si.rad, 1e3, .initUniqueSymbol("krad"));
pub const hrad: Unit = defUnitFromUnit(si.rad, 1e2, .initUniqueSymbol("hrad"));
pub const darad: Unit = defUnitFromUnit(si.rad, 1e1, .initUniqueSymbol("darad"));
pub const drad: Unit = defUnitFromUnit(si.rad, 1e-1, .initUniqueSymbol("drad"));
pub const crad: Unit = defUnitFromUnit(si.rad, 1e-2, .initUniqueSymbol("crad"));
pub const mrad: Unit = defUnitFromUnit(si.rad, 1e-3, .initUniqueSymbol("mrad"));
pub const urad: Unit = defUnitFromUnit(si.rad, 1e-6, .initUniqueSymbol("urad"));
pub const nrad: Unit = defUnitFromUnit(si.rad, 1e-9, .initUniqueSymbol("nrad"));
pub const prad: Unit = defUnitFromUnit(si.rad, 1e-12, .initUniqueSymbol("prad"));
pub const frad: Unit = defUnitFromUnit(si.rad, 1e-15, .initUniqueSymbol("frad"));
pub const arad: Unit = defUnitFromUnit(si.rad, 1e-18, .initUniqueSymbol("arad"));
pub const zrad: Unit = defUnitFromUnit(si.rad, 1e-21, .initUniqueSymbol("zrad"));
pub const yrad: Unit = defUnitFromUnit(si.rad, 1e-24, .initUniqueSymbol("yrad"));
pub const rrad: Unit = defUnitFromUnit(si.rad, 1e-27, .initUniqueSymbol("rrad"));
pub const qrad: Unit = defUnitFromUnit(si.rad, 1e-30, .initUniqueSymbol("qrad"));

// deg
pub const deg = si.deg;
pub const Qdeg: Unit = defUnitFromUnit(si.deg, 1e30, .initUniqueSymbol("Qdeg"));
pub const Rdeg: Unit = defUnitFromUnit(si.deg, 1e27, .initUniqueSymbol("Rdeg"));
pub const Ydeg: Unit = defUnitFromUnit(si.deg, 1e24, .initUniqueSymbol("Ydeg"));
pub const Zdeg: Unit = defUnitFromUnit(si.deg, 1e21, .initUniqueSymbol("Zdeg"));
pub const Edeg: Unit = defUnitFromUnit(si.deg, 1e18, .initUniqueSymbol("Edeg"));
pub const Pdeg: Unit = defUnitFromUnit(si.deg, 1e15, .initUniqueSymbol("Pdeg"));
pub const Tdeg: Unit = defUnitFromUnit(si.deg, 1e12, .initUniqueSymbol("Tdeg"));
pub const Gdeg: Unit = defUnitFromUnit(si.deg, 1e9, .initUniqueSymbol("Gdeg"));
pub const Mdeg: Unit = defUnitFromUnit(si.deg, 1e6, .initUniqueSymbol("Mdeg"));
pub const kdeg: Unit = defUnitFromUnit(si.deg, 1e3, .initUniqueSymbol("kdeg"));
pub const hdeg: Unit = defUnitFromUnit(si.deg, 1e2, .initUniqueSymbol("hdeg"));
pub const dadeg: Unit = defUnitFromUnit(si.deg, 1e1, .initUniqueSymbol("dadeg"));
pub const ddeg: Unit = defUnitFromUnit(si.deg, 1e-1, .initUniqueSymbol("ddeg"));
pub const cdeg: Unit = defUnitFromUnit(si.deg, 1e-2, .initUniqueSymbol("cdeg"));
pub const mdeg: Unit = defUnitFromUnit(si.deg, 1e-3, .initUniqueSymbol("mdeg"));
pub const udeg: Unit = defUnitFromUnit(si.deg, 1e-6, .initUniqueSymbol("udeg"));
pub const ndeg: Unit = defUnitFromUnit(si.deg, 1e-9, .initUniqueSymbol("ndeg"));
pub const pdeg: Unit = defUnitFromUnit(si.deg, 1e-12, .initUniqueSymbol("pdeg"));
pub const fdeg: Unit = defUnitFromUnit(si.deg, 1e-15, .initUniqueSymbol("fdeg"));
pub const adeg: Unit = defUnitFromUnit(si.deg, 1e-18, .initUniqueSymbol("adeg"));
pub const zdeg: Unit = defUnitFromUnit(si.deg, 1e-21, .initUniqueSymbol("zdeg"));
pub const ydeg: Unit = defUnitFromUnit(si.deg, 1e-24, .initUniqueSymbol("ydeg"));
pub const rdeg: Unit = defUnitFromUnit(si.deg, 1e-27, .initUniqueSymbol("rdeg"));
pub const qdeg: Unit = defUnitFromUnit(si.deg, 1e-30, .initUniqueSymbol("qdeg"));

// hourangle
pub const hourangle = si.hourangle;

// arcmin
pub const arcmin = si.arcmin;
pub const Qarcmin: Unit = defUnitFromUnit(si.arcmin, 1e30, .initUniqueSymbol("Qarcmin"));
pub const Rarcmin: Unit = defUnitFromUnit(si.arcmin, 1e27, .initUniqueSymbol("Rarcmin"));
pub const Yarcmin: Unit = defUnitFromUnit(si.arcmin, 1e24, .initUniqueSymbol("Yarcmin"));
pub const Zarcmin: Unit = defUnitFromUnit(si.arcmin, 1e21, .initUniqueSymbol("Zarcmin"));
pub const Earcmin: Unit = defUnitFromUnit(si.arcmin, 1e18, .initUniqueSymbol("Earcmin"));
pub const Parcmin: Unit = defUnitFromUnit(si.arcmin, 1e15, .initUniqueSymbol("Parcmin"));
pub const Tarcmin: Unit = defUnitFromUnit(si.arcmin, 1e12, .initUniqueSymbol("Tarcmin"));
pub const Garcmin: Unit = defUnitFromUnit(si.arcmin, 1e9, .initUniqueSymbol("Garcmin"));
pub const Marcmin: Unit = defUnitFromUnit(si.arcmin, 1e6, .initUniqueSymbol("Marcmin"));
pub const karcmin: Unit = defUnitFromUnit(si.arcmin, 1e3, .initUniqueSymbol("karcmin"));
pub const harcmin: Unit = defUnitFromUnit(si.arcmin, 1e2, .initUniqueSymbol("harcmin"));
pub const daarcmin: Unit = defUnitFromUnit(si.arcmin, 1e1, .initUniqueSymbol("daarcmin"));
pub const darcmin: Unit = defUnitFromUnit(si.arcmin, 1e-1, .initUniqueSymbol("darcmin"));
pub const carcmin: Unit = defUnitFromUnit(si.arcmin, 1e-2, .initUniqueSymbol("carcmin"));
pub const marcmin: Unit = defUnitFromUnit(si.arcmin, 1e-3, .initUniqueSymbol("marcmin"));
pub const uarcmin: Unit = defUnitFromUnit(si.arcmin, 1e-6, .initUniqueSymbol("uarcmin"));
pub const narcmin: Unit = defUnitFromUnit(si.arcmin, 1e-9, .initUniqueSymbol("narcmin"));
pub const parcmin: Unit = defUnitFromUnit(si.arcmin, 1e-12, .initUniqueSymbol("parcmin"));
pub const farcmin: Unit = defUnitFromUnit(si.arcmin, 1e-15, .initUniqueSymbol("farcmin"));
pub const aarcmin: Unit = defUnitFromUnit(si.arcmin, 1e-18, .initUniqueSymbol("aarcmin"));
pub const zarcmin: Unit = defUnitFromUnit(si.arcmin, 1e-21, .initUniqueSymbol("zarcmin"));
pub const yarcmin: Unit = defUnitFromUnit(si.arcmin, 1e-24, .initUniqueSymbol("yarcmin"));
pub const rarcmin: Unit = defUnitFromUnit(si.arcmin, 1e-27, .initUniqueSymbol("rarcmin"));
pub const qarcmin: Unit = defUnitFromUnit(si.arcmin, 1e-30, .initUniqueSymbol("qarcmin"));

// arcsec
pub const arcsec = si.arcsec;
pub const Qarcsec: Unit = defUnitFromUnit(si.arcsec, 1e30, .initUniqueSymbol("Qarcsec"));
pub const Rarcsec: Unit = defUnitFromUnit(si.arcsec, 1e27, .initUniqueSymbol("Rarcsec"));
pub const Yarcsec: Unit = defUnitFromUnit(si.arcsec, 1e24, .initUniqueSymbol("Yarcsec"));
pub const Zarcsec: Unit = defUnitFromUnit(si.arcsec, 1e21, .initUniqueSymbol("Zarcsec"));
pub const Earcsec: Unit = defUnitFromUnit(si.arcsec, 1e18, .initUniqueSymbol("Earcsec"));
pub const Parcsec: Unit = defUnitFromUnit(si.arcsec, 1e15, .initUniqueSymbol("Parcsec"));
pub const Tarcsec: Unit = defUnitFromUnit(si.arcsec, 1e12, .initUniqueSymbol("Tarcsec"));
pub const Garcsec: Unit = defUnitFromUnit(si.arcsec, 1e9, .initUniqueSymbol("Garcsec"));
pub const Marcsec: Unit = defUnitFromUnit(si.arcsec, 1e6, .initUniqueSymbol("Marcsec"));
pub const karcsec: Unit = defUnitFromUnit(si.arcsec, 1e3, .initUniqueSymbol("karcsec"));
pub const harcsec: Unit = defUnitFromUnit(si.arcsec, 1e2, .initUniqueSymbol("harcsec"));
pub const daarcsec: Unit = defUnitFromUnit(si.arcsec, 1e1, .initUniqueSymbol("daarcsec"));
pub const darcsec: Unit = defUnitFromUnit(si.arcsec, 1e-1, .initUniqueSymbol("darcsec"));
pub const carcsec: Unit = defUnitFromUnit(si.arcsec, 1e-2, .initUniqueSymbol("carcsec"));
pub const marcsec: Unit = defUnitFromUnit(si.arcsec, 1e-3, .initUniqueSymbol("marcsec"));
pub const uarcsec: Unit = defUnitFromUnit(si.arcsec, 1e-6, .initUniqueSymbol("uarcsec"));
pub const narcsec: Unit = defUnitFromUnit(si.arcsec, 1e-9, .initUniqueSymbol("narcsec"));
pub const parcsec: Unit = defUnitFromUnit(si.arcsec, 1e-12, .initUniqueSymbol("parcsec"));
pub const farcsec: Unit = defUnitFromUnit(si.arcsec, 1e-15, .initUniqueSymbol("farcsec"));
pub const aarcsec: Unit = defUnitFromUnit(si.arcsec, 1e-18, .initUniqueSymbol("aarcsec"));
pub const zarcsec: Unit = defUnitFromUnit(si.arcsec, 1e-21, .initUniqueSymbol("zarcsec"));
pub const yarcsec: Unit = defUnitFromUnit(si.arcsec, 1e-24, .initUniqueSymbol("yarcsec"));
pub const rarcsec: Unit = defUnitFromUnit(si.arcsec, 1e-27, .initUniqueSymbol("rarcsec"));
pub const qarcsec: Unit = defUnitFromUnit(si.arcsec, 1e-30, .initUniqueSymbol("qarcsec"));

// mas
pub const mas = si.mas;

// uas
pub const uas = si.uas;

// sr
pub const sr = si.sr;
pub const Qsr: Unit = defUnitFromUnit(si.sr, 1e30, .initUniqueSymbol("Qsr"));
pub const Rsr: Unit = defUnitFromUnit(si.sr, 1e27, .initUniqueSymbol("Rsr"));
pub const Ysr: Unit = defUnitFromUnit(si.sr, 1e24, .initUniqueSymbol("Ysr"));
pub const Zsr: Unit = defUnitFromUnit(si.sr, 1e21, .initUniqueSymbol("Zsr"));
pub const Esr: Unit = defUnitFromUnit(si.sr, 1e18, .initUniqueSymbol("Esr"));
pub const Psr: Unit = defUnitFromUnit(si.sr, 1e15, .initUniqueSymbol("Psr"));
pub const Tsr: Unit = defUnitFromUnit(si.sr, 1e12, .initUniqueSymbol("Tsr"));
pub const Gsr: Unit = defUnitFromUnit(si.sr, 1e9, .initUniqueSymbol("Gsr"));
pub const Msr: Unit = defUnitFromUnit(si.sr, 1e6, .initUniqueSymbol("Msr"));
pub const ksr: Unit = defUnitFromUnit(si.sr, 1e3, .initUniqueSymbol("ksr"));
pub const hsr: Unit = defUnitFromUnit(si.sr, 1e2, .initUniqueSymbol("hsr"));
pub const dasr: Unit = defUnitFromUnit(si.sr, 1e1, .initUniqueSymbol("dasr"));
pub const dsr: Unit = defUnitFromUnit(si.sr, 1e-1, .initUniqueSymbol("dsr"));
pub const csr: Unit = defUnitFromUnit(si.sr, 1e-2, .initUniqueSymbol("csr"));
pub const msr: Unit = defUnitFromUnit(si.sr, 1e-3, .initUniqueSymbol("msr"));
pub const usr: Unit = defUnitFromUnit(si.sr, 1e-6, .initUniqueSymbol("usr"));
pub const nsr: Unit = defUnitFromUnit(si.sr, 1e-9, .initUniqueSymbol("nsr"));
pub const psr: Unit = defUnitFromUnit(si.sr, 1e-12, .initUniqueSymbol("psr"));
pub const fsr: Unit = defUnitFromUnit(si.sr, 1e-15, .initUniqueSymbol("fsr"));
pub const asr: Unit = defUnitFromUnit(si.sr, 1e-18, .initUniqueSymbol("asr"));
pub const zsr: Unit = defUnitFromUnit(si.sr, 1e-21, .initUniqueSymbol("zsr"));
pub const ysr: Unit = defUnitFromUnit(si.sr, 1e-24, .initUniqueSymbol("ysr"));
pub const rsr: Unit = defUnitFromUnit(si.sr, 1e-27, .initUniqueSymbol("rsr"));
pub const qsr: Unit = defUnitFromUnit(si.sr, 1e-30, .initUniqueSymbol("qsr"));

// s
pub const s = si.s;
pub const Qs: Unit = defUnitFromUnit(si.s, 1e30, .initUniqueSymbol("Qs"));
pub const Rs: Unit = defUnitFromUnit(si.s, 1e27, .initUniqueSymbol("Rs"));
pub const Ys: Unit = defUnitFromUnit(si.s, 1e24, .initUniqueSymbol("Ys"));
pub const Zs: Unit = defUnitFromUnit(si.s, 1e21, .initUniqueSymbol("Zs"));
pub const Es: Unit = defUnitFromUnit(si.s, 1e18, .initUniqueSymbol("Es"));
pub const Ps: Unit = defUnitFromUnit(si.s, 1e15, .initUniqueSymbol("Ps"));
pub const Ts: Unit = defUnitFromUnit(si.s, 1e12, .initUniqueSymbol("Ts"));
pub const Gs: Unit = defUnitFromUnit(si.s, 1e9, .initUniqueSymbol("Gs"));
pub const Ms: Unit = defUnitFromUnit(si.s, 1e6, .initUniqueSymbol("Ms"));
pub const ks: Unit = defUnitFromUnit(si.s, 1e3, .initUniqueSymbol("ks"));
pub const hs: Unit = defUnitFromUnit(si.s, 1e2, .initUniqueSymbol("hs"));
pub const das: Unit = defUnitFromUnit(si.s, 1e1, .initUniqueSymbol("das"));
pub const ds: Unit = defUnitFromUnit(si.s, 1e-1, .initUniqueSymbol("ds"));
pub const cs: Unit = defUnitFromUnit(si.s, 1e-2, .initUniqueSymbol("cs"));
pub const ms: Unit = defUnitFromUnit(si.s, 1e-3, .initUniqueSymbol("ms"));
pub const us: Unit = defUnitFromUnit(si.s, 1e-6, .initUniqueSymbol("us"));
pub const ns: Unit = defUnitFromUnit(si.s, 1e-9, .initUniqueSymbol("ns"));
pub const ps: Unit = defUnitFromUnit(si.s, 1e-12, .initUniqueSymbol("ps"));
pub const fs: Unit = defUnitFromUnit(si.s, 1e-15, .initUniqueSymbol("fs"));
pub const as: Unit = defUnitFromUnit(si.s, 1e-18, .initUniqueSymbol("as"));
pub const zs: Unit = defUnitFromUnit(si.s, 1e-21, .initUniqueSymbol("zs"));
pub const ys: Unit = defUnitFromUnit(si.s, 1e-24, .initUniqueSymbol("ys"));
pub const rs: Unit = defUnitFromUnit(si.s, 1e-27, .initUniqueSymbol("rs"));
pub const qs: Unit = defUnitFromUnit(si.s, 1e-30, .initUniqueSymbol("qs"));

// min
pub const min = si.min;
pub const Qmin: Unit = defUnitFromUnit(si.min, 1e30, .initUniqueSymbol("Qmin"));
pub const Rmin: Unit = defUnitFromUnit(si.min, 1e27, .initUniqueSymbol("Rmin"));
pub const Ymin: Unit = defUnitFromUnit(si.min, 1e24, .initUniqueSymbol("Ymin"));
pub const Zmin: Unit = defUnitFromUnit(si.min, 1e21, .initUniqueSymbol("Zmin"));
pub const Emin: Unit = defUnitFromUnit(si.min, 1e18, .initUniqueSymbol("Emin"));
pub const Pmin: Unit = defUnitFromUnit(si.min, 1e15, .initUniqueSymbol("Pmin"));
pub const Tmin: Unit = defUnitFromUnit(si.min, 1e12, .initUniqueSymbol("Tmin"));
pub const Gmin: Unit = defUnitFromUnit(si.min, 1e9, .initUniqueSymbol("Gmin"));
pub const Mmin: Unit = defUnitFromUnit(si.min, 1e6, .initUniqueSymbol("Mmin"));
pub const kmin: Unit = defUnitFromUnit(si.min, 1e3, .initUniqueSymbol("kmin"));
pub const hmin: Unit = defUnitFromUnit(si.min, 1e2, .initUniqueSymbol("hmin"));
pub const damin: Unit = defUnitFromUnit(si.min, 1e1, .initUniqueSymbol("damin"));
pub const dmin: Unit = defUnitFromUnit(si.min, 1e-1, .initUniqueSymbol("dmin"));
pub const cmin: Unit = defUnitFromUnit(si.min, 1e-2, .initUniqueSymbol("cmin"));
pub const mmin: Unit = defUnitFromUnit(si.min, 1e-3, .initUniqueSymbol("mmin"));
pub const umin: Unit = defUnitFromUnit(si.min, 1e-6, .initUniqueSymbol("umin"));
pub const nmin: Unit = defUnitFromUnit(si.min, 1e-9, .initUniqueSymbol("nmin"));
pub const pmin: Unit = defUnitFromUnit(si.min, 1e-12, .initUniqueSymbol("pmin"));
pub const fmin: Unit = defUnitFromUnit(si.min, 1e-15, .initUniqueSymbol("fmin"));
pub const amin: Unit = defUnitFromUnit(si.min, 1e-18, .initUniqueSymbol("amin"));
pub const zmin: Unit = defUnitFromUnit(si.min, 1e-21, .initUniqueSymbol("zmin"));
pub const ymin: Unit = defUnitFromUnit(si.min, 1e-24, .initUniqueSymbol("ymin"));
pub const rmin: Unit = defUnitFromUnit(si.min, 1e-27, .initUniqueSymbol("rmin"));
pub const qmin: Unit = defUnitFromUnit(si.min, 1e-30, .initUniqueSymbol("qmin"));

// h
pub const h = si.h;
pub const Qh: Unit = defUnitFromUnit(si.h, 1e30, .initUniqueSymbol("Qh"));
pub const Rh: Unit = defUnitFromUnit(si.h, 1e27, .initUniqueSymbol("Rh"));
pub const Yh: Unit = defUnitFromUnit(si.h, 1e24, .initUniqueSymbol("Yh"));
pub const Zh: Unit = defUnitFromUnit(si.h, 1e21, .initUniqueSymbol("Zh"));
pub const Eh: Unit = defUnitFromUnit(si.h, 1e18, .initUniqueSymbol("Eh"));
pub const Ph: Unit = defUnitFromUnit(si.h, 1e15, .initUniqueSymbol("Ph"));
pub const Th: Unit = defUnitFromUnit(si.h, 1e12, .initUniqueSymbol("Th"));
pub const Gh: Unit = defUnitFromUnit(si.h, 1e9, .initUniqueSymbol("Gh"));
pub const Mh: Unit = defUnitFromUnit(si.h, 1e6, .initUniqueSymbol("Mh"));
pub const kh: Unit = defUnitFromUnit(si.h, 1e3, .initUniqueSymbol("kh"));
pub const hh: Unit = defUnitFromUnit(si.h, 1e2, .initUniqueSymbol("hh"));
pub const dah: Unit = defUnitFromUnit(si.h, 1e1, .initUniqueSymbol("dah"));
pub const dh: Unit = defUnitFromUnit(si.h, 1e-1, .initUniqueSymbol("dh"));
pub const ch: Unit = defUnitFromUnit(si.h, 1e-2, .initUniqueSymbol("ch"));
pub const mh: Unit = defUnitFromUnit(si.h, 1e-3, .initUniqueSymbol("mh"));
pub const uh: Unit = defUnitFromUnit(si.h, 1e-6, .initUniqueSymbol("uh"));
pub const nh: Unit = defUnitFromUnit(si.h, 1e-9, .initUniqueSymbol("nh"));
pub const fh: Unit = defUnitFromUnit(si.h, 1e-15, .initUniqueSymbol("fh"));
pub const ah: Unit = defUnitFromUnit(si.h, 1e-18, .initUniqueSymbol("ah"));
pub const zh: Unit = defUnitFromUnit(si.h, 1e-21, .initUniqueSymbol("zh"));
pub const yh: Unit = defUnitFromUnit(si.h, 1e-24, .initUniqueSymbol("yh"));
pub const rh: Unit = defUnitFromUnit(si.h, 1e-27, .initUniqueSymbol("rh"));
pub const qh: Unit = defUnitFromUnit(si.h, 1e-30, .initUniqueSymbol("qh"));

// d
pub const d = si.d;
pub const Qd: Unit = defUnitFromUnit(si.d, 1e30, .initUniqueSymbol("Qd"));
pub const Rd: Unit = defUnitFromUnit(si.d, 1e27, .initUniqueSymbol("Rd"));
pub const Yd: Unit = defUnitFromUnit(si.d, 1e24, .initUniqueSymbol("Yd"));
pub const Zd: Unit = defUnitFromUnit(si.d, 1e21, .initUniqueSymbol("Zd"));
pub const Ed: Unit = defUnitFromUnit(si.d, 1e18, .initUniqueSymbol("Ed"));
pub const Pd: Unit = defUnitFromUnit(si.d, 1e15, .initUniqueSymbol("Pd"));
pub const Td: Unit = defUnitFromUnit(si.d, 1e12, .initUniqueSymbol("Td"));
pub const Gd: Unit = defUnitFromUnit(si.d, 1e9, .initUniqueSymbol("Gd"));
pub const Md: Unit = defUnitFromUnit(si.d, 1e6, .initUniqueSymbol("Md"));
pub const kd: Unit = defUnitFromUnit(si.d, 1e3, .initUniqueSymbol("kd"));
pub const hd: Unit = defUnitFromUnit(si.d, 1e2, .initUniqueSymbol("hd"));
pub const dad: Unit = defUnitFromUnit(si.d, 1e1, .initUniqueSymbol("dad"));
pub const dd: Unit = defUnitFromUnit(si.d, 1e-1, .initUniqueSymbol("dd"));
pub const md: Unit = defUnitFromUnit(si.d, 1e-3, .initUniqueSymbol("md"));
pub const ud: Unit = defUnitFromUnit(si.d, 1e-6, .initUniqueSymbol("ud"));
pub const nd: Unit = defUnitFromUnit(si.d, 1e-9, .initUniqueSymbol("nd"));
pub const pd: Unit = defUnitFromUnit(si.d, 1e-12, .initUniqueSymbol("pd"));
pub const fd: Unit = defUnitFromUnit(si.d, 1e-15, .initUniqueSymbol("fd"));
pub const ad: Unit = defUnitFromUnit(si.d, 1e-18, .initUniqueSymbol("ad"));
pub const zd: Unit = defUnitFromUnit(si.d, 1e-21, .initUniqueSymbol("zd"));
pub const rd: Unit = defUnitFromUnit(si.d, 1e-27, .initUniqueSymbol("rd"));
pub const qd: Unit = defUnitFromUnit(si.d, 1e-30, .initUniqueSymbol("qd"));

// sday
pub const sday = si.sday;

// a
pub const a = si.a;
pub const Qa: Unit = defUnitFromUnit(si.a, 1e30, .initUniqueSymbol("Qa"));
pub const Ra: Unit = defUnitFromUnit(si.a, 1e27, .initUniqueSymbol("Ra"));
pub const Ya: Unit = defUnitFromUnit(si.a, 1e24, .initUniqueSymbol("Ya"));
pub const Za: Unit = defUnitFromUnit(si.a, 1e21, .initUniqueSymbol("Za"));
pub const Ea: Unit = defUnitFromUnit(si.a, 1e18, .initUniqueSymbol("Ea"));
pub const Ta: Unit = defUnitFromUnit(si.a, 1e12, .initUniqueSymbol("Ta"));
pub const Ga: Unit = defUnitFromUnit(si.a, 1e9, .initUniqueSymbol("Ga"));
pub const Ma: Unit = defUnitFromUnit(si.a, 1e6, .initUniqueSymbol("Ma"));
pub const ka: Unit = defUnitFromUnit(si.a, 1e3, .initUniqueSymbol("ka"));
pub const daa: Unit = defUnitFromUnit(si.a, 1e1, .initUniqueSymbol("daa"));
pub const da: Unit = defUnitFromUnit(si.a, 1e-1, .initUniqueSymbol("da"));
pub const ca: Unit = defUnitFromUnit(si.a, 1e-2, .initUniqueSymbol("ca"));
pub const ma: Unit = defUnitFromUnit(si.a, 1e-3, .initUniqueSymbol("ma"));
pub const ua: Unit = defUnitFromUnit(si.a, 1e-6, .initUniqueSymbol("ua"));
pub const na: Unit = defUnitFromUnit(si.a, 1e-9, .initUniqueSymbol("na"));
pub const pa: Unit = defUnitFromUnit(si.a, 1e-12, .initUniqueSymbol("pa"));
pub const fa: Unit = defUnitFromUnit(si.a, 1e-15, .initUniqueSymbol("fa"));
pub const aa: Unit = defUnitFromUnit(si.a, 1e-18, .initUniqueSymbol("aa"));
pub const za: Unit = defUnitFromUnit(si.a, 1e-21, .initUniqueSymbol("za"));
pub const ya: Unit = defUnitFromUnit(si.a, 1e-24, .initUniqueSymbol("ya"));
pub const ra: Unit = defUnitFromUnit(si.a, 1e-27, .initUniqueSymbol("ra"));
pub const qa: Unit = defUnitFromUnit(si.a, 1e-30, .initUniqueSymbol("qa"));

// yr
pub const yr = si.yr;
pub const Qyr: Unit = defUnitFromUnit(si.yr, 1e30, .initUniqueSymbol("Qyr"));
pub const Ryr: Unit = defUnitFromUnit(si.yr, 1e27, .initUniqueSymbol("Ryr"));
pub const Yyr: Unit = defUnitFromUnit(si.yr, 1e24, .initUniqueSymbol("Yyr"));
pub const Zyr: Unit = defUnitFromUnit(si.yr, 1e21, .initUniqueSymbol("Zyr"));
pub const Eyr: Unit = defUnitFromUnit(si.yr, 1e18, .initUniqueSymbol("Eyr"));
pub const Pyr: Unit = defUnitFromUnit(si.yr, 1e15, .initUniqueSymbol("Pyr"));
pub const Tyr: Unit = defUnitFromUnit(si.yr, 1e12, .initUniqueSymbol("Tyr"));
pub const Gyr: Unit = defUnitFromUnit(si.yr, 1e9, .initUniqueSymbol("Gyr"));
pub const Myr: Unit = defUnitFromUnit(si.yr, 1e6, .initUniqueSymbol("Myr"));
pub const kyr: Unit = defUnitFromUnit(si.yr, 1e3, .initUniqueSymbol("kyr"));
pub const hyr: Unit = defUnitFromUnit(si.yr, 1e2, .initUniqueSymbol("hyr"));
pub const dayr: Unit = defUnitFromUnit(si.yr, 1e1, .initUniqueSymbol("dayr"));
pub const dyr: Unit = defUnitFromUnit(si.yr, 1e-1, .initUniqueSymbol("dyr"));
pub const cyr: Unit = defUnitFromUnit(si.yr, 1e-2, .initUniqueSymbol("cyr"));
pub const myr: Unit = defUnitFromUnit(si.yr, 1e-3, .initUniqueSymbol("myr"));
pub const uyr: Unit = defUnitFromUnit(si.yr, 1e-6, .initUniqueSymbol("uyr"));
pub const nyr: Unit = defUnitFromUnit(si.yr, 1e-9, .initUniqueSymbol("nyr"));
pub const pyr: Unit = defUnitFromUnit(si.yr, 1e-12, .initUniqueSymbol("pyr"));
pub const fyr: Unit = defUnitFromUnit(si.yr, 1e-15, .initUniqueSymbol("fyr"));
pub const ayr: Unit = defUnitFromUnit(si.yr, 1e-18, .initUniqueSymbol("ayr"));
pub const zyr: Unit = defUnitFromUnit(si.yr, 1e-21, .initUniqueSymbol("zyr"));
pub const yyr: Unit = defUnitFromUnit(si.yr, 1e-24, .initUniqueSymbol("yyr"));
pub const ryr: Unit = defUnitFromUnit(si.yr, 1e-27, .initUniqueSymbol("ryr"));
pub const qyr: Unit = defUnitFromUnit(si.yr, 1e-30, .initUniqueSymbol("qyr"));

// Hz
pub const Hz = si.Hz;
pub const QHz: Unit = defUnitFromUnit(si.Hz, 1e30, .initUniqueSymbol("QHz"));
pub const RHz: Unit = defUnitFromUnit(si.Hz, 1e27, .initUniqueSymbol("RHz"));
pub const YHz: Unit = defUnitFromUnit(si.Hz, 1e24, .initUniqueSymbol("YHz"));
pub const ZHz: Unit = defUnitFromUnit(si.Hz, 1e21, .initUniqueSymbol("ZHz"));
pub const EHz: Unit = defUnitFromUnit(si.Hz, 1e18, .initUniqueSymbol("EHz"));
pub const PHz: Unit = defUnitFromUnit(si.Hz, 1e15, .initUniqueSymbol("PHz"));
pub const THz: Unit = defUnitFromUnit(si.Hz, 1e12, .initUniqueSymbol("THz"));
pub const GHz: Unit = defUnitFromUnit(si.Hz, 1e9, .initUniqueSymbol("GHz"));
pub const MHz: Unit = defUnitFromUnit(si.Hz, 1e6, .initUniqueSymbol("MHz"));
pub const kHz: Unit = defUnitFromUnit(si.Hz, 1e3, .initUniqueSymbol("kHz"));
pub const hHz: Unit = defUnitFromUnit(si.Hz, 1e2, .initUniqueSymbol("hHz"));
pub const daHz: Unit = defUnitFromUnit(si.Hz, 1e1, .initUniqueSymbol("daHz"));
pub const dHz: Unit = defUnitFromUnit(si.Hz, 1e-1, .initUniqueSymbol("dHz"));
pub const cHz: Unit = defUnitFromUnit(si.Hz, 1e-2, .initUniqueSymbol("cHz"));
pub const mHz: Unit = defUnitFromUnit(si.Hz, 1e-3, .initUniqueSymbol("mHz"));
pub const uHz: Unit = defUnitFromUnit(si.Hz, 1e-6, .initUniqueSymbol("uHz"));
pub const nHz: Unit = defUnitFromUnit(si.Hz, 1e-9, .initUniqueSymbol("nHz"));
pub const pHz: Unit = defUnitFromUnit(si.Hz, 1e-12, .initUniqueSymbol("pHz"));
pub const fHz: Unit = defUnitFromUnit(si.Hz, 1e-15, .initUniqueSymbol("fHz"));
pub const aHz: Unit = defUnitFromUnit(si.Hz, 1e-18, .initUniqueSymbol("aHz"));
pub const zHz: Unit = defUnitFromUnit(si.Hz, 1e-21, .initUniqueSymbol("zHz"));
pub const yHz: Unit = defUnitFromUnit(si.Hz, 1e-24, .initUniqueSymbol("yHz"));
pub const rHz: Unit = defUnitFromUnit(si.Hz, 1e-27, .initUniqueSymbol("rHz"));
pub const qHz: Unit = defUnitFromUnit(si.Hz, 1e-30, .initUniqueSymbol("qHz"));

// kg
pub const kg = si.kg;

// g
pub const g = si.g;
pub const Qg: Unit = defUnitFromUnit(si.g, 1e30, .initUniqueSymbol("Qg"));
pub const Rg: Unit = defUnitFromUnit(si.g, 1e27, .initUniqueSymbol("Rg"));
pub const Yg: Unit = defUnitFromUnit(si.g, 1e24, .initUniqueSymbol("Yg"));
pub const Zg: Unit = defUnitFromUnit(si.g, 1e21, .initUniqueSymbol("Zg"));
pub const Eg: Unit = defUnitFromUnit(si.g, 1e18, .initUniqueSymbol("Eg"));
pub const Pg: Unit = defUnitFromUnit(si.g, 1e15, .initUniqueSymbol("Pg"));
pub const Tg: Unit = defUnitFromUnit(si.g, 1e12, .initUniqueSymbol("Tg"));
pub const Gg: Unit = defUnitFromUnit(si.g, 1e9, .initUniqueSymbol("Gg"));
pub const Mg: Unit = defUnitFromUnit(si.g, 1e6, .initUniqueSymbol("Mg"));
pub const hg: Unit = defUnitFromUnit(si.g, 1e2, .initUniqueSymbol("hg"));
pub const dag: Unit = defUnitFromUnit(si.g, 1e1, .initUniqueSymbol("dag"));
pub const dg: Unit = defUnitFromUnit(si.g, 1e-1, .initUniqueSymbol("dg"));
pub const cg: Unit = defUnitFromUnit(si.g, 1e-2, .initUniqueSymbol("cg"));
pub const mg: Unit = defUnitFromUnit(si.g, 1e-3, .initUniqueSymbol("mg"));
pub const ug: Unit = defUnitFromUnit(si.g, 1e-6, .initUniqueSymbol("ug"));
pub const ng: Unit = defUnitFromUnit(si.g, 1e-9, .initUniqueSymbol("ng"));
pub const pg: Unit = defUnitFromUnit(si.g, 1e-12, .initUniqueSymbol("pg"));
pub const fg: Unit = defUnitFromUnit(si.g, 1e-15, .initUniqueSymbol("fg"));
pub const ag: Unit = defUnitFromUnit(si.g, 1e-18, .initUniqueSymbol("ag"));
pub const zg: Unit = defUnitFromUnit(si.g, 1e-21, .initUniqueSymbol("zg"));
pub const yg: Unit = defUnitFromUnit(si.g, 1e-24, .initUniqueSymbol("yg"));
pub const rg: Unit = defUnitFromUnit(si.g, 1e-27, .initUniqueSymbol("rg"));
pub const qg: Unit = defUnitFromUnit(si.g, 1e-30, .initUniqueSymbol("qg"));

// t
pub const t = si.t;

// mol
pub const mol = si.mol;
pub const Qmol: Unit = defUnitFromUnit(si.mol, 1e30, .initUniqueSymbol("Qmol"));
pub const Rmol: Unit = defUnitFromUnit(si.mol, 1e27, .initUniqueSymbol("Rmol"));
pub const Ymol: Unit = defUnitFromUnit(si.mol, 1e24, .initUniqueSymbol("Ymol"));
pub const Zmol: Unit = defUnitFromUnit(si.mol, 1e21, .initUniqueSymbol("Zmol"));
pub const Emol: Unit = defUnitFromUnit(si.mol, 1e18, .initUniqueSymbol("Emol"));
pub const Pmol: Unit = defUnitFromUnit(si.mol, 1e15, .initUniqueSymbol("Pmol"));
pub const Tmol: Unit = defUnitFromUnit(si.mol, 1e12, .initUniqueSymbol("Tmol"));
pub const Gmol: Unit = defUnitFromUnit(si.mol, 1e9, .initUniqueSymbol("Gmol"));
pub const Mmol: Unit = defUnitFromUnit(si.mol, 1e6, .initUniqueSymbol("Mmol"));
pub const kmol: Unit = defUnitFromUnit(si.mol, 1e3, .initUniqueSymbol("kmol"));
pub const hmol: Unit = defUnitFromUnit(si.mol, 1e2, .initUniqueSymbol("hmol"));
pub const damol: Unit = defUnitFromUnit(si.mol, 1e1, .initUniqueSymbol("damol"));
pub const dmol: Unit = defUnitFromUnit(si.mol, 1e-1, .initUniqueSymbol("dmol"));
pub const cmol: Unit = defUnitFromUnit(si.mol, 1e-2, .initUniqueSymbol("cmol"));
pub const mmol: Unit = defUnitFromUnit(si.mol, 1e-3, .initUniqueSymbol("mmol"));
pub const umol: Unit = defUnitFromUnit(si.mol, 1e-6, .initUniqueSymbol("umol"));
pub const nmol: Unit = defUnitFromUnit(si.mol, 1e-9, .initUniqueSymbol("nmol"));
pub const pmol: Unit = defUnitFromUnit(si.mol, 1e-12, .initUniqueSymbol("pmol"));
pub const fmol: Unit = defUnitFromUnit(si.mol, 1e-15, .initUniqueSymbol("fmol"));
pub const amol: Unit = defUnitFromUnit(si.mol, 1e-18, .initUniqueSymbol("amol"));
pub const zmol: Unit = defUnitFromUnit(si.mol, 1e-21, .initUniqueSymbol("zmol"));
pub const ymol: Unit = defUnitFromUnit(si.mol, 1e-24, .initUniqueSymbol("ymol"));
pub const rmol: Unit = defUnitFromUnit(si.mol, 1e-27, .initUniqueSymbol("rmol"));
pub const qmol: Unit = defUnitFromUnit(si.mol, 1e-30, .initUniqueSymbol("qmol"));

// kat
pub const kat = si.kat;
pub const Qkat: Unit = defUnitFromUnit(si.kat, 1e30, .initUniqueSymbol("Qkat"));
pub const Rkat: Unit = defUnitFromUnit(si.kat, 1e27, .initUniqueSymbol("Rkat"));
pub const Ykat: Unit = defUnitFromUnit(si.kat, 1e24, .initUniqueSymbol("Ykat"));
pub const Zkat: Unit = defUnitFromUnit(si.kat, 1e21, .initUniqueSymbol("Zkat"));
pub const Ekat: Unit = defUnitFromUnit(si.kat, 1e18, .initUniqueSymbol("Ekat"));
pub const Pkat: Unit = defUnitFromUnit(si.kat, 1e15, .initUniqueSymbol("Pkat"));
pub const Tkat: Unit = defUnitFromUnit(si.kat, 1e12, .initUniqueSymbol("Tkat"));
pub const Gkat: Unit = defUnitFromUnit(si.kat, 1e9, .initUniqueSymbol("Gkat"));
pub const Mkat: Unit = defUnitFromUnit(si.kat, 1e6, .initUniqueSymbol("Mkat"));
pub const kkat: Unit = defUnitFromUnit(si.kat, 1e3, .initUniqueSymbol("kkat"));
pub const hkat: Unit = defUnitFromUnit(si.kat, 1e2, .initUniqueSymbol("hkat"));
pub const dakat: Unit = defUnitFromUnit(si.kat, 1e1, .initUniqueSymbol("dakat"));
pub const dkat: Unit = defUnitFromUnit(si.kat, 1e-1, .initUniqueSymbol("dkat"));
pub const ckat: Unit = defUnitFromUnit(si.kat, 1e-2, .initUniqueSymbol("ckat"));
pub const mkat: Unit = defUnitFromUnit(si.kat, 1e-3, .initUniqueSymbol("mkat"));
pub const ukat: Unit = defUnitFromUnit(si.kat, 1e-6, .initUniqueSymbol("ukat"));
pub const nkat: Unit = defUnitFromUnit(si.kat, 1e-9, .initUniqueSymbol("nkat"));
pub const pkat: Unit = defUnitFromUnit(si.kat, 1e-12, .initUniqueSymbol("pkat"));
pub const fkat: Unit = defUnitFromUnit(si.kat, 1e-15, .initUniqueSymbol("fkat"));
pub const akat: Unit = defUnitFromUnit(si.kat, 1e-18, .initUniqueSymbol("akat"));
pub const zkat: Unit = defUnitFromUnit(si.kat, 1e-21, .initUniqueSymbol("zkat"));
pub const ykat: Unit = defUnitFromUnit(si.kat, 1e-24, .initUniqueSymbol("ykat"));
pub const rkat: Unit = defUnitFromUnit(si.kat, 1e-27, .initUniqueSymbol("rkat"));
pub const qkat: Unit = defUnitFromUnit(si.kat, 1e-30, .initUniqueSymbol("qkat"));

// K
pub const K = si.K;
pub const QK: Unit = defUnitFromUnit(si.K, 1e30, .initUniqueSymbol("QK"));
pub const RK: Unit = defUnitFromUnit(si.K, 1e27, .initUniqueSymbol("RK"));
pub const YK: Unit = defUnitFromUnit(si.K, 1e24, .initUniqueSymbol("YK"));
pub const ZK: Unit = defUnitFromUnit(si.K, 1e21, .initUniqueSymbol("ZK"));
pub const EK: Unit = defUnitFromUnit(si.K, 1e18, .initUniqueSymbol("EK"));
pub const PK: Unit = defUnitFromUnit(si.K, 1e15, .initUniqueSymbol("PK"));
pub const TK: Unit = defUnitFromUnit(si.K, 1e12, .initUniqueSymbol("TK"));
pub const GK: Unit = defUnitFromUnit(si.K, 1e9, .initUniqueSymbol("GK"));
pub const MK: Unit = defUnitFromUnit(si.K, 1e6, .initUniqueSymbol("MK"));
pub const kK: Unit = defUnitFromUnit(si.K, 1e3, .initUniqueSymbol("kK"));
pub const hK: Unit = defUnitFromUnit(si.K, 1e2, .initUniqueSymbol("hK"));
pub const daK: Unit = defUnitFromUnit(si.K, 1e1, .initUniqueSymbol("daK"));
pub const dK: Unit = defUnitFromUnit(si.K, 1e-1, .initUniqueSymbol("dK"));
pub const cK: Unit = defUnitFromUnit(si.K, 1e-2, .initUniqueSymbol("cK"));
pub const mK: Unit = defUnitFromUnit(si.K, 1e-3, .initUniqueSymbol("mK"));
pub const uK: Unit = defUnitFromUnit(si.K, 1e-6, .initUniqueSymbol("uK"));
pub const nK: Unit = defUnitFromUnit(si.K, 1e-9, .initUniqueSymbol("nK"));
pub const pK: Unit = defUnitFromUnit(si.K, 1e-12, .initUniqueSymbol("pK"));
pub const fK: Unit = defUnitFromUnit(si.K, 1e-15, .initUniqueSymbol("fK"));
pub const aK: Unit = defUnitFromUnit(si.K, 1e-18, .initUniqueSymbol("aK"));
pub const zK: Unit = defUnitFromUnit(si.K, 1e-21, .initUniqueSymbol("zK"));
pub const yK: Unit = defUnitFromUnit(si.K, 1e-24, .initUniqueSymbol("yK"));
pub const rK: Unit = defUnitFromUnit(si.K, 1e-27, .initUniqueSymbol("rK"));
pub const qK: Unit = defUnitFromUnit(si.K, 1e-30, .initUniqueSymbol("qK"));

// degC
pub const degC = si.degC;

// N
pub const N = si.N;
pub const QN: Unit = defUnitFromUnit(si.N, 1e30, .initUniqueSymbol("QN"));
pub const RN: Unit = defUnitFromUnit(si.N, 1e27, .initUniqueSymbol("RN"));
pub const YN: Unit = defUnitFromUnit(si.N, 1e24, .initUniqueSymbol("YN"));
pub const ZN: Unit = defUnitFromUnit(si.N, 1e21, .initUniqueSymbol("ZN"));
pub const EN: Unit = defUnitFromUnit(si.N, 1e18, .initUniqueSymbol("EN"));
pub const PN: Unit = defUnitFromUnit(si.N, 1e15, .initUniqueSymbol("PN"));
pub const TN: Unit = defUnitFromUnit(si.N, 1e12, .initUniqueSymbol("TN"));
pub const GN: Unit = defUnitFromUnit(si.N, 1e9, .initUniqueSymbol("GN"));
pub const MN: Unit = defUnitFromUnit(si.N, 1e6, .initUniqueSymbol("MN"));
pub const kN: Unit = defUnitFromUnit(si.N, 1e3, .initUniqueSymbol("kN"));
pub const hN: Unit = defUnitFromUnit(si.N, 1e2, .initUniqueSymbol("hN"));
pub const daN: Unit = defUnitFromUnit(si.N, 1e1, .initUniqueSymbol("daN"));
pub const dN: Unit = defUnitFromUnit(si.N, 1e-1, .initUniqueSymbol("dN"));
pub const cN: Unit = defUnitFromUnit(si.N, 1e-2, .initUniqueSymbol("cN"));
pub const mN: Unit = defUnitFromUnit(si.N, 1e-3, .initUniqueSymbol("mN"));
pub const uN: Unit = defUnitFromUnit(si.N, 1e-6, .initUniqueSymbol("uN"));
pub const nN: Unit = defUnitFromUnit(si.N, 1e-9, .initUniqueSymbol("nN"));
pub const pN: Unit = defUnitFromUnit(si.N, 1e-12, .initUniqueSymbol("pN"));
pub const fN: Unit = defUnitFromUnit(si.N, 1e-15, .initUniqueSymbol("fN"));
pub const aN: Unit = defUnitFromUnit(si.N, 1e-18, .initUniqueSymbol("aN"));
pub const zN: Unit = defUnitFromUnit(si.N, 1e-21, .initUniqueSymbol("zN"));
pub const yN: Unit = defUnitFromUnit(si.N, 1e-24, .initUniqueSymbol("yN"));
pub const rN: Unit = defUnitFromUnit(si.N, 1e-27, .initUniqueSymbol("rN"));
pub const qN: Unit = defUnitFromUnit(si.N, 1e-30, .initUniqueSymbol("qN"));

// J
pub const J = si.J;
pub const QJ: Unit = defUnitFromUnit(si.J, 1e30, .initUniqueSymbol("QJ"));
pub const RJ: Unit = defUnitFromUnit(si.J, 1e27, .initUniqueSymbol("RJ"));
pub const YJ: Unit = defUnitFromUnit(si.J, 1e24, .initUniqueSymbol("YJ"));
pub const ZJ: Unit = defUnitFromUnit(si.J, 1e21, .initUniqueSymbol("ZJ"));
pub const EJ: Unit = defUnitFromUnit(si.J, 1e18, .initUniqueSymbol("EJ"));
pub const PJ: Unit = defUnitFromUnit(si.J, 1e15, .initUniqueSymbol("PJ"));
pub const TJ: Unit = defUnitFromUnit(si.J, 1e12, .initUniqueSymbol("TJ"));
pub const GJ: Unit = defUnitFromUnit(si.J, 1e9, .initUniqueSymbol("GJ"));
pub const MJ: Unit = defUnitFromUnit(si.J, 1e6, .initUniqueSymbol("MJ"));
pub const kJ: Unit = defUnitFromUnit(si.J, 1e3, .initUniqueSymbol("kJ"));
pub const hJ: Unit = defUnitFromUnit(si.J, 1e2, .initUniqueSymbol("hJ"));
pub const daJ: Unit = defUnitFromUnit(si.J, 1e1, .initUniqueSymbol("daJ"));
pub const dJ: Unit = defUnitFromUnit(si.J, 1e-1, .initUniqueSymbol("dJ"));
pub const cJ: Unit = defUnitFromUnit(si.J, 1e-2, .initUniqueSymbol("cJ"));
pub const mJ: Unit = defUnitFromUnit(si.J, 1e-3, .initUniqueSymbol("mJ"));
pub const uJ: Unit = defUnitFromUnit(si.J, 1e-6, .initUniqueSymbol("uJ"));
pub const nJ: Unit = defUnitFromUnit(si.J, 1e-9, .initUniqueSymbol("nJ"));
pub const pJ: Unit = defUnitFromUnit(si.J, 1e-12, .initUniqueSymbol("pJ"));
pub const fJ: Unit = defUnitFromUnit(si.J, 1e-15, .initUniqueSymbol("fJ"));
pub const aJ: Unit = defUnitFromUnit(si.J, 1e-18, .initUniqueSymbol("aJ"));
pub const zJ: Unit = defUnitFromUnit(si.J, 1e-21, .initUniqueSymbol("zJ"));
pub const yJ: Unit = defUnitFromUnit(si.J, 1e-24, .initUniqueSymbol("yJ"));
pub const rJ: Unit = defUnitFromUnit(si.J, 1e-27, .initUniqueSymbol("rJ"));
pub const qJ: Unit = defUnitFromUnit(si.J, 1e-30, .initUniqueSymbol("qJ"));

// Pa
pub const Pa = si.Pa;
pub const QPa: Unit = defUnitFromUnit(si.Pa, 1e30, .initUniqueSymbol("QPa"));
pub const RPa: Unit = defUnitFromUnit(si.Pa, 1e27, .initUniqueSymbol("RPa"));
pub const YPa: Unit = defUnitFromUnit(si.Pa, 1e24, .initUniqueSymbol("YPa"));
pub const ZPa: Unit = defUnitFromUnit(si.Pa, 1e21, .initUniqueSymbol("ZPa"));
pub const EPa: Unit = defUnitFromUnit(si.Pa, 1e18, .initUniqueSymbol("EPa"));
pub const PPa: Unit = defUnitFromUnit(si.Pa, 1e15, .initUniqueSymbol("PPa"));
pub const TPa: Unit = defUnitFromUnit(si.Pa, 1e12, .initUniqueSymbol("TPa"));
pub const GPa: Unit = defUnitFromUnit(si.Pa, 1e9, .initUniqueSymbol("GPa"));
pub const MPa: Unit = defUnitFromUnit(si.Pa, 1e6, .initUniqueSymbol("MPa"));
pub const kPa: Unit = defUnitFromUnit(si.Pa, 1e3, .initUniqueSymbol("kPa"));
pub const hPa: Unit = defUnitFromUnit(si.Pa, 1e2, .initUniqueSymbol("hPa"));
pub const daPa: Unit = defUnitFromUnit(si.Pa, 1e1, .initUniqueSymbol("daPa"));
pub const dPa: Unit = defUnitFromUnit(si.Pa, 1e-1, .initUniqueSymbol("dPa"));
pub const cPa: Unit = defUnitFromUnit(si.Pa, 1e-2, .initUniqueSymbol("cPa"));
pub const mPa: Unit = defUnitFromUnit(si.Pa, 1e-3, .initUniqueSymbol("mPa"));
pub const uPa: Unit = defUnitFromUnit(si.Pa, 1e-6, .initUniqueSymbol("uPa"));
pub const nPa: Unit = defUnitFromUnit(si.Pa, 1e-9, .initUniqueSymbol("nPa"));
pub const pPa: Unit = defUnitFromUnit(si.Pa, 1e-12, .initUniqueSymbol("pPa"));
pub const fPa: Unit = defUnitFromUnit(si.Pa, 1e-15, .initUniqueSymbol("fPa"));
pub const aPa: Unit = defUnitFromUnit(si.Pa, 1e-18, .initUniqueSymbol("aPa"));
pub const zPa: Unit = defUnitFromUnit(si.Pa, 1e-21, .initUniqueSymbol("zPa"));
pub const yPa: Unit = defUnitFromUnit(si.Pa, 1e-24, .initUniqueSymbol("yPa"));
pub const rPa: Unit = defUnitFromUnit(si.Pa, 1e-27, .initUniqueSymbol("rPa"));
pub const qPa: Unit = defUnitFromUnit(si.Pa, 1e-30, .initUniqueSymbol("qPa"));

// W
pub const W = si.W;
pub const QW: Unit = defUnitFromUnit(si.W, 1e30, .initUniqueSymbol("QW"));
pub const RW: Unit = defUnitFromUnit(si.W, 1e27, .initUniqueSymbol("RW"));
pub const YW: Unit = defUnitFromUnit(si.W, 1e24, .initUniqueSymbol("YW"));
pub const ZW: Unit = defUnitFromUnit(si.W, 1e21, .initUniqueSymbol("ZW"));
pub const EW: Unit = defUnitFromUnit(si.W, 1e18, .initUniqueSymbol("EW"));
pub const PW: Unit = defUnitFromUnit(si.W, 1e15, .initUniqueSymbol("PW"));
pub const TW: Unit = defUnitFromUnit(si.W, 1e12, .initUniqueSymbol("TW"));
pub const GW: Unit = defUnitFromUnit(si.W, 1e9, .initUniqueSymbol("GW"));
pub const MW: Unit = defUnitFromUnit(si.W, 1e6, .initUniqueSymbol("MW"));
pub const kW: Unit = defUnitFromUnit(si.W, 1e3, .initUniqueSymbol("kW"));
pub const hW: Unit = defUnitFromUnit(si.W, 1e2, .initUniqueSymbol("hW"));
pub const daW: Unit = defUnitFromUnit(si.W, 1e1, .initUniqueSymbol("daW"));
pub const dW: Unit = defUnitFromUnit(si.W, 1e-1, .initUniqueSymbol("dW"));
pub const cW: Unit = defUnitFromUnit(si.W, 1e-2, .initUniqueSymbol("cW"));
pub const mW: Unit = defUnitFromUnit(si.W, 1e-3, .initUniqueSymbol("mW"));
pub const uW: Unit = defUnitFromUnit(si.W, 1e-6, .initUniqueSymbol("uW"));
pub const nW: Unit = defUnitFromUnit(si.W, 1e-9, .initUniqueSymbol("nW"));
pub const pW: Unit = defUnitFromUnit(si.W, 1e-12, .initUniqueSymbol("pW"));
pub const fW: Unit = defUnitFromUnit(si.W, 1e-15, .initUniqueSymbol("fW"));
pub const aW: Unit = defUnitFromUnit(si.W, 1e-18, .initUniqueSymbol("aW"));
pub const zW: Unit = defUnitFromUnit(si.W, 1e-21, .initUniqueSymbol("zW"));
pub const yW: Unit = defUnitFromUnit(si.W, 1e-24, .initUniqueSymbol("yW"));
pub const rW: Unit = defUnitFromUnit(si.W, 1e-27, .initUniqueSymbol("rW"));
pub const qW: Unit = defUnitFromUnit(si.W, 1e-30, .initUniqueSymbol("qW"));

// A
pub const A = si.A;
pub const QA: Unit = defUnitFromUnit(si.A, 1e30, .initUniqueSymbol("QA"));
pub const RA: Unit = defUnitFromUnit(si.A, 1e27, .initUniqueSymbol("RA"));
pub const YA: Unit = defUnitFromUnit(si.A, 1e24, .initUniqueSymbol("YA"));
pub const ZA: Unit = defUnitFromUnit(si.A, 1e21, .initUniqueSymbol("ZA"));
pub const EA: Unit = defUnitFromUnit(si.A, 1e18, .initUniqueSymbol("EA"));
pub const PA: Unit = defUnitFromUnit(si.A, 1e15, .initUniqueSymbol("PA"));
pub const TA: Unit = defUnitFromUnit(si.A, 1e12, .initUniqueSymbol("TA"));
pub const GA: Unit = defUnitFromUnit(si.A, 1e9, .initUniqueSymbol("GA"));
pub const MA: Unit = defUnitFromUnit(si.A, 1e6, .initUniqueSymbol("MA"));
pub const kA: Unit = defUnitFromUnit(si.A, 1e3, .initUniqueSymbol("kA"));
pub const hA: Unit = defUnitFromUnit(si.A, 1e2, .initUniqueSymbol("hA"));
pub const daA: Unit = defUnitFromUnit(si.A, 1e1, .initUniqueSymbol("daA"));
pub const dA: Unit = defUnitFromUnit(si.A, 1e-1, .initUniqueSymbol("dA"));
pub const cA: Unit = defUnitFromUnit(si.A, 1e-2, .initUniqueSymbol("cA"));
pub const mA: Unit = defUnitFromUnit(si.A, 1e-3, .initUniqueSymbol("mA"));
pub const uA: Unit = defUnitFromUnit(si.A, 1e-6, .initUniqueSymbol("uA"));
pub const nA: Unit = defUnitFromUnit(si.A, 1e-9, .initUniqueSymbol("nA"));
pub const pA: Unit = defUnitFromUnit(si.A, 1e-12, .initUniqueSymbol("pA"));
pub const fA: Unit = defUnitFromUnit(si.A, 1e-15, .initUniqueSymbol("fA"));
pub const aA: Unit = defUnitFromUnit(si.A, 1e-18, .initUniqueSymbol("aA"));
pub const zA: Unit = defUnitFromUnit(si.A, 1e-21, .initUniqueSymbol("zA"));
pub const yA: Unit = defUnitFromUnit(si.A, 1e-24, .initUniqueSymbol("yA"));
pub const rA: Unit = defUnitFromUnit(si.A, 1e-27, .initUniqueSymbol("rA"));
pub const qA: Unit = defUnitFromUnit(si.A, 1e-30, .initUniqueSymbol("qA"));

// C
pub const C = si.C;
pub const QC: Unit = defUnitFromUnit(si.C, 1e30, .initUniqueSymbol("QC"));
pub const RC: Unit = defUnitFromUnit(si.C, 1e27, .initUniqueSymbol("RC"));
pub const YC: Unit = defUnitFromUnit(si.C, 1e24, .initUniqueSymbol("YC"));
pub const ZC: Unit = defUnitFromUnit(si.C, 1e21, .initUniqueSymbol("ZC"));
pub const EC: Unit = defUnitFromUnit(si.C, 1e18, .initUniqueSymbol("EC"));
pub const PC: Unit = defUnitFromUnit(si.C, 1e15, .initUniqueSymbol("PC"));
pub const TC: Unit = defUnitFromUnit(si.C, 1e12, .initUniqueSymbol("TC"));
pub const GC: Unit = defUnitFromUnit(si.C, 1e9, .initUniqueSymbol("GC"));
pub const MC: Unit = defUnitFromUnit(si.C, 1e6, .initUniqueSymbol("MC"));
pub const kC: Unit = defUnitFromUnit(si.C, 1e3, .initUniqueSymbol("kC"));
pub const hC: Unit = defUnitFromUnit(si.C, 1e2, .initUniqueSymbol("hC"));
pub const daC: Unit = defUnitFromUnit(si.C, 1e1, .initUniqueSymbol("daC"));
pub const dC: Unit = defUnitFromUnit(si.C, 1e-1, .initUniqueSymbol("dC"));
pub const cC: Unit = defUnitFromUnit(si.C, 1e-2, .initUniqueSymbol("cC"));
pub const mC: Unit = defUnitFromUnit(si.C, 1e-3, .initUniqueSymbol("mC"));
pub const uC: Unit = defUnitFromUnit(si.C, 1e-6, .initUniqueSymbol("uC"));
pub const nC: Unit = defUnitFromUnit(si.C, 1e-9, .initUniqueSymbol("nC"));
pub const pC: Unit = defUnitFromUnit(si.C, 1e-12, .initUniqueSymbol("pC"));
pub const fC: Unit = defUnitFromUnit(si.C, 1e-15, .initUniqueSymbol("fC"));
pub const aC: Unit = defUnitFromUnit(si.C, 1e-18, .initUniqueSymbol("aC"));
pub const zC: Unit = defUnitFromUnit(si.C, 1e-21, .initUniqueSymbol("zC"));
pub const yC: Unit = defUnitFromUnit(si.C, 1e-24, .initUniqueSymbol("yC"));
pub const rC: Unit = defUnitFromUnit(si.C, 1e-27, .initUniqueSymbol("rC"));
pub const qC: Unit = defUnitFromUnit(si.C, 1e-30, .initUniqueSymbol("qC"));

// V
pub const V = si.V;

// Ohm
pub const Ohm = si.Ohm;
pub const QOhm: Unit = defUnitFromUnit(si.Ohm, 1e30, .initUniqueSymbol("QOhm"));
pub const ROhm: Unit = defUnitFromUnit(si.Ohm, 1e27, .initUniqueSymbol("ROhm"));
pub const YOhm: Unit = defUnitFromUnit(si.Ohm, 1e24, .initUniqueSymbol("YOhm"));
pub const ZOhm: Unit = defUnitFromUnit(si.Ohm, 1e21, .initUniqueSymbol("ZOhm"));
pub const EOhm: Unit = defUnitFromUnit(si.Ohm, 1e18, .initUniqueSymbol("EOhm"));
pub const POhm: Unit = defUnitFromUnit(si.Ohm, 1e15, .initUniqueSymbol("POhm"));
pub const TOhm: Unit = defUnitFromUnit(si.Ohm, 1e12, .initUniqueSymbol("TOhm"));
pub const GOhm: Unit = defUnitFromUnit(si.Ohm, 1e9, .initUniqueSymbol("GOhm"));
pub const MOhm: Unit = defUnitFromUnit(si.Ohm, 1e6, .initUniqueSymbol("MOhm"));
pub const kOhm: Unit = defUnitFromUnit(si.Ohm, 1e3, .initUniqueSymbol("kOhm"));
pub const hOhm: Unit = defUnitFromUnit(si.Ohm, 1e2, .initUniqueSymbol("hOhm"));
pub const daOhm: Unit = defUnitFromUnit(si.Ohm, 1e1, .initUniqueSymbol("daOhm"));
pub const dOhm: Unit = defUnitFromUnit(si.Ohm, 1e-1, .initUniqueSymbol("dOhm"));
pub const cOhm: Unit = defUnitFromUnit(si.Ohm, 1e-2, .initUniqueSymbol("cOhm"));
pub const mOhm: Unit = defUnitFromUnit(si.Ohm, 1e-3, .initUniqueSymbol("mOhm"));
pub const uOhm: Unit = defUnitFromUnit(si.Ohm, 1e-6, .initUniqueSymbol("uOhm"));
pub const nOhm: Unit = defUnitFromUnit(si.Ohm, 1e-9, .initUniqueSymbol("nOhm"));
pub const pOhm: Unit = defUnitFromUnit(si.Ohm, 1e-12, .initUniqueSymbol("pOhm"));
pub const fOhm: Unit = defUnitFromUnit(si.Ohm, 1e-15, .initUniqueSymbol("fOhm"));
pub const aOhm: Unit = defUnitFromUnit(si.Ohm, 1e-18, .initUniqueSymbol("aOhm"));
pub const zOhm: Unit = defUnitFromUnit(si.Ohm, 1e-21, .initUniqueSymbol("zOhm"));
pub const yOhm: Unit = defUnitFromUnit(si.Ohm, 1e-24, .initUniqueSymbol("yOhm"));
pub const rOhm: Unit = defUnitFromUnit(si.Ohm, 1e-27, .initUniqueSymbol("rOhm"));
pub const qOhm: Unit = defUnitFromUnit(si.Ohm, 1e-30, .initUniqueSymbol("qOhm"));

// S
pub const S = si.S;
pub const QS: Unit = defUnitFromUnit(si.S, 1e30, .initUniqueSymbol("QS"));
pub const RS: Unit = defUnitFromUnit(si.S, 1e27, .initUniqueSymbol("RS"));
pub const YS: Unit = defUnitFromUnit(si.S, 1e24, .initUniqueSymbol("YS"));
pub const ZS: Unit = defUnitFromUnit(si.S, 1e21, .initUniqueSymbol("ZS"));
pub const ES: Unit = defUnitFromUnit(si.S, 1e18, .initUniqueSymbol("ES"));
pub const PS: Unit = defUnitFromUnit(si.S, 1e15, .initUniqueSymbol("PS"));
pub const TS: Unit = defUnitFromUnit(si.S, 1e12, .initUniqueSymbol("TS"));
pub const GS: Unit = defUnitFromUnit(si.S, 1e9, .initUniqueSymbol("GS"));
pub const MS: Unit = defUnitFromUnit(si.S, 1e6, .initUniqueSymbol("MS"));
pub const kS: Unit = defUnitFromUnit(si.S, 1e3, .initUniqueSymbol("kS"));
pub const hS: Unit = defUnitFromUnit(si.S, 1e2, .initUniqueSymbol("hS"));
pub const daS: Unit = defUnitFromUnit(si.S, 1e1, .initUniqueSymbol("daS"));
pub const dS: Unit = defUnitFromUnit(si.S, 1e-1, .initUniqueSymbol("dS"));
pub const cS: Unit = defUnitFromUnit(si.S, 1e-2, .initUniqueSymbol("cS"));
pub const mS: Unit = defUnitFromUnit(si.S, 1e-3, .initUniqueSymbol("mS"));
pub const uS: Unit = defUnitFromUnit(si.S, 1e-6, .initUniqueSymbol("uS"));
pub const nS: Unit = defUnitFromUnit(si.S, 1e-9, .initUniqueSymbol("nS"));
pub const pS: Unit = defUnitFromUnit(si.S, 1e-12, .initUniqueSymbol("pS"));
pub const fS: Unit = defUnitFromUnit(si.S, 1e-15, .initUniqueSymbol("fS"));
pub const aS: Unit = defUnitFromUnit(si.S, 1e-18, .initUniqueSymbol("aS"));
pub const zS: Unit = defUnitFromUnit(si.S, 1e-21, .initUniqueSymbol("zS"));
pub const yS: Unit = defUnitFromUnit(si.S, 1e-24, .initUniqueSymbol("yS"));
pub const rS: Unit = defUnitFromUnit(si.S, 1e-27, .initUniqueSymbol("rS"));
pub const qS: Unit = defUnitFromUnit(si.S, 1e-30, .initUniqueSymbol("qS"));

// F
pub const F = si.F;
pub const QF: Unit = defUnitFromUnit(si.F, 1e30, .initUniqueSymbol("QF"));
pub const RF: Unit = defUnitFromUnit(si.F, 1e27, .initUniqueSymbol("RF"));
pub const YF: Unit = defUnitFromUnit(si.F, 1e24, .initUniqueSymbol("YF"));
pub const ZF: Unit = defUnitFromUnit(si.F, 1e21, .initUniqueSymbol("ZF"));
pub const EF: Unit = defUnitFromUnit(si.F, 1e18, .initUniqueSymbol("EF"));
pub const PF: Unit = defUnitFromUnit(si.F, 1e15, .initUniqueSymbol("PF"));
pub const TF: Unit = defUnitFromUnit(si.F, 1e12, .initUniqueSymbol("TF"));
pub const GF: Unit = defUnitFromUnit(si.F, 1e9, .initUniqueSymbol("GF"));
pub const MF: Unit = defUnitFromUnit(si.F, 1e6, .initUniqueSymbol("MF"));
pub const kF: Unit = defUnitFromUnit(si.F, 1e3, .initUniqueSymbol("kF"));
pub const hF: Unit = defUnitFromUnit(si.F, 1e2, .initUniqueSymbol("hF"));
pub const daF: Unit = defUnitFromUnit(si.F, 1e1, .initUniqueSymbol("daF"));
pub const dF: Unit = defUnitFromUnit(si.F, 1e-1, .initUniqueSymbol("dF"));
pub const cF: Unit = defUnitFromUnit(si.F, 1e-2, .initUniqueSymbol("cF"));
pub const mF: Unit = defUnitFromUnit(si.F, 1e-3, .initUniqueSymbol("mF"));
pub const uF: Unit = defUnitFromUnit(si.F, 1e-6, .initUniqueSymbol("uF"));
pub const nF: Unit = defUnitFromUnit(si.F, 1e-9, .initUniqueSymbol("nF"));
pub const pF: Unit = defUnitFromUnit(si.F, 1e-12, .initUniqueSymbol("pF"));
pub const fF: Unit = defUnitFromUnit(si.F, 1e-15, .initUniqueSymbol("fF"));
pub const aF: Unit = defUnitFromUnit(si.F, 1e-18, .initUniqueSymbol("aF"));
pub const zF: Unit = defUnitFromUnit(si.F, 1e-21, .initUniqueSymbol("zF"));
pub const yF: Unit = defUnitFromUnit(si.F, 1e-24, .initUniqueSymbol("yF"));
pub const rF: Unit = defUnitFromUnit(si.F, 1e-27, .initUniqueSymbol("rF"));
pub const qF: Unit = defUnitFromUnit(si.F, 1e-30, .initUniqueSymbol("qF"));

// Wb
pub const Wb = si.Wb;
pub const QWb: Unit = defUnitFromUnit(si.Wb, 1e30, .initUniqueSymbol("QWb"));
pub const RWb: Unit = defUnitFromUnit(si.Wb, 1e27, .initUniqueSymbol("RWb"));
pub const YWb: Unit = defUnitFromUnit(si.Wb, 1e24, .initUniqueSymbol("YWb"));
pub const ZWb: Unit = defUnitFromUnit(si.Wb, 1e21, .initUniqueSymbol("ZWb"));
pub const EWb: Unit = defUnitFromUnit(si.Wb, 1e18, .initUniqueSymbol("EWb"));
pub const PWb: Unit = defUnitFromUnit(si.Wb, 1e15, .initUniqueSymbol("PWb"));
pub const TWb: Unit = defUnitFromUnit(si.Wb, 1e12, .initUniqueSymbol("TWb"));
pub const GWb: Unit = defUnitFromUnit(si.Wb, 1e9, .initUniqueSymbol("GWb"));
pub const MWb: Unit = defUnitFromUnit(si.Wb, 1e6, .initUniqueSymbol("MWb"));
pub const kWb: Unit = defUnitFromUnit(si.Wb, 1e3, .initUniqueSymbol("kWb"));
pub const hWb: Unit = defUnitFromUnit(si.Wb, 1e2, .initUniqueSymbol("hWb"));
pub const daWb: Unit = defUnitFromUnit(si.Wb, 1e1, .initUniqueSymbol("daWb"));
pub const dWb: Unit = defUnitFromUnit(si.Wb, 1e-1, .initUniqueSymbol("dWb"));
pub const cWb: Unit = defUnitFromUnit(si.Wb, 1e-2, .initUniqueSymbol("cWb"));
pub const mWb: Unit = defUnitFromUnit(si.Wb, 1e-3, .initUniqueSymbol("mWb"));
pub const uWb: Unit = defUnitFromUnit(si.Wb, 1e-6, .initUniqueSymbol("uWb"));
pub const nWb: Unit = defUnitFromUnit(si.Wb, 1e-9, .initUniqueSymbol("nWb"));
pub const pWb: Unit = defUnitFromUnit(si.Wb, 1e-12, .initUniqueSymbol("pWb"));
pub const fWb: Unit = defUnitFromUnit(si.Wb, 1e-15, .initUniqueSymbol("fWb"));
pub const aWb: Unit = defUnitFromUnit(si.Wb, 1e-18, .initUniqueSymbol("aWb"));
pub const zWb: Unit = defUnitFromUnit(si.Wb, 1e-21, .initUniqueSymbol("zWb"));
pub const yWb: Unit = defUnitFromUnit(si.Wb, 1e-24, .initUniqueSymbol("yWb"));
pub const rWb: Unit = defUnitFromUnit(si.Wb, 1e-27, .initUniqueSymbol("rWb"));
pub const qWb: Unit = defUnitFromUnit(si.Wb, 1e-30, .initUniqueSymbol("qWb"));

// T
pub const T = si.T;
pub const QT: Unit = defUnitFromUnit(si.T, 1e30, .initUniqueSymbol("QT"));
pub const RT: Unit = defUnitFromUnit(si.T, 1e27, .initUniqueSymbol("RT"));
pub const YT: Unit = defUnitFromUnit(si.T, 1e24, .initUniqueSymbol("YT"));
pub const ZT: Unit = defUnitFromUnit(si.T, 1e21, .initUniqueSymbol("ZT"));
pub const ET: Unit = defUnitFromUnit(si.T, 1e18, .initUniqueSymbol("ET"));
pub const PT: Unit = defUnitFromUnit(si.T, 1e15, .initUniqueSymbol("PT"));
pub const TT: Unit = defUnitFromUnit(si.T, 1e12, .initUniqueSymbol("TT"));
pub const GT: Unit = defUnitFromUnit(si.T, 1e9, .initUniqueSymbol("GT"));
pub const MT: Unit = defUnitFromUnit(si.T, 1e6, .initUniqueSymbol("MT"));
pub const kT: Unit = defUnitFromUnit(si.T, 1e3, .initUniqueSymbol("kT"));
pub const hT: Unit = defUnitFromUnit(si.T, 1e2, .initUniqueSymbol("hT"));
pub const daT: Unit = defUnitFromUnit(si.T, 1e1, .initUniqueSymbol("daT"));
pub const dT: Unit = defUnitFromUnit(si.T, 1e-1, .initUniqueSymbol("dT"));
pub const cT: Unit = defUnitFromUnit(si.T, 1e-2, .initUniqueSymbol("cT"));
pub const mT: Unit = defUnitFromUnit(si.T, 1e-3, .initUniqueSymbol("mT"));
pub const uT: Unit = defUnitFromUnit(si.T, 1e-6, .initUniqueSymbol("uT"));
pub const nT: Unit = defUnitFromUnit(si.T, 1e-9, .initUniqueSymbol("nT"));
pub const pT: Unit = defUnitFromUnit(si.T, 1e-12, .initUniqueSymbol("pT"));
pub const fT: Unit = defUnitFromUnit(si.T, 1e-15, .initUniqueSymbol("fT"));
pub const aT: Unit = defUnitFromUnit(si.T, 1e-18, .initUniqueSymbol("aT"));
pub const zT: Unit = defUnitFromUnit(si.T, 1e-21, .initUniqueSymbol("zT"));
pub const yT: Unit = defUnitFromUnit(si.T, 1e-24, .initUniqueSymbol("yT"));
pub const rT: Unit = defUnitFromUnit(si.T, 1e-27, .initUniqueSymbol("rT"));
pub const qT: Unit = defUnitFromUnit(si.T, 1e-30, .initUniqueSymbol("qT"));

// H
pub const H = si.H;
pub const QH: Unit = defUnitFromUnit(si.H, 1e30, .initUniqueSymbol("QH"));
pub const RH: Unit = defUnitFromUnit(si.H, 1e27, .initUniqueSymbol("RH"));
pub const YH: Unit = defUnitFromUnit(si.H, 1e24, .initUniqueSymbol("YH"));
pub const ZH: Unit = defUnitFromUnit(si.H, 1e21, .initUniqueSymbol("ZH"));
pub const EH: Unit = defUnitFromUnit(si.H, 1e18, .initUniqueSymbol("EH"));
pub const PH: Unit = defUnitFromUnit(si.H, 1e15, .initUniqueSymbol("PH"));
pub const TH: Unit = defUnitFromUnit(si.H, 1e12, .initUniqueSymbol("TH"));
pub const GH: Unit = defUnitFromUnit(si.H, 1e9, .initUniqueSymbol("GH"));
pub const MH: Unit = defUnitFromUnit(si.H, 1e6, .initUniqueSymbol("MH"));
pub const kH: Unit = defUnitFromUnit(si.H, 1e3, .initUniqueSymbol("kH"));
pub const hH: Unit = defUnitFromUnit(si.H, 1e2, .initUniqueSymbol("hH"));
pub const daH: Unit = defUnitFromUnit(si.H, 1e1, .initUniqueSymbol("daH"));
pub const dH: Unit = defUnitFromUnit(si.H, 1e-1, .initUniqueSymbol("dH"));
pub const cH: Unit = defUnitFromUnit(si.H, 1e-2, .initUniqueSymbol("cH"));
pub const mH: Unit = defUnitFromUnit(si.H, 1e-3, .initUniqueSymbol("mH"));
pub const uH: Unit = defUnitFromUnit(si.H, 1e-6, .initUniqueSymbol("uH"));
pub const nH: Unit = defUnitFromUnit(si.H, 1e-9, .initUniqueSymbol("nH"));
pub const pH: Unit = defUnitFromUnit(si.H, 1e-12, .initUniqueSymbol("pH"));
pub const fH: Unit = defUnitFromUnit(si.H, 1e-15, .initUniqueSymbol("fH"));
pub const aH: Unit = defUnitFromUnit(si.H, 1e-18, .initUniqueSymbol("aH"));
pub const zH: Unit = defUnitFromUnit(si.H, 1e-21, .initUniqueSymbol("zH"));
pub const yH: Unit = defUnitFromUnit(si.H, 1e-24, .initUniqueSymbol("yH"));
pub const rH: Unit = defUnitFromUnit(si.H, 1e-27, .initUniqueSymbol("rH"));
pub const qH: Unit = defUnitFromUnit(si.H, 1e-30, .initUniqueSymbol("qH"));

// cd
pub const cd = si.cd;
pub const Qcd: Unit = defUnitFromUnit(si.cd, 1e30, .initUniqueSymbol("Qcd"));
pub const Rcd: Unit = defUnitFromUnit(si.cd, 1e27, .initUniqueSymbol("Rcd"));
pub const Ycd: Unit = defUnitFromUnit(si.cd, 1e24, .initUniqueSymbol("Ycd"));
pub const Zcd: Unit = defUnitFromUnit(si.cd, 1e21, .initUniqueSymbol("Zcd"));
pub const Ecd: Unit = defUnitFromUnit(si.cd, 1e18, .initUniqueSymbol("Ecd"));
pub const Pcd: Unit = defUnitFromUnit(si.cd, 1e15, .initUniqueSymbol("Pcd"));
pub const Tcd: Unit = defUnitFromUnit(si.cd, 1e12, .initUniqueSymbol("Tcd"));
pub const Gcd: Unit = defUnitFromUnit(si.cd, 1e9, .initUniqueSymbol("Gcd"));
pub const Mcd: Unit = defUnitFromUnit(si.cd, 1e6, .initUniqueSymbol("Mcd"));
pub const kcd: Unit = defUnitFromUnit(si.cd, 1e3, .initUniqueSymbol("kcd"));
pub const hcd: Unit = defUnitFromUnit(si.cd, 1e2, .initUniqueSymbol("hcd"));
pub const dacd: Unit = defUnitFromUnit(si.cd, 1e1, .initUniqueSymbol("dacd"));
pub const dcd: Unit = defUnitFromUnit(si.cd, 1e-1, .initUniqueSymbol("dcd"));
pub const ccd: Unit = defUnitFromUnit(si.cd, 1e-2, .initUniqueSymbol("ccd"));
pub const mcd: Unit = defUnitFromUnit(si.cd, 1e-3, .initUniqueSymbol("mcd"));
pub const ucd: Unit = defUnitFromUnit(si.cd, 1e-6, .initUniqueSymbol("ucd"));
pub const ncd: Unit = defUnitFromUnit(si.cd, 1e-9, .initUniqueSymbol("ncd"));
pub const pcd: Unit = defUnitFromUnit(si.cd, 1e-12, .initUniqueSymbol("pcd"));
pub const fcd: Unit = defUnitFromUnit(si.cd, 1e-15, .initUniqueSymbol("fcd"));
pub const acd: Unit = defUnitFromUnit(si.cd, 1e-18, .initUniqueSymbol("acd"));
pub const zcd: Unit = defUnitFromUnit(si.cd, 1e-21, .initUniqueSymbol("zcd"));
pub const ycd: Unit = defUnitFromUnit(si.cd, 1e-24, .initUniqueSymbol("ycd"));
pub const rcd: Unit = defUnitFromUnit(si.cd, 1e-27, .initUniqueSymbol("rcd"));
pub const qcd: Unit = defUnitFromUnit(si.cd, 1e-30, .initUniqueSymbol("qcd"));

// lm
pub const lm = si.lm;
pub const Qlm: Unit = defUnitFromUnit(si.lm, 1e30, .initUniqueSymbol("Qlm"));
pub const Rlm: Unit = defUnitFromUnit(si.lm, 1e27, .initUniqueSymbol("Rlm"));
pub const Ylm: Unit = defUnitFromUnit(si.lm, 1e24, .initUniqueSymbol("Ylm"));
pub const Zlm: Unit = defUnitFromUnit(si.lm, 1e21, .initUniqueSymbol("Zlm"));
pub const Elm: Unit = defUnitFromUnit(si.lm, 1e18, .initUniqueSymbol("Elm"));
pub const Plm: Unit = defUnitFromUnit(si.lm, 1e15, .initUniqueSymbol("Plm"));
pub const Tlm: Unit = defUnitFromUnit(si.lm, 1e12, .initUniqueSymbol("Tlm"));
pub const Glm: Unit = defUnitFromUnit(si.lm, 1e9, .initUniqueSymbol("Glm"));
pub const Mlm: Unit = defUnitFromUnit(si.lm, 1e6, .initUniqueSymbol("Mlm"));
pub const klm: Unit = defUnitFromUnit(si.lm, 1e3, .initUniqueSymbol("klm"));
pub const hlm: Unit = defUnitFromUnit(si.lm, 1e2, .initUniqueSymbol("hlm"));
pub const dalm: Unit = defUnitFromUnit(si.lm, 1e1, .initUniqueSymbol("dalm"));
pub const dlm: Unit = defUnitFromUnit(si.lm, 1e-1, .initUniqueSymbol("dlm"));
pub const clm: Unit = defUnitFromUnit(si.lm, 1e-2, .initUniqueSymbol("clm"));
pub const mlm: Unit = defUnitFromUnit(si.lm, 1e-3, .initUniqueSymbol("mlm"));
pub const ulm: Unit = defUnitFromUnit(si.lm, 1e-6, .initUniqueSymbol("ulm"));
pub const nlm: Unit = defUnitFromUnit(si.lm, 1e-9, .initUniqueSymbol("nlm"));
pub const plm: Unit = defUnitFromUnit(si.lm, 1e-12, .initUniqueSymbol("plm"));
pub const flm: Unit = defUnitFromUnit(si.lm, 1e-15, .initUniqueSymbol("flm"));
pub const alm: Unit = defUnitFromUnit(si.lm, 1e-18, .initUniqueSymbol("alm"));
pub const zlm: Unit = defUnitFromUnit(si.lm, 1e-21, .initUniqueSymbol("zlm"));
pub const ylm: Unit = defUnitFromUnit(si.lm, 1e-24, .initUniqueSymbol("ylm"));
pub const rlm: Unit = defUnitFromUnit(si.lm, 1e-27, .initUniqueSymbol("rlm"));
pub const qlm: Unit = defUnitFromUnit(si.lm, 1e-30, .initUniqueSymbol("qlm"));

// lx
pub const lx = si.lx;
pub const Qlx: Unit = defUnitFromUnit(si.lx, 1e30, .initUniqueSymbol("Qlx"));
pub const Rlx: Unit = defUnitFromUnit(si.lx, 1e27, .initUniqueSymbol("Rlx"));
pub const Ylx: Unit = defUnitFromUnit(si.lx, 1e24, .initUniqueSymbol("Ylx"));
pub const Zlx: Unit = defUnitFromUnit(si.lx, 1e21, .initUniqueSymbol("Zlx"));
pub const Elx: Unit = defUnitFromUnit(si.lx, 1e18, .initUniqueSymbol("Elx"));
pub const Plx: Unit = defUnitFromUnit(si.lx, 1e15, .initUniqueSymbol("Plx"));
pub const Tlx: Unit = defUnitFromUnit(si.lx, 1e12, .initUniqueSymbol("Tlx"));
pub const Glx: Unit = defUnitFromUnit(si.lx, 1e9, .initUniqueSymbol("Glx"));
pub const Mlx: Unit = defUnitFromUnit(si.lx, 1e6, .initUniqueSymbol("Mlx"));
pub const klx: Unit = defUnitFromUnit(si.lx, 1e3, .initUniqueSymbol("klx"));
pub const hlx: Unit = defUnitFromUnit(si.lx, 1e2, .initUniqueSymbol("hlx"));
pub const dalx: Unit = defUnitFromUnit(si.lx, 1e1, .initUniqueSymbol("dalx"));
pub const dlx: Unit = defUnitFromUnit(si.lx, 1e-1, .initUniqueSymbol("dlx"));
pub const clx: Unit = defUnitFromUnit(si.lx, 1e-2, .initUniqueSymbol("clx"));
pub const mlx: Unit = defUnitFromUnit(si.lx, 1e-3, .initUniqueSymbol("mlx"));
pub const ulx: Unit = defUnitFromUnit(si.lx, 1e-6, .initUniqueSymbol("ulx"));
pub const nlx: Unit = defUnitFromUnit(si.lx, 1e-9, .initUniqueSymbol("nlx"));
pub const plx: Unit = defUnitFromUnit(si.lx, 1e-12, .initUniqueSymbol("plx"));
pub const flx: Unit = defUnitFromUnit(si.lx, 1e-15, .initUniqueSymbol("flx"));
pub const alx: Unit = defUnitFromUnit(si.lx, 1e-18, .initUniqueSymbol("alx"));
pub const zlx: Unit = defUnitFromUnit(si.lx, 1e-21, .initUniqueSymbol("zlx"));
pub const ylx: Unit = defUnitFromUnit(si.lx, 1e-24, .initUniqueSymbol("ylx"));
pub const rlx: Unit = defUnitFromUnit(si.lx, 1e-27, .initUniqueSymbol("rlx"));
pub const qlx: Unit = defUnitFromUnit(si.lx, 1e-30, .initUniqueSymbol("qlx"));

// Bq
pub const Bq = si.Bq;
pub const QBq: Unit = defUnitFromUnit(si.Bq, 1e30, .initUniqueSymbol("QBq"));
pub const RBq: Unit = defUnitFromUnit(si.Bq, 1e27, .initUniqueSymbol("RBq"));
pub const YBq: Unit = defUnitFromUnit(si.Bq, 1e24, .initUniqueSymbol("YBq"));
pub const ZBq: Unit = defUnitFromUnit(si.Bq, 1e21, .initUniqueSymbol("ZBq"));
pub const EBq: Unit = defUnitFromUnit(si.Bq, 1e18, .initUniqueSymbol("EBq"));
pub const PBq: Unit = defUnitFromUnit(si.Bq, 1e15, .initUniqueSymbol("PBq"));
pub const TBq: Unit = defUnitFromUnit(si.Bq, 1e12, .initUniqueSymbol("TBq"));
pub const GBq: Unit = defUnitFromUnit(si.Bq, 1e9, .initUniqueSymbol("GBq"));
pub const MBq: Unit = defUnitFromUnit(si.Bq, 1e6, .initUniqueSymbol("MBq"));
pub const kBq: Unit = defUnitFromUnit(si.Bq, 1e3, .initUniqueSymbol("kBq"));
pub const hBq: Unit = defUnitFromUnit(si.Bq, 1e2, .initUniqueSymbol("hBq"));
pub const daBq: Unit = defUnitFromUnit(si.Bq, 1e1, .initUniqueSymbol("daBq"));
pub const dBq: Unit = defUnitFromUnit(si.Bq, 1e-1, .initUniqueSymbol("dBq"));
pub const cBq: Unit = defUnitFromUnit(si.Bq, 1e-2, .initUniqueSymbol("cBq"));
pub const mBq: Unit = defUnitFromUnit(si.Bq, 1e-3, .initUniqueSymbol("mBq"));
pub const uBq: Unit = defUnitFromUnit(si.Bq, 1e-6, .initUniqueSymbol("uBq"));
pub const nBq: Unit = defUnitFromUnit(si.Bq, 1e-9, .initUniqueSymbol("nBq"));
pub const pBq: Unit = defUnitFromUnit(si.Bq, 1e-12, .initUniqueSymbol("pBq"));
pub const fBq: Unit = defUnitFromUnit(si.Bq, 1e-15, .initUniqueSymbol("fBq"));
pub const aBq: Unit = defUnitFromUnit(si.Bq, 1e-18, .initUniqueSymbol("aBq"));
pub const zBq: Unit = defUnitFromUnit(si.Bq, 1e-21, .initUniqueSymbol("zBq"));
pub const yBq: Unit = defUnitFromUnit(si.Bq, 1e-24, .initUniqueSymbol("yBq"));
pub const rBq: Unit = defUnitFromUnit(si.Bq, 1e-27, .initUniqueSymbol("rBq"));
pub const qBq: Unit = defUnitFromUnit(si.Bq, 1e-30, .initUniqueSymbol("qBq"));

// Ci
pub const Ci = si.Ci;
pub const QCi: Unit = defUnitFromUnit(si.Ci, 1e30, .initUniqueSymbol("QCi"));
pub const RCi: Unit = defUnitFromUnit(si.Ci, 1e27, .initUniqueSymbol("RCi"));
pub const YCi: Unit = defUnitFromUnit(si.Ci, 1e24, .initUniqueSymbol("YCi"));
pub const ZCi: Unit = defUnitFromUnit(si.Ci, 1e21, .initUniqueSymbol("ZCi"));
pub const ECi: Unit = defUnitFromUnit(si.Ci, 1e18, .initUniqueSymbol("ECi"));
pub const PCi: Unit = defUnitFromUnit(si.Ci, 1e15, .initUniqueSymbol("PCi"));
pub const TCi: Unit = defUnitFromUnit(si.Ci, 1e12, .initUniqueSymbol("TCi"));
pub const GCi: Unit = defUnitFromUnit(si.Ci, 1e9, .initUniqueSymbol("GCi"));
pub const MCi: Unit = defUnitFromUnit(si.Ci, 1e6, .initUniqueSymbol("MCi"));
pub const kCi: Unit = defUnitFromUnit(si.Ci, 1e3, .initUniqueSymbol("kCi"));
pub const hCi: Unit = defUnitFromUnit(si.Ci, 1e2, .initUniqueSymbol("hCi"));
pub const daCi: Unit = defUnitFromUnit(si.Ci, 1e1, .initUniqueSymbol("daCi"));
pub const dCi: Unit = defUnitFromUnit(si.Ci, 1e-1, .initUniqueSymbol("dCi"));
pub const cCi: Unit = defUnitFromUnit(si.Ci, 1e-2, .initUniqueSymbol("cCi"));
pub const mCi: Unit = defUnitFromUnit(si.Ci, 1e-3, .initUniqueSymbol("mCi"));
pub const uCi: Unit = defUnitFromUnit(si.Ci, 1e-6, .initUniqueSymbol("uCi"));
pub const nCi: Unit = defUnitFromUnit(si.Ci, 1e-9, .initUniqueSymbol("nCi"));
pub const pCi: Unit = defUnitFromUnit(si.Ci, 1e-12, .initUniqueSymbol("pCi"));
pub const fCi: Unit = defUnitFromUnit(si.Ci, 1e-15, .initUniqueSymbol("fCi"));
pub const aCi: Unit = defUnitFromUnit(si.Ci, 1e-18, .initUniqueSymbol("aCi"));
pub const zCi: Unit = defUnitFromUnit(si.Ci, 1e-21, .initUniqueSymbol("zCi"));
pub const yCi: Unit = defUnitFromUnit(si.Ci, 1e-24, .initUniqueSymbol("yCi"));
pub const rCi: Unit = defUnitFromUnit(si.Ci, 1e-27, .initUniqueSymbol("rCi"));
pub const qCi: Unit = defUnitFromUnit(si.Ci, 1e-30, .initUniqueSymbol("qCi"));

// Gy
pub const Gy = si.Gy;
pub const QGy: Unit = defUnitFromUnit(si.Gy, 1e30, .initUniqueSymbol("QGy"));
pub const RGy: Unit = defUnitFromUnit(si.Gy, 1e27, .initUniqueSymbol("RGy"));
pub const YGy: Unit = defUnitFromUnit(si.Gy, 1e24, .initUniqueSymbol("YGy"));
pub const ZGy: Unit = defUnitFromUnit(si.Gy, 1e21, .initUniqueSymbol("ZGy"));
pub const EGy: Unit = defUnitFromUnit(si.Gy, 1e18, .initUniqueSymbol("EGy"));
pub const PGy: Unit = defUnitFromUnit(si.Gy, 1e15, .initUniqueSymbol("PGy"));
pub const TGy: Unit = defUnitFromUnit(si.Gy, 1e12, .initUniqueSymbol("TGy"));
pub const GGy: Unit = defUnitFromUnit(si.Gy, 1e9, .initUniqueSymbol("GGy"));
pub const MGy: Unit = defUnitFromUnit(si.Gy, 1e6, .initUniqueSymbol("MGy"));
pub const kGy: Unit = defUnitFromUnit(si.Gy, 1e3, .initUniqueSymbol("kGy"));
pub const hGy: Unit = defUnitFromUnit(si.Gy, 1e2, .initUniqueSymbol("hGy"));
pub const daGy: Unit = defUnitFromUnit(si.Gy, 1e1, .initUniqueSymbol("daGy"));
pub const dGy: Unit = defUnitFromUnit(si.Gy, 1e-1, .initUniqueSymbol("dGy"));
pub const cGy: Unit = defUnitFromUnit(si.Gy, 1e-2, .initUniqueSymbol("cGy"));
pub const mGy: Unit = defUnitFromUnit(si.Gy, 1e-3, .initUniqueSymbol("mGy"));
pub const uGy: Unit = defUnitFromUnit(si.Gy, 1e-6, .initUniqueSymbol("uGy"));
pub const nGy: Unit = defUnitFromUnit(si.Gy, 1e-9, .initUniqueSymbol("nGy"));
pub const pGy: Unit = defUnitFromUnit(si.Gy, 1e-12, .initUniqueSymbol("pGy"));
pub const fGy: Unit = defUnitFromUnit(si.Gy, 1e-15, .initUniqueSymbol("fGy"));
pub const aGy: Unit = defUnitFromUnit(si.Gy, 1e-18, .initUniqueSymbol("aGy"));
pub const zGy: Unit = defUnitFromUnit(si.Gy, 1e-21, .initUniqueSymbol("zGy"));
pub const yGy: Unit = defUnitFromUnit(si.Gy, 1e-24, .initUniqueSymbol("yGy"));
pub const rGy: Unit = defUnitFromUnit(si.Gy, 1e-27, .initUniqueSymbol("rGy"));
pub const qGy: Unit = defUnitFromUnit(si.Gy, 1e-30, .initUniqueSymbol("qGy"));

// Sv
pub const Sv = si.Sv;
pub const QSv: Unit = defUnitFromUnit(si.Sv, 1e30, .initUniqueSymbol("QSv"));
pub const RSv: Unit = defUnitFromUnit(si.Sv, 1e27, .initUniqueSymbol("RSv"));
pub const YSv: Unit = defUnitFromUnit(si.Sv, 1e24, .initUniqueSymbol("YSv"));
pub const ZSv: Unit = defUnitFromUnit(si.Sv, 1e21, .initUniqueSymbol("ZSv"));
pub const ESv: Unit = defUnitFromUnit(si.Sv, 1e18, .initUniqueSymbol("ESv"));
pub const PSv: Unit = defUnitFromUnit(si.Sv, 1e15, .initUniqueSymbol("PSv"));
pub const TSv: Unit = defUnitFromUnit(si.Sv, 1e12, .initUniqueSymbol("TSv"));
pub const GSv: Unit = defUnitFromUnit(si.Sv, 1e9, .initUniqueSymbol("GSv"));
pub const MSv: Unit = defUnitFromUnit(si.Sv, 1e6, .initUniqueSymbol("MSv"));
pub const kSv: Unit = defUnitFromUnit(si.Sv, 1e3, .initUniqueSymbol("kSv"));
pub const hSv: Unit = defUnitFromUnit(si.Sv, 1e2, .initUniqueSymbol("hSv"));
pub const daSv: Unit = defUnitFromUnit(si.Sv, 1e1, .initUniqueSymbol("daSv"));
pub const dSv: Unit = defUnitFromUnit(si.Sv, 1e-1, .initUniqueSymbol("dSv"));
pub const cSv: Unit = defUnitFromUnit(si.Sv, 1e-2, .initUniqueSymbol("cSv"));
pub const mSv: Unit = defUnitFromUnit(si.Sv, 1e-3, .initUniqueSymbol("mSv"));
pub const uSv: Unit = defUnitFromUnit(si.Sv, 1e-6, .initUniqueSymbol("uSv"));
pub const nSv: Unit = defUnitFromUnit(si.Sv, 1e-9, .initUniqueSymbol("nSv"));
pub const pSv: Unit = defUnitFromUnit(si.Sv, 1e-12, .initUniqueSymbol("pSv"));
pub const fSv: Unit = defUnitFromUnit(si.Sv, 1e-15, .initUniqueSymbol("fSv"));
pub const aSv: Unit = defUnitFromUnit(si.Sv, 1e-18, .initUniqueSymbol("aSv"));
pub const zSv: Unit = defUnitFromUnit(si.Sv, 1e-21, .initUniqueSymbol("zSv"));
pub const ySv: Unit = defUnitFromUnit(si.Sv, 1e-24, .initUniqueSymbol("ySv"));
pub const rSv: Unit = defUnitFromUnit(si.Sv, 1e-27, .initUniqueSymbol("rSv"));
pub const qSv: Unit = defUnitFromUnit(si.Sv, 1e-30, .initUniqueSymbol("qSv"));

//////////////////////////////////////////////////////
// CGS
//////////////////////////////////////////////////////

// Gal
pub const Gal = cgs.Gal;
pub const QGal: Unit = defUnitFromUnit(cgs.Gal, 1e30, .initUniqueSymbol("QGal"));
pub const RGal: Unit = defUnitFromUnit(cgs.Gal, 1e27, .initUniqueSymbol("RGal"));
pub const YGal: Unit = defUnitFromUnit(cgs.Gal, 1e24, .initUniqueSymbol("YGal"));
pub const ZGal: Unit = defUnitFromUnit(cgs.Gal, 1e21, .initUniqueSymbol("ZGal"));
pub const EGal: Unit = defUnitFromUnit(cgs.Gal, 1e18, .initUniqueSymbol("EGal"));
pub const PGal: Unit = defUnitFromUnit(cgs.Gal, 1e15, .initUniqueSymbol("PGal"));
pub const TGal: Unit = defUnitFromUnit(cgs.Gal, 1e12, .initUniqueSymbol("TGal"));
pub const GGal: Unit = defUnitFromUnit(cgs.Gal, 1e9, .initUniqueSymbol("GGal"));
pub const MGal: Unit = defUnitFromUnit(cgs.Gal, 1e6, .initUniqueSymbol("MGal"));
pub const kGal: Unit = defUnitFromUnit(cgs.Gal, 1e3, .initUniqueSymbol("kGal"));
pub const hGal: Unit = defUnitFromUnit(cgs.Gal, 1e2, .initUniqueSymbol("hGal"));
pub const daGal: Unit = defUnitFromUnit(cgs.Gal, 1e1, .initUniqueSymbol("daGal"));
pub const dGal: Unit = defUnitFromUnit(cgs.Gal, 1e-1, .initUniqueSymbol("dGal"));
pub const cGal: Unit = defUnitFromUnit(cgs.Gal, 1e-2, .initUniqueSymbol("cGal"));
pub const mGal: Unit = defUnitFromUnit(cgs.Gal, 1e-3, .initUniqueSymbol("mGal"));
pub const uGal: Unit = defUnitFromUnit(cgs.Gal, 1e-6, .initUniqueSymbol("uGal"));
pub const nGal: Unit = defUnitFromUnit(cgs.Gal, 1e-9, .initUniqueSymbol("nGal"));
pub const pGal: Unit = defUnitFromUnit(cgs.Gal, 1e-12, .initUniqueSymbol("pGal"));
pub const fGal: Unit = defUnitFromUnit(cgs.Gal, 1e-15, .initUniqueSymbol("fGal"));
pub const aGal: Unit = defUnitFromUnit(cgs.Gal, 1e-18, .initUniqueSymbol("aGal"));
pub const zGal: Unit = defUnitFromUnit(cgs.Gal, 1e-21, .initUniqueSymbol("zGal"));
pub const yGal: Unit = defUnitFromUnit(cgs.Gal, 1e-24, .initUniqueSymbol("yGal"));
pub const rGal: Unit = defUnitFromUnit(cgs.Gal, 1e-27, .initUniqueSymbol("rGal"));
pub const qGal: Unit = defUnitFromUnit(cgs.Gal, 1e-30, .initUniqueSymbol("qGal"));

// erg
pub const erg = cgs.erg;
pub const Qerg: Unit = defUnitFromUnit(cgs.erg, 1e30, .initUniqueSymbol("Qerg"));
pub const Rerg: Unit = defUnitFromUnit(cgs.erg, 1e27, .initUniqueSymbol("Rerg"));
pub const Yerg: Unit = defUnitFromUnit(cgs.erg, 1e24, .initUniqueSymbol("Yerg"));
pub const Zerg: Unit = defUnitFromUnit(cgs.erg, 1e21, .initUniqueSymbol("Zerg"));
pub const Eerg: Unit = defUnitFromUnit(cgs.erg, 1e18, .initUniqueSymbol("Eerg"));
pub const Perg: Unit = defUnitFromUnit(cgs.erg, 1e15, .initUniqueSymbol("Perg"));
pub const Terg: Unit = defUnitFromUnit(cgs.erg, 1e12, .initUniqueSymbol("Terg"));
pub const Gerg: Unit = defUnitFromUnit(cgs.erg, 1e9, .initUniqueSymbol("Gerg"));
pub const Merg: Unit = defUnitFromUnit(cgs.erg, 1e6, .initUniqueSymbol("Merg"));
pub const kerg: Unit = defUnitFromUnit(cgs.erg, 1e3, .initUniqueSymbol("kerg"));
pub const herg: Unit = defUnitFromUnit(cgs.erg, 1e2, .initUniqueSymbol("herg"));
pub const daerg: Unit = defUnitFromUnit(cgs.erg, 1e1, .initUniqueSymbol("daerg"));
pub const derg: Unit = defUnitFromUnit(cgs.erg, 1e-1, .initUniqueSymbol("derg"));
pub const cerg: Unit = defUnitFromUnit(cgs.erg, 1e-2, .initUniqueSymbol("cerg"));
pub const merg: Unit = defUnitFromUnit(cgs.erg, 1e-3, .initUniqueSymbol("merg"));
pub const uerg: Unit = defUnitFromUnit(cgs.erg, 1e-6, .initUniqueSymbol("uerg"));
pub const nerg: Unit = defUnitFromUnit(cgs.erg, 1e-9, .initUniqueSymbol("nerg"));
pub const perg: Unit = defUnitFromUnit(cgs.erg, 1e-12, .initUniqueSymbol("perg"));
pub const ferg: Unit = defUnitFromUnit(cgs.erg, 1e-15, .initUniqueSymbol("ferg"));
pub const aerg: Unit = defUnitFromUnit(cgs.erg, 1e-18, .initUniqueSymbol("aerg"));
pub const zerg: Unit = defUnitFromUnit(cgs.erg, 1e-21, .initUniqueSymbol("zerg"));
pub const yerg: Unit = defUnitFromUnit(cgs.erg, 1e-24, .initUniqueSymbol("yerg"));
pub const rerg: Unit = defUnitFromUnit(cgs.erg, 1e-27, .initUniqueSymbol("rerg"));
pub const qerg: Unit = defUnitFromUnit(cgs.erg, 1e-30, .initUniqueSymbol("qerg"));

// dyn
pub const dyn = cgs.dyn;
pub const Qdyn: Unit = defUnitFromUnit(cgs.dyn, 1e30, .initUniqueSymbol("Qdyn"));
pub const Rdyn: Unit = defUnitFromUnit(cgs.dyn, 1e27, .initUniqueSymbol("Rdyn"));
pub const Ydyn: Unit = defUnitFromUnit(cgs.dyn, 1e24, .initUniqueSymbol("Ydyn"));
pub const Zdyn: Unit = defUnitFromUnit(cgs.dyn, 1e21, .initUniqueSymbol("Zdyn"));
pub const Edyn: Unit = defUnitFromUnit(cgs.dyn, 1e18, .initUniqueSymbol("Edyn"));
pub const Pdyn: Unit = defUnitFromUnit(cgs.dyn, 1e15, .initUniqueSymbol("Pdyn"));
pub const Tdyn: Unit = defUnitFromUnit(cgs.dyn, 1e12, .initUniqueSymbol("Tdyn"));
pub const Gdyn: Unit = defUnitFromUnit(cgs.dyn, 1e9, .initUniqueSymbol("Gdyn"));
pub const Mdyn: Unit = defUnitFromUnit(cgs.dyn, 1e6, .initUniqueSymbol("Mdyn"));
pub const kdyn: Unit = defUnitFromUnit(cgs.dyn, 1e3, .initUniqueSymbol("kdyn"));
pub const hdyn: Unit = defUnitFromUnit(cgs.dyn, 1e2, .initUniqueSymbol("hdyn"));
pub const dadyn: Unit = defUnitFromUnit(cgs.dyn, 1e1, .initUniqueSymbol("dadyn"));
pub const ddyn: Unit = defUnitFromUnit(cgs.dyn, 1e-1, .initUniqueSymbol("ddyn"));
pub const cdyn: Unit = defUnitFromUnit(cgs.dyn, 1e-2, .initUniqueSymbol("cdyn"));
pub const mdyn: Unit = defUnitFromUnit(cgs.dyn, 1e-3, .initUniqueSymbol("mdyn"));
pub const udyn: Unit = defUnitFromUnit(cgs.dyn, 1e-6, .initUniqueSymbol("udyn"));
pub const ndyn: Unit = defUnitFromUnit(cgs.dyn, 1e-9, .initUniqueSymbol("ndyn"));
pub const pdyn: Unit = defUnitFromUnit(cgs.dyn, 1e-12, .initUniqueSymbol("pdyn"));
pub const fdyn: Unit = defUnitFromUnit(cgs.dyn, 1e-15, .initUniqueSymbol("fdyn"));
pub const adyn: Unit = defUnitFromUnit(cgs.dyn, 1e-18, .initUniqueSymbol("adyn"));
pub const zdyn: Unit = defUnitFromUnit(cgs.dyn, 1e-21, .initUniqueSymbol("zdyn"));
pub const ydyn: Unit = defUnitFromUnit(cgs.dyn, 1e-24, .initUniqueSymbol("ydyn"));
pub const rdyn: Unit = defUnitFromUnit(cgs.dyn, 1e-27, .initUniqueSymbol("rdyn"));
pub const qdyn: Unit = defUnitFromUnit(cgs.dyn, 1e-30, .initUniqueSymbol("qdyn"));

// Ba
pub const Ba = cgs.Ba;
pub const QBa: Unit = defUnitFromUnit(cgs.Ba, 1e30, .initUniqueSymbol("QBa"));
pub const RBa: Unit = defUnitFromUnit(cgs.Ba, 1e27, .initUniqueSymbol("RBa"));
pub const YBa: Unit = defUnitFromUnit(cgs.Ba, 1e24, .initUniqueSymbol("YBa"));
pub const ZBa: Unit = defUnitFromUnit(cgs.Ba, 1e21, .initUniqueSymbol("ZBa"));
pub const EBa: Unit = defUnitFromUnit(cgs.Ba, 1e18, .initUniqueSymbol("EBa"));
pub const PBa: Unit = defUnitFromUnit(cgs.Ba, 1e15, .initUniqueSymbol("PBa"));
pub const TBa: Unit = defUnitFromUnit(cgs.Ba, 1e12, .initUniqueSymbol("TBa"));
pub const GBa: Unit = defUnitFromUnit(cgs.Ba, 1e9, .initUniqueSymbol("GBa"));
pub const MBa: Unit = defUnitFromUnit(cgs.Ba, 1e6, .initUniqueSymbol("MBa"));
pub const kBa: Unit = defUnitFromUnit(cgs.Ba, 1e3, .initUniqueSymbol("kBa"));
pub const hBa: Unit = defUnitFromUnit(cgs.Ba, 1e2, .initUniqueSymbol("hBa"));
pub const daBa: Unit = defUnitFromUnit(cgs.Ba, 1e1, .initUniqueSymbol("daBa"));
pub const dBa: Unit = defUnitFromUnit(cgs.Ba, 1e-1, .initUniqueSymbol("dBa"));
pub const cBa: Unit = defUnitFromUnit(cgs.Ba, 1e-2, .initUniqueSymbol("cBa"));
pub const mBa: Unit = defUnitFromUnit(cgs.Ba, 1e-3, .initUniqueSymbol("mBa"));
pub const uBa: Unit = defUnitFromUnit(cgs.Ba, 1e-6, .initUniqueSymbol("uBa"));
pub const nBa: Unit = defUnitFromUnit(cgs.Ba, 1e-9, .initUniqueSymbol("nBa"));
pub const pBa: Unit = defUnitFromUnit(cgs.Ba, 1e-12, .initUniqueSymbol("pBa"));
pub const fBa: Unit = defUnitFromUnit(cgs.Ba, 1e-15, .initUniqueSymbol("fBa"));
pub const aBa: Unit = defUnitFromUnit(cgs.Ba, 1e-18, .initUniqueSymbol("aBa"));
pub const zBa: Unit = defUnitFromUnit(cgs.Ba, 1e-21, .initUniqueSymbol("zBa"));
pub const yBa: Unit = defUnitFromUnit(cgs.Ba, 1e-24, .initUniqueSymbol("yBa"));
pub const rBa: Unit = defUnitFromUnit(cgs.Ba, 1e-27, .initUniqueSymbol("rBa"));
pub const qBa: Unit = defUnitFromUnit(cgs.Ba, 1e-30, .initUniqueSymbol("qBa"));

// P
pub const P = cgs.P;
pub const QP: Unit = defUnitFromUnit(cgs.P, 1e30, .initUniqueSymbol("QP"));
pub const RP: Unit = defUnitFromUnit(cgs.P, 1e27, .initUniqueSymbol("RP"));
pub const YP: Unit = defUnitFromUnit(cgs.P, 1e24, .initUniqueSymbol("YP"));
pub const ZP: Unit = defUnitFromUnit(cgs.P, 1e21, .initUniqueSymbol("ZP"));
pub const EP: Unit = defUnitFromUnit(cgs.P, 1e18, .initUniqueSymbol("EP"));
pub const PP: Unit = defUnitFromUnit(cgs.P, 1e15, .initUniqueSymbol("PP"));
pub const TP: Unit = defUnitFromUnit(cgs.P, 1e12, .initUniqueSymbol("TP"));
pub const GP: Unit = defUnitFromUnit(cgs.P, 1e9, .initUniqueSymbol("GP"));
pub const MP: Unit = defUnitFromUnit(cgs.P, 1e6, .initUniqueSymbol("MP"));
pub const kP: Unit = defUnitFromUnit(cgs.P, 1e3, .initUniqueSymbol("kP"));
pub const hP: Unit = defUnitFromUnit(cgs.P, 1e2, .initUniqueSymbol("hP"));
pub const daP: Unit = defUnitFromUnit(cgs.P, 1e1, .initUniqueSymbol("daP"));
pub const dP: Unit = defUnitFromUnit(cgs.P, 1e-1, .initUniqueSymbol("dP"));
pub const cP: Unit = defUnitFromUnit(cgs.P, 1e-2, .initUniqueSymbol("cP"));
pub const mP: Unit = defUnitFromUnit(cgs.P, 1e-3, .initUniqueSymbol("mP"));
pub const uP: Unit = defUnitFromUnit(cgs.P, 1e-6, .initUniqueSymbol("uP"));
pub const nP: Unit = defUnitFromUnit(cgs.P, 1e-9, .initUniqueSymbol("nP"));
pub const pP: Unit = defUnitFromUnit(cgs.P, 1e-12, .initUniqueSymbol("pP"));
pub const fP: Unit = defUnitFromUnit(cgs.P, 1e-15, .initUniqueSymbol("fP"));
pub const aP: Unit = defUnitFromUnit(cgs.P, 1e-18, .initUniqueSymbol("aP"));
pub const zP: Unit = defUnitFromUnit(cgs.P, 1e-21, .initUniqueSymbol("zP"));
pub const yP: Unit = defUnitFromUnit(cgs.P, 1e-24, .initUniqueSymbol("yP"));
pub const rP: Unit = defUnitFromUnit(cgs.P, 1e-27, .initUniqueSymbol("rP"));
pub const qP: Unit = defUnitFromUnit(cgs.P, 1e-30, .initUniqueSymbol("qP"));

// St
pub const St = cgs.St;
pub const QSt: Unit = defUnitFromUnit(cgs.St, 1e30, .initUniqueSymbol("QSt"));
pub const RSt: Unit = defUnitFromUnit(cgs.St, 1e27, .initUniqueSymbol("RSt"));
pub const YSt: Unit = defUnitFromUnit(cgs.St, 1e24, .initUniqueSymbol("YSt"));
pub const ZSt: Unit = defUnitFromUnit(cgs.St, 1e21, .initUniqueSymbol("ZSt"));
pub const ESt: Unit = defUnitFromUnit(cgs.St, 1e18, .initUniqueSymbol("ESt"));
pub const PSt: Unit = defUnitFromUnit(cgs.St, 1e15, .initUniqueSymbol("PSt"));
pub const TSt: Unit = defUnitFromUnit(cgs.St, 1e12, .initUniqueSymbol("TSt"));
pub const GSt: Unit = defUnitFromUnit(cgs.St, 1e9, .initUniqueSymbol("GSt"));
pub const MSt: Unit = defUnitFromUnit(cgs.St, 1e6, .initUniqueSymbol("MSt"));
pub const kSt: Unit = defUnitFromUnit(cgs.St, 1e3, .initUniqueSymbol("kSt"));
pub const hSt: Unit = defUnitFromUnit(cgs.St, 1e2, .initUniqueSymbol("hSt"));
pub const daSt: Unit = defUnitFromUnit(cgs.St, 1e1, .initUniqueSymbol("daSt"));
pub const dSt: Unit = defUnitFromUnit(cgs.St, 1e-1, .initUniqueSymbol("dSt"));
pub const cSt: Unit = defUnitFromUnit(cgs.St, 1e-2, .initUniqueSymbol("cSt"));
pub const mSt: Unit = defUnitFromUnit(cgs.St, 1e-3, .initUniqueSymbol("mSt"));
pub const uSt: Unit = defUnitFromUnit(cgs.St, 1e-6, .initUniqueSymbol("uSt"));
pub const nSt: Unit = defUnitFromUnit(cgs.St, 1e-9, .initUniqueSymbol("nSt"));
pub const pSt: Unit = defUnitFromUnit(cgs.St, 1e-12, .initUniqueSymbol("pSt"));
pub const fSt: Unit = defUnitFromUnit(cgs.St, 1e-15, .initUniqueSymbol("fSt"));
pub const aSt: Unit = defUnitFromUnit(cgs.St, 1e-18, .initUniqueSymbol("aSt"));
pub const zSt: Unit = defUnitFromUnit(cgs.St, 1e-21, .initUniqueSymbol("zSt"));
pub const ySt: Unit = defUnitFromUnit(cgs.St, 1e-24, .initUniqueSymbol("ySt"));
pub const rSt: Unit = defUnitFromUnit(cgs.St, 1e-27, .initUniqueSymbol("rSt"));
pub const qSt: Unit = defUnitFromUnit(cgs.St, 1e-30, .initUniqueSymbol("qSt"));

// k
pub const k = cgs.k;
pub const Qk: Unit = defUnitFromUnit(cgs.k, 1e30, .initUniqueSymbol("Qk"));
pub const Rk: Unit = defUnitFromUnit(cgs.k, 1e27, .initUniqueSymbol("Rk"));
pub const Yk: Unit = defUnitFromUnit(cgs.k, 1e24, .initUniqueSymbol("Yk"));
pub const Zk: Unit = defUnitFromUnit(cgs.k, 1e21, .initUniqueSymbol("Zk"));
pub const Ek: Unit = defUnitFromUnit(cgs.k, 1e18, .initUniqueSymbol("Ek"));
pub const Pk: Unit = defUnitFromUnit(cgs.k, 1e15, .initUniqueSymbol("Pk"));
pub const Tk: Unit = defUnitFromUnit(cgs.k, 1e12, .initUniqueSymbol("Tk"));
pub const Gk: Unit = defUnitFromUnit(cgs.k, 1e9, .initUniqueSymbol("Gk"));
pub const Mk: Unit = defUnitFromUnit(cgs.k, 1e6, .initUniqueSymbol("Mk"));
pub const kk: Unit = defUnitFromUnit(cgs.k, 1e3, .initUniqueSymbol("kk"));
pub const hk: Unit = defUnitFromUnit(cgs.k, 1e2, .initUniqueSymbol("hk"));
pub const dak: Unit = defUnitFromUnit(cgs.k, 1e1, .initUniqueSymbol("dak"));
pub const dk: Unit = defUnitFromUnit(cgs.k, 1e-1, .initUniqueSymbol("dk"));
pub const ck: Unit = defUnitFromUnit(cgs.k, 1e-2, .initUniqueSymbol("ck"));
pub const mk: Unit = defUnitFromUnit(cgs.k, 1e-3, .initUniqueSymbol("mk"));
pub const uk: Unit = defUnitFromUnit(cgs.k, 1e-6, .initUniqueSymbol("uk"));
pub const nk: Unit = defUnitFromUnit(cgs.k, 1e-9, .initUniqueSymbol("nk"));
pub const pk: Unit = defUnitFromUnit(cgs.k, 1e-12, .initUniqueSymbol("pk"));
pub const fk: Unit = defUnitFromUnit(cgs.k, 1e-15, .initUniqueSymbol("fk"));
pub const ak: Unit = defUnitFromUnit(cgs.k, 1e-18, .initUniqueSymbol("ak"));
pub const zk: Unit = defUnitFromUnit(cgs.k, 1e-21, .initUniqueSymbol("zk"));
pub const yk: Unit = defUnitFromUnit(cgs.k, 1e-24, .initUniqueSymbol("yk"));
pub const rk: Unit = defUnitFromUnit(cgs.k, 1e-27, .initUniqueSymbol("rk"));
pub const qk: Unit = defUnitFromUnit(cgs.k, 1e-30, .initUniqueSymbol("qk"));

// D
pub const D = cgs.D;
pub const QD: Unit = defUnitFromUnit(cgs.D, 1e30, .initUniqueSymbol("QD"));
pub const RD: Unit = defUnitFromUnit(cgs.D, 1e27, .initUniqueSymbol("RD"));
pub const YD: Unit = defUnitFromUnit(cgs.D, 1e24, .initUniqueSymbol("YD"));
pub const ZD: Unit = defUnitFromUnit(cgs.D, 1e21, .initUniqueSymbol("ZD"));
pub const ED: Unit = defUnitFromUnit(cgs.D, 1e18, .initUniqueSymbol("ED"));
pub const PD: Unit = defUnitFromUnit(cgs.D, 1e15, .initUniqueSymbol("PD"));
pub const TD: Unit = defUnitFromUnit(cgs.D, 1e12, .initUniqueSymbol("TD"));
pub const GD: Unit = defUnitFromUnit(cgs.D, 1e9, .initUniqueSymbol("GD"));
pub const MD: Unit = defUnitFromUnit(cgs.D, 1e6, .initUniqueSymbol("MD"));
pub const kD: Unit = defUnitFromUnit(cgs.D, 1e3, .initUniqueSymbol("kD"));
pub const hD: Unit = defUnitFromUnit(cgs.D, 1e2, .initUniqueSymbol("hD"));
pub const daD: Unit = defUnitFromUnit(cgs.D, 1e1, .initUniqueSymbol("daD"));
pub const dD: Unit = defUnitFromUnit(cgs.D, 1e-1, .initUniqueSymbol("dD"));
pub const cD: Unit = defUnitFromUnit(cgs.D, 1e-2, .initUniqueSymbol("cD"));
pub const mD: Unit = defUnitFromUnit(cgs.D, 1e-3, .initUniqueSymbol("mD"));
pub const uD: Unit = defUnitFromUnit(cgs.D, 1e-6, .initUniqueSymbol("uD"));
pub const nD: Unit = defUnitFromUnit(cgs.D, 1e-9, .initUniqueSymbol("nD"));
pub const pD: Unit = defUnitFromUnit(cgs.D, 1e-12, .initUniqueSymbol("pD"));
pub const fD: Unit = defUnitFromUnit(cgs.D, 1e-15, .initUniqueSymbol("fD"));
pub const aD: Unit = defUnitFromUnit(cgs.D, 1e-18, .initUniqueSymbol("aD"));
pub const zD: Unit = defUnitFromUnit(cgs.D, 1e-21, .initUniqueSymbol("zD"));
pub const yD: Unit = defUnitFromUnit(cgs.D, 1e-24, .initUniqueSymbol("yD"));
pub const rD: Unit = defUnitFromUnit(cgs.D, 1e-27, .initUniqueSymbol("rD"));
pub const qD: Unit = defUnitFromUnit(cgs.D, 1e-30, .initUniqueSymbol("qD"));

// Fr
pub const Fr = cgs.Fr;

// statA
pub const statA = cgs.statA;

// Bi
pub const Bi = cgs.Bi;

// abC
pub const abC = cgs.abC;

// G
pub const G = cgs.G;
pub const QG: Unit = defUnitFromUnit(cgs.G, 1e30, .initUniqueSymbol("QG"));
pub const RG: Unit = defUnitFromUnit(cgs.G, 1e27, .initUniqueSymbol("RG"));
pub const YG: Unit = defUnitFromUnit(cgs.G, 1e24, .initUniqueSymbol("YG"));
pub const ZG: Unit = defUnitFromUnit(cgs.G, 1e21, .initUniqueSymbol("ZG"));
pub const EG: Unit = defUnitFromUnit(cgs.G, 1e18, .initUniqueSymbol("EG"));
pub const PG: Unit = defUnitFromUnit(cgs.G, 1e15, .initUniqueSymbol("PG"));
pub const TG: Unit = defUnitFromUnit(cgs.G, 1e12, .initUniqueSymbol("TG"));
pub const GG: Unit = defUnitFromUnit(cgs.G, 1e9, .initUniqueSymbol("GG"));
pub const MG: Unit = defUnitFromUnit(cgs.G, 1e6, .initUniqueSymbol("MG"));
pub const kG: Unit = defUnitFromUnit(cgs.G, 1e3, .initUniqueSymbol("kG"));
pub const hG: Unit = defUnitFromUnit(cgs.G, 1e2, .initUniqueSymbol("hG"));
pub const daG: Unit = defUnitFromUnit(cgs.G, 1e1, .initUniqueSymbol("daG"));
pub const dG: Unit = defUnitFromUnit(cgs.G, 1e-1, .initUniqueSymbol("dG"));
pub const cG: Unit = defUnitFromUnit(cgs.G, 1e-2, .initUniqueSymbol("cG"));
pub const mG: Unit = defUnitFromUnit(cgs.G, 1e-3, .initUniqueSymbol("mG"));
pub const uG: Unit = defUnitFromUnit(cgs.G, 1e-6, .initUniqueSymbol("uG"));
pub const nG: Unit = defUnitFromUnit(cgs.G, 1e-9, .initUniqueSymbol("nG"));
pub const pG: Unit = defUnitFromUnit(cgs.G, 1e-12, .initUniqueSymbol("pG"));
pub const fG: Unit = defUnitFromUnit(cgs.G, 1e-15, .initUniqueSymbol("fG"));
pub const aG: Unit = defUnitFromUnit(cgs.G, 1e-18, .initUniqueSymbol("aG"));
pub const zG: Unit = defUnitFromUnit(cgs.G, 1e-21, .initUniqueSymbol("zG"));
pub const yG: Unit = defUnitFromUnit(cgs.G, 1e-24, .initUniqueSymbol("yG"));
pub const rG: Unit = defUnitFromUnit(cgs.G, 1e-27, .initUniqueSymbol("rG"));
pub const qG: Unit = defUnitFromUnit(cgs.G, 1e-30, .initUniqueSymbol("qG"));

// Mx
pub const Mx = cgs.Mx;

// Oe
pub const Oe = cgs.Oe;
pub const QOe: Unit = defUnitFromUnit(cgs.Oe, 1e30, .initUniqueSymbol("QOe"));
pub const ROe: Unit = defUnitFromUnit(cgs.Oe, 1e27, .initUniqueSymbol("ROe"));
pub const YOe: Unit = defUnitFromUnit(cgs.Oe, 1e24, .initUniqueSymbol("YOe"));
pub const ZOe: Unit = defUnitFromUnit(cgs.Oe, 1e21, .initUniqueSymbol("ZOe"));
pub const EOe: Unit = defUnitFromUnit(cgs.Oe, 1e18, .initUniqueSymbol("EOe"));
pub const POe: Unit = defUnitFromUnit(cgs.Oe, 1e15, .initUniqueSymbol("POe"));
pub const TOe: Unit = defUnitFromUnit(cgs.Oe, 1e12, .initUniqueSymbol("TOe"));
pub const GOe: Unit = defUnitFromUnit(cgs.Oe, 1e9, .initUniqueSymbol("GOe"));
pub const MOe: Unit = defUnitFromUnit(cgs.Oe, 1e6, .initUniqueSymbol("MOe"));
pub const kOe: Unit = defUnitFromUnit(cgs.Oe, 1e3, .initUniqueSymbol("kOe"));
pub const hOe: Unit = defUnitFromUnit(cgs.Oe, 1e2, .initUniqueSymbol("hOe"));
pub const daOe: Unit = defUnitFromUnit(cgs.Oe, 1e1, .initUniqueSymbol("daOe"));
pub const dOe: Unit = defUnitFromUnit(cgs.Oe, 1e-1, .initUniqueSymbol("dOe"));
pub const cOe: Unit = defUnitFromUnit(cgs.Oe, 1e-2, .initUniqueSymbol("cOe"));
pub const mOe: Unit = defUnitFromUnit(cgs.Oe, 1e-3, .initUniqueSymbol("mOe"));
pub const uOe: Unit = defUnitFromUnit(cgs.Oe, 1e-6, .initUniqueSymbol("uOe"));
pub const nOe: Unit = defUnitFromUnit(cgs.Oe, 1e-9, .initUniqueSymbol("nOe"));
pub const pOe: Unit = defUnitFromUnit(cgs.Oe, 1e-12, .initUniqueSymbol("pOe"));
pub const fOe: Unit = defUnitFromUnit(cgs.Oe, 1e-15, .initUniqueSymbol("fOe"));
pub const aOe: Unit = defUnitFromUnit(cgs.Oe, 1e-18, .initUniqueSymbol("aOe"));
pub const zOe: Unit = defUnitFromUnit(cgs.Oe, 1e-21, .initUniqueSymbol("zOe"));
pub const yOe: Unit = defUnitFromUnit(cgs.Oe, 1e-24, .initUniqueSymbol("yOe"));
pub const rOe: Unit = defUnitFromUnit(cgs.Oe, 1e-27, .initUniqueSymbol("rOe"));
pub const qOe: Unit = defUnitFromUnit(cgs.Oe, 1e-30, .initUniqueSymbol("qOe"));

//////////////////////////////////////////////////////
// PHOTOMETRIC
//////////////////////////////////////////////////////

// Bol
pub const Bol = photometric.Bol;

// bol
pub const bol = photometric.bol;

// AB
pub const AB = photometric.AB;

// ST
pub const ST = photometric.ST;

// mgy
pub const mgy = photometric.mgy;
pub const Qmgy: Unit = defUnitFromUnit(photometric.mgy, 1e30, .initUniqueSymbol("Qmgy"));
pub const Rmgy: Unit = defUnitFromUnit(photometric.mgy, 1e27, .initUniqueSymbol("Rmgy"));
pub const Ymgy: Unit = defUnitFromUnit(photometric.mgy, 1e24, .initUniqueSymbol("Ymgy"));
pub const Zmgy: Unit = defUnitFromUnit(photometric.mgy, 1e21, .initUniqueSymbol("Zmgy"));
pub const Emgy: Unit = defUnitFromUnit(photometric.mgy, 1e18, .initUniqueSymbol("Emgy"));
pub const Pmgy: Unit = defUnitFromUnit(photometric.mgy, 1e15, .initUniqueSymbol("Pmgy"));
pub const Tmgy: Unit = defUnitFromUnit(photometric.mgy, 1e12, .initUniqueSymbol("Tmgy"));
pub const Gmgy: Unit = defUnitFromUnit(photometric.mgy, 1e9, .initUniqueSymbol("Gmgy"));
pub const Mmgy: Unit = defUnitFromUnit(photometric.mgy, 1e6, .initUniqueSymbol("Mmgy"));
pub const kmgy: Unit = defUnitFromUnit(photometric.mgy, 1e3, .initUniqueSymbol("kmgy"));
pub const hmgy: Unit = defUnitFromUnit(photometric.mgy, 1e2, .initUniqueSymbol("hmgy"));
pub const damgy: Unit = defUnitFromUnit(photometric.mgy, 1e1, .initUniqueSymbol("damgy"));
pub const dmgy: Unit = defUnitFromUnit(photometric.mgy, 1e-1, .initUniqueSymbol("dmgy"));
pub const cmgy: Unit = defUnitFromUnit(photometric.mgy, 1e-2, .initUniqueSymbol("cmgy"));
pub const mmgy: Unit = defUnitFromUnit(photometric.mgy, 1e-3, .initUniqueSymbol("mmgy"));
pub const umgy: Unit = defUnitFromUnit(photometric.mgy, 1e-6, .initUniqueSymbol("umgy"));
pub const nmgy: Unit = defUnitFromUnit(photometric.mgy, 1e-9, .initUniqueSymbol("nmgy"));
pub const pmgy: Unit = defUnitFromUnit(photometric.mgy, 1e-12, .initUniqueSymbol("pmgy"));
pub const fmgy: Unit = defUnitFromUnit(photometric.mgy, 1e-15, .initUniqueSymbol("fmgy"));
pub const amgy: Unit = defUnitFromUnit(photometric.mgy, 1e-18, .initUniqueSymbol("amgy"));
pub const zmgy: Unit = defUnitFromUnit(photometric.mgy, 1e-21, .initUniqueSymbol("zmgy"));
pub const ymgy: Unit = defUnitFromUnit(photometric.mgy, 1e-24, .initUniqueSymbol("ymgy"));
pub const rmgy: Unit = defUnitFromUnit(photometric.mgy, 1e-27, .initUniqueSymbol("rmgy"));
pub const qmgy: Unit = defUnitFromUnit(photometric.mgy, 1e-30, .initUniqueSymbol("qmgy"));

//////////////////////////////////////////////////////
// ASTROPHYS
//////////////////////////////////////////////////////

// au
pub const au = astrophys.au;
pub const Qau: Unit = defUnitFromUnit(astrophys.au, 1e30, .initUniqueSymbol("Qau"));
pub const Rau: Unit = defUnitFromUnit(astrophys.au, 1e27, .initUniqueSymbol("Rau"));
pub const Yau: Unit = defUnitFromUnit(astrophys.au, 1e24, .initUniqueSymbol("Yau"));
pub const Zau: Unit = defUnitFromUnit(astrophys.au, 1e21, .initUniqueSymbol("Zau"));
pub const Eau: Unit = defUnitFromUnit(astrophys.au, 1e18, .initUniqueSymbol("Eau"));
pub const Pau: Unit = defUnitFromUnit(astrophys.au, 1e15, .initUniqueSymbol("Pau"));
pub const Tau: Unit = defUnitFromUnit(astrophys.au, 1e12, .initUniqueSymbol("Tau"));
pub const Gau: Unit = defUnitFromUnit(astrophys.au, 1e9, .initUniqueSymbol("Gau"));
pub const Mau: Unit = defUnitFromUnit(astrophys.au, 1e6, .initUniqueSymbol("Mau"));
pub const kau: Unit = defUnitFromUnit(astrophys.au, 1e3, .initUniqueSymbol("kau"));
pub const hau: Unit = defUnitFromUnit(astrophys.au, 1e2, .initUniqueSymbol("hau"));
pub const daau: Unit = defUnitFromUnit(astrophys.au, 1e1, .initUniqueSymbol("daau"));
pub const dau: Unit = defUnitFromUnit(astrophys.au, 1e-1, .initUniqueSymbol("dau"));
pub const cau: Unit = defUnitFromUnit(astrophys.au, 1e-2, .initUniqueSymbol("cau"));
pub const mau: Unit = defUnitFromUnit(astrophys.au, 1e-3, .initUniqueSymbol("mau"));
pub const uau: Unit = defUnitFromUnit(astrophys.au, 1e-6, .initUniqueSymbol("uau"));
pub const nau: Unit = defUnitFromUnit(astrophys.au, 1e-9, .initUniqueSymbol("nau"));
pub const pau: Unit = defUnitFromUnit(astrophys.au, 1e-12, .initUniqueSymbol("pau"));
pub const fau: Unit = defUnitFromUnit(astrophys.au, 1e-15, .initUniqueSymbol("fau"));
pub const aau: Unit = defUnitFromUnit(astrophys.au, 1e-18, .initUniqueSymbol("aau"));
pub const zau: Unit = defUnitFromUnit(astrophys.au, 1e-21, .initUniqueSymbol("zau"));
pub const yau: Unit = defUnitFromUnit(astrophys.au, 1e-24, .initUniqueSymbol("yau"));
pub const rau: Unit = defUnitFromUnit(astrophys.au, 1e-27, .initUniqueSymbol("rau"));
pub const qau: Unit = defUnitFromUnit(astrophys.au, 1e-30, .initUniqueSymbol("qau"));

// pc
pub const pc = astrophys.pc;
pub const Qpc: Unit = defUnitFromUnit(astrophys.pc, 1e30, .initUniqueSymbol("Qpc"));
pub const Rpc: Unit = defUnitFromUnit(astrophys.pc, 1e27, .initUniqueSymbol("Rpc"));
pub const Ypc: Unit = defUnitFromUnit(astrophys.pc, 1e24, .initUniqueSymbol("Ypc"));
pub const Zpc: Unit = defUnitFromUnit(astrophys.pc, 1e21, .initUniqueSymbol("Zpc"));
pub const Epc: Unit = defUnitFromUnit(astrophys.pc, 1e18, .initUniqueSymbol("Epc"));
pub const Ppc: Unit = defUnitFromUnit(astrophys.pc, 1e15, .initUniqueSymbol("Ppc"));
pub const Tpc: Unit = defUnitFromUnit(astrophys.pc, 1e12, .initUniqueSymbol("Tpc"));
pub const Gpc: Unit = defUnitFromUnit(astrophys.pc, 1e9, .initUniqueSymbol("Gpc"));
pub const Mpc: Unit = defUnitFromUnit(astrophys.pc, 1e6, .initUniqueSymbol("Mpc"));
pub const hpc: Unit = defUnitFromUnit(astrophys.pc, 1e2, .initUniqueSymbol("hpc"));
pub const dapc: Unit = defUnitFromUnit(astrophys.pc, 1e1, .initUniqueSymbol("dapc"));
pub const dpc: Unit = defUnitFromUnit(astrophys.pc, 1e-1, .initUniqueSymbol("dpc"));
pub const cpc: Unit = defUnitFromUnit(astrophys.pc, 1e-2, .initUniqueSymbol("cpc"));
pub const mpc: Unit = defUnitFromUnit(astrophys.pc, 1e-3, .initUniqueSymbol("mpc"));
pub const upc: Unit = defUnitFromUnit(astrophys.pc, 1e-6, .initUniqueSymbol("upc"));
pub const npc: Unit = defUnitFromUnit(astrophys.pc, 1e-9, .initUniqueSymbol("npc"));
pub const ppc: Unit = defUnitFromUnit(astrophys.pc, 1e-12, .initUniqueSymbol("ppc"));
pub const fpc: Unit = defUnitFromUnit(astrophys.pc, 1e-15, .initUniqueSymbol("fpc"));
pub const apc: Unit = defUnitFromUnit(astrophys.pc, 1e-18, .initUniqueSymbol("apc"));
pub const zpc: Unit = defUnitFromUnit(astrophys.pc, 1e-21, .initUniqueSymbol("zpc"));
pub const ypc: Unit = defUnitFromUnit(astrophys.pc, 1e-24, .initUniqueSymbol("ypc"));
pub const rpc: Unit = defUnitFromUnit(astrophys.pc, 1e-27, .initUniqueSymbol("rpc"));
pub const qpc: Unit = defUnitFromUnit(astrophys.pc, 1e-30, .initUniqueSymbol("qpc"));

// kpc
pub const kpc = astrophys.kpc;

// solRad
pub const solRad = astrophys.solRad;

// jupiterRad
pub const jupiterRad = astrophys.jupiterRad;

// earthRad
pub const earthRad = astrophys.earthRad;

// lyr
pub const lyr = astrophys.lyr;
pub const Qlyr: Unit = defUnitFromUnit(astrophys.lyr, 1e30, .initUniqueSymbol("Qlyr"));
pub const Rlyr: Unit = defUnitFromUnit(astrophys.lyr, 1e27, .initUniqueSymbol("Rlyr"));
pub const Ylyr: Unit = defUnitFromUnit(astrophys.lyr, 1e24, .initUniqueSymbol("Ylyr"));
pub const Zlyr: Unit = defUnitFromUnit(astrophys.lyr, 1e21, .initUniqueSymbol("Zlyr"));
pub const Elyr: Unit = defUnitFromUnit(astrophys.lyr, 1e18, .initUniqueSymbol("Elyr"));
pub const Plyr: Unit = defUnitFromUnit(astrophys.lyr, 1e15, .initUniqueSymbol("Plyr"));
pub const Tlyr: Unit = defUnitFromUnit(astrophys.lyr, 1e12, .initUniqueSymbol("Tlyr"));
pub const Glyr: Unit = defUnitFromUnit(astrophys.lyr, 1e9, .initUniqueSymbol("Glyr"));
pub const Mlyr: Unit = defUnitFromUnit(astrophys.lyr, 1e6, .initUniqueSymbol("Mlyr"));
pub const klyr: Unit = defUnitFromUnit(astrophys.lyr, 1e3, .initUniqueSymbol("klyr"));
pub const hlyr: Unit = defUnitFromUnit(astrophys.lyr, 1e2, .initUniqueSymbol("hlyr"));
pub const dalyr: Unit = defUnitFromUnit(astrophys.lyr, 1e1, .initUniqueSymbol("dalyr"));
pub const dlyr: Unit = defUnitFromUnit(astrophys.lyr, 1e-1, .initUniqueSymbol("dlyr"));
pub const clyr: Unit = defUnitFromUnit(astrophys.lyr, 1e-2, .initUniqueSymbol("clyr"));
pub const mlyr: Unit = defUnitFromUnit(astrophys.lyr, 1e-3, .initUniqueSymbol("mlyr"));
pub const ulyr: Unit = defUnitFromUnit(astrophys.lyr, 1e-6, .initUniqueSymbol("ulyr"));
pub const nlyr: Unit = defUnitFromUnit(astrophys.lyr, 1e-9, .initUniqueSymbol("nlyr"));
pub const plyr: Unit = defUnitFromUnit(astrophys.lyr, 1e-12, .initUniqueSymbol("plyr"));
pub const flyr: Unit = defUnitFromUnit(astrophys.lyr, 1e-15, .initUniqueSymbol("flyr"));
pub const alyr: Unit = defUnitFromUnit(astrophys.lyr, 1e-18, .initUniqueSymbol("alyr"));
pub const zlyr: Unit = defUnitFromUnit(astrophys.lyr, 1e-21, .initUniqueSymbol("zlyr"));
pub const ylyr: Unit = defUnitFromUnit(astrophys.lyr, 1e-24, .initUniqueSymbol("ylyr"));
pub const rlyr: Unit = defUnitFromUnit(astrophys.lyr, 1e-27, .initUniqueSymbol("rlyr"));
pub const qlyr: Unit = defUnitFromUnit(astrophys.lyr, 1e-30, .initUniqueSymbol("qlyr"));

// lsec
pub const lsec = astrophys.lsec;

// solMass
pub const solMass = astrophys.solMass;

// jupiterMass
pub const jupiterMass = astrophys.jupiterMass;

// earthMass
pub const earthMass = astrophys.earthMass;

// foe
pub const foe = astrophys.foe;

// solLum
pub const solLum = astrophys.solLum;

// ph
pub const ph = astrophys.ph;
pub const Qph: Unit = defUnitFromUnit(astrophys.ph, 1e30, .initUniqueSymbol("Qph"));
pub const Rph: Unit = defUnitFromUnit(astrophys.ph, 1e27, .initUniqueSymbol("Rph"));
pub const Yph: Unit = defUnitFromUnit(astrophys.ph, 1e24, .initUniqueSymbol("Yph"));
pub const Zph: Unit = defUnitFromUnit(astrophys.ph, 1e21, .initUniqueSymbol("Zph"));
pub const Eph: Unit = defUnitFromUnit(astrophys.ph, 1e18, .initUniqueSymbol("Eph"));
pub const Pph: Unit = defUnitFromUnit(astrophys.ph, 1e15, .initUniqueSymbol("Pph"));
pub const Tph: Unit = defUnitFromUnit(astrophys.ph, 1e12, .initUniqueSymbol("Tph"));
pub const Gph: Unit = defUnitFromUnit(astrophys.ph, 1e9, .initUniqueSymbol("Gph"));
pub const Mph: Unit = defUnitFromUnit(astrophys.ph, 1e6, .initUniqueSymbol("Mph"));
pub const kph: Unit = defUnitFromUnit(astrophys.ph, 1e3, .initUniqueSymbol("kph"));
pub const hph: Unit = defUnitFromUnit(astrophys.ph, 1e2, .initUniqueSymbol("hph"));
pub const daph: Unit = defUnitFromUnit(astrophys.ph, 1e1, .initUniqueSymbol("daph"));
pub const dph: Unit = defUnitFromUnit(astrophys.ph, 1e-1, .initUniqueSymbol("dph"));
pub const cph: Unit = defUnitFromUnit(astrophys.ph, 1e-2, .initUniqueSymbol("cph"));
pub const mph: Unit = defUnitFromUnit(astrophys.ph, 1e-3, .initUniqueSymbol("mph"));
pub const uph: Unit = defUnitFromUnit(astrophys.ph, 1e-6, .initUniqueSymbol("uph"));
pub const nph: Unit = defUnitFromUnit(astrophys.ph, 1e-9, .initUniqueSymbol("nph"));
pub const pph: Unit = defUnitFromUnit(astrophys.ph, 1e-12, .initUniqueSymbol("pph"));
pub const fph: Unit = defUnitFromUnit(astrophys.ph, 1e-15, .initUniqueSymbol("fph"));
pub const aph: Unit = defUnitFromUnit(astrophys.ph, 1e-18, .initUniqueSymbol("aph"));
pub const zph: Unit = defUnitFromUnit(astrophys.ph, 1e-21, .initUniqueSymbol("zph"));
pub const yph: Unit = defUnitFromUnit(astrophys.ph, 1e-24, .initUniqueSymbol("yph"));
pub const rph: Unit = defUnitFromUnit(astrophys.ph, 1e-27, .initUniqueSymbol("rph"));
pub const qph: Unit = defUnitFromUnit(astrophys.ph, 1e-30, .initUniqueSymbol("qph"));

// Jy
pub const Jy = astrophys.Jy;
pub const QJy: Unit = defUnitFromUnit(astrophys.Jy, 1e30, .initUniqueSymbol("QJy"));
pub const RJy: Unit = defUnitFromUnit(astrophys.Jy, 1e27, .initUniqueSymbol("RJy"));
pub const YJy: Unit = defUnitFromUnit(astrophys.Jy, 1e24, .initUniqueSymbol("YJy"));
pub const ZJy: Unit = defUnitFromUnit(astrophys.Jy, 1e21, .initUniqueSymbol("ZJy"));
pub const EJy: Unit = defUnitFromUnit(astrophys.Jy, 1e18, .initUniqueSymbol("EJy"));
pub const PJy: Unit = defUnitFromUnit(astrophys.Jy, 1e15, .initUniqueSymbol("PJy"));
pub const TJy: Unit = defUnitFromUnit(astrophys.Jy, 1e12, .initUniqueSymbol("TJy"));
pub const GJy: Unit = defUnitFromUnit(astrophys.Jy, 1e9, .initUniqueSymbol("GJy"));
pub const MJy: Unit = defUnitFromUnit(astrophys.Jy, 1e6, .initUniqueSymbol("MJy"));
pub const kJy: Unit = defUnitFromUnit(astrophys.Jy, 1e3, .initUniqueSymbol("kJy"));
pub const hJy: Unit = defUnitFromUnit(astrophys.Jy, 1e2, .initUniqueSymbol("hJy"));
pub const daJy: Unit = defUnitFromUnit(astrophys.Jy, 1e1, .initUniqueSymbol("daJy"));
pub const dJy: Unit = defUnitFromUnit(astrophys.Jy, 1e-1, .initUniqueSymbol("dJy"));
pub const cJy: Unit = defUnitFromUnit(astrophys.Jy, 1e-2, .initUniqueSymbol("cJy"));
pub const mJy: Unit = defUnitFromUnit(astrophys.Jy, 1e-3, .initUniqueSymbol("mJy"));
pub const uJy: Unit = defUnitFromUnit(astrophys.Jy, 1e-6, .initUniqueSymbol("uJy"));
pub const nJy: Unit = defUnitFromUnit(astrophys.Jy, 1e-9, .initUniqueSymbol("nJy"));
pub const pJy: Unit = defUnitFromUnit(astrophys.Jy, 1e-12, .initUniqueSymbol("pJy"));
pub const fJy: Unit = defUnitFromUnit(astrophys.Jy, 1e-15, .initUniqueSymbol("fJy"));
pub const aJy: Unit = defUnitFromUnit(astrophys.Jy, 1e-18, .initUniqueSymbol("aJy"));
pub const zJy: Unit = defUnitFromUnit(astrophys.Jy, 1e-21, .initUniqueSymbol("zJy"));
pub const yJy: Unit = defUnitFromUnit(astrophys.Jy, 1e-24, .initUniqueSymbol("yJy"));
pub const rJy: Unit = defUnitFromUnit(astrophys.Jy, 1e-27, .initUniqueSymbol("rJy"));
pub const qJy: Unit = defUnitFromUnit(astrophys.Jy, 1e-30, .initUniqueSymbol("qJy"));

// R
pub const R = astrophys.R;
pub const QR: Unit = defUnitFromUnit(astrophys.R, 1e30, .initUniqueSymbol("QR"));
pub const RR: Unit = defUnitFromUnit(astrophys.R, 1e27, .initUniqueSymbol("RR"));
pub const YR: Unit = defUnitFromUnit(astrophys.R, 1e24, .initUniqueSymbol("YR"));
pub const ZR: Unit = defUnitFromUnit(astrophys.R, 1e21, .initUniqueSymbol("ZR"));
pub const ER: Unit = defUnitFromUnit(astrophys.R, 1e18, .initUniqueSymbol("ER"));
pub const PR: Unit = defUnitFromUnit(astrophys.R, 1e15, .initUniqueSymbol("PR"));
pub const TR: Unit = defUnitFromUnit(astrophys.R, 1e12, .initUniqueSymbol("TR"));
pub const GR: Unit = defUnitFromUnit(astrophys.R, 1e9, .initUniqueSymbol("GR"));
pub const MR: Unit = defUnitFromUnit(astrophys.R, 1e6, .initUniqueSymbol("MR"));
pub const kR: Unit = defUnitFromUnit(astrophys.R, 1e3, .initUniqueSymbol("kR"));
pub const hR: Unit = defUnitFromUnit(astrophys.R, 1e2, .initUniqueSymbol("hR"));
pub const daR: Unit = defUnitFromUnit(astrophys.R, 1e1, .initUniqueSymbol("daR"));
pub const dR: Unit = defUnitFromUnit(astrophys.R, 1e-1, .initUniqueSymbol("dR"));
pub const cR: Unit = defUnitFromUnit(astrophys.R, 1e-2, .initUniqueSymbol("cR"));
pub const mR: Unit = defUnitFromUnit(astrophys.R, 1e-3, .initUniqueSymbol("mR"));
pub const uR: Unit = defUnitFromUnit(astrophys.R, 1e-6, .initUniqueSymbol("uR"));
pub const nR: Unit = defUnitFromUnit(astrophys.R, 1e-9, .initUniqueSymbol("nR"));
pub const pR: Unit = defUnitFromUnit(astrophys.R, 1e-12, .initUniqueSymbol("pR"));
pub const fR: Unit = defUnitFromUnit(astrophys.R, 1e-15, .initUniqueSymbol("fR"));
pub const aR: Unit = defUnitFromUnit(astrophys.R, 1e-18, .initUniqueSymbol("aR"));
pub const zR: Unit = defUnitFromUnit(astrophys.R, 1e-21, .initUniqueSymbol("zR"));
pub const yR: Unit = defUnitFromUnit(astrophys.R, 1e-24, .initUniqueSymbol("yR"));
pub const rR: Unit = defUnitFromUnit(astrophys.R, 1e-27, .initUniqueSymbol("rR"));
pub const qR: Unit = defUnitFromUnit(astrophys.R, 1e-30, .initUniqueSymbol("qR"));

// ct
pub const ct = astrophys.ct;
pub const Qct: Unit = defUnitFromUnit(astrophys.ct, 1e30, .initUniqueSymbol("Qct"));
pub const Rct: Unit = defUnitFromUnit(astrophys.ct, 1e27, .initUniqueSymbol("Rct"));
pub const Yct: Unit = defUnitFromUnit(astrophys.ct, 1e24, .initUniqueSymbol("Yct"));
pub const Zct: Unit = defUnitFromUnit(astrophys.ct, 1e21, .initUniqueSymbol("Zct"));
pub const Ect: Unit = defUnitFromUnit(astrophys.ct, 1e18, .initUniqueSymbol("Ect"));
pub const Pct: Unit = defUnitFromUnit(astrophys.ct, 1e15, .initUniqueSymbol("Pct"));
pub const Tct: Unit = defUnitFromUnit(astrophys.ct, 1e12, .initUniqueSymbol("Tct"));
pub const Gct: Unit = defUnitFromUnit(astrophys.ct, 1e9, .initUniqueSymbol("Gct"));
pub const Mct: Unit = defUnitFromUnit(astrophys.ct, 1e6, .initUniqueSymbol("Mct"));
pub const kct: Unit = defUnitFromUnit(astrophys.ct, 1e3, .initUniqueSymbol("kct"));
pub const hct: Unit = defUnitFromUnit(astrophys.ct, 1e2, .initUniqueSymbol("hct"));
pub const dact: Unit = defUnitFromUnit(astrophys.ct, 1e1, .initUniqueSymbol("dact"));
pub const dct: Unit = defUnitFromUnit(astrophys.ct, 1e-1, .initUniqueSymbol("dct"));
pub const cct: Unit = defUnitFromUnit(astrophys.ct, 1e-2, .initUniqueSymbol("cct"));
pub const mct: Unit = defUnitFromUnit(astrophys.ct, 1e-3, .initUniqueSymbol("mct"));
pub const uct: Unit = defUnitFromUnit(astrophys.ct, 1e-6, .initUniqueSymbol("uct"));
pub const nct: Unit = defUnitFromUnit(astrophys.ct, 1e-9, .initUniqueSymbol("nct"));
pub const fct: Unit = defUnitFromUnit(astrophys.ct, 1e-15, .initUniqueSymbol("fct"));
pub const act: Unit = defUnitFromUnit(astrophys.ct, 1e-18, .initUniqueSymbol("act"));
pub const zct: Unit = defUnitFromUnit(astrophys.ct, 1e-21, .initUniqueSymbol("zct"));
pub const yct: Unit = defUnitFromUnit(astrophys.ct, 1e-24, .initUniqueSymbol("yct"));
pub const rct: Unit = defUnitFromUnit(astrophys.ct, 1e-27, .initUniqueSymbol("rct"));
pub const qct: Unit = defUnitFromUnit(astrophys.ct, 1e-30, .initUniqueSymbol("qct"));

// adu
pub const adu = astrophys.adu;

// DN
pub const DN = astrophys.DN;

//////////////////////////////////////////////////////
// MISC
//////////////////////////////////////////////////////

// barn
pub const barn = misc.barn;
pub const Qbarn: Unit = defUnitFromUnit(misc.barn, 1e30, .initUniqueSymbol("Qbarn"));
pub const Rbarn: Unit = defUnitFromUnit(misc.barn, 1e27, .initUniqueSymbol("Rbarn"));
pub const Ybarn: Unit = defUnitFromUnit(misc.barn, 1e24, .initUniqueSymbol("Ybarn"));
pub const Zbarn: Unit = defUnitFromUnit(misc.barn, 1e21, .initUniqueSymbol("Zbarn"));
pub const Ebarn: Unit = defUnitFromUnit(misc.barn, 1e18, .initUniqueSymbol("Ebarn"));
pub const Pbarn: Unit = defUnitFromUnit(misc.barn, 1e15, .initUniqueSymbol("Pbarn"));
pub const Tbarn: Unit = defUnitFromUnit(misc.barn, 1e12, .initUniqueSymbol("Tbarn"));
pub const Gbarn: Unit = defUnitFromUnit(misc.barn, 1e9, .initUniqueSymbol("Gbarn"));
pub const Mbarn: Unit = defUnitFromUnit(misc.barn, 1e6, .initUniqueSymbol("Mbarn"));
pub const kbarn: Unit = defUnitFromUnit(misc.barn, 1e3, .initUniqueSymbol("kbarn"));
pub const hbarn: Unit = defUnitFromUnit(misc.barn, 1e2, .initUniqueSymbol("hbarn"));
pub const dabarn: Unit = defUnitFromUnit(misc.barn, 1e1, .initUniqueSymbol("dabarn"));
pub const dbarn: Unit = defUnitFromUnit(misc.barn, 1e-1, .initUniqueSymbol("dbarn"));
pub const cbarn: Unit = defUnitFromUnit(misc.barn, 1e-2, .initUniqueSymbol("cbarn"));
pub const mbarn: Unit = defUnitFromUnit(misc.barn, 1e-3, .initUniqueSymbol("mbarn"));
pub const ubarn: Unit = defUnitFromUnit(misc.barn, 1e-6, .initUniqueSymbol("ubarn"));
pub const nbarn: Unit = defUnitFromUnit(misc.barn, 1e-9, .initUniqueSymbol("nbarn"));
pub const pbarn: Unit = defUnitFromUnit(misc.barn, 1e-12, .initUniqueSymbol("pbarn"));
pub const fbarn: Unit = defUnitFromUnit(misc.barn, 1e-15, .initUniqueSymbol("fbarn"));
pub const abarn: Unit = defUnitFromUnit(misc.barn, 1e-18, .initUniqueSymbol("abarn"));
pub const zbarn: Unit = defUnitFromUnit(misc.barn, 1e-21, .initUniqueSymbol("zbarn"));
pub const ybarn: Unit = defUnitFromUnit(misc.barn, 1e-24, .initUniqueSymbol("ybarn"));
pub const rbarn: Unit = defUnitFromUnit(misc.barn, 1e-27, .initUniqueSymbol("rbarn"));
pub const qbarn: Unit = defUnitFromUnit(misc.barn, 1e-30, .initUniqueSymbol("qbarn"));

// cycle
pub const cycle = misc.cycle;

// spat
pub const spat = misc.spat;

// bar
pub const bar = misc.bar;
pub const mbar: Unit = defUnitFromUnit(misc.bar, 1e-3, .initUniqueSymbol("mbar"));

// Torr
pub const Torr = misc.Torr;
pub const mTorr: Unit = defUnitFromUnit(misc.Torr, 1e-3, .initUniqueSymbol("mTorr"));

// M_p
pub const M_p = misc.M_p;

// M_e
pub const M_e = misc.M_e;

// u
pub const u = misc.u;
pub const Qu: Unit = defUnitFromUnit(misc.u, 1e30, .initUniqueSymbol("Qu"));
pub const Ru: Unit = defUnitFromUnit(misc.u, 1e27, .initUniqueSymbol("Ru"));
pub const Yu: Unit = defUnitFromUnit(misc.u, 1e24, .initUniqueSymbol("Yu"));
pub const Zu: Unit = defUnitFromUnit(misc.u, 1e21, .initUniqueSymbol("Zu"));
pub const Eu: Unit = defUnitFromUnit(misc.u, 1e18, .initUniqueSymbol("Eu"));
pub const Pu: Unit = defUnitFromUnit(misc.u, 1e15, .initUniqueSymbol("Pu"));
pub const Tu: Unit = defUnitFromUnit(misc.u, 1e12, .initUniqueSymbol("Tu"));
pub const Gu: Unit = defUnitFromUnit(misc.u, 1e9, .initUniqueSymbol("Gu"));
pub const Mu: Unit = defUnitFromUnit(misc.u, 1e6, .initUniqueSymbol("Mu"));
pub const ku: Unit = defUnitFromUnit(misc.u, 1e3, .initUniqueSymbol("ku"));
pub const hu: Unit = defUnitFromUnit(misc.u, 1e2, .initUniqueSymbol("hu"));
pub const du: Unit = defUnitFromUnit(misc.u, 1e-1, .initUniqueSymbol("du"));
pub const cu: Unit = defUnitFromUnit(misc.u, 1e-2, .initUniqueSymbol("cu"));
pub const mu: Unit = defUnitFromUnit(misc.u, 1e-3, .initUniqueSymbol("mu"));
pub const uu: Unit = defUnitFromUnit(misc.u, 1e-6, .initUniqueSymbol("uu"));
pub const nu: Unit = defUnitFromUnit(misc.u, 1e-9, .initUniqueSymbol("nu"));
pub const pu: Unit = defUnitFromUnit(misc.u, 1e-12, .initUniqueSymbol("pu"));
pub const fu: Unit = defUnitFromUnit(misc.u, 1e-15, .initUniqueSymbol("fu"));
pub const zu: Unit = defUnitFromUnit(misc.u, 1e-21, .initUniqueSymbol("zu"));
pub const yu: Unit = defUnitFromUnit(misc.u, 1e-24, .initUniqueSymbol("yu"));
pub const ru: Unit = defUnitFromUnit(misc.u, 1e-27, .initUniqueSymbol("ru"));
pub const qu: Unit = defUnitFromUnit(misc.u, 1e-30, .initUniqueSymbol("qu"));

// eV
pub const eV = misc.eV;
pub const QeV: Unit = defUnitFromUnit(misc.eV, 1e30, .initUniqueSymbol("QeV"));
pub const ReV: Unit = defUnitFromUnit(misc.eV, 1e27, .initUniqueSymbol("ReV"));
pub const YeV: Unit = defUnitFromUnit(misc.eV, 1e24, .initUniqueSymbol("YeV"));
pub const ZeV: Unit = defUnitFromUnit(misc.eV, 1e21, .initUniqueSymbol("ZeV"));
pub const EeV: Unit = defUnitFromUnit(misc.eV, 1e18, .initUniqueSymbol("EeV"));
pub const PeV: Unit = defUnitFromUnit(misc.eV, 1e15, .initUniqueSymbol("PeV"));
pub const TeV: Unit = defUnitFromUnit(misc.eV, 1e12, .initUniqueSymbol("TeV"));
pub const GeV: Unit = defUnitFromUnit(misc.eV, 1e9, .initUniqueSymbol("GeV"));
pub const MeV: Unit = defUnitFromUnit(misc.eV, 1e6, .initUniqueSymbol("MeV"));
pub const keV: Unit = defUnitFromUnit(misc.eV, 1e3, .initUniqueSymbol("keV"));
pub const heV: Unit = defUnitFromUnit(misc.eV, 1e2, .initUniqueSymbol("heV"));
pub const daeV: Unit = defUnitFromUnit(misc.eV, 1e1, .initUniqueSymbol("daeV"));
pub const deV: Unit = defUnitFromUnit(misc.eV, 1e-1, .initUniqueSymbol("deV"));
pub const ceV: Unit = defUnitFromUnit(misc.eV, 1e-2, .initUniqueSymbol("ceV"));
pub const meV: Unit = defUnitFromUnit(misc.eV, 1e-3, .initUniqueSymbol("meV"));
pub const ueV: Unit = defUnitFromUnit(misc.eV, 1e-6, .initUniqueSymbol("ueV"));
pub const neV: Unit = defUnitFromUnit(misc.eV, 1e-9, .initUniqueSymbol("neV"));
pub const peV: Unit = defUnitFromUnit(misc.eV, 1e-12, .initUniqueSymbol("peV"));
pub const feV: Unit = defUnitFromUnit(misc.eV, 1e-15, .initUniqueSymbol("feV"));
pub const aeV: Unit = defUnitFromUnit(misc.eV, 1e-18, .initUniqueSymbol("aeV"));
pub const zeV: Unit = defUnitFromUnit(misc.eV, 1e-21, .initUniqueSymbol("zeV"));
pub const yeV: Unit = defUnitFromUnit(misc.eV, 1e-24, .initUniqueSymbol("yeV"));
pub const reV: Unit = defUnitFromUnit(misc.eV, 1e-27, .initUniqueSymbol("reV"));
pub const qeV: Unit = defUnitFromUnit(misc.eV, 1e-30, .initUniqueSymbol("qeV"));

// Ry
pub const Ry = misc.Ry;
pub const QRy: Unit = defUnitFromUnit(misc.Ry, 1e30, .initUniqueSymbol("QRy"));
pub const RRy: Unit = defUnitFromUnit(misc.Ry, 1e27, .initUniqueSymbol("RRy"));
pub const YRy: Unit = defUnitFromUnit(misc.Ry, 1e24, .initUniqueSymbol("YRy"));
pub const ZRy: Unit = defUnitFromUnit(misc.Ry, 1e21, .initUniqueSymbol("ZRy"));
pub const ERy: Unit = defUnitFromUnit(misc.Ry, 1e18, .initUniqueSymbol("ERy"));
pub const PRy: Unit = defUnitFromUnit(misc.Ry, 1e15, .initUniqueSymbol("PRy"));
pub const TRy: Unit = defUnitFromUnit(misc.Ry, 1e12, .initUniqueSymbol("TRy"));
pub const GRy: Unit = defUnitFromUnit(misc.Ry, 1e9, .initUniqueSymbol("GRy"));
pub const MRy: Unit = defUnitFromUnit(misc.Ry, 1e6, .initUniqueSymbol("MRy"));
pub const kRy: Unit = defUnitFromUnit(misc.Ry, 1e3, .initUniqueSymbol("kRy"));
pub const hRy: Unit = defUnitFromUnit(misc.Ry, 1e2, .initUniqueSymbol("hRy"));
pub const daRy: Unit = defUnitFromUnit(misc.Ry, 1e1, .initUniqueSymbol("daRy"));
pub const dRy: Unit = defUnitFromUnit(misc.Ry, 1e-1, .initUniqueSymbol("dRy"));
pub const cRy: Unit = defUnitFromUnit(misc.Ry, 1e-2, .initUniqueSymbol("cRy"));
pub const mRy: Unit = defUnitFromUnit(misc.Ry, 1e-3, .initUniqueSymbol("mRy"));
pub const uRy: Unit = defUnitFromUnit(misc.Ry, 1e-6, .initUniqueSymbol("uRy"));
pub const nRy: Unit = defUnitFromUnit(misc.Ry, 1e-9, .initUniqueSymbol("nRy"));
pub const pRy: Unit = defUnitFromUnit(misc.Ry, 1e-12, .initUniqueSymbol("pRy"));
pub const fRy: Unit = defUnitFromUnit(misc.Ry, 1e-15, .initUniqueSymbol("fRy"));
pub const aRy: Unit = defUnitFromUnit(misc.Ry, 1e-18, .initUniqueSymbol("aRy"));
pub const zRy: Unit = defUnitFromUnit(misc.Ry, 1e-21, .initUniqueSymbol("zRy"));
pub const yRy: Unit = defUnitFromUnit(misc.Ry, 1e-24, .initUniqueSymbol("yRy"));
pub const rRy: Unit = defUnitFromUnit(misc.Ry, 1e-27, .initUniqueSymbol("rRy"));
pub const qRy: Unit = defUnitFromUnit(misc.Ry, 1e-30, .initUniqueSymbol("qRy"));

// bit
pub const bit = misc.bit;

// byte
pub const byte = misc.byte;

// pix
pub const pix = misc.pix;

// vox
pub const vox = misc.vox;

//////////////////////////////////////////////////////
// IMPERIAL
//////////////////////////////////////////////////////

