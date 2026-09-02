const std = @import("std");
const math = std.math;
const testing = std.testing;
const Allocator = std.mem.Allocator;
const unitMod = @import("unit.zig");
const Unit = unitMod.Unit;
const System = @import("system.zig").System;
const si = @import("si.zig");
const imperial = @import("imperial.zig");
const zatest = @import("../test.zig");
const equivalency_mod = @import("equivalency.zig");
const Equivalency = equivalency_mod.Equivalency;
const utils = @import("utils.zig");
const us = @import("units_storage.zig");

/// A physical quantity: a value paired with a unit that is known at compile time.
///
/// `Quantity` is generic over two parameters:
/// - `T`: the storage type of the underlying value. Supported types are a float
///   scalar (`f32`/`f64`/...), a `@Vector` of floats, an array of floats,
///   or a slice of floats. Integer storage is intentionally not supported.
/// - `U`: the `Unit` of the quantity, a comptime value carrying the dimensional
///   analysis, scale factor, optional affine offset, and symbol.
///
/// Because `U` is a comptime parameter, all unit logic (dimension checking, scale
/// computation, equivalency routing) resolves at compile time. Only the arithmetic
/// on the stored value happens at runtime, making this effectively a zero-cost
/// abstraction over raw float operations.
///
/// Operations families follow a naming convention:
/// - `<op>`        returns a new `Quantity` (chainable; not available for slices,
///               which have no owned storage to return).
/// - `<op>InPlace` mutates `self` in place and returns `void`.
/// - `<op>Into`    writes the result into a caller-provided `out` buffer; this is the
///               required form for slice-backed quantities.
pub fn Quantity(comptime T: type, comptime U: Unit) type {
    // Classifies the storage type `T` into one of four shapes. Each method
    // switches on this to select the right element-wise strategy.
    const InnerType = enum {
        scalar,
        vector,
        array,
        slice,
    };
    return struct {
        const Self = @This();
        /// Marker declaration used by `utils.isQuantity` / `assertIsQuantity` to
        /// recognize a `Quantity` type via `@hasDecl` without inspecting fields.
        pub const is_zali_quantity: bool = true;
        /// The compile-time unit of this quantity.
        pub const unit: Unit = U;
        /// The storage type of the underlying value (e.g. `f64`, `[]f32`).
        pub const value_type: type = T;
        // Resolved storage shape for `T`. Rejects any non-float element type at
        // compile time so the rest of the struct can assume floating point math.
        const inner_type: InnerType = switch (@typeInfo(T)) {
            .float => .scalar,
            .vector => |vector| blk: {
                switch (@typeInfo(vector.child)) {
                    .float => break :blk .vector,
                    else => @compileError("Unsupported Vector child type " ++ @typeName(vector.child) ++ " ."),
                }
            },
            .array => |array| blk: {
                switch (@typeInfo(array.child)) {
                    .float => break :blk .array,
                    else => @compileError("Unsupported Array child type " ++ @typeName(array.child) ++ " ."),
                }
            },
            .pointer => |p| blk: {
                switch (p.size) {
                    .slice => switch (@typeInfo(p.child)) {
                        .float => break :blk .slice,
                        else => @compileError("Unsupported Slice child type " ++ @typeName(p.child) ++ " ."),
                    },
                    else => @compileError("Unsupported pointer type."),
                }
            },
            else => @compileError("Unsupported type for Quantity value type T, got " ++ @typeName(T) ++ " ."),
        };

        /// The stored value, in units of `U`.
        value: T,

        // Returns the scalar element type underlying `Ty`: `Ty` itself for a float
        // scalar, or the child type for a vector, array, or slice.
        fn getInnerTypeScalarType(comptime Ty: type) type {
            switch (@typeInfo(Ty)) {
                .float => return Ty,
                .vector => |vector| return vector.child,
                .array => |array| return array.child,
                .pointer => |pointer| switch (pointer.size) {
                    .slice => return pointer.child,
                    else => @compileError("Unsupported pointer type."),
                },
                else => unreachable,
            }
        }

        /// Wraps an already-constructed value of type `T` in a `Quantity`.
        pub fn init(value: T) Self {
            return .{ .value = value };
        }

        /// Constructs a quantity from a single scalar, broadcasting it across all
        /// elements for vector and array storage. Not valid for slices, which need
        /// caller-owned backing memory (use `initScalarValueWithBuf`).
        pub fn initScalarValue(value: getInnerTypeScalarType(T)) Self {
            var return_val: T = undefined;
            switch (inner_type) {
                .scalar => return_val = value,
                .vector => return_val = @splat(value),
                .array => @memset(&return_val, value),
                .slice => {
                    @compileError("Cannot init slice without a buffer, use initScalarValueWithBuf instead.");
                },
            }
            return Self{ .value = return_val };
        }

        /// Slice-only variant of `initScalarValue`: fills the caller-provided `buf`
        /// with `value` and stores it. The quantity borrows `buf`; the caller owns
        /// its lifetime.
        pub fn initScalarValueWithBuf(value: getInnerTypeScalarType(T), buf: T) Self {
            switch (inner_type) {
                .slice => {
                    @memset(buf, value);
                    return Self{ .value = buf };
                },
                else => {
                    @compileError("Using buffered init for non-slice type is unnecessary, use initScalarValue instead.");
                },
            }
        }

        /// Returns the unit `U` of this quantity as a runtime value.
        pub fn getUnit(self: *const Self) Unit {
            return @TypeOf(self.*).unit;
        }

        fn assertScalarQuantity(comptime Ty: type) void {
            if (@typeInfo(Ty.value_type) != .float) {
                @compileError("Expected Quantity with scalar (float) value type, got " ++ @typeName(Ty.value_type) ++ " .");
            }
        }

        /// Adds two quantities of the same unit, returning a new quantity.
        /// Slices have no owned storage to return, so use `addInPlace` or `addInto`.
        pub fn add(self: *const Self, other: Self) Self {
            switch (inner_type) {
                .scalar, .vector => {
                    return Quantity(T, U).init(self.value + other.value);
                },
                .array => {
                    var new_array: T = undefined;
                    for (&new_array, self.value, other.value) |*n, s, o| {
                        n.* = s + o;
                    }
                    return Quantity(T, U).init(new_array);
                },
                .slice => {
                    @compileError("Cannot add Slice, use addInPlace or addInto instead.");
                },
            }
        }

        /// Adds `other` into `self`, mutating it in place. Works for all storage
        /// shapes including slices.
        pub fn addInPlace(self: *Self, other: Self) void {
            switch (inner_type) {
                .scalar, .vector => {
                    self.value += other.value;
                },
                .array => {
                    for (&self.value, other.value) |*s, o| {
                        s.* += o;
                    }
                },
                .slice => {
                    for (self.value, other.value) |*s, o| {
                        s.* += o;
                    }
                },
            }
        }

        /// Adds `self` and `other`, writing the result into `out`. This is the
        /// required form for slices, which cannot return owned storage from `add`.
        pub fn addInto(self: *const Self, other: Self, out: *Self) void {
            switch (inner_type) {
                .slice => {
                    for (self.value, other.value, out.value) |s, o, *buf| {
                        buf.* = s + o;
                    }
                },
                else => {
                    out.value = self.add(other).value;
                },
            }
        }

        /// Adds a raw value of type `T` (same unit assumed), returning a new quantity.
        pub fn addValue(self: *const Self, val: T) Self {
            const quantity_val: Quantity(T, U) = .init(val);
            return self.add(quantity_val);
        }

        /// In-place variant of `addValue`.
        pub fn addValueInPlace(self: *Self, val: T) void {
            const quantity_val: Quantity(T, U) = .init(val);
            self.addInPlace(quantity_val);
        }
        /// Buffer-output variant of `addValue`.
        pub fn addValueInto(self: *const Self, val: T, out: *Self) void {
            const quantity_val: Quantity(T, U) = .init(val);
            self.addInto(quantity_val, out);
        }

        /// Adds a scalar quantity of the same units, returning a new quantity.
        /// Cast the scalar value into the quantity value type.
        pub fn addScalar(self: *const Self, other: anytype) Self {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                assertScalarQuantity(OtherType);
            }
            const other_value_float: getInnerTypeScalarType(T) = @floatCast(other.value);
            switch (inner_type) {
                .scalar => {
                    return .init(self.value + other_value_float);
                },
                .vector => {
                    const other_value_vec: T = @splat(other_value_float);
                    return .init(self.value + other_value_vec);
                },
                .array => {
                    var new_array: T = undefined;
                    for (&new_array, self.value) |*n, s| {
                        n.* = s + other_value_float;
                    }
                    return Quantity(T, U).init(new_array);
                },
                .slice => {
                    @compileError("Cannot add Slice, use subInPlace or subInto instead.");
                },
            }
        }

        /// In-place variant of `addScalar`.
        pub fn addScalarInPlace(self: *Self, other: anytype) void {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                assertScalarQuantity(OtherType);
            }
            const other_value_float: getInnerTypeScalarType(T) = @floatCast(other.value);
            switch (inner_type) {
                .scalar => {
                    self.value += other_value_float;
                },
                .vector => {
                    const other_value_vec: T = @splat(other_value_float);
                    self.value += other_value_vec;
                },
                .array => {
                    for (&self.value) |*s| {
                        s.* += other_value_float;
                    }
                },
                .slice => {
                    for (self.value) |*s| {
                        s.* += other_value_float;
                    }
                },
            }
        }

        /// Buffer-output variant of `addScalar`.
        /// Cast the scalar value into the quantity value type.
        pub fn addScalarInto(self: *const Self, other: anytype, out: *Self) void {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                assertScalarQuantity(OtherType);
            }
            const other_value_float: getInnerTypeScalarType(T) = @floatCast(other.value);
            switch (inner_type) {
                .slice => {
                    for (self.value, out.value) |s, *buf| {
                        buf.* = s + other_value_float;
                    }
                },
                else => out.value = self.addScalar(other).value,
            }
        }

        /// Subtracts two quantities of the same unit, returning a new quantity.
        /// Slices have no owned storage to return, so use `subInPlace` or `subInto`.
        pub fn sub(self: *const Self, other: Self) Self {
            switch (inner_type) {
                .scalar, .vector => {
                    return Quantity(T, U).init(self.value - other.value);
                },
                .array => {
                    var new_array: T = undefined;
                    for (&new_array, self.value, other.value) |*n, s, o| {
                        n.* = s - o;
                    }
                    return Quantity(T, U).init(new_array);
                },
                .slice => {
                    @compileError("Cannot sub Slice, use subInPlace or subInto instead.");
                },
            }
        }

        /// Subtracts `other` from `self`, mutating it in place. Works for all
        /// storage shapes including slices.
        pub fn subInPlace(self: *Self, other: Self) void {
            switch (inner_type) {
                .scalar, .vector => self.value -= other.value,
                .array => {
                    for (&self.value, other.value) |*s, o| {
                        s.* -= o;
                    }
                },
                .slice => {
                    for (self.value, other.value) |*s, o| {
                        s.* -= o;
                    }
                },
            }
        }

        /// Subtracts `other` from `self`, writing the result into `out`. Required
        /// form for slices.
        pub fn subInto(self: *const Self, other: Self, out: *Self) void {
            switch (inner_type) {
                .slice => {
                    for (self.value, other.value, out.value) |s, o, *buf| {
                        buf.* = s - o;
                    }
                },
                else => {
                    out.value = self.sub(other).value;
                },
            }
        }

        /// Subtracts a raw value of type `T` (same unit assumed), returning a new quantity.
        pub fn subValue(self: *const Self, val: T) Self {
            const quantity_val: Quantity(T, U) = .init(val);
            return self.sub(quantity_val);
        }

        /// In-place variant of `subValue`.
        pub fn subValueInPlace(self: *Self, val: T) void {
            const quantity_val: Quantity(T, U) = .init(val);
            self.subInPlace(quantity_val);
        }

        /// Buffer-output variant of `subValue`.
        pub fn subValueInto(self: *const Self, val: T, out: *Self) void {
            const quantity_val: Quantity(T, U) = .init(val);
            self.subInto(quantity_val, out);
        }

        /// Substracts a scalar quantity of the same units, returning a new quantity.
        /// Cast the scalar value into the quantity value type.
        pub fn subScalar(self: *const Self, other: anytype) Self {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                assertScalarQuantity(OtherType);
            }
            const other_value_float: getInnerTypeScalarType(T) = @floatCast(other.value);
            switch (inner_type) {
                .scalar => {
                    return .init(self.value - other_value_float);
                },
                .vector => {
                    const other_value_vec: T = @splat(other_value_float);
                    return .init(self.value - other_value_vec);
                },
                .array => {
                    var new_array: T = undefined;
                    for (&new_array, self.value) |*n, s| {
                        n.* = s - other_value_float;
                    }
                    return Quantity(T, U).init(new_array);
                },
                .slice => {
                    @compileError("Cannot add Slice, use subInPlace or subInto instead.");
                },
            }
        }

        /// In-place variant of `subScalar`.
        pub fn subScalarInPlace(self: *Self, other: anytype) void {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                assertScalarQuantity(OtherType);
            }
            const other_value_float: getInnerTypeScalarType(T) = @floatCast(other.value);
            switch (inner_type) {
                .scalar => self.value -= other_value_float,
                .vector => {
                    const other_value_vec: T = @splat(other_value_float);
                    self.value -= other_value_vec;
                },
                .array => {
                    for (&self.value) |*s| {
                        s.* -= other_value_float;
                    }
                },
                .slice => {
                    for (self.value) |*s| {
                        s.* -= other_value_float;
                    }
                },
            }
        }

        /// Buffer-output variant of `subScalar`.
        /// Cast the scalar value into the quantity value type.
        pub fn subScalarInto(self: *const Self, other: anytype, out: *Self) void {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                assertScalarQuantity(OtherType);
            }
            const other_value_float: getInnerTypeScalarType(T) = @floatCast(other.value);
            switch (inner_type) {
                .slice => {
                    for (self.value, out.value) |s, *buf| {
                        buf.* = s - other_value_float;
                    }
                },
                else => out.value = self.subScalar(other).value,
            }
        }

        /// Multiplies two quantities, producing a quantity whose unit is the product
        /// `U * other.unit`. `other` may carry any unit but must have the same value
        /// storage type `T`. Slices use `mulInto`.
        pub fn mul(self: *const Self, other: anytype) Quantity(T, U.mul(@TypeOf(other).unit)) {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                const vt = OtherType.value_type;
                if (vt != T) {
                    @compileError("Expected Quantity with value type " ++ @typeName(T) ++ " ,got " ++ @typeName(vt) ++ " .");
                }
            }
            switch (inner_type) {
                .scalar, .vector => return .init(self.value * other.value),
                .array => {
                    var new_array: T = undefined;
                    for (&new_array, self.value, other.value) |*n, s, o| {
                        n.* = s * o;
                    }
                    return .init(new_array);
                },
                .slice => @compileError("Cannot multiply Slice, use mulInto instead."),
            }
        }

        /// Multiplies `self` by `other`, writing the result into `out` whose unit is
        /// `U * other.unit`. Required form for slices.
        pub fn mulInto(self: *const Self, other: anytype, out: *Quantity(T, U.mul(@TypeOf(other).unit))) void {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                const vt = OtherType.value_type;
                if (vt != T) {
                    @compileError("Expected Quantity with value type " ++ @typeName(T) ++ " ,got " ++ @typeName(vt) ++ " .");
                }
            }
            switch (inner_type) {
                .slice => {
                    for (self.value, other.value, out.value) |s, o, *buf| {
                        buf.* = s * o;
                    }
                },
                else => {
                    out.value = self.mul(other).value;
                },
            }
        }

        /// Multiplies by a dimensionless value of type `T`, leaving the unit
        /// unchanged, and returns a new quantity.
        pub fn mulValue(self: *const Self, val: T) Self {
            const quantity_val: Quantity(T, unitMod.UNITLESS) = .init(val);
            return self.mul(quantity_val);
        }

        /// In-place variant of `mulValue`.
        pub fn mulValueInPlace(self: *Self, val: T) void {
            switch (inner_type) {
                .scalar, .vector => self.value *= val,
                .array => {
                    for (&self.value, val) |*s, v| {
                        s.* *= v;
                    }
                },
                .slice => {
                    for (self.value, val) |*s, v| {
                        s.* *= v;
                    }
                },
            }
        }

        /// Buffer-output variant of `mulValue`.
        pub fn mulValueInto(self: *const Self, val: T, out: *Self) void {
            const quantity_val: Quantity(T, unitMod.UNITLESS) = .init(val);
            self.mulInto(quantity_val, out);
        }

        /// Multiplies by a scalar quantity (float value). Cast the scalar
        /// value into the quantity value type. This is the equivanlent to
        /// `mulValue` when the Unit matters.
        pub fn mulScalar(self: *const Self, other: anytype) Quantity(T, U.mul(@TypeOf(other).unit)) {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                assertScalarQuantity(OtherType);
            }
            const other_value_float: getInnerTypeScalarType(T) = @floatCast(other.value);
            switch (inner_type) {
                .scalar => return .init(self.value * other_value_float),
                .vector => {
                    const other_value_vec: T = @splat(other_value_float);
                    return .init(self.value * other_value_vec);
                },
                .array => {
                    var new_array: T = undefined;
                    for (&new_array, self.value) |*n, s| {
                        n.* = s * other_value_float;
                    }
                    return .init(new_array);
                },
                .slice => @compileError("Cannot multiply Slice with scalar quantity, use mulScalarInto instead."),
            }
        }

        /// Buffer-output variant of `mulScalar`.
        /// Cast the scalar value into the quantity value type.
        pub fn mulScalarInto(self: *const Self, other: anytype, out: *Quantity(T, U.mul(@TypeOf(other).unit))) void {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                assertScalarQuantity(OtherType);
            }
            const other_value_float: getInnerTypeScalarType(T) = @floatCast(other.value);
            switch (inner_type) {
                .slice => {
                    for (self.value, out.value) |s, *buf| {
                        buf.* = s * other_value_float;
                    }
                },
                else => {
                    out.value = self.mulScalar(other).value;
                },
            }
        }

        /// Divides two quantities, producing a quantity whose unit is the quotient
        /// `U / other.unit`. `other` may carry any unit but must have the same value
        /// storage type `T`. Slices use `divInto`.
        pub fn div(self: *const Self, other: anytype) Quantity(T, U.div(@TypeOf(other).unit)) {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                const vt = OtherType.value_type;
                if (vt != T) {
                    @compileError("Expected Quantity with value type " ++ @typeName(T) ++ " ,got " ++ @typeName(vt) ++ " .");
                }
            }
            switch (inner_type) {
                .scalar, .vector => return .init(self.value / other.value),
                .array => {
                    var new_arr: T = undefined;
                    for (&new_arr, self.value, other.value) |*n, s, o| {
                        n.* = s / o;
                    }
                    return .init(new_arr);
                },
                .slice => @compileError("Cannot divide Slice, use divInto instead."),
            }
        }

        /// Divides `self` by `other`, writing the result into `out` whose unit is
        /// `U / other.unit`. Required form for slices.
        pub fn divInto(self: *const Self, other: anytype, out: *Quantity(T, U.div(@TypeOf(other).unit))) void {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                const vt = OtherType.value_type;
                if (vt != T) {
                    @compileError("Expected Quantity with value type " ++ @typeName(T) ++ " ,got " ++ @typeName(vt) ++ " .");
                }
            }
            switch (inner_type) {
                .slice => {
                    for (self.value, other.value, out.value) |s, o, *buf| {
                        buf.* = s / o;
                    }
                },
                else => {
                    out.value = self.div(other).value;
                },
            }
        }

        /// Divides by a dimensionless value of type `T`, leaving the unit
        /// unchanged, and returns a new quantity.
        pub fn divValue(self: *const Self, val: T) Self {
            const quantity_val: Quantity(T, unitMod.UNITLESS) = .init(val);
            return self.div(quantity_val);
        }

        /// In-place variant of `divValue`.
        pub fn divValueInPlace(self: *Self, val: T) void {
            switch (inner_type) {
                .scalar, .vector => self.value /= val,
                .array, .slice => {
                    for (self.value, val) |*s, v| {
                        s.* /= v;
                    }
                },
            }
        }

        /// Buffer-output variant of `divValue`.
        pub fn divValueInto(self: *const Self, val: T, out: *Self) void {
            const quantity_val: Quantity(T, unitMod.UNITLESS) = .init(val);
            self.divInto(quantity_val, out);
        }

        /// Divides by a scalar quantity (float value). Cast the scalar
        /// value into the quantity value type. This is the equivanlent to
        /// `divValue` when the Unit matters.
        pub fn divScalar(self: *const Self, other: anytype) Quantity(T, U.div(@TypeOf(other).unit)) {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                assertScalarQuantity(OtherType);
            }
            const other_value_float: getInnerTypeScalarType(T) = @floatCast(other.value);
            switch (inner_type) {
                .scalar => return .init(self.value / other_value_float),
                .vector => {
                    const other_value_vec: T = @splat(other_value_float);
                    return .init(self.value / other_value_vec);
                },
                .array => {
                    var new_array: T = undefined;
                    for (&new_array, self.value) |*n, s| {
                        n.* = s / other_value_float;
                    }
                    return .init(new_array);
                },
                .slice => @compileError("Cannot multiply Slice with scalar quantity, use mulScalarInto instead."),
            }
        }

        /// Buffer-output variant of `divScalar`.
        /// Cast the scalar value into the quantity value type.
        pub fn divScalarInto(self: *const Self, other: anytype, out: *Quantity(T, U.div(@TypeOf(other).unit))) void {
            comptime {
                const OtherType = @TypeOf(other);
                utils.assertIsQuantity(OtherType);
                assertScalarQuantity(OtherType);
            }
            const other_value_float: getInnerTypeScalarType(T) = @floatCast(other.value);
            switch (inner_type) {
                .slice => {
                    for (self.value, out.value) |s, *buf| {
                        buf.* = s / other_value_float;
                    }
                },
                else => {
                    out.value = self.divScalar(other).value;
                },
            }
        }

        /// Raises the quantity to a comptime integer power, scaling the unit by the
        /// same exponent (e.g. `m` raised to 2 becomes `m^2`). Negative powers invert.
        /// Slices use `powInto`.
        pub fn pow(self: *const Self, comptime value: isize) Quantity(T, U.pow(value)) {
            switch (inner_type) {
                .scalar => return .init(math.pow(T, self.value, value)),
                .vector => {
                    var new_vec: T = self.value;
                    for (0..@abs(value) - 1) |_| {
                        new_vec = new_vec * new_vec;
                    }
                    if (value < 0) {
                        const ones: T = @splat(1);
                        new_vec = ones / new_vec;
                    }
                    return .init(new_vec);
                },
                .array => {
                    const scalar_type: type = @typeInfo(T).array.child;
                    var new_arr: T = undefined;
                    for (self.value, &new_arr) |s, *n| {
                        n.* = math.pow(scalar_type, s, value);
                    }
                    return .init(new_arr);
                },
                .slice => @compileError("Cannot power Slice, use powInto instead"),
            }
            unreachable;
        }

        /// Buffer-output variant of `pow`, writing into `out` whose unit is `U^value`.
        /// Required form for slices.
        pub fn powInto(self: *const Self, comptime value: isize, out: *Quantity(T, U.pow(value))) void {
            switch (inner_type) {
                .slice => {
                    const scalar_type: type = @typeInfo(T).pointer.child;
                    for (self.value, out.value) |s, *buf| {
                        buf.* = math.pow(scalar_type, s, value);
                    }
                },
                else => {
                    out.value = self.pow(value).value;
                },
            }
        }
        // Panics if `value` is non-positive; sqrt is only defined for positive reals here.
        fn checkSqrtPanic(value: anytype) bool {
            if (value <= 0) sqrtPanic();
            return true;
        }

        fn sqrtPanic() void {
            @panic("Square root of zero encounter");
        }

        /// Takes the square root, halving the unit's exponents (e.g. `m^2` becomes `m`).
        /// Panics if any element is non-positive. Slices use `sqrtInto`.
        pub fn sqrt(self: *const Self) Quantity(T, U.sqrt()) {
            switch (inner_type) {
                .scalar => {
                    if (checkSqrtPanic(self.value)) return .init(@sqrt(self.value));
                },
                .vector => {
                    const zeroes: T = @splat(0);
                    const cmp = self.value <= zeroes;
                    if (@reduce(.Or, cmp)) sqrtPanic();
                    return .init(@sqrt(self.value));
                },
                .array => {
                    var new_array: T = undefined;
                    for (self.value, &new_array) |s, *n| {
                        if (checkSqrtPanic(s)) n.* = @sqrt(s);
                    }
                    return .init(new_array);
                },
                .slice => @compileError("Cannot sqrt Slice, use sqrtInto instead"),
            }
            unreachable;
        }

        /// Buffer-output variant of `sqrt`, writing into `out` whose unit is `sqrt(U)`.
        /// Required form for slices.
        pub fn sqrtInto(self: *const Self, out: *Quantity(T, U.sqrt())) void {
            switch (inner_type) {
                .slice => {
                    for (self.value, out.value) |s, *buf| {
                        if (checkSqrtPanic(s)) buf.* = @sqrt(s);
                    }
                },
                else => out.value = self.sqrt().value,
            }
        }

        // Panics if `value` is non-positive; this implementation restricts cbrt to
        // positive reals.
        fn checkCbrtPanic(value: anytype) bool {
            if (value <= 0) cbrtPanic();
            return true;
        }

        fn cbrtPanic() void {
            @panic("Cube root of zero encounter");
        }

        /// Takes the cube root, dividing the unit's exponents by three (e.g. `m^3`
        /// becomes `m`). Panics if any element is non-positive. Slices use `cbrtInto`.
        pub fn cbrt(self: *const Self) Quantity(T, U.cbrt()) {
            switch (inner_type) {
                .scalar => {
                    if (checkCbrtPanic(self.value)) return .init(math.cbrt(self.value));
                },
                .vector => {
                    const zeroes: T = @splat(0);
                    const cmp = self.value <= zeroes;
                    if (@reduce(.Or, cmp)) cbrtPanic();
                    const vector_type = @typeInfo(T).vector;
                    var new_vec: [vector_type.len]vector_type.child = undefined;
                    const val: [vector_type.len]vector_type.child = self.value;
                    for (val, &new_vec) |v, *n| {
                        n.* = math.cbrt(v);
                    }
                    return .init(new_vec);
                },
                .array => {
                    var new_arr: T = undefined;
                    for (self.value, &new_arr) |s, *n| {
                        if (checkCbrtPanic(s)) {
                            n.* = math.cbrt(s);
                        }
                    }
                    return .init(new_arr);
                },
                .slice => @compileError("Cannot cbrt Slice, use cbrtInto instead"),
            }
            unreachable;
        }

        /// Buffer-output variant of `cbrt`, writing into `out` whose unit is `cbrt(U)`.
        /// Required form for slices.
        pub fn cbrtInto(self: *const Self, out: *Quantity(T, U.cbrt())) void {
            switch (inner_type) {
                .slice => {
                    for (self.value, out.value) |s, *buf| {
                        if (checkCbrtPanic(s)) buf.* = math.cbrt(s);
                    }
                },
                else => out.value = self.cbrt().value,
            }
        }

        /// Sets every element to `value`, broadcasting the scalar across vector,
        /// array, and slice storage.
        pub fn setScalarValue(self: *Self, value: getInnerTypeScalarType(T)) void {
            switch (inner_type) {
                .scalar => self.value = value,
                .vector => self.value = @splat(value),
                .array => @memset(&self.value, value),
                .slice => @memset(self.value, value),
            }
        }

        /// Reduces a multi-element quantity to a single scalar quantity of the same
        /// unit, using the given operation. Supports `Add`, `Mul`, `Min`, `Max`.
        /// A scalar quantity reduces to itself.
        pub fn reduce(self: *const Self, comptime op: std.builtin.ReduceOp) Quantity(getInnerTypeScalarType(T), U) {
            switch (inner_type) {
                .scalar => return self.*,
                .vector => return .init(@reduce(op, self.value)),
                else => {
                    const scalar_type: type = getInnerTypeScalarType(T);
                    switch (op) {
                        .Add => {
                            var sum: scalar_type = 0;
                            for (self.value) |s| {
                                sum += s;
                            }
                            return .init(sum);
                        },
                        .Mul => {
                            var res: scalar_type = 1;
                            for (self.value) |s| {
                                res *= s;
                            }
                            return .init(res);
                        },
                        .Min => {
                            var min: scalar_type = self.value[0];
                            if (self.value.len == 1) return .init(min);
                            for (self.value[1..]) |s| {
                                min = @min(min, s);
                            }
                            return .init(min);
                        },
                        .Max => {
                            var max: scalar_type = self.value[0];
                            if (self.value.len == 1) return .init(max);
                            for (self.value[1..]) |s| {
                                max = @max(max, s);
                            }
                            return .init(max);
                        },
                        else => @compileError("Unsupported reduce operator, supported operator are `Add`, `Mul`, `Min`, `Max`."),
                    }
                },
            }
        }

        /// Dot product with `other`: element-wise multiply then sum, returning a
        /// scalar quantity whose unit is `U * other.unit`. For scalar storage this is
        /// just multiplication.
        pub fn dot(self: *const Self, other: anytype) Quantity(getInnerTypeScalarType(T), U.mul(@TypeOf(other).unit)) {
            switch (inner_type) {
                .scalar => return self.mul(other),
                .vector, .array => return self.mul(other).reduce(.Add),
                .slice => {
                    const sum: getInnerTypeScalarType(T) = 0;
                    for (self.value, other.value) |s, o| {
                        sum += s * o;
                    }
                    return .init(sum);
                },
            }
        }

        /// Converts to another unit of the same dimension. The conversion is affine:
        /// `out = value * (U.scale / target.scale) + (U.offset - target.offset) / target.scale`,
        /// which correctly handles offset units like Celsius and Fahrenheit. A
        /// dimension mismatch is a compile error. Slices use `toInto`.
        pub fn to(self: *const Self, comptime unit_type: Unit) Quantity(T, unit_type) {
            if (comptime !U.dim.eql(unit_type.dim)) {
                @compileError("Units are not compatible.");
            }
            const convert_scale = U.scale / unit_type.scale;
            const self_offset: f64 = U.offset orelse 0;
            const unit_offset: f64 = unit_type.offset orelse 0;
            const convert_offset: f64 = (self_offset - unit_offset) / unit_type.scale;
            const scalar_type: type = getInnerTypeScalarType(T);

            switch (inner_type) {
                .scalar => {
                    if (T != f64) {
                        const convert_scale_float: T = @floatCast(convert_scale);
                        const convert_offset_float: T = @floatCast(convert_offset);
                        return .init(@mulAdd(T, self.value, convert_scale_float, convert_offset_float));
                    }
                    return .init(@mulAdd(T, self.value, convert_scale, convert_offset));
                },
                .vector => {
                    if (scalar_type != f64) {
                        const convert_scale_float: scalar_type = @floatCast(convert_scale);
                        const convert_offset_float: scalar_type = @floatCast(convert_offset);
                        const convert_scale_vec: T = @splat(convert_scale_float);
                        const convert_offset_vec: T = @splat(convert_offset_float);
                        return .init(@mulAdd(T, self.value, convert_scale_vec, convert_offset_vec));
                    } else {
                        const convert_scale_vec: T = @splat(convert_scale);
                        const convert_offset_vec: T = @splat(convert_offset);
                        return .init(@mulAdd(T, self.value, convert_scale_vec, convert_offset_vec));
                    }
                },
                .array => {
                    var new_array: T = undefined;
                    if (scalar_type != f64) {
                        const convert_scale_float: scalar_type = @floatCast(convert_scale);
                        const convert_offset_float: scalar_type = @floatCast(convert_offset);
                        for (self.value, &new_array) |s, *n| {
                            n.* = @mulAdd(scalar_type, s, convert_scale_float, convert_offset_float);
                        }
                        return .init(new_array);
                    }
                    for (self.value, &new_array) |s, *n| {
                        n.* = @mulAdd(scalar_type, s, convert_scale, convert_offset);
                    }
                    return .init(new_array);
                },
                .slice => @compileError("Cannot convert Slice with to, use toInto instead."),
            }
        }

        /// Converts to a target unit using a named physical equivalency (e.g.
        /// `.spectral`, `.mass_energy`, `.doppler_radio`) that allows conversions
        /// across different dimensions. `equivalency` is comptime-known so only the
        /// selected conversion is compiled. `args` carries any extra parameters the
        /// equivalency needs (an empty tuple `.{}` for those that take none).
        pub fn toWithEquivalency(self: *const Self, comptime unit_type: Unit, comptime equivalency: Equivalency, args: anytype) Quantity(T, unit_type) {
            return equivalency.convert(T, U, self, unit_type, args);
        }

        /// Buffer-output variant of `to`, writing the converted value into `out`.
        /// Required form for slices.
        pub fn toInto(self: *const Self, comptime unit_type: Unit, out: *Quantity(T, unit_type)) void {
            if (comptime !U.dim.eql(unit_type.dim)) {
                @compileError("Units are not compatible.");
            }
            const convert_scale = U.scale / unit_type.scale;
            const self_offset: f64 = U.offset orelse 0;
            const unit_offset: f64 = unit_type.offset orelse 0;
            const convert_offset = (self_offset - unit_offset) / unit_type.scale;
            switch (inner_type) {
                .slice => {
                    const scalar_type: type = getInnerTypeScalarType(T);
                    if (scalar_type != f64) {
                        const convert_scale_float: scalar_type = @floatCast(convert_scale);
                        const convert_offset_float: scalar_type = @floatCast(convert_offset);
                        for (self.value, out.value) |s, *buf| {
                            buf.* = @mulAdd(scalar_type, s, convert_scale_float, convert_offset_float);
                        }
                    } else {
                        for (self.value, out.value) |s, *buf| {
                            buf.* = @mulAdd(scalar_type, s, convert_scale, convert_offset);
                        }
                    }
                },
                else => out.value = self.to(unit_type).value,
            }
        }

        pub fn toIntoWithEquivalency(self: *const Self, comptime unit_type: Unit, out: *Quantity(T, unit_type), comptime equivalency: Equivalency, args: anytype) void {
            switch (inner_type) {
                .slice => equivalency.convertInto(T, U, self, unit_type, out, args),
                else => out.value = equivalency.convert(T, U, self, unit_type, args).value,
            }
        }

        // Decomposes the unit into base units of the given `system` (e.g. expanding
        /// `N` into `kg·m·s⁻²`), scaling the value by `U.scale` so the physical
        /// magnitude is preserved. Slices use `decomposeInto`.
        pub fn decompose(self: *const Self, comptime system: System) Quantity(T, U.decompose(system)) {
            switch (inner_type) {
                .scalar, .vector => return .init(self.value * U.scale),
                .array => {
                    var new_arr = self.value;
                    for (&new_arr) |*n| {
                        n.* *= U.scale;
                    }
                    return .init(new_arr);
                },
                .slice => @compileError("Cannot convert Slice with decompose, use decomposeInto instead."),
            }
        }

        /// Buffer-output variant of `decompose`, writing into `out`. Required form
        /// for slices.
        pub fn decomposeInto(self: *const Self, comptime system: System, out: *Quantity(T, U.decompose(system))) void {
            for (self.value, out.value) |s, *buf| {
                buf.* = s * U.scale;
            }
        }

        // Prints a single float, switching to scientific notation for very large or
        // very small magnitudes and using decimal notation otherwise.
        fn printQuantityFloat(writer: *std.Io.Writer, comptime Ty: type, value: Ty) std.Io.Writer.Error!void {
            if (@abs(value) > 100000 or @abs(value) < 1e-3) {
                try writer.print("{e}", .{value});
            } else {
                try writer.print("{d}", .{value});
            }
        }

        // Formats vector/array/slice storage. Collections of more than three
        // elements are abbreviated as `{ a, b, ... y, z }` to keep output compact.
        fn formatIterable(self: *const Self, writer: *std.Io.Writer) std.Io.Writer.Error!void {
            const scalar_type: type = getInnerTypeScalarType(T);
            const container_type, const str = switch (inner_type) {
                .array => .{ T, "Array: { " },
                .slice => .{ T, "Slice: { " },
                .vector => blk: {
                    const vector_type = @typeInfo(T).vector;
                    break :blk .{ [vector_type.len]vector_type.child, "Vector: { " };
                },
                else => unreachable,
            };
            const val: container_type = self.value;
            const len = val.len;
            if (len <= 3) {
                try writer.writeAll(str);
                for (0..len) |i| {
                    try printQuantityFloat(writer, scalar_type, val[i]);
                    if (i != len - 1) try writer.writeByte(',');
                    try writer.writeByte(' ');
                }
                try writer.print("}} {f}", .{U.symbol});
            } else {
                try writer.writeAll(str);
                for (0..2) |i| {
                    try printQuantityFloat(writer, scalar_type, val[i]);
                    try writer.writeAll(", ");
                }
                try writer.writeAll("... ");
                for (len - 2..len) |i| {
                    try printQuantityFloat(writer, scalar_type, val[i]);
                    if (i != len - 1) try writer.writeByte(',');
                    try writer.writeByte(' ');
                }
                try writer.print("}} {f}", .{U.symbol});
            }
        }

        /// `std.fmt` formatting hook. Prints the value followed by the unit symbol,
        /// e.g. `2e6 s` for a scalar or `Vector: { 440, 880, 1760 } Hz` for a vector.
        pub fn format(self: *const Self, writer: *std.Io.Writer) std.Io.Writer.Error!void {
            switch (inner_type) {
                .scalar => {
                    try printQuantityFloat(writer, T, self.value);
                    try writer.print(" {f}", .{U.symbol});
                },
                .vector, .array, .slice => {
                    try self.formatIterable(writer);
                },
            }
        }
    };
}

test "init" {
    const size = Quantity(f64, si.m).init(3.1415);
    try testing.expectEqual(size.value, 3.1415);
    try testing.expectEqual(@TypeOf(size).unit, si.m);
}

test "add" {
    //float
    const time1 = Quantity(f64, si.s).init(10);
    const time2 = Quantity(f64, si.s).init(15);
    const timeRes = time1.add(time2);
    try testing.expectApproxEqAbs(timeRes.value, 25, 1e-15);

    // vector
    const vec1 = @Vector(2, f64){ 2, 4 };
    const vec2 = @Vector(2, f64){ 3, 5 };
    const quantity1: Quantity(@Vector(2, f64), si.AA) = .init(vec1);
    const quantity2: Quantity(@Vector(2, f64), si.AA) = .init(vec2);
    const added = quantity1.add(quantity2);
    const val: [2]f64 = added.value;
    const exp: [2]f64 = .{ 5, 9 };
    try zatest.expectApproxEqAbsIter(exp, val, 1e-15);

    // array
    const arr1: [3]f64 = .{ 1.1, 2.2, 3.3 };
    const arr2: [3]f64 = .{ 1.1, 2.2, 3.3 };
    const size1: Quantity([3]f64, si.m) = .init(arr1);
    const size2: Quantity([3]f64, si.m) = .init(arr2);
    const sizeRes = size1.add(size2);
    const expected: [3]f64 = .{ 2.2, 4.4, 6.6 };
    try zatest.expectApproxEqAbsIter(expected, sizeRes.value, 1e-15);
}

test "addInPlace" {
    //float
    var time1 = Quantity(f32, si.s).init(15);
    const time2 = Quantity(f32, si.s).init(5);
    time1.addInPlace(time2);
    try testing.expectApproxEqAbs(20, time1.value, 1e-15);

    // vector
    const vec1 = @Vector(2, f64){ 2, 4 };
    const vec2 = @Vector(2, f64){ 3, 5 };
    var quantity1: Quantity(@Vector(2, f64), si.AA) = .init(vec1);
    const quantity2: Quantity(@Vector(2, f64), si.AA) = .init(vec2);
    quantity1.addInPlace(quantity2);
    const val: [2]f64 = quantity1.value;
    const exp: [2]f64 = .{ 5, 9 };
    try zatest.expectApproxEqAbsIter(exp, val, 1e-15);

    // array
    const arr1: [3]f64 = .{ 1.1, 2.2, 3.3 };
    const arr2: [3]f64 = .{ 1.1, 2.2, 3.3 };
    var size1: Quantity([3]f64, si.m) = .init(arr1);
    const size2: Quantity([3]f64, si.m) = .init(arr2);
    size1.addInPlace(size2);
    const expected: [3]f64 = .{ 2.2, 4.4, 6.6 };
    try zatest.expectApproxEqAbsIter(expected, size1.value, 1e-15);
}

test "addInto" {
    // float
    const q1: Quantity(f64, si.m) = .init(3.3);
    const q2: Quantity(f64, si.m) = .init(2.2);
    var q_dest: Quantity(f64, si.m) = .init(undefined);
    q1.addInto(q2, &q_dest);
    try testing.expectApproxEqAbs(5.5, q_dest.value, 1e-15);

    // slice
    const allocator = testing.allocator;
    const list_type = std.ArrayList(f64);
    var list_1 = try list_type.initCapacity(allocator, 2);
    defer list_1.deinit(allocator);
    var list_2 = try list_type.initCapacity(allocator, 2);
    defer list_2.deinit(allocator);
    list_1.appendSliceAssumeCapacity(&[2]f64{ 1, 2 });
    list_2.appendSliceAssumeCapacity(&[2]f64{ 2, 3 });
    const q_list_1: Quantity([]f64, si.m) = .init(list_1.items);
    const q_list_2: Quantity([]f64, si.m) = .init(list_2.items);
    var list_dest = try list_type.initCapacity(allocator, 2);
    defer list_dest.deinit(allocator);
    try list_dest.resize(allocator, 2);
    var q_list_dest: Quantity([]f64, si.m) = .init(list_dest.items);
    q_list_1.addInto(q_list_2, &q_list_dest);
    try zatest.expectApproxEqAbsIter(&[_]f64{ 3, 5 }, q_list_dest.value, 1e-15);
    try testing.expectEqual(si.m, @TypeOf(q_list_dest).unit);
}

test "add value methods" {
    const q1: Quantity(f64, si.m) = .init(5);
    const q_add1 = q1.addValue(3);
    try testing.expectApproxEqAbs(8, q_add1.value, 1e-15);
    try testing.expectEqual(q1.getUnit(), q_add1.getUnit());

    var q2: Quantity(@Vector(3, f32), si.s) = .init(.{ 3, 4, 5 });
    q2.addValueInPlace(.{ 3, 4, 5 });
    const val: [3]f32 = q2.value;
    try zatest.expectApproxEqAbsIter([3]f32{ 6, 8, 10 }, val, 1e-15);

    var buf: [3]f64 = undefined;
    const q3: Quantity([]f64, si.Bq) = .init(@constCast(&[3]f64{ 10, 20, 30 }));
    var q_add3: Quantity([]f64, si.Bq) = .init(&buf);
    q3.addValueInto(@constCast(&[3]f64{ 40, 50, 60 }), &q_add3);
    try zatest.expectApproxEqAbsIter(@constCast(&[3]f64{ 50, 70, 90 }), q_add3.value, 1e-15);
}

test "add scalar methods" {
    const q1: Quantity(f64, si.arcmin) = .init(12);
    const q2: Quantity(f64, si.arcmin) = .init(14);
    const added = q1.addScalar(q2);
    try testing.expectApproxEqAbs(26, added.value, 1e-15);
    try testing.expectEqual(si.arcmin, added.getUnit());

    var q3: Quantity(@Vector(2, f64), us.TeV) = .init(.{ 3, 6 });
    const q4: Quantity(f64, us.TeV) = .init(10);
    q3.addScalarInPlace(q4);
    const val: [2]f64 = q3.value;
    const exp: [2]f64 = .{ 13, 16 };
    try zatest.expectApproxEqAbsIter(exp, val, 1e-15);

    var buf: [4]f32 = undefined;
    const q5: Quantity([]f32, si.deg) = .init(@constCast(&[_]f32{ 1, 2, 3, 4 }));
    const q6: Quantity(f64, si.deg) = .init(6);
    var added_2: Quantity([]f32, si.deg) = .init(&buf);
    q5.addScalarInto(q6, &added_2);
    try zatest.expectApproxEqAbsIter(@constCast(&[_]f32{ 7, 8, 9, 10 }), added_2.value, 1e-15);
}

test "sub" {
    //float
    const size1 = Quantity(f64, si.AA).init(12);
    const size2 = Quantity(f64, si.AA).init(3);
    const sizeRes = size1.sub(size2);
    try testing.expectApproxEqAbs(sizeRes.value, 9, 1e-15);

    // vector
    const vec1 = @Vector(2, f64){ 2, 4 };
    const vec2 = @Vector(2, f64){ 3, 5 };
    const quantity1: Quantity(@Vector(2, f64), si.AA) = .init(vec1);
    const quantity2: Quantity(@Vector(2, f64), si.AA) = .init(vec2);
    const subbed = quantity1.sub(quantity2);
    const val: [2]f64 = subbed.value;
    const exp: [2]f64 = .{ -1, -1 };
    try zatest.expectApproxEqAbsIter(exp, val, 1e-15);

    // array
    const arr1: [3]f64 = .{ 1.1, 2.2, 3.3 };
    const arr2: [3]f64 = .{ 1.1, 1.1, 1.1 };
    const size3: Quantity([3]f64, si.m) = .init(arr1);
    const size4: Quantity([3]f64, si.m) = .init(arr2);
    const sizeRes2 = size3.sub(size4);
    const expected: [3]f64 = .{ 0.0, 1.1, 2.2 };
    try zatest.expectApproxEqAbsIter(expected, sizeRes2.value, 1e-15);
}

test "subInPlace" {
    //float
    var freq1 = Quantity(f32, si.Hz).init(50);
    const freq2 = Quantity(f32, si.Hz).init(70);
    freq1.subInPlace(freq2);
    try testing.expectApproxEqAbs(freq1.value, -20, 1e-15);

    // vector
    const vec1 = @Vector(2, f64){ 2, 4 };
    const vec2 = @Vector(2, f64){ 3, 5 };
    var quantity1: Quantity(@Vector(2, f64), si.AA) = .init(vec1);
    const quantity2: Quantity(@Vector(2, f64), si.AA) = .init(vec2);
    quantity1.subInPlace(quantity2);
    const val: [2]f64 = quantity1.value;
    const exp: [2]f64 = .{ -1, -1 };
    try zatest.expectApproxEqAbsIter(exp, val, 1e-15);

    // array
    const arr1: [3]f64 = .{ 1.1, 2.2, 3.3 };
    const arr2: [3]f64 = .{ 1.1, 1.1, 1.1 };
    var size3: Quantity([3]f64, si.m) = .init(arr1);
    const size4: Quantity([3]f64, si.m) = .init(arr2);
    size3.subInPlace(size4);
    const expected: [3]f64 = .{ 0.0, 1.1, 2.2 };
    try zatest.expectApproxEqAbsIter(expected, size3.value, 1e-15);
}

test "subInto" {
    // slice
    var arr1: [3]f64 = .{ 3, 5, 7 };
    var arr2: [3]f64 = .{ 2, 4, 6 };
    var buf: [3]f64 = undefined;
    const q1: Quantity([]f64, si.s) = .init(&arr1);
    const q2: Quantity([]f64, si.s) = .init(&arr2);
    var q_subbed: Quantity([]f64, si.s) = .init(&buf);
    q1.subInto(q2, &q_subbed);
    try zatest.expectApproxEqAbsIter([_]f64{ 1, 1, 1 }, buf, 1e-15);
    try testing.expectApproxEqAbs(1, q_subbed.value[0], 1e-15);
}

test "sub value methods" {
    const q1: Quantity(f32, si.N) = .init(-33);
    const q_sub1 = q1.subValue(15);
    try testing.expectApproxEqAbs(-48, q_sub1.value, 1e-15);
    try testing.expectEqual(q1.getUnit(), q_sub1.getUnit());

    var q2: Quantity([3]f64, si.mol) = .init(.{ 3, 3, 3 });
    q2.addValueInPlace(.{ 4, 5, 6 });
    try zatest.expectApproxEqAbsIter([3]f64{ 7, 8, 9 }, q2.value, 1e-15);

    var buf: [2]f32 = undefined;
    const q3: Quantity([]f32, si.kg) = .init(@constCast(&[2]f32{ 3.3, 4.4 }));
    var q_sub3: Quantity([]f32, si.kg) = .init(&buf);
    q3.subValueInto(@constCast(&[2]f32{ 3.3, 4.4 }), &q_sub3);
    try zatest.expectApproxEqAbsIter(@constCast(&[2]f32{ 0.0, 0.0 }), q_sub3.value, 1e-15);
}

test "sub scalar methods" {
    const q1: Quantity(f64, si.Hz) = .init(32);
    const q2: Quantity(f64, si.Hz) = .init(2);
    const sub_1 = q1.subScalar(q2);
    try testing.expectApproxEqAbs(30, sub_1.value, 1e-15);
    try testing.expectEqual(si.Hz, sub_1.getUnit());

    var q3: Quantity([3]f32, si.m) = .init(.{ 10, 9, 8 });
    q3.subScalarInPlace(q2);
    try zatest.expectApproxEqAbsIter([_]f32{ 8, 7, 6 }, q3.value, 1e-15);

    var buf: [2]f64 = undefined;
    var out: Quantity([]f64, si.F) = .init(&buf);
    const q4: Quantity([]f64, si.F) = .init(@constCast(&[_]f64{ 15, 25 }));
    q4.subScalarInto(q2, &out);
    try zatest.expectApproxEqAbsIter(@constCast(&[_]f64{ 13, 23 }), out.value, 1e-15);
}

test "mul" {
    // float
    const size1 = Quantity(f64, si.m).init(10);
    const size2 = Quantity(f64, si.m).init(3);
    const area = size1.mul(size2);
    try testing.expectEqual(area.value, 30);
    try testing.expectEqual(si.m.mul(si.m), @TypeOf(area).unit);

    // vector
    const vec1 = @Vector(2, f64){ 2, 4 };
    const vec2 = @Vector(2, f64){ 3, 5 };
    const quantity1: Quantity(@Vector(2, f64), si.AA) = .init(vec1);
    const quantity2: Quantity(@Vector(2, f64), si.AA) = .init(vec2);
    const multiplied = quantity1.mul(quantity2);
    const val: [2]f64 = multiplied.value;
    const exp: [2]f64 = .{ 6, 20 };
    try zatest.expectApproxEqAbsIter(exp, val, 1e-15);

    // array
    const arr1: [3]f64 = .{ 1.1, 2.2, 3.3 };
    const arr2: [3]f64 = .{ 1.1, 2.2, 2.2 };
    const size3: Quantity([3]f64, si.m) = .init(arr1);
    const size4: Quantity([3]f64, si.m) = .init(arr2);
    const area2 = size3.mul(size4);
    const expected: [3]f64 = .{ 1.21, 4.84, 7.26 };
    try zatest.expectApproxEqAbsIter(expected, area2.value, 1e-15);
}

test "mulInto" {
    // slice
    var arr1: [3]f64 = .{ 1, 2, 3 };
    var arr2: [3]f64 = .{ 2, 3, 4 };
    var buf: [3]f64 = undefined;
    const q1: Quantity([]f64, si.m) = .init(&arr1);
    const q2: Quantity([]f64, si.s) = .init(&arr2);
    var action: Quantity([]f64, si.m.mul(si.s)) = .init(&buf);
    q1.mulInto(q2, &action);
    try zatest.expectApproxEqAbsIter(&[_]f64{ 2, 6, 12 }, action.value, 1e-15);
    try testing.expectEqual(si.m.mul(si.s), @TypeOf(action).unit);
}

test "mul value methods" {
    const q1: Quantity(f64, si.mm) = .init(32);
    const q_mul1 = q1.mulValue(10);
    try testing.expectApproxEqAbs(320, q_mul1.value, 1e-15);
    try testing.expectEqual(q1.getUnit(), q_mul1.getUnit());

    var q2: Quantity([3]f64, si.kg) = .init(.{ 1, 2, 3 });
    q2.mulValueInPlace(.{ 10, 10, 10 });
    try zatest.expectApproxEqAbsIter([3]f64{ 10, 20, 30 }, q2.value, 1e-15);
    try testing.expectEqual(si.kg, q2.getUnit());

    var buf: [1]f64 = undefined;
    const q3: Quantity([]f64, si.deg) = .init(@constCast(&[1]f64{-20}));
    var q_mul3: Quantity([]f64, si.deg) = .init(&buf);
    q3.mulValueInto(@constCast(&[1]f64{-4}), &q_mul3);
    try zatest.expectApproxEqAbsIter(@constCast(&[_]f64{80}), q_mul3.value, 1e-15);
    try testing.expectEqual(si.deg, q_mul3.getUnit());
}

test "mul scalar method" {
    const q1: Quantity(f64, si.m) = .init(64);
    const q2: Quantity(f32, si.s) = .init(2);
    const q_mul1 = q1.mulScalar(q2);
    try testing.expectApproxEqAbs(128, q_mul1.value, 1e-15);
    try testing.expectEqual(si.m.mul(si.s), q_mul1.getUnit());

    var q3: Quantity([2]f64, si.g) = .init(.{ 2, 4 });
    const q_mul2 = q3.mulScalar(q2);
    try zatest.expectApproxEqAbsIter([2]f64{ 4, 8 }, q_mul2.value, 1e-15);
    try testing.expectEqual(si.g.mul(si.s), q_mul2.getUnit());

    var buf: [3]f64 = undefined;
    const q4: Quantity([]f64, si.deg) = .init(@constCast(&[3]f64{ 3, 6, 9 }));
    var q_mul3: Quantity([]f64, si.deg.mul(si.s)) = .init(&buf);
    q4.mulScalarInto(q2, &q_mul3);
    try zatest.expectApproxEqAbsIter(@constCast(&[_]f64{ 6, 12, 18 }), q_mul3.value, 1e-15);
    try testing.expectEqual(si.deg.mul(si.s), q_mul3.getUnit());
}

test "div" {
    // float
    const size = Quantity(f64, si.m).init(5);
    const time = Quantity(f64, si.s).init(2);
    const speed = size.div(time);
    try testing.expectEqual(2.5, speed.value);
    try testing.expectEqual(si.m.div(si.s), @TypeOf(speed).unit);

    // vector
    const vec1 = @Vector(2, f64){ 9, 20 };
    const vec2 = @Vector(2, f64){ 3, 5 };
    const quantity1: Quantity(@Vector(2, f64), si.AA) = .init(vec1);
    const quantity2: Quantity(@Vector(2, f64), si.AA) = .init(vec2);
    const divided = quantity1.div(quantity2);
    const val: [2]f64 = divided.value;
    const exp: [2]f64 = .{ 3, 4 };
    try zatest.expectApproxEqAbsIter(exp, val, 1e-15);

    // array
    const size_arr: [2]f32 = .{ 2, 5 };
    const time_arr: [2]f32 = @splat(2);
    const size_2: Quantity([2]f32, si.m) = .init(size_arr);
    const time_2: Quantity([2]f32, si.s) = .init(time_arr);
    const speed_2 = size_2.div(time_2);
    const expected = [_]f32{ 1, 2.5 };
    try zatest.expectApproxEqAbsIter(expected, speed_2.value, 1e-15);
}

test "divInto" {
    // slice
    var arr1: [1]f32 = .{-1};
    var arr2: [1]f32 = .{2};
    var buf: [1]f32 = .{3};
    const q1: Quantity([]f32, si.m) = .init(&arr1);
    const q2: Quantity([]f32, si.s) = .init(&arr2);
    var speed: Quantity([]f32, si.m.div(si.s)) = .init(&buf);
    q1.divInto(q2, &speed);
    try testing.expectApproxEqAbs(-0.5, speed.value[0], 1e-15);
    try testing.expectEqual(si.m.div(si.s), @TypeOf(speed).unit);
}

test "div value methods" {
    const q1: Quantity(@Vector(2, f32), si.kg) = .init(.{ 10, 20 });
    const q_div1 = q1.divValue(@splat(2));
    const val: [2]f32 = q_div1.value;
    try zatest.expectApproxEqAbsIter([2]f32{ 5, 10 }, val, 1e-15);
    try testing.expectEqual(q1.getUnit(), q_div1.getUnit());

    var buf1: [2]f32 = .{ 15, 25 };
    var q2: Quantity([]f32, si.m) = .init(&buf1);
    q2.divValueInPlace(@constCast(&[2]f32{ 5, 25 }));
    try zatest.expectApproxEqAbsIter(@constCast(&[2]f32{ 3, 1 }), q2.value, 1e-15);
    try testing.expectEqual(si.m, q2.getUnit());

    var buf2: [2]f32 = undefined;
    var q_div3: Quantity([]f32, si.m) = .init(&buf2);
    q2.divValueInto(@constCast(&[2]f32{ 2, 2 }), &q_div3);
    try zatest.expectApproxEqAbsIter(@constCast(&[2]f32{ 1.5, 0.5 }), q_div3.value, 1e-15);
    try testing.expectEqual(si.m, q_div3.getUnit());
}

test "div scalar methods" {
    const q1: Quantity(f32, si.m) = .init(12);
    const q2: Quantity(f64, si.s) = .init(2);
    const divided = q1.divScalar(q2);
    try testing.expectApproxEqAbs(6, divided.value, 1e-15);
    try testing.expectEqual(si.m.div(si.s), divided.getUnit());

    const q3: Quantity(@Vector(3, f64), si.g) = .init(.{4, 6, 8});
    const divided_2 = q3.divScalar(q2);
    const val: [3]f64 = divided_2.value;
    const exp: [3]f64 = .{2, 3, 4};
    try zatest.expectApproxEqAbsIter(exp, val, 1e-15);

    var buf: [2]f32 = undefined;
    var out: Quantity([]f32, si.Hz.div(si.s)) = .init(&buf);
    const q4: Quantity([]f32, si.Hz) = .init(@constCast(&[_]f32{10, 20}));
    q4.divScalarInto(q2, &out);
    try zatest.expectApproxEqAbsIter(@constCast(&[_]f32{5, 10}), out.value, 1e-15);
}

test "pow" {
    // float
    const q1: Quantity(f64, si.kg) = .init(3);
    const q1_pow = q1.pow(2);
    try testing.expectApproxEqAbs(9, q1_pow.value, 1e-15);
    try testing.expectEqual(si.kg.pow(2), @TypeOf(q1_pow).unit);
    const q2: Quantity(f32, si.m) = .init(15.5);
    const q2_pow = q2.pow(3);
    try testing.expectApproxEqAbs(3723.875, q2_pow.value, 1e-15);

    // vector
    const q3: Quantity(@Vector(3, f64), si.s) = .init(.{ 2, 4, 6 });
    const q3_pow = q3.pow(2);
    try testing.expectEqual(@Vector(3, f64){ 4, 16, 36 }, q3_pow.value);

    //array
    const q4: Quantity([2]f32, si.s) = .init(.{ 4, 16 });
    const q4_pow = q4.pow(-2);
    try zatest.expectApproxEqAbsIter([2]f32{ 0.0625, 0.00390625 }, q4_pow.value, 1e-15);
}

test "powInto" {
    // slice
    var arr1: [3]f64 = .{ 2, 3, 4 };
    var arr2: [3]f64 = undefined;
    const q1: Quantity([]f64, si.s) = .init(&arr1);
    var q_pow: Quantity([]f64, si.s.pow(2)) = .init(&arr2);
    q1.powInto(2, &q_pow);
    try zatest.expectApproxEqAbsIter(&[3]f64{ 4, 9, 16 }, q_pow.value, 1e-15);
    try testing.expectEqual(si.s.pow(2), @TypeOf(q_pow).unit);
}

test "sqrt" {
    // float
    const q1: Quantity(f64, si.m) = .init(9);
    const q1_sqrt = q1.sqrt();
    try testing.expectEqual(3, q1_sqrt.value);
    try testing.expectEqual(si.m.sqrt(), @TypeOf(q1_sqrt).unit);

    // vector
    const q2: Quantity(@Vector(3, f32), si.Hz) = .init(.{ 9, 16, 25 });
    const q2_sqrt = q2.sqrt();
    try testing.expectEqual(@Vector(3, f32){ 3, 4, 5 }, q2_sqrt.value);

    // array
    const q3: Quantity([1]f64, si.rad) = .init(.{4});
    const q3_sqrt = q3.sqrt();
    try testing.expectEqual([_]f64{2}, q3_sqrt.value);
}

test "sqrtInto" {
    var arr1: [3]f64 = .{ 16, 25, 36 };
    var arr2: [3]f64 = undefined;
    const q1: Quantity([]f64, si.m.pow(2)) = .init(&arr1);
    var q_sqrt: Quantity([]f64, si.m.pow(2).sqrt()) = .init(&arr2);
    q1.sqrtInto(&q_sqrt);
    try zatest.expectApproxEqAbsIter(&[3]f64{ 4, 5, 6 }, q_sqrt.value, 1e-15);
    const unit = comptime blk: {
        break :blk si.m.pow(2).sqrt();
    };
    try testing.expectEqual(unit, @TypeOf(q_sqrt).unit);
}

test "cbrt" {
    // float and int
    const q1: Quantity(f64, si.m) = .init(27);
    const q1_cbrt = q1.cbrt();
    try testing.expectEqual(3, q1_cbrt.value);
    try testing.expectEqual(si.m.cbrt(), @TypeOf(q1_cbrt).unit);

    // vector
    const q2: Quantity(@Vector(3, f32), si.Hz) = .init(.{ 27, 64, 125 });
    const q2_cbrt = q2.cbrt();
    try testing.expectEqual(@Vector(3, f32){ 3, 4, 5 }, q2_cbrt.value);

    // array
    const q3: Quantity([1]f64, si.rad) = .init(.{8});
    const q3_cbrt = q3.cbrt();
    try testing.expectEqual([_]f64{2}, q3_cbrt.value);
}

test "cbrtInto" {
    var arr1: [2]f32 = .{ 27, 64 };
    var arr2: [2]f32 = undefined;
    const q1: Quantity([]f32, si.m) = .init(&arr1);
    var q_cbrt: Quantity([]f32, si.m.cbrt()) = .init(&arr2);
    q1.cbrtInto(&q_cbrt);
    try zatest.expectApproxEqAbsIter(&[2]f32{ 3, 4 }, q_cbrt.value, 1e-15);
    try testing.expectEqual(si.m.cbrt(), @TypeOf(q_cbrt).unit);
}

test "to" {
    const size_m = Quantity(f64, si.m).init(3);
    const size_cm = size_m.to(si.cm);
    try testing.expectEqual(300, size_cm.value);
    try testing.expectEqual(si.cm, @TypeOf(size_cm).unit);

    const mass_g = Quantity(f64, si.g).init(30);
    const mass_kg = mass_g.to(si.kg);

    try testing.expectEqual(0.03, mass_kg.value);
    try testing.expectEqual(si.kg, @TypeOf(mass_kg).unit);

    const temp_C = Quantity(f64, si.degC).init(0);
    const temp_K = temp_C.to(si.K);
    try testing.expectEqual(273.15, temp_K.value);
    try testing.expectEqual(si.K, @TypeOf(temp_K).unit);

    const temp_K_2 = Quantity(f64, si.K).init(0);
    const temp_C_2 = temp_K_2.to(si.degC);
    try testing.expectEqual(-273.15, temp_C_2.value);

    const temp_F: Quantity(f64, imperial.degF) = .init(32);
    const temp_F_to_K = temp_F.to(si.K);
    try testing.expectApproxEqAbs(255.37222222222223, temp_F_to_K.value, 1e-15);
}

test "toWithEquivalency" {
    // float
    const freq: Quantity(f64, si.Hz) = .init(1e9);
    const wavelength = freq.toWithEquivalency(si.nm, .spectral, .{});
    try testing.expectApproxEqAbs(299792458, wavelength.value, 1e-15);
    try testing.expectEqual(si.nm, wavelength.getUnit());

    // vector
    const vec: @Vector(2, f64) = .{ 9.1093837015e-31, 1.67262192369e-27 };
    const mass: Quantity(@Vector(2, f64), si.kg) = .init(vec);
    const energy = mass.toWithEquivalency(si.J, .mass_energy, .{});
    const expected: @Vector(2, f64) = .{ 8.187105776e-14, 1.503277615e-10 };
    const val: [2]f64 = energy.value;
    const exp: [2]f64 = expected;
    try zatest.expectApproxEqAbsIter(exp, val, 1e-15);

    // array
    const rest_freq: Quantity([3]f64, us.GHz) = .initScalarValue(1.420405751768);
    const velocities: [3]f64 = .{ 0.0, 1000.0, -1000.0 };
    const freq_arr: Quantity([3]f64, us.km.div(si.s)) = .init(velocities);
    const as_freq = freq_arr.toWithEquivalency(us.GHz, .doppler_radio, .{rest_freq});
    const expected_2: [3]f64 = .{ 1.420405751768, 1.4156677881739728, 1.4251437153620274 };
    try zatest.expectApproxEqAbsIter(expected_2, as_freq.value, 1e-15);
}

test "toInto" {
    const q1: Quantity([]f64, si.m) = .init(@constCast(&[2]f64{ 1, 2 }));
    var arr: [2]f64 = undefined;
    var q2: Quantity([]f64, si.cm) = .init(&arr);
    q1.toInto(si.cm, &q2);
    try testing.expectEqualSlices(f64, &[2]f64{ 100, 200 }, q2.value);
}

test "reduce" {
    // Add
    const q1: Quantity(f32, si.AA) = .init(23);
    const q1_red: Quantity(f32, si.AA) = q1.reduce(.Add);
    try testing.expectApproxEqAbs(23, q1_red.value, 1e-15);
    try testing.expectEqual(si.AA, @TypeOf(q1_red).unit);

    // Mul
    const q2: Quantity(@Vector(3, f32), si.mas) = .init(.{ 2, -4, 10 });
    const q2_red = q2.reduce(.Mul);
    try testing.expectApproxEqAbs(-80, q2_red.value, 1e-15);
    try testing.expectEqual(si.mas, @TypeOf(q2_red).unit);

    // Min
    const q3: Quantity([2]f32, si.m) = .init(.{ 4.06, 12.32 });
    const q3_red = q3.reduce(.Min);
    try testing.expectApproxEqAbs(4.06, q3_red.value, 1e-15);
    try testing.expectEqual(si.m, @TypeOf(q3_red).unit);

    // Max
    const arr: [3]f64 = .{ 2.5, 45.98, 123.3214 };
    const q4: Quantity([]f64, si.C) = .init(@constCast(&arr));
    const q4_red: Quantity(f64, si.C) = q4.reduce(.Max);
    try testing.expectApproxEqAbs(123.3214, q4_red.value, 1e-15);
    try testing.expectEqual(si.C, @TypeOf(q4_red).unit);
}

test "decompose" {
    const q1: Quantity(f64, si.cm) = .init(2.5);
    const q1_decomp = q1.decompose(.SI);
    try testing.expectApproxEqAbs(0.025, q1_decomp.value, 1e-15);
    try testing.expectEqual(si.m, @TypeOf(q1_decomp).unit);

    const q2: Quantity(f64, si.N) = .init(10);
    const q2_decomp = q2.decompose(.SI);
    try testing.expectApproxEqAbs(10, q2_decomp.value, 1e-15);
    const expected_unit_1: Unit = si.kg.mul(si.m).div(si.s.pow(2));
    try testing.expect(expected_unit_1.eqlExact(@TypeOf(q2_decomp).unit));

    const q3: Quantity([3]f64, si.N.mul(si.J).mul(si.um).div(si.s.pow(3))) = .init(.{ 32, 45, 78 });
    const q3_decomp = q3.decompose(.SI);
    try zatest.expectApproxEqAbsIter([3]f64{ 32e-6, 45e-6, 78e-6 }, q3_decomp.value, 1e-15);
    const expected_unit_2: Unit = si.m.pow(4).mul(si.kg.pow(2)).div(si.s.pow(7));
    try testing.expect(expected_unit_2.eqlExact(@TypeOf(q3_decomp).unit));
}

test "decomposeInto" {
    var arr: [3]f64 = .{ 2, 3, 4 };
    const q1: Quantity([]f64, si.C) = .init(&arr);
    var buf: [3]f64 = undefined;
    var q1_decom: Quantity([]f64, si.s.mul(si.A)) = .init(&buf);
    q1.decomposeInto(.SI, &q1_decom);
    try testing.expectEqualSlices(f64, &[3]f64{ 2, 3, 4 }, q1_decom.value);
    try testing.expect(si.A.mul(si.s).eqlExact(@TypeOf(q1_decom).unit));
}

test "format" {
    const allocator = std.testing.allocator;

    const q1: Quantity(f64, si.s) = .init(2000000);
    const print1 = try std.fmt.allocPrint(allocator, "{f}", .{q1});
    try testing.expectEqualSlices(u8, "2e6 s", print1);
    allocator.free(print1);

    const q2: Quantity(f64, si.kg) = .init(1.2094484932943e12);
    const print2 = try std.fmt.allocPrint(allocator, "{f}", .{q2});
    try testing.expectEqualSlices(u8, "1.2094484932943e12 kg", print2);
    allocator.free(print2);

    const q3: Quantity(@Vector(3, f64), si.Hz) = .init(.{ 440, 880, 1760 });
    const print3 = try std.fmt.allocPrint(allocator, "{f}", .{q3});
    try testing.expectEqualSlices(u8, "Vector: { 440, 880, 1760 } Hz", print3);
    allocator.free(print3);

    const q4: Quantity([5]f32, si.T) = .init(.{ 2.3, 45, 1.5e7, 1345, 0.0004 });
    const print4 = try std.fmt.allocPrint(allocator, "{f}", .{q4});
    try std.testing.expectEqualSlices(u8, "Array: { 2.3, 45, ... 1345, 4e-4 } T", print4);
    allocator.free(print4);

    const q5: Quantity([]f64, si.Pa.div(si.s)) = .init(@constCast(&[2]f64{ 3, 7 }));
    const print5 = try std.fmt.allocPrint(allocator, "{f}", .{q5});
    try std.testing.expectEqualSlices(u8, "Slice: { 3, 7 } Pa s-1", print5);
    allocator.free(print5);
}

test "initScalarValue" {
    // float
    const q1: Quantity(f32, si.m) = .initScalarValue(4);
    try testing.expectApproxEqAbs(4, q1.value, 1e-15);

    // Vector
    const q2: Quantity(@Vector(2, f32), si.Pa) = .initScalarValue(2);
    const val: [2]f32 = q2.value;
    try zatest.expectApproxEqAbsIter([2]f32{ 2, 2 }, val, 1e-15);

    // Array
    const q3: Quantity([2]f32, si.Pa) = .initScalarValue(3);
    try zatest.expectApproxEqAbsIter([2]f32{ 3, 3 }, q3.value, 1e-15);
}

test "initScalarValueWithBuf" {
    var buf: [3]f32 = undefined;
    const q: Quantity([]f32, si.m) = .initScalarValueWithBuf(10, &buf);
    try zatest.expectApproxEqAbsIter(@constCast(&[3]f32{ 10, 10, 10 }), q.value, 1e-15);
}

test "setScalarValue" {
    // float
    var q1: Quantity(f32, si.m) = .init(0);
    q1.setScalarValue(3);
    try testing.expectApproxEqAbs(3, q1.value, 1e-15);

    // Vector
    var q2: Quantity(@Vector(3, f64), si.s) = .init(.{ 1, 2, 3 });
    q2.setScalarValue(5);
    const val: [3]f64 = q2.value;
    try zatest.expectApproxEqAbsIter([3]f64{ 5, 5, 5 }, val, 1e-15);

    // Array
    var q3: Quantity([2]f64, si.a) = .init(.{ 3.0, 6.0 });
    q3.setScalarValue(10.0);
    try zatest.expectApproxEqAbsIter([2]u8{ 10.0, 10.0 }, q3.value, 1e-15);

    // Slice
    var buf: [4]f32 = undefined;
    var q4: Quantity([]f32, si.Hz) = .init(&buf);
    q4.setScalarValue(12);
    try zatest.expectApproxEqAbsIter(@constCast(&[4]u8{ 12, 12, 12, 12 }), q4.value, 1e-15);
}
