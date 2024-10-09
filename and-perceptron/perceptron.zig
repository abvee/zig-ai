const std = @import("std");
const stdout = std.io.getStdOut().writer();

const alpha: i32 = 1;
var b: i32 = 1; // bias

// inputs
const x1: [2]i32 = [_]i32{-1,1};
const x2: [2]i32 = [_]i32{-1,1};

const threshold = enum(i32) { THETHA = 0 };

const TETHA: i32 = 0.0;

pub fn main() !void {
	var epoch: u8 = 0;
	var w: [2]i32 = .{0,0};

	var yin: i32 = undefined;
	while (true) {

		var zero_counter: u8 = 0; // number of no weight changes
		for (x1) |p| {
			for (x2) |q| {

				if (activation_func(p, w[0], q, w[1], b) > TETHA)
					yin = 1
				else if (activation_func(p, w[0], q, w[1], b) < TETHA)
					yin = -1
				else
					yin = 0;

				const and_gate = if (p == -1 and q == -1) -1 else p * q;
				if (yin != p * q) {
					w[0] += alpha * and_gate * p;
					w[1] += alpha * and_gate * q;
					b += alpha * p * q;
				}
				else zero_counter += 1;
			}
		}
		epoch += 1;
		if (zero_counter == 3) break;
		std.debug.print("zero_counter: {} ", .{zero_counter});
		std.debug.print("w1: {} w2: {}\n", .{w[0], w[1]});
	}

	try stdout.print("Weights:\n", .{});
	try stdout.print("w1: {}\tw2: {}\tb: {}\n", .{w[0], w[1], b});
}

inline fn activation_func(x: i32, w1: i32, y: i32, w2: i32, bias: i32) i32 {
	return bias + x * w1 + y * w2;
}
