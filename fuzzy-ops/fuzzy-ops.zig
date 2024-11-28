const std = @import("std");
const stdout = std.io.getStdOut().writer();

const float = f32;
const LEN = 5;

pub fn main() void {
	const a: [LEN]u8 = [LEN]u8{10, 20, 30, 40, 50};
	var mu_a: [LEN]float = [_]float{0} ** LEN;
	const b: [LEN]u8 = [LEN]u8{10, 20, 30, 40, 50};
	var mu_b: [LEN]float = [_]float{0} ** LEN;

	// calculate mu values
	for (a, b, &mu_a, &mu_b) |element_a, element_b, *ma, *mb| {
		ma.* = membership_a(@floatFromInt(element_a));
		mb.* = membership_b(@floatFromInt(element_b));
	}

	// Fuzzy union of the sets
	stdout.print("Fuzzy Union\n", .{}) catch {};
	for (fuzzy_union(mu_a, mu_b)) |x|
		stdout.print("{d:.3} ", .{x}) catch {};
	stdout.print("\n\n", .{}) catch {};

	// Fuzzy intersection
	stdout.print("Fuzzy Intersection\n", .{}) catch {};
	for (fuzzy_intersection(mu_a, mu_b)) |x|
		stdout.print("{d:.3} ", .{x}) catch {};
	stdout.print("\n\n", .{}) catch {};

	// Fuzzy complements
	stdout.print("Fuzzy Complements\n", .{}) catch {};
	for (fuzzy_complement(mu_a)) |x|
		stdout.print("{d:.3} ", .{x}) catch {};
	stdout.print("\n", .{}) catch {};
	for (fuzzy_complement(mu_a)) |x|
		stdout.print("{d:.3} ", .{x}) catch {};
	stdout.print("\n", .{}) catch {};
}

inline fn membership_a(x: float) float {
	return x / (x + 2);
}

inline fn membership_b(x: float) float {
	return (x - 5) / (x + 5);
}

fn fuzzy_union(mu_a: [LEN]float, mu_b: [LEN]float) [LEN]float {
	var ret: [LEN]float = [_]float{0} ** LEN;

	for (mu_a, mu_b, &ret) |a, b, *r| {
		r.* = b;
		if (a > b)
			r.* = a;
	}
	return ret;
}

fn fuzzy_intersection(mu_a: [LEN]float, mu_b: [LEN]float) [LEN]float {
	var ret: [LEN]float = [_]float{0} ** LEN;

	for (mu_a, mu_b, &ret) |a, b, *r| {
		r.* = b;
		if (a < b)
			r.* = a;
	}
	return ret;
}

fn fuzzy_complement(mu: [LEN]float) [LEN]float {
	var ret: [LEN]float = [_]float{0} ** LEN;

	for (mu, &ret) |a, *r| {
		r.* = 1 - a;
	}
	return ret;
}
