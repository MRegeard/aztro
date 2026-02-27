const std = @import("std");
const math = std.math;
const testing = std.testing;
const Allocator = std.mem.Allocator;
const Unit = @import("unit.zig").Unit;
const si = @import("si.zig");
const aztest = @import("../test.zig");

pub const QuantityChildType = enum {
    int,
    float,
    vector_int,
    vector_float,
    array_int,
    array_float,
    slice_int,
    slice_float,
};

pub const QuantityError = error{ DifferentArrayListItemsLen, UnitNotCompatibleError } || Allocator.Error;

pub fn Quantity(comptime T: type, comptime U: Unit) type {
    const child_type_enum: QuantityChildType = switch (@typeInfo(T)) {
        .int => .int,
        .float => .float,
        .vector => |vector| blk: {
            switch (@typeInfo(vector.child)) {
                .int => break :blk .vector_int,
                .float => break :blk .vector_float,
                else => @compileError("Unsupported child type for vector"),
            }
        },
        .array => |array| blk: {
            switch (@typeInfo(array.child)) {
                .int => break :blk .array_int,
                .float => break :blk .array_float,
                else => @compileError("Unsupported child type for array"),
            }
        },
        .pointer => |p| blk: {
            switch (p.size) {
                .slice => switch (@typeInfo(p.child)) {
                    .int => break :blk .slice_int,
                    .float => break :blk .slice_float,
                    else => @compileError("Unsupported child type for slice"),
                },
                else => @compileError("Unsupported pointer type"),
            }
        },
        else => @compileError("Unsupported type"),
    };
    return struct {
        const Self = @This();

        pub const unit: Unit = U;

        value: T,

        const child_type: QuantityChildType = child_type_enum;

        pub fn init(value: T) Self {
            return .{ .value = value };
        }

        pub fn add(self: Self, other: Self) Self {
            switch (child_type) {
                .int, .float, .vector_float, .vector_int => {
                    return Quantity(T, U).init(self.value + other.value);
                },
                .array_int, .array_float => {
                    var new_array: T = undefined;
                    for (0..self.value.len) |i| {
                        new_array[i] = self.value[i] + other.value[i];
                    }
                    return Quantity(T, U).init(new_array);
                },
                .slice_int, .slice_float => {
                    @compileError("Cannot add slice, use addInPlace or addInto instead.");
                },
            }
        }

        pub fn addInPlace(self: *Self, other: Self) void {
            switch (child_type) {
                .int, .float, .vector_int, .vector_float => {
                    self.value += other.value;
                },
                .array_int, .array_float => {
                    for (0..self.value.len) |i| {
                        self.value[i] += other.value[i];
                    }
                },
                .slice_int, .slice_float => {
                    std.debug.assert(self.value.len == other.value.len);
                    for (0..self.value.len) |i| {
                        self.value[i] += other.value.items[i];
                    }
                },
            }
        }

        pub fn addInto(self: Self, other: Self, out: *Self) void {
            switch (child_type) {
                .slice_int, .slice_float => {
                    std.debug.assert((self.value.len == other.value.len) and (self.value.len == out.value.len));
                    for (0..self.value.len) |i| {
                        out.value[i] = self.value[i] + other.value[i];
                    }
                },
                else => {
                    out.value = self.add(other).value;
                },
            }
            return;
        }

        pub fn sub(self: Self, other: Self) Self {
            switch (child_type) {
                .int, .float, .vector_int, .vector_float => {
                    return Quantity(T, U).init(self.value - other.value);
                },
                .array_int, .array_float => {
                    var new_array: T = undefined;
                    for (0..self.value.len) |i| {
                        new_array[i] = self.value[i] - other.value[i];
                    }
                    return Quantity(T, U).init(new_array);
                },
                .slice_int, .slice_float => {
                    @compileError("Cannot sub slice, use subInPlace or subInto instead.");
                },
            }
        }

        pub fn subInPlace(self: *Self, other: Self) void {
            switch (child_type) {
                .int, .float, .vector_int, .vector_float => self.value -= other.value,
                .array_int, .array_float => {
                    for (0..self.value.len) |i| {
                        self.value[i] -= other.value[i];
                    }
                },
                .slice_int, .slice_float => {
                    std.debug.assert(self.value.len == other.value.len);
                    for (0..self.value.len) |i| {
                        self.value[i] -= other.value[i];
                    }
                },
            }
        }

        pub fn subInto(self: Self, other: Self, out: *Self) void {
            switch (child_type) {
                .slice_int, .slice_float => {
                    std.debug.assert((self.value.len == other.value.len) and (self.value.len == out.value.len));
                    for (0..self.value.len) |i| {
                        out.value[i] = self.value[i] - other.value[i];
                    }
                },
                else => {
                    out.value = self.sub(other).value;
                },
            }
            return;
        }

        pub fn mul(self: Self, other: anytype) Quantity(T, U.mul(@TypeOf(other).unit)) {
            if (@TypeOf(other.value) != T) {
                @compileError("To multiply quantity, value type must match.");
            }
            switch (child_type) {
                .int, .float, .vector_int, .vector_float => return .init(self.value * other.value),
                .array_int, .array_float => {
                    var new_array: T = undefined;
                    for (0..self.value.len) |i| {
                        new_array[i] = self.value[i] * other.value[i];
                    }
                    return .init(new_array);
                },
                .slice_int, .slice_float => @compileError("Cannot multiply slice, use mulInto instead."),
            }
        }

        pub fn mulInto(self: Self, other: anytype, out: *Quantity(T, U.mul(@TypeOf(other).unit))) void {
            if (@TypeOf(other.value) != T) {
                @compileError("To mutliply quantity, value type must match.");
            }
            switch (child_type) {
                .slice_int, .slice_float => {
                    std.debug.assert((self.value.len == other.value.len) and (self.value.len == out.value.len));
                    for (0..self.value.len) |i| {
                        out.value[i] = self.value[i] * other.value[i];
                    }
                },
                else => {
                    out.value = self.mul(other).value;
                },
            }
            return;
        }

        pub fn div(self: Self, other: anytype) Quantity(T, U.div(@TypeOf(other).unit)) {
            if (@TypeOf(other.value) != T) {
                @compileError("To divide quantity, value type must match.");
            }
            switch (child_type) {
                .int, .vector_int => return .init(@divTrunc(self.value, other.value)),
                .float, .vector_float => return .init(self.value / other.value),
                .array_int => {
                    var new_arr: T = undefined;
                    for (0..self.value.len) |i| {
                        new_arr[i] = @divTrunc(self.value[i], other.value[i]);
                    }
                    return .init(new_arr);
                },
                .array_float => {
                    var new_arr: T = undefined;
                    for (0..self.value.len) |i| {
                        new_arr[i] = self.value[i] / other.value[i];
                    }
                    return .init(new_arr);
                },
                .slice_int, .slice_float => @compileError("Cannot divide slice, use divInto instead."),
            }
        }

        pub fn divInto(self: Self, other: anytype, out: *Quantity(T, U.div(@TypeOf(other).unit))) void {
            if (@TypeOf(other.value) != T) {
                @compileError("To divide quantity, value must match.");
            }
            switch (child_type) {
                .slice_int => {
                    std.debug.assert((self.value.len == other.value.len) and (self.value.len == out.value.len));
                    for (0..self.value.len) |i| {
                        out.value[i] = @divTrunc(self.value[i], other.value[i]);
                    }
                },
                .slice_float => {
                    std.debug.assert((self.value.len == other.value.len) and (self.value.len == out.value.len));
                    for (0..self.value.len) |i| {
                        out.value[i] = self.value[i] / other.value[i];
                    }
                },
                else => {
                    out.value = self.div(other).value;
                },
            }
        }

        pub fn pow(self: Self, comptime value: isize) Quantity(T, U.pow(value)) {
            switch (child_type) {
                .int, .float => return .init(math.pow(T, self.value, value)),
                .vector_int, .vector_float => {
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
                .array_int, .array_float => {
                    const inner_type: type = @typeInfo(T).array.child;
                    var new_arr: T = undefined;
                    for (0..self.value.len) |i| {
                        new_arr[i] = math.pow(inner_type, self.value[i], value);
                    }
                    return .init(new_arr);
                },
                .slice_int, .slice_float => @compileError("Cannot power slice, use powInto instead"),
            }
            unreachable;
        }

        pub fn powInto(self: Self, comptime value: isize, out: *Quantity(T, U.pow(value))) void {
            switch (child_type) {
                .slice_int, .slice_float => {
                    std.debug.assert(self.value.len == out.value.len);
                    const inner_type: type = @typeInfo(T).pointer.child;
                    for (0..self.value.len) |i| {
                        out.value[i] = math.pow(inner_type, self.value[i], value);
                    }
                },
                else => {
                    out.value = self.pow(value).value;
                },
            }
        }

        fn checkSqrtPanic(value: anytype) bool {
            if (value <= 0) sqrtPanic();
            return true;
        }

        fn sqrtPanic() void {
            @panic("Square root of zero encounter");
        }

        pub fn sqrt(self: Self) Quantity(T, U.sqrt()) {
            switch (child_type) {
                .int, .float => {
                    if (checkSqrtPanic(self.value)) return .init(@sqrt(self.value));
                },
                .vector_int, .vector_float => {
                    const zeroes: T = @splat(0);
                    const cmp = self.value <= zeroes;
                    if (@reduce(.Or, cmp)) sqrtPanic();
                    return .init(@sqrt(self.value));
                },
                .array_int, .array_float => {
                    var new_array: T = undefined;
                    for (0..self.value.len) |i| {
                        if (checkSqrtPanic(self.value[i])) new_array[i] = @sqrt(self.value[i]);
                    }
                    return .init(new_array);
                },
                .slice_int, .slice_float => @compileError("Cannot sqrt slice, use sqrtInto instead"),
            }
            unreachable;
        }

        pub fn sqrtInto(self: Self, out: *Quantity(T, U.sqrt())) void {
            switch (child_type) {
                .slice_int, .slice_float => {
                    std.debug.assert(self.value.len == out.value.len);
                    for (0..self.value.len) |i| {
                        if (checkSqrtPanic(self.value[i])) out.value[i] = @sqrt(self.value[i]);
                    }
                },
                else => out.value = self.sqrt().value,
            }
        }

        fn checkCbrtPanic(value: anytype) bool {
            if (value <= 0) cbrtPanic();
            return true;
        }

        fn cbrtPanic() void {
            @panic("Cube root of zero encounter");
        }

        pub fn cbrt(self: Self) Quantity(T, U.cbrt()) {
            switch (child_type) {
                .int, .float => {
                    if (checkCbrtPanic(self.value)) return .init(math.cbrt(self.value));
                },
                .vector_int, .vector_float => {
                    const zeroes: T = @splat(0);
                    const cmp = self.value <= zeroes;
                    if (@reduce(.Or, cmp)) cbrtPanic();
                    var new_vec: T = undefined;
                    for (0..@typeInfo(T).vector.len) |i| {
                        new_vec[i] = math.cbrt(self.value[i]);
                    }
                    return .init(new_vec);
                },
                .array_int, .array_float => {
                    var new_arr: T = undefined;
                    for (0..self.value.len) |i| {
                        if (checkCbrtPanic(self.value[i])) {
                            new_arr[i] = math.cbrt(self.value[i]);
                        }
                    }
                    return .init(new_arr);
                },
                .slice_int, .slice_float => @compileError("Cannot cbrt slice, use cbrtInto instead"),
            }
            unreachable;
        }

        pub fn cbrtInto(self: Self, out: *Quantity(T, U.cbrt())) void {
            switch (child_type) {
                .slice_int, .slice_float => {
                    std.debug.assert(self.value.len == out.value.len);
                    for (0..self.value.len) |i| {
                        if (checkCbrtPanic(self.value[i])) out.value[i] = math.cbrt(self.value[i]);
                    }
                },
                else => out.value = self.cbrt().value,
            }
        }

        pub fn to(self: Self, comptime unit_type: Unit) QuantityError!Quantity(T, unit_type) {
            if (!U.dim.eql(unit_type.dim)) {
                return QuantityError.UnitNotCompatibleError;
            }
            const convert_scale = U.scale / unit_type.scale;
            const self_offset: f64 = U.offset orelse 0;
            const unit_offset: f64 = unit_type.offset orelse 0;
            const convert_offset = self_offset - unit_offset;
            switch (child_type) {
                .int => {
                    const convert_scale_int: T = @intFromFloat(convert_scale);
                    const convert_offset_int: T = @intFromFloat(convert_offset);
                    const multiply = @mulWithOverflow(self.value, convert_scale_int);
                    if (multiply[1] != 0) @panic("Overflow encounter");
                    const result = @addWithOverflow(multiply[0], convert_offset_int);
                    if (result[1] != 0) @panic("Overflow encounter");
                    return .init(result[0]);
                },
                .float => {
                    if (T != f64) {
                        const convert_scale_float: T = @floatCast(convert_scale);
                        const convert_offset_float: T = @floatCast(convert_offset);
                        return .init(@mulAdd(T, self.value, convert_scale_float, convert_offset_float));
                    }
                    return .init(@mulAdd(T, self.value, convert_scale, convert_offset));
                },
                .vector_int => {
                    const inner_type: type = @typeInfo(T).vector.child;
                    const convert_scale_int: inner_type = @intFromFloat(convert_scale);
                    const convert_offset_int: inner_type = @intFromFloat(convert_offset);
                    const convert_scale_vec: T = @splat(convert_scale_int);
                    const convert_offset_vec: T = @splat(convert_offset_int);
                    const multiply = @mulWithOverflow(self.value, convert_scale_vec);
                    if (multiply[1] != 0) @panic("Overflow encounter");
                    const result = @addWithOverflow(multiply[0], convert_offset_vec);
                    if (result[1] != 0) @panic("Overflow encounter");
                    return .init(result[0]);
                },
                .vector_float => {
                    const inner_type: type = @typeInfo(T).vector.child;
                    if (inner_type != f64) {
                        const convert_scale_float: inner_type = @floatCast(convert_scale);
                        const convert_offset_float: inner_type = @floatCast(convert_offset);
                        const convert_scale_vec: T = @splat(convert_scale_float);
                        const convert_offset_vec: T = @splat(convert_offset_float);
                        return .init(@mulAdd(T, self.value, convert_scale_vec, convert_offset_vec));
                    } else {
                        const convert_scale_vec: T = @splat(convert_scale);
                        const convert_offset_vec: T = @splat(convert_offset);
                        return .init(@mulAdd(T, self.value, convert_scale_vec, convert_offset_vec));
                    }
                },
                .array_int => {
                    const inner_type: type = @typeInfo(T).array.child;
                    const convert_scale_int: inner_type = @intFromFloat(convert_scale);
                    const convert_offset_int: inner_type = @intFromFloat(convert_offset);
                    var new_array: T = undefined;
                    for (0..self.value.len) |i| {
                        const multiply = @mulWithOverflow(self.value[i], convert_scale_int);
                        if (multiply[1] != 0) @panic("Overflow encounter");
                        const result = @addWithOverflow(multiply[0], convert_offset_int);
                        if (result[1] != 0) @panic("Overflow encounter");
                        new_array[i] = result[0];
                    }
                    return .init(new_array);
                },
                .array_float => {
                    const inner_type: type = @typeInfo(T).array.child;
                    var new_array: T = undefined;
                    if (inner_type != f64) {
                        const convert_scale_float: inner_type = @floatCast(convert_scale);
                        const convert_offset_float: inner_type = @floatCast(convert_offset);
                        for (0..self.value.len) |i| {
                            new_array[i] = @mulAdd(inner_type, self.value[i], convert_scale_float, convert_offset_float);
                        }
                        return .init(new_array);
                    }
                    for (0..self.value.len) |i| {
                        new_array[i] = @mulAdd(inner_type, self.value[i], convert_scale, convert_offset);
                    }
                    return .init(new_array);
                },
                .slice_int, .slice_float => @compileError("Cannot convert slice with to, use toInto instead."),
            }
        }

        pub fn toInto(self: Self, comptime unit_type: Unit, out: *Quantity(T, unit_type)) QuantityError!void {
            if (!U.dim.eql(unit_type.dim)) {
                return QuantityError.UnitNotCompatibleError;
            }
            const convert_scale = U.scale / unit_type.scale;
            const self_offset: f64 = U.offset orelse 0;
            const unit_offset: f64 = unit_type.offset orelse 0;
            const convert_offset = self_offset - unit_offset;
            switch (child_type) {
                .slice_int => {
                    std.debug.assert(self.value.len == out.value.len);
                    const inner_type = @typeInfo(T).pointer.child;
                    const convert_scale_int: inner_type = @intFromFloat(convert_scale);
                    const convert_offset_int: inner_type = @intFromFloat(convert_offset);
                    for (0..self.value.len) |i| {
                        const multiply = @mulWithOverflow(self.value[i], convert_scale_int);
                        if (multiply[1] != 0) @panic("Overflow encounter");
                        const result = @addWithOverflow(multiply[0], convert_offset_int);
                        if (result[1] != 0) @panic("Overflow encounter");
                        out.value[i] = result[0];
                    }
                },
                .slice_float => {
                    std.debug.assert(self.value.len == out.value.len);
                    const inner_type: type = @typeInfo(T).pointer.child;
                    if (inner_type != f64) {
                        const convert_scale_float: inner_type = @floatCast(convert_scale);
                        const convert_offset_float: inner_type = @floatCast(convert_offset);
                        for (0..self.value.len) |i| {
                            out.value[i] = @mulAdd(inner_type, self.value[i], convert_scale_float, convert_offset_float);
                        }
                    } else {
                        for (0..self.value.len) |i| {
                            out.value[i] = @mulAdd(inner_type, self.value[i], convert_scale, convert_offset);
                        }
                    }
                },
                else => out.value = self.to(unit_type).value,
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
    //float and int
    const time1 = Quantity(u64, si.s).init(10);
    const time2 = Quantity(u64, si.s).init(15);
    const timeRes = time1.add(time2);
    try testing.expectEqual(timeRes.value, 25);

    // vector
    const vec1 = @Vector(2, i64){ 2, 4 };
    const vec2 = @Vector(2, i64){ 3, 5 };
    const quantity1: Quantity(@Vector(2, i64), si.AA) = .init(vec1);
    const quantity2: Quantity(@Vector(2, i64), si.AA) = .init(vec2);
    const added = quantity1.add(quantity2);
    const exp: @Vector(2, i64) = .{ 5, 9 };
    try testing.expectEqual(exp, added.value);

    // array
    const arr1: [3]f64 = .{ 1.1, 2.2, 3.3 };
    const arr2: [3]f64 = .{ 1.1, 2.2, 3.3 };
    const size1: Quantity([3]f64, si.m) = .init(arr1);
    const size2: Quantity([3]f64, si.m) = .init(arr2);
    const sizeRes = size1.add(size2);
    const expected: [3]f64 = .{ 2.2, 4.4, 6.6 };
    try aztest.expectApproxEqAbsIter(expected, sizeRes.value, 1e-15);
}

test "addInPlace" {
    //float and int
    var time1 = Quantity(u32, si.s).init(15);
    const time2 = Quantity(u32, si.s).init(5);
    time1.addInPlace(time2);
    try testing.expectEqual(time1.value, 20);

    // vector
    const vec1 = @Vector(2, i64){ 2, 4 };
    const vec2 = @Vector(2, i64){ 3, 5 };
    var quantity1: Quantity(@Vector(2, i64), si.AA) = .init(vec1);
    const quantity2: Quantity(@Vector(2, i64), si.AA) = .init(vec2);
    quantity1.addInPlace(quantity2);
    const exp: @Vector(2, i64) = .{ 5, 9 };
    try testing.expectEqual(exp, quantity1.value);

    // array
    const arr1: [3]f64 = .{ 1.1, 2.2, 3.3 };
    const arr2: [3]f64 = .{ 1.1, 2.2, 3.3 };
    var size1: Quantity([3]f64, si.m) = .init(arr1);
    const size2: Quantity([3]f64, si.m) = .init(arr2);
    size1.addInPlace(size2);
    const expected: [3]f64 = .{ 2.2, 4.4, 6.6 };
    try aztest.expectApproxEqAbsIter(expected, size1.value, 1e-15);
}

test "addInto" {
    // float and int
    const q1: Quantity(f64, si.m) = .init(3.3);
    const q2: Quantity(f64, si.m) = .init(2.2);
    var q_dest: Quantity(f64, si.m) = .init(undefined);
    q1.addInto(q2, &q_dest);
    try testing.expectApproxEqAbs(5.5, q_dest.value, 1e-15);

    // slice
    const allocator = testing.allocator;
    const list_type = std.ArrayList(u8);
    var list_1 = try list_type.initCapacity(allocator, 2);
    defer list_1.deinit(allocator);
    var list_2 = try list_type.initCapacity(allocator, 2);
    defer list_2.deinit(allocator);
    list_1.appendSliceAssumeCapacity(&[2]u8{ 1, 2 });
    list_2.appendSliceAssumeCapacity(&[2]u8{ 2, 3 });
    const q_list_1: Quantity([]u8, si.m) = .init(list_1.items);
    const q_list_2: Quantity([]u8, si.m) = .init(list_2.items);
    var list_dest = try list_type.initCapacity(allocator, 2);
    defer list_dest.deinit(allocator);
    try list_dest.resize(allocator, 2);
    var q_list_dest: Quantity([]u8, si.m) = .init(list_dest.items);
    q_list_1.addInto(q_list_2, &q_list_dest);
    try testing.expectEqualSlices(u8, &[_]u8{ 3, 5 }, q_list_dest.value);
    try testing.expectEqual(si.m, @TypeOf(q_list_dest).unit);
}

test "sub" {
    //float and int
    const size1 = Quantity(u8, si.AA).init(12);
    const size2 = Quantity(u8, si.AA).init(3);
    const sizeRes = size1.sub(size2);
    try testing.expectEqual(sizeRes.value, 9);

    // vector
    const vec1 = @Vector(2, i64){ 2, 4 };
    const vec2 = @Vector(2, i64){ 3, 5 };
    const quantity1: Quantity(@Vector(2, i64), si.AA) = .init(vec1);
    const quantity2: Quantity(@Vector(2, i64), si.AA) = .init(vec2);
    const subbed = quantity1.sub(quantity2);
    const exp: @Vector(2, i64) = .{ -1, -1 };
    try testing.expectEqual(exp, subbed.value);

    // array
    const arr1: [3]f64 = .{ 1.1, 2.2, 3.3 };
    const arr2: [3]f64 = .{ 1.1, 1.1, 1.1 };
    const size3: Quantity([3]f64, si.m) = .init(arr1);
    const size4: Quantity([3]f64, si.m) = .init(arr2);
    const sizeRes2 = size3.sub(size4);
    const expected: [3]f64 = .{ 0.0, 1.1, 2.2 };
    try aztest.expectApproxEqAbsIter(expected, sizeRes2.value, 1e-15);
}

test "subInPlace" {
    //float and int
    var freq1 = Quantity(i32, si.Hz).init(50);
    const freq2 = Quantity(i32, si.Hz).init(70);
    freq1.subInPlace(freq2);
    try testing.expectEqual(freq1.value, -20);

    // vector
    const vec1 = @Vector(2, i64){ 2, 4 };
    const vec2 = @Vector(2, i64){ 3, 5 };
    var quantity1: Quantity(@Vector(2, i64), si.AA) = .init(vec1);
    const quantity2: Quantity(@Vector(2, i64), si.AA) = .init(vec2);
    quantity1.subInPlace(quantity2);
    const exp: @Vector(2, i64) = .{ -1, -1 };
    try testing.expectEqual(exp, quantity1.value);

    // array
    const arr1: [3]f64 = .{ 1.1, 2.2, 3.3 };
    const arr2: [3]f64 = .{ 1.1, 1.1, 1.1 };
    var size3: Quantity([3]f64, si.m) = .init(arr1);
    const size4: Quantity([3]f64, si.m) = .init(arr2);
    size3.subInPlace(size4);
    const expected: [3]f64 = .{ 0.0, 1.1, 2.2 };
    try aztest.expectApproxEqAbsIter(expected, size3.value, 1e-15);
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
    try aztest.expectApproxEqAbsIter([_]f64{ 1, 1, 1 }, buf, 1e-15);
    try testing.expectApproxEqAbs(1, q_subbed.value[0], 1e-15);
}

test "mul" {
    // float and int
    const size1 = Quantity(f64, si.m).init(10);
    const size2 = Quantity(f64, si.m).init(3);
    const area = size1.mul(size2);
    try testing.expectEqual(area.value, 30);
    try testing.expectEqual(si.m.mul(si.m), @TypeOf(area).unit);

    // vector
    const vec1 = @Vector(2, i64){ 2, 4 };
    const vec2 = @Vector(2, i64){ 3, 5 };
    const quantity1: Quantity(@Vector(2, i64), si.AA) = .init(vec1);
    const quantity2: Quantity(@Vector(2, i64), si.AA) = .init(vec2);
    const mulitpied = quantity1.mul(quantity2);
    const exp: @Vector(2, i64) = .{ 6, 20 };
    try testing.expectEqual(exp, mulitpied.value);

    // array
    const arr1: [3]f64 = .{ 1.1, 2.2, 3.3 };
    const arr2: [3]f64 = .{ 1.1, 2.2, 2.2 };
    const size3: Quantity([3]f64, si.m) = .init(arr1);
    const size4: Quantity([3]f64, si.m) = .init(arr2);
    const area2 = size3.mul(size4);
    const expected: [3]f64 = .{ 1.21, 4.84, 7.26 };
    try aztest.expectApproxEqAbsIter(expected, area2.value, 1e-15);
}

test "mulInto" {
    // slice
    var arr1: [3]usize = .{ 1, 2, 3 };
    var arr2: [3]usize = .{ 2, 3, 4 };
    var buf: [3]usize = undefined;
    const q1: Quantity([]usize, si.m) = .init(&arr1);
    const q2: Quantity([]usize, si.s) = .init(&arr2);
    var action: Quantity([]usize, si.m.mul(si.s)) = .init(&buf);
    q1.mulInto(q2, &action);
    try testing.expectEqualSlices(usize, &[_]usize{ 2, 6, 12 }, action.value);
    try testing.expectEqual(si.m.mul(si.s), @TypeOf(action).unit);
}

test "div" {
    // float and int
    const size = Quantity(f64, si.m).init(5);
    const time = Quantity(f64, si.s).init(2);
    const speed = size.div(time);
    try testing.expectEqual(2.5, speed.value);
    try testing.expectEqual(si.m.div(si.s), @TypeOf(speed).unit);

    // vector
    const vec1 = @Vector(2, i64){ 9, 20 };
    const vec2 = @Vector(2, i64){ 3, 5 };
    const quantity1: Quantity(@Vector(2, i64), si.AA) = .init(vec1);
    const quantity2: Quantity(@Vector(2, i64), si.AA) = .init(vec2);
    const divided = quantity1.div(quantity2);
    const exp: @Vector(2, i64) = .{ 3, 4 };
    try testing.expectEqual(exp, divided.value);

    // array
    const size_arr: [2]f32 = .{ 2, 5 };
    const time_arr: [2]f32 = @splat(2);
    const size_2: Quantity([2]f32, si.m) = .init(size_arr);
    const time_2: Quantity([2]f32, si.s) = .init(time_arr);
    const speed_2 = size_2.div(time_2);
    const expected = [_]f32{ 1, 2.5 };
    try aztest.expectApproxEqAbsIter(expected, speed_2.value, 1e-15);
}

test "divInto" {
    // slice
    var arr1: [1]i32 = .{-1};
    var arr2: [1]i32 = .{2};
    var buf: [1]i32 = .{3}; // check that it overwrite
    const q1: Quantity([]i32, si.m) = .init(&arr1);
    const q2: Quantity([]i32, si.s) = .init(&arr2);
    var speed: Quantity([]i32, si.m.div(si.s)) = .init(&buf);
    q1.divInto(q2, &speed);
    try testing.expectEqual(0, speed.value[0]);
    try testing.expectEqual(si.m.div(si.s), @TypeOf(speed).unit);
}

test "pow" {
    // float and int
    const q1: Quantity(i16, si.kg) = .init(3);
    const q1_pow = q1.pow(2);
    try testing.expectEqual(9, q1_pow.value);
    try testing.expectEqual(si.kg.pow(2), @TypeOf(q1_pow).unit);
    const q2: Quantity(f32, si.m) = .init(15.5);
    const q2_pow = q2.pow(3);
    try testing.expectEqual(3723.875, q2_pow.value);

    // vector
    const q3: Quantity(@Vector(3, f64), si.s) = .init(.{ 2, 4, 6 });
    const q3_pow = q3.pow(2);
    try testing.expectEqual(@Vector(3, f64){ 4, 16, 36 }, q3_pow.value);

    //array
    const q4: Quantity([2]f32, si.s) = .init(.{ 4, 16 });
    const q4_pow = q4.pow(-2);
    try aztest.expectApproxEqAbsIter([2]f32{ 0.0625, 0.00390625 }, q4_pow.value, 1e-15);
}

test "powInto" {
    // slice
    var arr1: [3]u8 = .{ 2, 3, 4 };
    var arr2: [3]u8 = undefined;
    const q1: Quantity([]u8, si.s) = .init(&arr1);
    var q_pow: Quantity([]u8, si.s.pow(2)) = .init(&arr2);
    q1.powInto(2, &q_pow);
    try testing.expectEqualSlices(u8, &[3]u8{ 4, 9, 16 }, q_pow.value);
    try testing.expectEqual(si.s.pow(2), @TypeOf(q_pow).unit);
}

test "sqrt" {
    // float and int
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
    try aztest.expectApproxEqAbsIter(&[3]f64{ 4, 5, 6 }, q_sqrt.value, 1e-15);
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
    try aztest.expectApproxEqAbsIter(&[2]f32{ 3, 4 }, q_cbrt.value, 1e-15);
    try testing.expectEqual(si.m.cbrt(), @TypeOf(q_cbrt).unit);
}

test "to" {
    const size_m = Quantity(f64, si.m).init(3);
    const size_cm = try size_m.to(si.cm);
    try testing.expectEqual(300, size_cm.value);
    try testing.expectEqual(si.cm, @TypeOf(size_cm).unit);

    const mass_g = Quantity(f64, si.g).init(30);
    const mass_kg = try mass_g.to(si.kg);

    try testing.expectEqual(0.03, mass_kg.value);
    try testing.expectEqual(si.kg, @TypeOf(mass_kg).unit);

    const temp_C = Quantity(f64, si.degC).init(0);
    const temp_K = try temp_C.to(si.K);
    try testing.expectEqual(273.15, temp_K.value);
    try testing.expectEqual(si.K, @TypeOf(temp_K).unit);

    const temp_K_2 = Quantity(f64, si.K).init(0);
    const temp_C_2 = try temp_K_2.to(si.degC);
    try testing.expectEqual(-273.15, temp_C_2.value);
}

test "toInto" {
    const q1: Quantity([]f64, si.m) = .init(@constCast(&[2]f64{ 1, 2 }));
    var arr: [2]f64 = undefined;
    var q2: Quantity([]f64, si.cm) = .init(&arr);
    try q1.toInto(si.cm, &q2);
    try testing.expectEqualSlices(f64, &[2]f64{ 100, 200 }, q2.value);
}
