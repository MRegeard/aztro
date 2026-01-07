const std = @import("std");
const testing = std.testing;
const math = std.math;
const mem = std.mem;

const fraction = @import("fraction.zig");
const Fraction = fraction.Fraction;
const FractionError = fraction.FractionError;

pub const length: Dim = .initUniqueFieldInt("l", 1);
pub const mass: Dim = .initUniqueFieldInt("m", 1);
pub const time: Dim = .initUniqueFieldInt("t", 1);
pub const electricCurrent: Dim = .initUniqueFieldInt("i", 1);
pub const temperature: Dim = .initUniqueFieldInt("th", 1);
pub const amount: Dim = .initUniqueFieldInt("n", 1);
pub const luminousIntensity: Dim = .initUniqueFieldInt("j", 1);

pub const Dim = struct {
    const Self = @This();

    l: Fraction(i32),
    m: Fraction(i32),
    t: Fraction(i32),
    i: Fraction(i32),
    th: Fraction(i32),
    n: Fraction(i32),
    j: Fraction(i32),

    pub fn initDimensionless() Self {
        return .{
            .l = Fraction(i32).initInt(0),
            .m = Fraction(i32).initInt(0),
            .t = Fraction(i32).initInt(0),
            .i = Fraction(i32).initInt(0),
            .th = Fraction(i32).initInt(0),
            .n = Fraction(i32).initInt(0),
            .j = Fraction(i32).initInt(0),
        };
    }

    pub fn initUniqueField(comptime field_name: []const u8, frac: Fraction(i32)) Self {
        var res = Self.initDimensionless();
        @field(res, field_name) = frac;
        return res;
    }

    pub fn initUniqueFieldInt(comptime field_name: []const u8, value: i32) Self {
        return Self.initUniqueField(field_name, Fraction(i32).initInt(value));
    }

    pub fn eql(self: Self, other: Self) bool {
        return (self.l.eql(other.l)) and
            (self.m.eql(other.m)) and
            (self.t.eql(other.t)) and
            (self.i.eql(other.i)) and
            (self.th.eql(other.th)) and
            (self.n.eql(other.n)) and
            (self.j.eql(other.j));
    }

    pub fn add(self: Self, other: Self) FractionError!Self {
        var res = Self.initDimensionless();
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            @field(res, name) = try @field(self, name).add(@field(other, name));
        }
        return res;
    }

    pub fn addInPlace(self: *Self, other: Self) FractionError!void {
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            try @field(self.*, name).addInPlace(@field(other, name));
        }
    }

    pub fn sub(self: Self, other: Self) FractionError!Self {
        var res = Self.initDimensionless();
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            @field(res, name) = try @field(self, name).sub(@field(other, name));
        }
        return res;
    }

    pub fn subInPlace(self: *Self, other: Self) FractionError!void {
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            try @field(self.*, name).subInPlace(@field(other, name));
        }
    }

    pub fn neg(self: Self) FractionError!Self {
        var res = self;
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            @field(res, name) = try @field(self, name).neg();
        }
        return res;
    }

    pub fn negInPlace(self: *Self) FractionError!void {
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            try @field(self.*, name).negInPlace();
        }
    }

    pub fn mulScalar(self: Self, value: i32) FractionError!Self {
        var res = self;
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            @field(res, name) = try @field(res, name).mulScalar(value);
        }
        return res;
    }

    pub fn mulScalarInPlace(self: *Self, value: i32) FractionError!void {
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            try @field(self.*, name).mulScalarInPlace(value);
        }
    }

    pub fn mulFraction(self: Self, frac: Fraction(i32)) FractionError!Self {
        var res = self;
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            @field(res, name) = try @field(res, name).mul(frac);
        }
        return res;
    }

    pub fn mulFractionInPlace(self: *Self, frac: Fraction(i32)) FractionError!void {
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            try @field(self.*, name).mulInPlace(frac);
        }
    }

    pub fn divScalar(self: Self, value: i32) FractionError!Self {
        var res = self;
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            @field(res, name) = try @field(self, name).divScalar(value);
        }
        return res;
    }

    pub fn divScalarInPlace(self: *Self, value: i32) FractionError!void {
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            try @field(self.*, name).divScalarInPlace(value);
        }
    }

    pub fn divFraction(self: Self, frac: Fraction(i32)) FractionError!Self {
        var res = self;
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            @field(res, name) = try @field(res, name).div(frac);
        }
        return res;
    }

    pub fn divFractionInPlace(self: *Self, frac: Fraction(i32)) FractionError!void {
        inline for (@typeInfo(Self).@"struct".fields) |field| {
            const name = field.name;
            try @field(self.*, name).divInPlace(frac);
        }
    }
};

test "init dimensionless" {
    const d = Dim.initDimensionless();
    inline for (@typeInfo(Dim).@"struct".fields) |field| {
        const name = field.name;
        try testing.expectEqual(Fraction(i32).initInt(0), @field(d, name));
    }
}

test "initUniqueField" {
    const fieldValue = try Fraction(i32).init(3, 4);
    const d = Dim.initUniqueField("t", fieldValue);
    inline for (@typeInfo(Dim).@"struct".fields) |field| {
        const name = field.name;
        if (mem.eql(u8, name, "t")) {
            try testing.expectEqual(try Fraction(i32).init(3, 4), @field(d, name));
        } else {
            try testing.expectEqual(Fraction(i32).initInt(0), @field(d, name));
        }
    }
}

test "initUniqueFieldInt" {
    const d = Dim.initUniqueFieldInt("l", 3);
    inline for (@typeInfo(Dim).@"struct".fields) |field| {
        const name = field.name;
        if (mem.eql(u8, name, "l")) {
            try testing.expectEqual(try Fraction(i32).init(3, 1), @field(d, name));
        } else {
            try testing.expectEqual(Fraction(i32).initInt(0), @field(d, name));
        }
    }
}

test "eql" {
    const d1 = Dim.initDimensionless();
    const d2 = Dim.initDimensionless();
    try testing.expect(Dim.eql(d1, d2) == true);
}

test "add" {
    var lengthTime: Dim = .initDimensionless();
    lengthTime.l = Fraction(i32).initInt(1);
    lengthTime.t = Fraction(i32).initInt(1);
    const added = try length.add(time);
    try testing.expectEqual(lengthTime, added);
}

test "addInPlace" {
    var massElectricCurrent: Dim = .initDimensionless();
    massElectricCurrent.m = Fraction(i32).initInt(1);
    massElectricCurrent.i = Fraction(i32).initInt(1);
    var massTest: Dim = mass;
    try massTest.addInPlace(electricCurrent);
    try testing.expectEqual(massElectricCurrent, massTest);
}

test "sub" {
    var tempByAmount: Dim = .initDimensionless();
    tempByAmount.th = Fraction(i32).initInt(1);
    tempByAmount.n = Fraction(i32).initInt(-1);
    const subbed = try temperature.sub(amount);
    try testing.expectEqual(tempByAmount, subbed);
}

test "subInPlace" {
    var lumBylength: Dim = .initDimensionless();
    lumBylength.l = Fraction(i32).initInt(-1);
    lumBylength.j = Fraction(i32).initInt(1);
    var lumTest: Dim = luminousIntensity;
    try lumTest.subInPlace(length);
    try testing.expectEqual(lumBylength, lumTest);
}

test "neg" {
    const invMass = try mass.neg();
    const invMassRes: Dim = .initUniqueFieldInt("m", -1);
    try testing.expectEqual(invMassRes, invMass);
}

test "mulScalar" {
    const massTestmul2 = try mass.mulScalar(2);
    try testing.expect(massTestmul2.m.eqlScalar(2) == true);

    const massTestmul_2 = try mass.mulScalar(-2);
    try testing.expect(massTestmul_2.m.eqlScalar(-2) == true);
    try testing.expect(massTestmul_2.l.eqlScalar(0) == true);
}

test "mulScalarInPlace" {
    var massTest = mass;
    try massTest.mulScalarInPlace(2);
    try testing.expect(massTest.m.eqlScalar(2) == true);

    var massTest2 = mass;
    try massTest2.mulScalarInPlace(-2);
    try testing.expect(massTest2.m.eqlScalar(-2) == true);
    try testing.expect(massTest2.l.eqlScalar(0) == true);
}

test "mulFraction" {
    const sizeTest4 = try length.mulScalar(4);
    const sizeTest4MulFrac = try sizeTest4.mulFraction(try Fraction(i32).init(1, 4));
    try testing.expectEqual(length, sizeTest4MulFrac);
}

test "mulFractionInPlace" {
    var sizeTest4 = try length.mulScalar(4);
    try sizeTest4.mulFractionInPlace(try Fraction(i32).init(1, 4));
    try testing.expectEqual(length, sizeTest4);
}

test "divScalar" {
    const massTestmul2 = try mass.divScalar(2);
    try testing.expectEqual(try Fraction(i32).init(1, 2), massTestmul2.m);

    const massTestmul_2 = try mass.divScalar(-2);
    try testing.expectEqual(try Fraction(i32).init(-1, 2), massTestmul_2.m);
    try testing.expect(massTestmul_2.l.eqlScalar(0) == true);
}

test "divScalarInPlace" {
    var massTest = mass;
    try massTest.divScalarInPlace(2);
    try testing.expectEqual(try Fraction(i32).init(1, 2), massTest.m);

    var massTest2 = mass;
    try massTest2.divScalarInPlace(-2);
    try testing.expectEqual(try Fraction(i32).init(-1, 2), massTest2.m);
    try testing.expect(massTest2.l.eqlScalar(0) == true);
}

test "divFraction" {
    const sizeTest4 = try length.divScalar(4);
    const sizeTest4MulFrac = try sizeTest4.divFraction(try Fraction(i32).init(1, 4));
    try testing.expectEqual(length, sizeTest4MulFrac);
}

test "divFractionInPlace" {
    var sizeTest4 = try length.divScalar(4);
    try sizeTest4.divFractionInPlace(try Fraction(i32).init(1, 4));
    try testing.expectEqual(length, sizeTest4);
}

test "negInPlace" {
    var amountTest = amount;
    try amountTest.negInPlace();
    const invAmountRes: Dim = .initUniqueFieldInt("n", -1);
    try testing.expectEqual(invAmountRes, amountTest);
}
