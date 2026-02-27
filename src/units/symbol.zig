const std = @import("std");
const testing = std.testing;
const Fraction = @import("fraction.zig").Fraction;

pub const SymbolTerm = struct {
    const Self = @This();

    symbol: []const u8,
    exponent: Fraction(isize),

    pub fn init(symbol: []const u8, exponent: Fraction(isize)) Self {
        return .{ .symbol = symbol, .exponent = exponent };
    }

    pub fn initSymbol(symbol: []const u8) Self {
        return .init(symbol, Fraction(isize).initInt(1));
    }

    pub fn initSymbolInt(symbol: []const u8, value: isize) Self {
        return .init(symbol, Fraction(isize).initInt(value));
    }

    // Case m1
    // Case m-1 m+1
    // Case m1/2
    // Case m^1/2
    // Case m-1/2 m+1/2
    // Case m^-1/2 m^+1/2
    fn parseExponent(string: []const u8) !Fraction(isize) {
        var result = Fraction(isize).initInt(1);
        var str_pos: usize = 0;
        var is_num: bool = true;
        loop: while (str_pos < string.len) {
            switch (string[str_pos]) {
                '^' => str_pos += 1,
                '/' => {
                    is_num = false;
                    str_pos += 1;
                },
                else => {
                    if (is_num) {
                        const slash_pos = std.mem.indexOfScalarPos(u8, string, str_pos, '/');
                        if (slash_pos) |idx| {
                            const num: isize = try std.fmt.parseInt(isize, string[str_pos..idx], 10);
                            result.num = num;
                            str_pos = idx;
                        } else {
                            const num: isize = try std.fmt.parseInt(isize, string[str_pos..], 10);
                            result.num = num;
                            str_pos = string.len;
                        }
                    } else {
                        const denum = try std.fmt.parseInt(isize, string[str_pos..], 10);
                        std.debug.assert(denum != 0);
                        result.denum = denum;
                        break :loop;
                    }
                },
            }
        }
        result.reduceInPlace();
        return result;
    }

    pub fn format(self: Self, writer: *std.Io.Writer) std.io.Writer.Error!void {
        if (self.exponent.eqlScalar(1)) {
            try writer.print("{s}", .{self.symbol});
        } else {
            try writer.print("{s}{f}", .{ self.symbol, self.exponent });
        }
    }
};

pub const SymbolExpression = struct {
    const Self = @This();

    len: usize = 0,
    terms: [8]SymbolTerm = undefined,

    pub fn init(terms: []SymbolTerm) Self {
        if (terms.len > 8) @panic("More than 8 UniqueSymbol were given");
        var result: Self = .{};
        for (0..terms.len) |i| {
            result.terms[i] = terms[i];
        }
        result.len = terms.len;
        return result;
    }

    pub fn initFromString(comptime string: []const u8) !Self {
        if (string.len == 0) @panic("Implement/check Unitless edge case");
        var terms: [8]SymbolTerm = undefined;
        var split_it = std.mem.splitScalar(u8, string, ' ');
        var term_counter: usize = 0;
        while (split_it.next()) |str| {
            if (term_counter > 8) @panic("Reach maximum len for SymbolExpression");
            var split_idx: usize = 0;
            inner: while (split_idx < str.len) {
                switch (str[split_idx]) {
                    'a'...'z', 'A'...'Z' => split_idx += 1,
                    else => {
                        break :inner;
                    },
                }
            }
            if (split_idx == str.len) {
                terms[term_counter] = SymbolTerm.initSymbol(str[0..split_idx]);
            } else {
                const exponent: Fraction(isize) = try SymbolTerm.parseExponent(str[split_idx..]);
                terms[term_counter] = SymbolTerm.init(str[0..split_idx], exponent);
            }
            term_counter += 1;
        }
        var result: SymbolExpression = .{ .len = term_counter, .terms = terms };
        result.checkDuplicatesInPlace();
        return result;
    }

    pub fn checkDuplicates(self: Self) Self {
        var result = self;
        result.checkDuplicatesInPlace();
        return result;
    }

    pub fn checkDuplicatesInPlace(self: *Self) void {
        var i: usize = 0;
        while (i < self.len) {
            var j: usize = i + 1;
            while (j < self.len) {
                if (std.mem.eql(u8, self.terms[i].symbol, self.terms[j].symbol)) {
                    self.terms[i].exponent.addInPlace(self.terms[j].exponent) catch unreachable;
                    self.removePosInPlace(j);
                }
                j += 1;
            }
            i += 1;
        }
    }

    pub fn append(self: Self, symbol_term: SymbolTerm) Self {
        var result = self;
        result.appendInPlace(symbol_term);
        return result;
    }

    pub fn appendInPlace(self: *Self, symbol_term: SymbolTerm) void {
        if (self.indexOfSymbol(symbol_term)) |idx| {
            self.terms[idx].exponent.addInPlace(symbol_term.exponent) catch unreachable;
            self.checkRemoveInPlace();
        } else {
            if (self.len == 8) {
                @panic("Reach maximum len for SymbolExpression");
            } else {
                self.terms[self.len] = symbol_term;
                self.len += 1;
            }
        }
    }

    pub fn checkRemove(self: Self) Self {
        var result = self;
        result.checkRemoveInPlace();
        return result;
    }

    pub fn checkRemoveInPlace(self: *Self) void {
        var idx: usize = 0;
        while (idx < self.len) {
            if (self.terms[idx].exponent.eqlScalar(0)) {
                self.removePosInPlace(idx);
            }
            idx += 1;
        }
    }

    pub fn removePos(self: Self, pos: usize) Self {
        var result = self;
        result.removePosInPlace(pos);
        return result;
    }

    pub fn removePosInPlace(self: *Self, pos: usize) void {
        if (self.len == 0) @panic("Trying to remove from uninitialize memory cause panic!");
        if (pos >= self.len) @panic("Accessing undefined memory cause panic!");
        self.terms[pos] = self.terms[self.len - 1];
        self.len -= 1;
    }

    pub fn indexOfSymbol(self: Self, symbol_term: SymbolTerm) ?usize {
        for (0..self.len) |i| {
            if (std.mem.eql(u8, self.terms[i].symbol, symbol_term.symbol)) {
                return i;
            }
        }
        return null;
    }

    pub fn format(self: *const Self, writer: *std.Io.Writer) std.Io.Writer.Error!void {
        if (self.len == 0) {
            try writer.print("", .{});
            return;
        }
        for (0..self.len - 1) |i| {
            try writer.print("{f} ", .{self.terms[i]});
        }
        try writer.print("{f}", .{self.terms[self.len - 1]});
    }

    pub fn eql(self: Self, other: Self) bool {
        if (self.len == 0 and other.len == 0) return true;
        if (self.len != other.len) return false;
        const other_inv = other.inv();
        const result = self.concatenate(other_inv);
        if (result.len == 0) return true;
        return false;
    }

    pub fn concatenate(self: Self, other: Self) Self {
        var result = self;
        result.concatenateInPlace(other);
        return result;
    }

    pub fn concatenateInPlace(self: *Self, other: Self) void {
        for (0..other.len) |i| {
            self.appendInPlace(other.terms[i]);
        }
    }

    pub fn inv(self: Self) Self {
        var result = self;
        result.invInPlace();
        return result;
    }

    pub fn invInPlace(self: *Self) void {
        for (0..self.len) |i| {
            self.terms[i].exponent.negInPlace() catch unreachable;
        }
    }
};

test "SymbolTerm init" {
    const symbol1 = SymbolTerm.init("m", try Fraction(isize).init(1, 2));
    const symbol2 = SymbolTerm.initSymbol("s");
    const symbol3 = SymbolTerm.initSymbolInt("kg", -1);

    try testing.expectEqual("m", symbol1.symbol);
    try testing.expectEqual(try Fraction(isize).init(1, 2), symbol1.exponent);
    try testing.expect((1 == symbol2.exponent.denum) and (1 == symbol2.exponent.num));
    try testing.expect(symbol3.exponent.eqlScalar(-1));
}

test "SymbolTerm init comptime" {
    comptime {
        const symbol = SymbolTerm.init("Hz", try Fraction(isize).init(1, 3));
        try testing.expect(3 == symbol.exponent.denum);
    }
}

test "SymbolExpression init" {
    const symbol1 = SymbolTerm.initSymbol("m");
    const symbol2 = SymbolTerm.initSymbolInt("s", -1);

    const terms: [2]SymbolTerm = .{ symbol1, symbol2 };
    const symbol_list: SymbolExpression = .init(@constCast(&terms));

    try testing.expectEqual(2, symbol_list.len);
    try testing.expectEqual(symbol1, symbol_list.terms[0]);
}

test "SymbolTerm parseExponent" {
    // Case m-1/2 m+1/2
    // Case m^-1/2 m^+1/2

    // Case m1
    const exp1: Fraction(isize) = try SymbolTerm.parseExponent("1");
    try testing.expectEqual(1, exp1.num);
    try testing.expectEqual(1, exp1.denum);

    // Case m-1
    const exp2: Fraction(isize) = try SymbolTerm.parseExponent("-1");
    try testing.expectEqual(-1, exp2.num);
    try testing.expectEqual(1, exp2.denum);

    const exp3: Fraction(isize) = try SymbolTerm.parseExponent("+1");
    try testing.expectEqual(1, exp3.num);
    try testing.expectEqual(1, exp3.denum);

    // Case m1/2
    const exp4: Fraction(isize) = try SymbolTerm.parseExponent("1/2");
    try testing.expectEqual(1, exp4.num);
    try testing.expectEqual(2, exp4.denum);

    // Case m^1/2
    const exp5: Fraction(isize) = try SymbolTerm.parseExponent("^1/2");
    try testing.expectEqual(1, exp5.num);
    try testing.expectEqual(2, exp5.denum);

    // Case m-1/2
    const exp6: Fraction(isize) = try SymbolTerm.parseExponent("-1/2");
    try testing.expectEqual(-1, exp6.num);
    try testing.expectEqual(2, exp6.denum);

    // Case m^-1/2
    const exp7: Fraction(isize) = try SymbolTerm.parseExponent("^-1/2");
    try testing.expectEqual(-1, exp7.num);
    try testing.expectEqual(2, exp7.denum);
}

test "SymbolTerm format" {
    const symbol1 = SymbolTerm.initSymbol("m");
    const symbol2 = SymbolTerm.init("s", try .init(-1, 2));
    var buf: [8]u8 = undefined;
    const print_res_1 = try std.fmt.bufPrint(&buf, "{f}", .{symbol1});
    try testing.expectEqualSlices(u8, "m", print_res_1);
    const print_res_2 = try std.fmt.bufPrint(&buf, "{f}", .{symbol2});
    try testing.expectEqualSlices(u8, "s-1/2", print_res_2);
}

test "SymbolExpression initFromString" {
    const symb_expr = try SymbolExpression.initFromString("m s-1");
    try testing.expectEqual(2, symb_expr.len);
    try testing.expectEqualSlices(u8, "m", symb_expr.terms[0].symbol);
    try testing.expectEqualSlices(u8, "s", symb_expr.terms[1].symbol);
    try testing.expect(symb_expr.terms[1].exponent.eqlScalar(-1));
}

test "SymbolExpression indexOfSymbol" {
    const symb_expr: SymbolExpression = try .initFromString("m s-1");
    const symb_meter: SymbolTerm = .initSymbol("m");
    const symb_Hz: SymbolTerm = .initSymbol("Hz");
    try testing.expectEqual(0, symb_expr.indexOfSymbol(symb_meter));
    try testing.expectEqual(null, symb_expr.indexOfSymbol(symb_Hz));
}

test "SymbolExpression removeInPlace" {
    var symb_expr: SymbolExpression = try .initFromString("m s-1");
    symb_expr.removePosInPlace(1);
    try testing.expectEqual(1, symb_expr.len);
    try testing.expectEqualSlices(u8, "m", symb_expr.terms[0].symbol);
    try testing.expect(symb_expr.terms[0].exponent.eqlScalar(1));

    symb_expr.removePosInPlace(0);
    try testing.expectEqual(0, symb_expr.len);
}

test "SymbolExpression checkRemoveInPlace" {
    var symb_expr: SymbolExpression = try .initFromString("m s0");
    try testing.expectEqual(2, symb_expr.len);
    symb_expr.checkRemoveInPlace();
    try testing.expectEqual(1, symb_expr.len);
    try testing.expectEqualSlices(u8, "m", symb_expr.terms[0].symbol);
}

test "SymbolExpression appendInPlace" {
    var symb_expr: SymbolExpression = try .initFromString("m s-1");
    symb_expr.appendInPlace(SymbolTerm.initSymbol("s"));
    try testing.expectEqual(1, symb_expr.len);
    symb_expr.appendInPlace(SymbolTerm.initSymbol("s"));
    try testing.expectEqual(2, symb_expr.len);
    try testing.expectEqualSlices(u8, "s", symb_expr.terms[1].symbol);
}

test "SymbolExpression checkDuplicatesInPlace" {
    var arr: [3]SymbolTerm = .{
        SymbolTerm.initSymbol("m"),
        SymbolTerm.initSymbolInt("s", -1),
        SymbolTerm.initSymbol("m"),
    };
    var symb_expr: SymbolExpression = .init(&arr);
    try testing.expectEqual(3, symb_expr.len);
    symb_expr.checkDuplicatesInPlace();
    try testing.expectEqual(2, symb_expr.len);
    try testing.expect(symb_expr.terms[0].exponent.eqlScalar(2));
}

test "SymbolExpression invInPlace" {
    var symb_expr: SymbolExpression = try .initFromString("m2 s-3");
    symb_expr.invInPlace();
    try testing.expectEqual(2, symb_expr.len);
    try testing.expect(symb_expr.terms[0].exponent.eqlScalar(-2));
    try testing.expect(symb_expr.terms[1].exponent.eqlScalar(3));
}

test "SymbolExpression concatenateInPlace" {
    var symb_expr_1: SymbolExpression = try .initFromString("m s-1");
    const symb_expr_2: SymbolExpression = try .initFromString("s m");

    symb_expr_1.concatenateInPlace(symb_expr_2);
    try testing.expectEqual(1, symb_expr_1.len);
    try testing.expectEqualSlices(u8, "m", symb_expr_1.terms[0].symbol);
    try testing.expect(symb_expr_1.terms[0].exponent.eqlScalar(2));
}

test "SymbolExpression eql" {
    const symb_expr_1: SymbolExpression = try .initFromString("m s-1 erg2 G");
    const symb_expr_2: SymbolExpression = try .initFromString("s-1 erg2 m G");
    try testing.expect(symb_expr_1.eql(symb_expr_2));
    const symb_expr_3: SymbolExpression = try .initFromString("cm s-1 erg");
    try testing.expect(!symb_expr_1.eql(symb_expr_3));
}

test "SymbolExpression format" {
    var arr: [3]SymbolTerm = .{ SymbolTerm.initSymbol("m"), SymbolTerm.initSymbolInt("s", -2), SymbolTerm.initSymbol("kg") };
    const symb_exp_1: SymbolExpression = .init(&arr);

    var buf: [16]u8 = undefined;
    const print_res_1 = try std.fmt.bufPrint(&buf, "{f}", .{symb_exp_1});
    try testing.expectEqualSlices(u8, "m s-2 kg", print_res_1);

    const symb_exp_2: SymbolExpression = .{};
    const print_res_2 = try std.fmt.bufPrint(&buf, "{f}", .{symb_exp_2});
    try testing.expectEqualSlices(u8, "", print_res_2);
}
