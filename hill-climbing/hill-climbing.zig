const std = @import("std");
const rand = std.crypto.random;
const stdout = std.io.getStdOut().writer();

const default_len = 20;
const steepest_ascent_jump = 5;

pub fn main() !void {
	var default_arr: [default_len]u8 = [_]u8{0} ** default_len;
	var arr: []u8 = undefined;

	// Allocator
	var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
	defer arena.deinit();
	const allocator = arena.allocator();

	if (std.os.argv.len < 5) {
		try stdout.print("Not enough arguments passed, using default array\n", .{});
		arr = &default_arr;
		rand_array(arr);
	} else {
		arr = try allocator.alloc(u8, std.os.argv.len);
		// put elements of argv into arr
		for (std.os.argv[1..], 0..) |str, i|
			arr[i] = patoi(str);
	}

	// Hill climbing

	try stdout.print("\nFull array:\n", .{});
	for (arr) |i| try stdout.print("{} ", .{i});
	try stdout.print("\n", .{});

	var current: u8 = 0;
	try stdout.print("\nSimple Hill Climbing maxima (local) is at: {}({})\n", .{
		blk:{current = simple_hc(arr); break :blk current;},
		arr[current],
	});

	try stdout.print("Steepest Ascent Hill Climbing maxima (local) is at: {}({})\n", .{
		blk:{current = steepest_ascent_hc(arr, steepest_ascent_jump); break :blk current;},
		arr[current],
	});
	// Place holder
	print_graph(arr, 0);
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

test "+ve atoi" {
	try stdout.print("{}\n",.{patoi(std.os.argv[1])});
}

// TODO: plot a graph to show local maxima
inline fn print_graph(arr: []u8, maxima: u8) void {
	_ = arr;
	_ = maxima;
}

// Simple hill climbing
fn simple_hc(arr: []u8) u8 {
	var ret: u8 = 0;
	while (ret < arr.len - 1 and arr[ret] < arr[ret + 1]) : (ret += 1) {}
	return ret;
}

fn steepest_ascent_hc(arr: []u8, jump: u8) u8 {
	var ret: u8 = 0;
	var i: u8 = 0; // index

	while (ret < arr.len - 1) : (ret = i) {
		i = ret+1;
		while (i < arr.len - 1 and i < ret+jump) : (i += 1)
			if (arr[i] > arr[ret])
				break;

		if (arr[ret] > arr[i]) return ret
		else {ret = i;}
	 }
	 return ret;
}
