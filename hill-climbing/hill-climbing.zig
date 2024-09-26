const std = @import("std");
const rand = std.crypto.random;
const print = std.debug.print;

const default_len = 20;

pub fn main() !void {
	var default_arr: [default_len]u8 = [_]u8{0} ** default_len;
	var arr: []u8 = undefined;

	// Allocator
	var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
	defer arena.deinit();
	const allocator = arena.allocator();

	if (std.os.argv.len < 5) {
		print("Not enough arguments passed, using default array\n", .{});
		arr = &default_arr;
		rand_array(arr);
	} else {
		arr = try allocator.alloc(u8, std.os.argv.len);
		// put elements of argv into arr
		for (std.os.argv, 0..) |str, i|
			arr[i] = patoi(str);
	}

	// Hill climbing
	var current: u8 = 0;
	while (current < arr.len - 1 and arr[current] < arr[current + 1]) : (current += 1) {}

	print("The maxima (local) is: {}\n", .{arr[current]});
	print("Full array:\n", .{});
	for (arr) |i| print("{} ", .{i});
	print("\n", .{});

	print_graph(arr, current);
}

// randomise all elements in the input array
fn rand_array(in: []u8) void {
	for (in) |*i|
		i.* = rand.int(u8);
}

fn patoi(str: [*:0]u8) u8 {
	var i: u8 = 0; // str index

	while (str[i] == ' ' or str[i] == '\t') : (i += 1) {}

	if (str[i] == '-') i += 1;

	var ret: u8 = 0;
	while (str[i] != 0) : (i += 1) {
		ret *= 10;
		ret += str[i] - '0';
	}

	return ret;
}

// TODO: plot a graph to show local maxima
fn print_graph(arr: []u8, maxima: u8) void {
	_ = arr;
	_ = maxima;
}
