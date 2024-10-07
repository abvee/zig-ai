// Generate valid graphs
const std = @import("std");
const rand = std.crypto.random;
const assert = std.debug.assert;

// Generates an undirected, no weight graph's adjacency matrix
pub fn undirected_nw_graph(allocator: std.mem.Allocator, n: u8) ![][]bool {

	// allocate nxn adjacency matrix
	var graph: [][]bool = try allocator.alloc([]bool, n);
	for (0..n) |i|
		graph[i] = try allocator.alloc(bool, n);

	// Assign random values to graph
	var j: u8 = 0;
	for (0..n) |i| {
		j = 0;

		// fill in connections that have already been determined
		while (j < i) : (j += 1)
			graph[i][j] = graph[j][i];

		// Make sure node is not adjascent to itself
		assert(j == i);
		graph[i][j] = false;
		j += 1;

		while (j < n) : (j += 1)
			graph[i][j] = rand.boolean();
	}
	return graph;
}

test "undirected, no weight graph" {
	var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
	const allocator = arena.allocator();
	defer arena.deinit();

	const graph = try undirected_nw_graph(allocator, 8);

	// print graph
	for (0..8) |i|
		std.debug.print("\t{}", .{i});
	std.debug.print("\n", .{});

	for (graph, 0..) |node, p| {
		std.debug.print("{}:", .{p});
		for (node) |i|
			std.debug.print("\t{}", .{i});
		std.debug.print("\n", .{});
	}
}
