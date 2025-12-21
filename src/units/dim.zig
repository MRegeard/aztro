const std = @import("std");
const testing = std.testing;

pub const length: Dim = .{ .l = 1, .m = 0, .t = 0, .i = 0, .th = 0, .n = 0, .j = 0 };
pub const mass: Dim = .{ .l = 0, .m = 1, .t = 0, .i = 0, .th = 0, .n = 0, .j = 0 };
pub const time: Dim = .{ .l = 0, .m = 0, .t = 1, .i = 0, .th = 0, .n = 0, .j = 0 };
pub const electricCurrent: Dim = .{ .l = 0, .m = 0, .t = 0, .i = 1, .th = 0, .n = 0, .j = 0 };
pub const temperature: Dim = .{ .l = 0, .m = 0, .t = 0, .i = 0, .th = 1, .n = 0, .j = 0 };
pub const amount: Dim = .{ .l = 0, .m = 0, .t = 0, .i = 0, .th = 0, .n = 1, .j = 0 };
pub const luminousIntensity: Dim = .{ .l = 0, .m = 0, .t = 0, .i = 0, .th = 0, .n = 0, .j = 1 };

pub const Dim = struct {
    const Self = @This();

    l: i8,
    m: i8,
    t: i8,
    i: i8,
    th: i8,
    n: i8,
    j: i8,

    pub fn initDimensionless() Self {
        return .{
            .l = 0,
            .m = 0,
            .t = 0,
            .i = 0,
            .th = 0,
            .n = 0,
            .j = 0,
        };
    }

    pub fn eql(d1: Self, d2: Self) bool {
        return d1.l == d2.l and d1.m == d2.m and d1.t == d2.t and d1.i == d2.i and d1.th == d2.th and d1.n == d2.n and d1.j == d2.j;
    }

    pub fn add(self: Self, other: Self) Self {
        var res = Self.initDimensionless();
        inline for (@typeInfo(Dim).@"struct".fields) |field| {
            const name = field.name;
            @field(res, name) = @field(self, name) + @field(other, name);
        }
        return res;
    }

    pub fn addInPlace(self: *Self, other: Self) void {
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            @field(self.*, name) += @field(other, name);
        }
    }

    pub fn sub(self: Self, other: Self) Self {
        var res = Self.initDimensionless();
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            @field(res, name) = @field(self, name) - @field(other, name);
        }
        return res;
    }

    pub fn subInPlace(self: *Self, other: Self) void {
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            @field(self.*, name) -= @field(other, name);
        }
    }

    pub fn inv(self: Self) Self {
        var res = self;
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            @field(res, name) = -@field(self, name);
        }
        return res;
    }

    pub fn invInPlace(self: *Self) void {
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            @field(self.*, name) = -@field(self.*, name);
        }
    }

    pub fn selfMul(self: Self, comptime times: isize) Self {
        if (times == 0) return Self.initDimensionless();
        var res = Self.initDimensionless();
        if (times > 0) {
            inline for (0..times) |_| {
                res.addInPlace(self);
            }
        } else {
            inline for (0..-times) |_| {
                res.subInPlace(self);
            }
        }
        return res;
    }
};

test "init dimensionless" {
    const d = Dim.initDimensionless();
    inline for (@typeInfo(Dim).@"struct".fields) |field| {
        const name = field.name;
        try testing.expectEqual(@field(d, name), 0);
    }
}

test "test equals" {
    const d1 = Dim.initDimensionless();
    const d2 = Dim.initDimensionless();
    try testing.expectEqual(Dim.eql(d1, d2), true);
}

test "add lenght and time" {
    const lengthTime: Dim = .{ .l = 1, .m = 0, .t = 1, .i = 0, .th = 0, .n = 0, .j = 0 };
    const added = length.add(time);
    try testing.expectEqual(added, lengthTime);
}

test "addInPlace mass electricCurrent" {
    var massTest: Dim = mass;
    const massElectricCurrent: Dim = .{ .l = 0, .m = 1, .t = 0, .i = 1, .th = 0, .n = 0, .j = 0 };
    massTest.addInPlace(electricCurrent);
    try testing.expectEqual(massTest, massElectricCurrent);
}

test "sub temp and amount" {
    const tempByAmount: Dim = .{ .l = 0, .m = 0, .t = 0, .i = 0, .th = 1, .n = -1, .j = 0 };
    const subbed = temperature.sub(amount);
    try testing.expectEqual(subbed, tempByAmount);
}

test "subInPlace lum length" {
    var lumTest: Dim = luminousIntensity;
    const lumBylength: Dim = .{ .l = -1, .m = 0, .t = 0, .i = 0, .th = 0, .n = 0, .j = 1 };
    lumTest.subInPlace(length);
    try testing.expectEqual(lumTest, lumBylength);
}

test "selfMul" {
    const lengthTest = length;
    const lengthSquare = lengthTest.selfMul(2);
    const lengthSquareRes: Dim = .{ .l = 2, .m = 0, .t = 0, .i = 0, .th = 0, .n = 0, .j = 0 };
    try testing.expectEqual(lengthSquareRes, lengthSquare);
    const invTimeSquare = time.selfMul(-2);
    const invTimeSquareRes: Dim = .{ .l = 0, .m = 0, .t = -2, .i = 0, .th = 0, .n = 0, .j = 0 };
    try testing.expectEqual(invTimeSquareRes, invTimeSquare);
}

test "inv" {
    const invMass = mass.inv();
    const invMassRes: Dim = .{ .l = 0, .m = -1, .t = 0, .i = 0, .th = 0, .n = 0, .j = 0 };
    try testing.expectEqual(invMassRes, invMass);
}

test "invInPlace" {
    var amountTest = amount;
    amountTest.invInPlace();
    const invAmountRes: Dim = .{ .l = 0, .m = 0, .t = 0, .i = 0, .th = 0, .n = -1, .j = 0 };
    try testing.expectEqual(invAmountRes, amountTest);
}
