const std = @import("std");
const testing = std.testing;
const u = @import("../units.zig");
const Unit = u.Unit;
const Quantity = u.Quantity;
const System = u.System;

pub fn Constant(comptime T: type, comptime U: Unit) type {
    return struct {
        const Self = @This();

        quantity: Quantity(T, U),
        desc: []const u8 = "",
        system: System,

        pub fn init(value: T, desc: []const u8, system: System) Self {
            return Self{ .quantity = .init(value), .desc = desc, .system = system };
        }
    };
}

pub fn ConstantFromQuantity(comptime quantity_type: type) type {
    const T: type = blk: {
        for (@typeInfo(quantity_type).@"struct".fields) |field| {
            if (std.mem.eql(u8, "value", field.name)) {
                break :blk field.type;
            }
        }
    };
    const U: Unit = quantity_type.unit;
    return Constant(T, U);
}

test "ConstantFromQuantity" {
    const q_type = Quantity(f64, u.m);
    const constant_type: type = ConstantFromQuantity(q_type);
    inline for (@typeInfo(constant_type).@"struct".fields) |field| {
        if (std.mem.eql(u8, "quantity", field.name)) {
            try testing.expect(field.type == q_type);
        }
    }
}

test "Constant init" {
    const constant: Constant(f64, u.m) = .init(10, "something", System.SI);
    try testing.expectEqual(Quantity(f64, u.m), @TypeOf(constant.quantity));
    try testing.expectEqualStrings("something", constant.desc);
    try testing.expectEqual(System.SI, constant.system);
}
