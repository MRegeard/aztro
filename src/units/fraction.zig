const std = @import("std");
const testing = std.testing;
const math = std.math;

pub fn Fraction(comptime T: type) type {
    comptime {
        const typeInfo = @typeInfo(T);
        if (typeInfo != .int) {
            @compileError("Fraction(T): T must be a signed integer type.");
        }
        if (typeInfo.int.signedness != .signed) {
            @compileError("Fraction(T): T must be a signed integer type.");
        }
    }

    return struct {
        const Self = @This();

        num: T,
        denum: T,

        pub const Error = error{
            ZeroDenominator,
            Overflow,
        };

        pub fn init(num: T, denum: T) Error!Self {
            if (denum == 0) return Error.ZeroDenominator;
            if (num < 0 and denum < 0) {
                return .{ .num = num, .denum = denum };
            }
            return .{ .num = num, .denum = denum };
        }

        pub fn initInt(value: T) Self {
            return .{ .num = value, .denum = 1 };
        }

        pub fn initReduce(num: T, denum: T) Error!Self {
            var frac = try init(num, denum);
            frac.reduceInPlace();
            return frac;
        }

        pub fn reduce(self: Self) Self {
            var frac = self;
            if (frac.denum < 0) {
                frac.num = -frac.num;
                frac.denum = -frac.denum;
            }
            if (frac.num == 0) {
                frac.denum = 1;
                return frac;
            }

            const g = math.gcd(@abs(frac.num), @abs(frac.denum));
            const gT: T = @intCast(g);
            frac.num = @divExact(frac.num, gT);
            frac.denum = @divExact(frac.denum, gT);

            return frac;
        }

        pub fn reduceInPlace(self: *Self) void {
            if (self.denum < 0) {
                self.num = -self.num;
                self.denum = -self.denum;
            }
            if (self.num == 0) {
                self.denum = 1;
                return;
            }

            const g = math.gcd(@abs(self.num), @abs(self.denum));
            const gT: T = @intCast(g);
            self.num = @divExact(self.num, gT);
            self.denum = @divExact(self.denum, gT);
        }

        fn addChecked(a: T, b: T) Error!T {
            const result = @addWithOverflow(a, b);
            if (result[1] != 0) return Error.Overflow;
            return result[0];
        }

        fn mulChecked(a: T, b: T) Error!T {
            const result = @mulWithOverflow(a, b);
            if (result[1] != 0) return Error.Overflow;
            return result[0];
        }

        pub fn add(self: Self, other: Self) Error!Self {
            const num1 = try mulChecked(self.num, other.denum);
            const num2 = try mulChecked(other.num, self.denum);
            const denum = try mulChecked(self.denum, other.denum);
            const num = try addChecked(num1, num2);
            return .init(num, denum);
        }

        pub fn addInPlace(self: *Self, other: Self) Error!void {
            const num1 = try mulChecked(self.num, other.denum);
            const num2 = try mulChecked(other.num, self.denum);
            const denum = try mulChecked(self.denum, other.denum);
            const num = try addChecked(num1, num2);
            self.num = num;
            self.denum = denum;
        }

        pub fn addValue(self: Self, value: T) Error!Self {
            const fracInt = try init(value, 1);
            return try self.add(fracInt);
        }

        pub fn addValueInPlace(self: *Self, value: T) Error!void {
            const fracInt = try init(value, 1);
            try self.addInPlace(fracInt);
        }

        pub fn sub(self: Self, other: Self) Error!Self {
            return add(self, try other.neg());
        }

        pub fn subInPlace(self: *Self, other: Self) Error!void {
            return addInPlace(self, try other.neg());
        }

        pub fn subValue(self: Self, value: T) Error!Self {
            const fracInt = try init(value, 1);
            return try self.sub(fracInt);
        }

        pub fn subValueInPlace(self: *Self, value: T) Error!void {
            const fracInt = try init(value, 1);
            try self.subInPlace(fracInt);
        }

        pub fn neg(self: Self) Error!Self {
            if (self.num == math.minInt(T)) return Error.Overflow;
            return .init(-self.num, self.denum);
        }

        pub fn negInPlace(self: *Self) Error!void {
            if (self.num == math.minInt(T)) return Error.Overflow;
            self.num = -self.num;
        }

        pub fn inv(self: Self) Error!Self {
            if (self.num == 0) return Error.ZeroDenominator;
            if (self.num < 0) return .init(-self.denum, -self.num);
            return .init(self.denum, self.num);
        }

        pub fn invInPlace(self: *Self) Error!void {
            if (self.num == 0) return Error.ZeroDenominator;
            if (self.num < 0) {
                self.num = -self.num;
                self.denum = -self.denum;
            }
            const temp = self.num;
            self.num = self.denum;
            self.denum = temp;
        }

        pub fn mul(self: Self, other: Self) Error!Self {
            const num = try mulChecked(self.num, other.num);
            const denum = try mulChecked(self.denum, other.denum);
            return .init(num, denum);
        }

        pub fn mulInPlace(self: *Self, other: Self) Error!void {
            self.num = try mulChecked(self.num, other.num);
            self.denum = try mulChecked(self.denum, other.denum);
        }

        pub fn mulValue(self: Self, value: T) Error!Self {
            const fracInt = try init(value, 1);
            return try self.mul(fracInt);
        }

        pub fn mulValueInPlace(self: *Self, value: T) Error!void {
            const fracInt = try init(value, 1);
            try self.mulInPlace(fracInt);
        }

        pub fn div(self: Self, other: Self) Error!Self {
            return try self.mul(try other.inv());
        }

        pub fn divInPlace(self: *Self, other: Self) Error!void {
            try self.mulInPlace(try other.inv());
        }

        pub fn divValue(self: Self, value: T) Error!Self {
            const fracInt = try init(value, 1);
            return try self.div(fracInt);
        }

        pub fn divValueInPlace(self: *Self, value: T) Error!void {
            const fracInt = try init(value, 1);
            return try self.divInPlace(fracInt);
        }

        pub fn isInt(self: Self) bool {
            return self.reduce().denum == 1;
        }

        pub fn sign(self: Self) T {
            return math.sign(self.num) * math.sign(self.denum);
        }

        pub fn eql(self: Self, other: Self) bool {
            return (self.sign() == other.sign()) and (@abs(self.num) == @abs(other.num)) and (@abs(self.denum) == @abs(other.denum));
        }

        pub fn abs(self: Self) Self {
            return Self{ .num = self.num * math.sign(self.num), .denum = self.denum * math.sign(self.denum) };
        }

        pub fn absInPlace(self: *Self) void {
            self.num *= math.sign(self.num);
            self.denum *= math.sign(self.denum);
        }
    };
}

const Fraci32 = Fraction(i32);

test "init" {
    const frac = try Fraci32.init(1, 2);
    try testing.expectEqual(1, frac.num);
    try testing.expectEqual(2, frac.denum);
    try testing.expectError(error.ZeroDenominator, Fraci32.init(2, 0));
    const frac2 = try Fraci32.init(-2, 4);
    try testing.expectEqual(-2, frac2.num);
    try testing.expectEqual(4, frac2.denum);
}

test "initReduce" {
    const frac = try Fraci32.initReduce(8, 12);
    try testing.expectEqual(try Fraci32.init(2, 3), frac);
}

test "reduce" {
    const canReduce = try Fraci32.init(8, 12);
    const reduced = canReduce.reduce();
    try testing.expectEqual(try Fraci32.init(2, 3), reduced);
    const cannotReduce = try Fraci32.init(7, 12);
    const reduced2 = cannotReduce.reduce();
    try testing.expectEqual(cannotReduce, reduced2);
}

test "reduceInPlace" {
    var canReduce = try Fraci32.init(8, 12);
    canReduce.reduceInPlace();
    try testing.expectEqual(try Fraci32.init(2, 3), canReduce);
    var cannotReduce = try Fraci32.init(7, 12);
    cannotReduce.reduceInPlace();
    try testing.expectEqual(try Fraci32.init(7, 12), cannotReduce);
}

test "add" {
    const frac1 = try Fraci32.init(1, 4);
    const frac2 = try Fraci32.init(1, 6);
    const fracAdd = try frac1.add(frac2);
    try testing.expectEqual(try Fraci32.init(10, 24), fracAdd);

    const frac3 = try Fraci32.init(3, 8);
    const frac4 = try Fraci32.init(-1, 4);
    const fracAdd2 = try frac3.add(frac4);
    try testing.expectEqual(try Fraci32.init(4, 32), fracAdd2);

    const frac5 = try Fraci32.init(1, 6);
    const frac6 = try Fraci32.init(-1, 2);
    const fracAdd3 = try frac5.add(frac6);
    try testing.expectEqual(try Fraci32.init(-4, 12), fracAdd3);
}

test "addInPlace" {
    var frac1 = try Fraci32.init(1, 4);
    const frac2 = try Fraci32.init(1, 6);
    try frac1.addInPlace(frac2);
    try testing.expectEqual(try Fraci32.init(10, 24), frac1);

    var frac3 = try Fraci32.init(3, 8);
    const frac4 = try Fraci32.init(-1, 4);
    try frac3.addInPlace(frac4);
    try testing.expectEqual(try Fraci32.init(4, 32), frac3);

    var frac5 = try Fraci32.init(1, 6);
    const frac6 = try Fraci32.init(-1, 2);
    try frac5.addInPlace(frac6);
    try testing.expectEqual(try Fraci32.init(-4, 12), frac5);
}

test "addValue" {
    const frac = try Fraci32.init(2, 4);
    const fracAddValue = try frac.addValue(2);
    try testing.expectEqual(try Fraci32.init(10, 4), fracAddValue);

    const fracAddValue2 = try frac.addValue(-2);
    try testing.expectEqual(try Fraci32.init(-6, 4), fracAddValue2);
}

test "addValueInPlace" {
    var frac = try Fraci32.init(2, 4);
    try frac.addValueInPlace(2);
    try testing.expectEqual(try Fraci32.init(10, 4), frac);

    var frac2 = try Fraci32.init(2, 4);
    try frac2.addValueInPlace(-2);
    try testing.expectEqual(try Fraci32.init(-6, 4), frac2);
}

test "sub" {
    const frac1 = try Fraci32.init(1, 4);
    const frac2 = try Fraci32.init(1, 6);
    const fracSub = try frac1.sub(frac2);
    try testing.expectEqual(try Fraci32.init(2, 24), fracSub);

    const frac3 = try Fraci32.init(3, 8);
    const frac4 = try Fraci32.init(-1, 4);
    const fracSub2 = try frac3.sub(frac4);
    try testing.expectEqual(try Fraci32.init(20, 32), fracSub2);

    const frac5 = try Fraci32.init(1, 6);
    const frac6 = try Fraci32.init(1, 4);
    const fracSub3 = try frac5.sub(frac6);
    try testing.expectEqual(try Fraci32.init(-2, 24), fracSub3);
}

test "subInPlace" {
    var frac1 = try Fraci32.init(1, 4);
    const frac2 = try Fraci32.init(1, 6);
    try frac1.subInPlace(frac2);
    try testing.expectEqual(try Fraci32.init(2, 24), frac1);

    var frac3 = try Fraci32.init(3, 8);
    const frac4 = try Fraci32.init(-1, 4);
    try frac3.subInPlace(frac4);
    try testing.expectEqual(try Fraci32.init(20, 32), frac3);

    var frac5 = try Fraci32.init(1, 6);
    const frac6 = try Fraci32.init(1, 4);
    try frac5.subInPlace(frac6);
    try testing.expectEqual(try Fraci32.init(-2, 24), frac5);
}

test "subValue" {
    const frac = try Fraci32.init(1, 3);
    const fracSubValue = try frac.subValue(1);
    try testing.expectEqual(try Fraci32.init(-2, 3), fracSubValue);

    const fracSubValue2 = try frac.subValue(-1);
    try testing.expectEqual(try Fraci32.init(4, 3), fracSubValue2);
}

test "subValueInPlace" {
    var frac = try Fraci32.init(1, 3);
    try frac.subValueInPlace(1);
    try testing.expectEqual(try Fraci32.init(-2, 3), frac);

    var frac2 = try Fraci32.init(1, 3);
    try frac2.subValueInPlace(-1);
    try testing.expectEqual(try Fraci32.init(4, 3), frac2);
}

test "neg" {
    const frac = try Fraci32.init(1, 4);
    const fracNeg = try frac.neg();
    try testing.expectEqual(try Fraci32.init(-1, 4), fracNeg);
}

test "negInPlace" {
    var frac = try Fraci32.init(3, 5);
    try frac.negInPlace();
    try testing.expectEqual(try Fraci32.init(-3, 5), frac);
}

test "inv" {
    const frac = try Fraci32.init(5, 12);
    const fracinv = try frac.inv();
    try testing.expectEqual(try Fraci32.init(12, 5), fracinv);

    const frac2 = try Fraci32.init(-2, 4);
    const fracinvNeg = try frac2.inv();
    try testing.expectEqual(try Fraci32.init(-4, 2), fracinvNeg);

    const frac3 = try Fraci32.init(-3, -3);
    const fracinvNegAll = try frac3.inv();
    try testing.expectEqual(try Fraci32.init(3, 3), fracinvNegAll);
}

test "invInPlace" {
    var frac = try Fraci32.init(-5, 11);
    try frac.invInPlace();
    try testing.expectEqual(try Fraci32.init(-11, 5), frac);

    var frac2 = try Fraci32.init(-2, 4);
    try frac2.invInPlace();
    try testing.expectEqual(try Fraci32.init(-4, 2), frac2);

    frac2.denum = -frac2.denum;
    try frac2.invInPlace();
    try testing.expectEqual(try Fraci32.init(2, 4), frac2);
}

test "mul" {
    const frac1 = try Fraci32.init(3, 4);
    const frac2 = try Fraci32.init(2, 8);
    const fracMul = try frac1.mul(frac2);
    try testing.expectEqual(try Fraci32.init(6, 32), fracMul);

    const frac3 = try Fraci32.init(-2, 10);
    const frac4 = try Fraci32.init(2, 10);
    const fracMul2 = try frac3.mul(frac4);
    try testing.expectEqual(try Fraci32.init(-4, 100), fracMul2);
}

test "mulInPlace" {
    var frac1 = try Fraci32.init(3, 4);
    const frac2 = try Fraci32.init(2, 8);
    try frac1.mulInPlace(frac2);
    try testing.expectEqual(try Fraci32.init(6, 32), frac1);

    var frac3 = try Fraci32.init(-2, 10);
    const frac4 = try Fraci32.init(2, 10);
    try frac3.mulInPlace(frac4);
    try testing.expectEqual(try Fraci32.init(-4, 100), frac3);
}

test "mulValue" {
    const frac = try Fraci32.init(4, 12);
    const fracMulValue = try frac.mulValue(3);
    try testing.expectEqual(try Fraci32.init(12, 12), fracMulValue);

    const fracMulValue2 = try frac.mulValue(-2);
    try testing.expectEqual(try Fraci32.init(-8, 12), fracMulValue2);
}

test "mulValueInPlace" {
    var frac = try Fraci32.init(4, 12);
    try frac.mulValueInPlace(3);
    try testing.expectEqual(try Fraci32.init(12, 12), frac);

    try frac.mulValueInPlace(-2);
    try testing.expectEqual(try Fraci32.init(-24, 12), frac);
}

test "div" {
    const frac1 = try Fraci32.init(5, 3);
    const frac2 = try Fraci32.init(4, 2);
    const fracDiv = try frac1.div(frac2);
    try testing.expectEqual(try Fraci32.init(10, 12), fracDiv);
}

test "divInPlace" {
    var frac1 = try Fraci32.init(4, 2);
    const frac2 = try Fraci32.init(3, 5);
    try frac1.divInPlace(frac2);
    try testing.expectEqual(try Fraci32.init(20, 6), frac1);
}

test "divValue" {
    const frac = try Fraci32.init(4, 6);
    const fracDivValue = try frac.divValue(2);
    try testing.expectEqual(try Fraci32.init(4, 12), fracDivValue);

    const fracDivValue2 = try frac.divValue(-2);
    try testing.expectEqual(try Fraci32.init(-4, 12), fracDivValue2);
}

test "divValueInPlace" {
    var frac = try Fraci32.init(4, 6);
    try frac.divValueInPlace(2);
    try testing.expectEqual(try Fraci32.init(4, 12), frac);

    try frac.divValueInPlace(-2);
    try testing.expectEqual(try Fraci32.init(-4, 24), frac);
}

test "isInt" {
    const frac1 = try Fraci32.init(4, 2);
    const frac2 = try Fraci32.init(1, 1);
    const frac3 = try Fraci32.init(4, 8);
    try testing.expectEqual(true, frac1.isInt());
    try testing.expectEqual(true, frac2.isInt());
    try testing.expectEqual(false, frac3.isInt());
}

test "sign" {
    var frac = try Fraci32.init(4, 4);
    try testing.expect(frac.sign() == 1);
    frac.num = -frac.num;
    try testing.expect(frac.sign() == -1);
    frac.denum = -frac.denum;
    try testing.expect(frac.sign() == 1);
    frac.num = 0;
    try testing.expect(frac.sign() == 0);
}

test "eql" {
    const frac1 = try Fraci32.init(4, 5);
    const frac2 = try Fraci32.init(4, 5);
    try testing.expect(frac1.eql(frac2) == true);

    const frac3 = try Fraci32.init(-4, 5);
    try testing.expect(frac1.eql(frac3) == false);

    const frac4 = try Fraci32.init(2, 6);
    try testing.expect(frac4.eql(frac2) == false);
    try testing.expect(frac4.eql(frac3) == false);
}

test "abs" {
    const frac = try Fraci32.init(3, 8);
    const fracAbs = frac.abs();
    try testing.expectEqual(try Fraci32.init(3, 8), fracAbs);

    const frac2 = try Fraci32.init(-3, 8);
    const fracAbs2 = frac2.abs();
    try testing.expectEqual(try Fraci32.init(3, 8), fracAbs2);

    const frac3 = try Fraci32.init(-3, -8);
    const fracAbs3 = frac3.abs();
    try testing.expectEqual(try Fraci32.init(3, 8), fracAbs3);
}

test "absInPlace" {
    var frac = try Fraci32.init(3, 8);
    frac.absInPlace();
    try testing.expectEqual(try Fraci32.init(3, 8), frac);

    var frac2 = try Fraci32.init(-3, 8);
    frac2.absInPlace();
    try testing.expectEqual(try Fraci32.init(3, 8), frac2);

    var frac3 = try Fraci32.init(-3, -8);
    frac3.absInPlace();
    try testing.expectEqual(try Fraci32.init(3, 8), frac3);
}
