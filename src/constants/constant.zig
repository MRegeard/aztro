const std = @import("std");
const aztro = @import("../aztro.zig");
const units = aztro.units;
const Unit = units.Unit;
const Quantity = units.Quantity;
const System = units.System;

pub fn Constant(comptime quantity_type: type) type {
    return struct {
        const Self = @This();

        quantity: quantity_type,
        desc: []const u8,
        system: System,
    };
}

// CODATA 2022
//
