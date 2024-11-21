const std = @import("std");
const stdout = std.io.getStdOut().writer();

inline fn fitness(x: u32) u32 { return x * x; }

const LEN = 4;
var population: [LEN]u5 = [_]u5{
	0b01100,
	0b11001,
	0b00101,
	0b10011,
}; // hardcoded initial population

pub fn main() void {
	// Initialise initial values
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

// return popluation after changing it
fn mating() [LEN]u5 {
	var ret: [LEN]u5 = population; // return population

	// hardcoded cross over - one is 4, the other is 2
	_ = enum {FIRST = 4, SECOND = 2};
	const first_zero_mask = 0b0 << .FIRST;
	const second_zero_mask = 0b0 << .SECOND;

	const first_clear_mask = 0b01111;
	const second_clear_mask = 0b00011;

	// first section
	for (&ret[0..LEN / 2]) |*r| {
		const mutation = ~(r.*|first_clear_mask)|first_clear_mask;
		r.* |= first_clear_mask;
		r.* += mutation;
	}

	// second section
	for (&ret[(LEN / 2) + 1..LEN]) |*r| {
		const mutation = ~(r.*|second_clear_mask)|second_clear_mask;
		r.* |= second_clear_mask;
		r.* += mutation;
	}

	return ret;
}
