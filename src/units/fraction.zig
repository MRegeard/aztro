const std = @import("std");
const testing = std.testing;
const math = std.math;
const debug = std.debug;

pub const FractionError = error{
    Overflow,
    ZeroDenominator,
    ImpossibleConversionToInt,
};

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

        pub const Error = FractionError;

        pub fn init(num: T, denum: T) Error!Self {
            if (denum == 0) return Error.ZeroDenominator;
            if (num < 0 and denum < 0) {
                return (Self{ .num = num, .denum = denum }).reduce();
            }
            return (Self{ .num = num, .denum = denum }).reduce();
        }

        pub fn initInt(value: T) Self {
            return .{ .num = value, .denum = 1 };
        }

        fn initUnchecked(num: T, denum: T) Self {
            debug.assert(denum != 0);
            return Self{ .num = num, .denum = denum };
        }

        fn initUncheckedReduce(num: T, denum: T) Self {
            debug.assert(denum != 0);
            return (Self{ .num = num, .denum = denum }).reduce();
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
            return Self.initUncheckedReduce(num, denum);
        }

        pub fn addInPlace(self: *Self, other: Self) Error!void {
            const num1 = try mulChecked(self.num, other.denum);
            const num2 = try mulChecked(other.num, self.denum);
            const denum = try mulChecked(self.denum, other.denum);
            const num = try addChecked(num1, num2);
            self.num = num;
            self.denum = denum;
            self.reduceInPlace();
        }

        pub fn addScalar(self: Self, value: T) Error!Self {
            const fracInt = Self.initInt(value);
            return try self.add(fracInt);
        }

        pub fn addScalarInPlace(self: *Self, value: T) Error!void {
            const fracInt = Self.initInt(value);
            try self.addInPlace(fracInt);
        }

        pub fn sub(self: Self, other: Self) Error!Self {
            return add(self, try other.neg());
        }

        pub fn subInPlace(self: *Self, other: Self) Error!void {
            return addInPlace(self, try other.neg());
        }

        pub fn subScalar(self: Self, value: T) Error!Self {
            const fracInt = Self.initInt(value);
            return try self.sub(fracInt);
        }

        pub fn subScalarInPlace(self: *Self, value: T) Error!void {
            const fracInt = Self.initInt(value);
            try self.subInPlace(fracInt);
        }

        pub fn neg(self: Self) Error!Self {
            if (self.num == math.minInt(T)) return Error.Overflow;
            return Self{ .num = -self.num, .denum = self.denum };
        }

        pub fn negInPlace(self: *Self) Error!void {
            if (self.num == math.minInt(T)) return Error.Overflow;
            self.num = -self.num;
        }

        pub fn inv(self: Self) Error!Self {
            if (self.num == 0) return Error.ZeroDenominator;
            if (self.num < 0) return Self.initUncheckedReduce(-self.denum, -self.num);
            return Self.initUncheckedReduce(self.denum, self.num);
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
            self.reduceInPlace();
        }

        pub fn mul(self: Self, other: Self) Error!Self {
            const num = try mulChecked(self.num, other.num);
            const denum = try mulChecked(self.denum, other.denum);
            return Self.initUncheckedReduce(num, denum);
        }

        pub fn mulInPlace(self: *Self, other: Self) Error!void {
            self.num = try mulChecked(self.num, other.num);
            self.denum = try mulChecked(self.denum, other.denum);
            self.reduceInPlace();
        }

        pub fn mulScalar(self: Self, value: T) Error!Self {
            const fracInt = Self.initInt(value);
            return try self.mul(fracInt);
        }

        pub fn mulScalarInPlace(self: *Self, value: T) Error!void {
            const fracInt = Self.initInt(value);
            try self.mulInPlace(fracInt);
        }

        pub fn div(self: Self, other: Self) Error!Self {
            return try self.mul(try other.inv());
        }

        pub fn divInPlace(self: *Self, other: Self) Error!void {
            try self.mulInPlace(try other.inv());
        }

        pub fn divScalar(self: Self, value: T) Error!Self {
            const fracInt = Self.initInt(value);
            return try self.div(fracInt);
        }

        pub fn divScalarInPlace(self: *Self, value: T) Error!void {
            const fracInt = Self.initInt(value);
            return try self.divInPlace(fracInt);
        }

        pub fn isInt(self: Self) bool {
            return self.reduce().denum == 1;
        }

        pub fn sign(self: Self) T {
            return math.sign(self.num) * math.sign(self.denum);
        }

        pub fn eqlScalar(self: Self, value: T) bool {
            return self.eql(Self.initInt(value));
        }

        pub fn eql(self: Self, other: Self) bool {
            return (self.sign() == other.sign()) and
                (@abs(self.num) == @abs(other.num)) and
                (@abs(self.denum) == @abs(other.denum));
        }

        pub fn abs(self: Self) Self {
            return Self.initUncheckedReduce(self.num * math.sign(self.num), self.denum * math.sign(self.denum));
        }

        pub fn absInPlace(self: *Self) void {
            self.num *= math.sign(self.num);
            self.denum *= math.sign(self.denum);
        }

        pub fn toFloat(self: Self, comptime float_type: type) float_type {
            const num: float_type = @floatFromInt(self.num);
            const denum: float_type = @floatFromInt(self.denum);
            return num / denum;
        }

        pub fn toInt(self: Self, comptime int_type: type) Error!int_type {
            if (self.isInt()) {
                const res: int_type = @intCast(self.reduce().num);
                return res;
            } else {
                return Error.ImpossibleConversionToInt;
            }
        }

        pub fn format(self: Self, writer: *std.Io.Writer) std.Io.Writer.Error!void {
            const frac = self.reduce();
            if (self.isInt()) {
                try writer.print("{d}", .{frac.num});
            } else {
                try writer.print("{d}/{d}", .{ frac.num, frac.denum });
            }
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
    try testing.expectEqual(-1, frac2.num);
    try testing.expectEqual(2, frac2.denum);
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
    try testing.expectEqual(try Fraci32.init(5, 12), fracAdd);

    const frac3 = try Fraci32.init(3, 8);
    const frac4 = try Fraci32.init(-1, 4);
    const fracAdd2 = try frac3.add(frac4);
    try testing.expectEqual(try Fraci32.init(1, 8), fracAdd2);

    const frac5 = try Fraci32.init(1, 6);
    const frac6 = try Fraci32.init(-1, 2);
    const fracAdd3 = try frac5.add(frac6);
    try testing.expectEqual(try Fraci32.init(-1, 3), fracAdd3);
}

test "addInPlace" {
    var frac1 = try Fraci32.init(1, 4);
    const frac2 = try Fraci32.init(1, 6);
    try frac1.addInPlace(frac2);
    try testing.expectEqual(try Fraci32.init(5, 12), frac1);

    var frac3 = try Fraci32.init(3, 8);
    const frac4 = try Fraci32.init(-1, 4);
    try frac3.addInPlace(frac4);
    try testing.expectEqual(try Fraci32.init(1, 8), frac3);

    var frac5 = try Fraci32.init(1, 6);
    const frac6 = try Fraci32.init(-1, 2);
    try frac5.addInPlace(frac6);
    try testing.expectEqual(try Fraci32.init(-1, 3), frac5);
}

test "addScalar" {
    const frac = try Fraci32.init(2, 4);
    const fracAddScalar = try frac.addScalar(2);
    try testing.expectEqual(try Fraci32.init(5, 2), fracAddScalar);

    const fracAddScalar2 = try frac.addScalar(-2);
    try testing.expectEqual(try Fraci32.init(-3, 2), fracAddScalar2);
}

test "addScalarInPlace" {
    var frac = try Fraci32.init(2, 4);
    try frac.addScalarInPlace(2);
    try testing.expectEqual(try Fraci32.init(5, 2), frac);

    var frac2 = try Fraci32.init(2, 4);
    try frac2.addScalarInPlace(-2);
    try testing.expectEqual(try Fraci32.init(-3, 2), frac2);
}

test "sub" {
    const frac1 = try Fraci32.init(1, 4);
    const frac2 = try Fraci32.init(1, 6);
    const fracSub = try frac1.sub(frac2);
    try testing.expectEqual(try Fraci32.init(1, 12), fracSub);

    const frac3 = try Fraci32.init(3, 8);
    const frac4 = try Fraci32.init(-1, 4);
    const fracSub2 = try frac3.sub(frac4);
    try testing.expectEqual(try Fraci32.init(5, 8), fracSub2);

    const frac5 = try Fraci32.init(1, 6);
    const frac6 = try Fraci32.init(1, 4);
    const fracSub3 = try frac5.sub(frac6);
    try testing.expectEqual(try Fraci32.init(-1, 12), fracSub3);
}

test "subInPlace" {
    var frac1 = try Fraci32.init(1, 4);
    const frac2 = try Fraci32.init(1, 6);
    try frac1.subInPlace(frac2);
    try testing.expectEqual(try Fraci32.init(1, 12), frac1);

    var frac3 = try Fraci32.init(3, 8);
    const frac4 = try Fraci32.init(-1, 4);
    try frac3.subInPlace(frac4);
    try testing.expectEqual(try Fraci32.init(5, 8), frac3);

    var frac5 = try Fraci32.init(1, 6);
    const frac6 = try Fraci32.init(1, 4);
    try frac5.subInPlace(frac6);
    try testing.expectEqual(try Fraci32.init(-1, 12), frac5);
}

test "subScalar" {
    const frac = try Fraci32.init(1, 3);
    const fracSubScalar = try frac.subScalar(1);
    try testing.expectEqual(try Fraci32.init(-2, 3), fracSubScalar);

    const fracSubScalar2 = try frac.subScalar(-1);
    try testing.expectEqual(try Fraci32.init(4, 3), fracSubScalar2);
}

test "subScalarInPlace" {
    var frac = try Fraci32.init(1, 3);
    try frac.subScalarInPlace(1);
    try testing.expectEqual(try Fraci32.init(-2, 3), frac);

    var frac2 = try Fraci32.init(1, 3);
    try frac2.subScalarInPlace(-1);
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
    try testing.expectEqual(try Fraci32.init(-2, 1), fracinvNeg);

    const frac3 = try Fraci32.init(-3, -3);
    const fracinvNegAll = try frac3.inv();
    try testing.expectEqual(try Fraci32.init(1, 1), fracinvNegAll);
}

test "invInPlace" {
    var frac = try Fraci32.init(-5, 11);
    try frac.invInPlace();
    try testing.expectEqual(try Fraci32.init(-11, 5), frac);

    var frac2 = try Fraci32.init(-2, 4);
    try frac2.invInPlace();
    try testing.expectEqual(try Fraci32.init(-2, 1), frac2);

    frac2.denum = -frac2.denum;
    try frac2.invInPlace();
    try testing.expectEqual(try Fraci32.init(1, 2), frac2);
}

test "mul" {
    const frac1 = try Fraci32.init(3, 4);
    const frac2 = try Fraci32.init(2, 8);
    const fracMul = try frac1.mul(frac2);
    try testing.expectEqual(try Fraci32.init(3, 16), fracMul);

    const frac3 = try Fraci32.init(-2, 10);
    const frac4 = try Fraci32.init(2, 10);
    const fracMul2 = try frac3.mul(frac4);
    try testing.expectEqual(try Fraci32.init(-1, 25), fracMul2);
}

test "mulInPlace" {
    var frac1 = try Fraci32.init(3, 4);
    const frac2 = try Fraci32.init(2, 8);
    try frac1.mulInPlace(frac2);
    try testing.expectEqual(try Fraci32.init(3, 16), frac1);

    var frac3 = try Fraci32.init(-2, 10);
    const frac4 = try Fraci32.init(2, 10);
    try frac3.mulInPlace(frac4);
    try testing.expectEqual(try Fraci32.init(-1, 25), frac3);
}

test "mulScalar" {
    const frac = try Fraci32.init(4, 12);
    const fracMulScalar = try frac.mulScalar(3);
    try testing.expectEqual(try Fraci32.init(1, 1), fracMulScalar);

    const fracMulScalar2 = try frac.mulScalar(-2);
    try testing.expectEqual(try Fraci32.init(-2, 3), fracMulScalar2);
}

test "mulScalarInPlace" {
    var frac = try Fraci32.init(4, 12);
    try frac.mulScalarInPlace(3);
    try testing.expectEqual(try Fraci32.init(1, 1), frac);

    try frac.mulScalarInPlace(-2);
    try testing.expectEqual(try Fraci32.init(-2, 1), frac);
}

test "div" {
    const frac1 = try Fraci32.init(5, 3);
    const frac2 = try Fraci32.init(4, 2);
    const fracDiv = try frac1.div(frac2);
    try testing.expectEqual(try Fraci32.init(5, 6), fracDiv);
}

test "divInPlace" {
    var frac1 = try Fraci32.init(4, 2);
    const frac2 = try Fraci32.init(3, 5);
    try frac1.divInPlace(frac2);
    try testing.expectEqual(try Fraci32.init(10, 3), frac1);
}

test "divScalar" {
    const frac = try Fraci32.init(4, 6);
    const fracDivScalar = try frac.divScalar(2);
    try testing.expectEqual(try Fraci32.init(1, 3), fracDivScalar);

    const fracDivScalar2 = try frac.divScalar(-2);
    try testing.expectEqual(try Fraci32.init(-1, 3), fracDivScalar2);
}

test "divScalarInPlace" {
    var frac = try Fraci32.init(4, 6);
    try frac.divScalarInPlace(2);
    try testing.expectEqual(try Fraci32.init(1, 3), frac);

    try frac.divScalarInPlace(-2);
    try testing.expectEqual(try Fraci32.init(-1, 6), frac);
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

test "eqlInt" {
    const frac = try Fraci32.init(4, 2);
    try testing.expect(frac.eqlScalar(2) == true);
    const frac2 = try Fraci32.init(3, 2);
    try testing.expect(frac2.eqlScalar(3) == false);
}

test "toFloat" {
    const frac = try Fraci32.init(1, 2);
    try testing.expect(math.approxEqAbs(f64, frac.toFloat(f64), 0.5, 1e-15));
    try testing.expect(math.approxEqAbs(f32, frac.toFloat(f32), 0.5, 1e-15));

    const fracOverload = try Fraci32.init(math.maxInt(i32), 1);
    _ = fracOverload.toFloat(f64);
}

test "toInt" {
    const frac = try Fraci32.init(4, 2);
    try testing.expectEqual(2, try frac.toInt(u32));

    const frac2 = try Fraci32.init(1, 3);
    try testing.expectError(FractionError.ImpossibleConversionToInt, frac2.toInt(u32));

    // Should crash the test
    // const fracOverload = try Fraci32.init(math.maxInt(i32), 1);
    // _ = try fracOverload.toInt(u16);
}

test "fromat" {
    var buf: [8]u8 = undefined;
    const frac = try Fraci32.init(4, 2);
    const print_res = try std.fmt.bufPrint(&buf, "{f}", .{frac});
    try testing.expectEqualSlices(u8, "2", print_res);

    const frac2 = try Fraci32.init(3, 2);
    const print_res2 = try std.fmt.bufPrint(&buf, "{f}", .{frac2});
    try testing.expectEqualSlices(u8, "3/2", print_res2);
}
