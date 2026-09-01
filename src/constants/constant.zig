const std = @import("std");
const testing = std.testing;
const u = @import("../units.zig");
const Unit = u.Unit;
const Quantity = u.Quantity;
const System = u.System;

/// A named physical constant: a `Quantity` paired with a human-readable description
/// and the unit system it is expressed in. Generic over the same `T` (value storage
/// type) and `U` (unit) parameters as `Quantity`, so constants compose with
/// quantities through the normal arithmetic methods (e.g. `cst.c.quantity.mul(...)`).
pub fn Constant(comptime T: type, comptime U: Unit) type {
    return struct {
        const Self = @This();

        /// The constant's value and unit.
        quantity: Quantity(T, U),
        /// Human-readable description, e.g. "Speed of light in vacuum".
        desc: []const u8 = "",
        /// The unit system the constant is expressed in.
        system: System,

        /// Constructs a constant from a raw value, a description, and a system. The
        /// unit comes from the type parameter `U`.
        pub fn init(value: T, desc: []const u8, system: System) Self {
            return Self{ .quantity = .init(value), .desc = desc, .system = system };
        }
    };
}

/// Derives the matching `Constant` type for a given `Quantity` type, extracting the
/// value storage type from the quantity's `value` field and the unit from its `unit`
/// declaration. Useful when you have a `Quantity` type in hand and want the constant
/// type that would hold it.
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
