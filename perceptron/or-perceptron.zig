const std = @import("std");
const stdout = std.io.getStdOut().writer();

const alpha: i32 = 1;
var b: i32 = 1; // bias

// inputs
const x1: [2]i32 = [_]i32{1,-1};
const x2: [2]i32 = [_]i32{1,-1};

const threshold = enum(i32) { THETHA = 0 };

const TETHA: i32 = 0.0;

pub fn main() !void {
	var epoch: u8 = 0;
	var w: [2]i32 = .{0,0};
	var yin: i32 = undefined;

	stdout.print("Inputs\t\tNet\tOutput\tTarget\tWeight changes\tWeights\n", .{}) catch {};
	while (true) {

		stdout.print("Epoch {}\n", .{epoch}) catch {};

		var zero_counter: u8 = 0; // number of no weight changes
		for (x1) |p| {
			for (x2) |q| {

				stdout.print("{:>2} {:>2} ({:>2})\t{:>2}\t", .{
					p, q, b, activation_func(p, w[0], q, w[1], b)
				}) catch {};

				if (activation_func(p, w[0], q, w[1], b) > TETHA)
					yin = 1
				else if (activation_func(p, w[0], q, w[1], b) < TETHA)
					yin = -1
				else
					yin = 0;

				const or_gate = if (p == 1 and q == 1) 1 else -1 * p * q;

				stdout.print("{:>2}\t{:>2}\t", .{yin, or_gate}) catch {};
				if (yin != or_gate) {
					w[0] += alpha * or_gate * p;
					w[1] += alpha * or_gate * q;
					b += alpha * p * q;
				}
				else zero_counter += 1;

				stdout.print("{:>2} {:>2} {:>2}\t", .{
					alpha * or_gate * p,
					alpha * or_gate * q,
					alpha * p * q
				}) catch {};

				stdout.print("{:>2} {:>2} ({:>2})\t\n", .{
					w[0],
					w[1],
					b,
				}) catch {};
			}
		}
		epoch += 1;
		if (zero_counter == 3) break;
	}
}

inline fn activation_func(x: i32, w1: i32, y: i32, w2: i32, bias: i32) i32 {
	return bias + x * w1 + y * w2;
}
