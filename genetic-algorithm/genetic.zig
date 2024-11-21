const std = @import("std");
const stdout = std.io.getStdOut().writer();

inline fn fitness(x: u32) u32 { return x * x; }

const LEN = 4;
const EPOCHS = 10;

var population: [LEN]u5 = [_]u5{
	0b01100,
	0b11001,
	0b00101,
	0b10011,
}; // hardcoded initial population

// calculate fitness values for population and return them
inline fn fitness_calc(fit_sum: *u32) [LEN]u32 {
	var ret: [LEN]u32 = [_]u32{0} ** LEN;
	fit_sum.* = 0;
	for (&ret, population) |*r, p| {
		r.* = fitness(p);
		fit_sum.* += r.*;
	}
	return ret;
}
test "fitness_calc" {
	var fit_sum: u32 = 0;
	const fit: [LEN]u32 = fitness_calc(&fit_sum);
	std.debug.print("{any}\n", .{fit});
	std.debug.print("{any}\n", .{fit_sum});
}

// probabilities for values in population and return them
inline fn probabilities(fit: [LEN]u32, fit_sum: u32) [LEN]f32 {
	var probability: [LEN]f32 = [_]f32{0} ** LEN;
	for (fit, &probability) |f, *p| {
		p.* = @as(f32, @floatFromInt(f)) / @as(f32, @floatFromInt(fit_sum));
	}
	return probability;
}

// expected count for values in population and return them
inline fn expected_count(fit: [LEN]u32, fit_average: f32) [LEN]f32 {
	var expected: [LEN]f32 = [_]f32{0} ** LEN;
	for (fit, &expected) |f, *e| {
		e.* = @as(f32, @floatFromInt(f)) / fit_average;
	}
	return expected;
}

pub fn main() void {
	// Initialise initial values
	// fitness values
	var fit_sum: u32 = 0;
	var fit: [LEN]u32 = fitness_calc(&fit_sum); // fitness
	var fit_average: f32 = @as(f32, @floatFromInt(fit_sum)) / LEN;

	// probabilities
	var probability: [LEN]f32 = [_]f32{0} ** LEN;
	probability = probabilities(fit, fit_sum);

	// expected
	const expected: [LEN]f32 = expected_count(fit, fit_average);
	_ = expected;

	// run for specified number of epochs
	for (0..EPOCHS) |_| {
		// perform mating
		population = mating();

		// perform mutation
		population = mutation();

		// recalculate fitness values
		fit = fitness_calc(&fit_sum);
		fit_average = @as(f32, @floatFromInt(fit_sum)) / LEN;
	}
}

// return popluation after mating
fn mating() [LEN]u5 {
	var ret: [LEN]u5 = population; // return population

	// hardcoded cross over - one is 4, the other is 2
	var first_mask: u5 = 0b00001;
	var second_mask: u5 = 0b00011;

	// first section
	for (ret[0..LEN / 2]) |*r| {
		const mut = (~(r.* & first_mask))&first_mask;
		r.* &= ~first_mask;
		r.* += mut;
	}

	// second section
	for (ret[(LEN / 2) + 1..LEN]) |*r| {
		const mut = (~(r.* & second_mask))&second_mask;
		r.* &= ~second_mask;
		r.* += mut;
	}
	first_mask += 1;
	second_mask += 1;
	return ret;
}
test "mating" {
	const p = mating();
	std.debug.print("{any}\n", .{population});
	std.debug.print("{any}\n", .{p});
}

const rand = std.crypto.random;
// return population mutation
fn mutation() [LEN]u5 {
	var ret: [LEN]u5 = population; // return population
	for (&ret) |*r| {
		const seed = rand.int(u5); // generate random mutation value
		r.* ^= seed;
	}
	return ret;
}
test "mutation" {
	std.debug.print("MUTATION\n", .{});
	const p = mutation();
	std.debug.print("{any}\n", .{population});
	std.debug.print("{any}\n", .{p});
}
