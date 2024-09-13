// Generate a random, valid adjacency matrix for a graph.
const std = @import("std");
const print = std.debug.print;
const rand = std.crypto.random;
const assert = std.debug.assert;

const ArgErrors = error{NotEnoughArguments};

pub fn main() !void {
	if (std.os.argv.len < 2) return error.NotEnoughArguments;
	// number of nodes, has to be under 10
	const n: u8 = patoi(u8, std.os.argv[1]);
	const tabs: [*:0]const u8 = no_tabs(n);

	// allocate graph
	var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator); 
	defer arena.deinit();
	const allocator = arena.allocator();

	var graph: [][]bool = try allocator.alloc([]bool, n);
	for (0..n) |i|
		graph[i] = try allocator.alloc(bool, n);

	// Assign random values to graph
	var j: u8 = 0;
	for (0..n) |i| {
		j = 0;
		while (j < i) : (j += 1)
			graph[i][j] = graph[j][i];

		// assert(j == i); // Make sure node is not adjascent to itself
		graph[i][j] = false;

		j += 1;
		// assert(j == i+1);

		while (j < n) : (j += 1)
			graph[i][j] = rand.boolean();
	}

	// print graph
	print("\t", .{});
	for (0..n) |i|
		print("{}{s}", .{i, tabs});
	print("\n", .{});

	for (graph, 0..) |node, p| {
		print("{}\t", .{p});
		for (node) |i|
			print("{}{s}", .{i, tabs});
		print("\n", .{});
	}
}

fn patoi(comptime T: type, n: [*:0]T) T {
	var ret: T = 0;
	var i: u8 = 0;

	if (n[i] == '-') i+=1;
	while (n[i] != 0) : (i += 1) {
		ret *= 10;
		ret = ret + (n[i] - '0');
	}
	return ret;
}

// number of tabs
fn no_tabs(n: u8) [*:0]const u8 {
	if (n > 10)
		return "\t\t"
	else return "\t";
}
