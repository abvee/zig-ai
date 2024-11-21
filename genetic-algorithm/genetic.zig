const std = @import("std");
const stdout = std.io.getStdOut().writer();

inline fn fitness(x: u32) u32 { return x * x; }

const LEN = 4;

pub fn main() void {
	// Initialise initial population values

	const population: [LEN]u5 = [_]u5{
		0b01100,
		0b11001,
		0b00101,
		0b10011,
	}; // hardcoded initial population

	// fitness values
	var fit: [LEN]u32 = [_]u32{0} ** LEN;
	var fit_sum: u32 = 0;
	for (&fit, population) |*f, p| {
		f.* = fitness(p);
		fit_sum += f.*;
	}
	const fit_average: f32 = @as(f32, @floatFromInt(fit_sum)) / LEN;
	std.debug.print("{d:.3}\n", .{fit_average});

	// probabilities
	var probability: [LEN]f32 = [_]f32{0} ** LEN;
	for (fit, &probability) |f, *p| {
		p.* = @as(f32, @floatFromInt(f)) / @as(f32, @floatFromInt(fit_sum));
		std.debug.print("{d:.3}\n", .{p.*});
	}

	// expected count
	var expected: [LEN]f32 = [_]f32{0} ** LEN;
	for (fit, &expected) |f, *e| {
		e.* = @as(f32, @floatFromInt(f)) / fit_average;
	}
}
