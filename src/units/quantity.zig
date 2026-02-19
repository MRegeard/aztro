const std = @import("std");
const math = std.math;
const testing = std.testing;
const Unit = @import("unit.zig").Unit;
const si = @import("si.zig");
const aztest = @import("../test.zig");
const utils = @import("utils.zig");

const QuantityError = error{UnitNotCompatibleError};

pub const QuantityChildType = enum {
    int,
    float,
    vector,
    array,
    array_list,
};

pub fn Quantity(comptime T: type, comptime U: Unit) type {
    const child_type_enum: QuantityChildType = switch (@typeInfo(T)) {
        .int => .int,
        .float => .float,
        .vector => .vector,
        .array => .array,
        .@"struct" => blk: {
            if (utils.isArrayList(T)) break :blk .array_list;
        },
        else => @compileError("Invalid type for Quantity."),
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
                .int, .float, .vector => {
                    return Quantity(T, U).init(self.value + other.value);
                },
                .array => {
                    var new_array: T = undefined;
                    for (0..self.value.len) |i| {
                        new_array[i] = self.value[i] + other.value[i];
                    }
                    return Quantity(T, U).init(new_array);
                },
                .array_list => {
                    @compileError("Cannot add ArrayList, use addInPlace or addAlloc instead.");
                },
            }
        }

        pub fn addInPlace(self: *Self, other: Self) void {
            switch (child_type) {
                .int, .float, .vector => {
                    self.value += other.value;
                },
                .array => {
                    for (0..self.value.len) |i| {
                        self.value[i] += other.value[i];
                    }
                },
                .array_list => {
                    for (0..T.items.len) |i| {
                        self.value.items[i] += other.value.items[i];
                    }
                },
            }
        }

        pub fn sub(self: Self, other: Self) Self {
            switch (child_type) {
                .int, .float, .vector => {
                    return Quantity(T, U).init(self.value - other.value);
                },
                .array => {
                    var new_array: T = undefined;
                    for (0..self.value.len) |i| {
                        new_array[i] = self.value[i] - other.value[i];
                    }
                    return Quantity(T, U).init(new_array);
                },
                .array_list => {
                    @compileError("Cannot sub ArrayList, use subInPlace or subAlloc instead.");
                },
            }
        }

        pub fn subInPlace(self: *Self, other: Self) void {
            switch (child_type) {
                .int, .float, .vector => self.value -= other.value,
                .array => {
                    for (0..self.value.len) |i| {
                        self.value[i] -= other.value[i];
                    }
                },
                .array_list => {
                    for (0..self.value.items.len) |i| {
                        self.value.items[i] -= other.value.items[i];
                    }
                },
            }
        }

        pub fn mul(self: Self, other: anytype) Quantity(T, U.mul(@TypeOf(other).unit)) {
            if (@TypeOf(other.value) != T) {
                @compileError("To multiply quantity, value type must match.");
            }
            switch (child_type) {
                .int, .float, .vector => return .init(self.value * other.value),
                .array => {
                    var new_array: T = undefined;
                    for (0..self.value.len) |i| {
                        new_array[i] = self.value[i] * other.value[i];
                    }
                    return .init(new_array);
                },
                .array_list => @compileError("Cannot multiply ArrayList, use mulAlloc instead."),
            }
        }

        pub fn div(self: Self, other: anytype) Quantity(T, U.div(@TypeOf(other).unit)) {
            if (@TypeOf(other.value) != T) {
                @compileError("To divide quantity, value type must match.");
            }
            switch (child_type) {
                .int, .float, .vector => return .init(self.value / other.value),
                .array => {
                    var new_array: T = undefined;
                    for (0..self.value.len) |i| {
                        new_array[i] = self.value[i] / other.value[i];
                    }
                    return .init(new_array);
                },
                .array_list => @compileError("Cannot divide ArrayList, use divAlloc instead."),
            }
        }

        pub fn pow(self: Self, comptime value: isize) Quantity(T, U.pow(value)) {
            if (value == 0) @panic("Power by zero encountered");
            switch (child_type) {
                .int, .float => return .init(math.pow(T, self.value, value)),
                .vector => {
                    var new_vec: T = self.value;
                    for (0..@abs(value) - 1) |_| {
                        new_vec = new_vec * new_vec;
                    }
                    if (value < 0) {
                        const ones: T = @splat(0);
                        new_vec = ones / new_vec;
                    }
                    return .init(new_vec);
                },
                .array => {
                    const inner_type: type = @typeInfo(T).array.child;
                    var new_arr: T = undefined;
                    for (0..self.value.len) |i| {
                        new_arr[i] = math.pow(inner_type, self.value[i], value);
                    }
                    return .init(new_arr);
                },
                .array_list => @compileError("Cannot power ArrayList, use powAlloc instead"),
            }
            unreachable;
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
                .vector => {
                    const zeroes: T = @splat(0);
                    const cmp = self.value <= zeroes;
                    if (@reduce(.Or, cmp)) sqrtPanic();
                    return .init(@sqrt(self.value));
                },
                .array => {
                    var new_array: T = undefined;
                    for (0..self.value.len) |i| {
                        if (checkSqrtPanic(self.value[i])) new_array[i] = @sqrt(self.value[i]);
                    }
                    return .init(new_array);
                },
                .array_list => @compileError("Cannot sqrt ArrayList, use sqrtAlloc instead"),
            }
            unreachable;
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
                .vector => {
                    const zeroes: T = @splat(0);
                    const cmp = self.value <= zeroes;
                    if (@reduce(.Or, cmp)) cbrtPanic();
                    var new_vec: T = undefined;
                    for (0..@typeInfo(T).vector.len) |i| {
                        new_vec[i] = math.cbrt(self.value[i]);
                    }
                    return .init(new_vec);
                },
                .array => {
                    var new_arr: T = undefined;
                    for (0..self.value.len) |i| {
                        if (checkCbrtPanic(self.value[i])) {
                            new_arr[i] = math.cbrt(self.value[i]);
                        }
                    }
                    return .init(new_arr);
                },
                .array_list => @compileError("Cannot cbrt ArrayList, use cbrtAlloc instead"),
            }
            unreachable;
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
                .int,
                .float,
                => return .init(self.value * convert_scale + convert_offset),
                .vector => {
                    const convert_scale_vec: T = @splat(convert_scale);
                    const convert_offset_vec: T = @splat(convert_offset);
                    return .init(self.value * convert_scale_vec + convert_offset_vec);
                },
                .array => {
                    var new_array: T = undefined;
                    for (0..child_type.value.len) |i| {
                        new_array[i] = self.value[i] * convert_scale + convert_offset;
                    }
                    return .init(new_array);
                },
                .array_list => @compileError("Cannot convert ArrayList with to, use allocTo instead."),
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
