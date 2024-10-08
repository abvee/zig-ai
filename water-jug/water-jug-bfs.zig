const std = @import("std");
const stdout = std.io.getStdOut().writer();
const assert = std.debug.assert;

const ArgErrors = error{NotEnoughArguments};

// a state space
pub const state = struct {
	a:u8,
	b:u8,
};

// All actions
const action = enum(u8) {
	FillA,
	FillB,
	FillAwithB,
	FillBwithA,
	EmptyA,
	EmptyB,
};

// max values of jugs
var a_max: i32 = undefined;
var b_max: i32 = undefined;

// queue stuff
const enqueue = @import("queue.zig").enqueue;
const pop = @import("queue.zig").pop;

// visited
var visited: [][]bool = undefined;

inline fn state_visited(c: state) bool {
	return visited[c.a][c.b];
}

pub fn main() !void {
	if (std.os.argv.len < 3) return ArgErrors.NotEnoughArguments;

	// get max values for jugs
	a_max = patoi(u8, std.os.argv[1]);
	b_max = patoi(u8, std.os.argv[2]);

	// visited hash map
	var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator); 
	defer arena.deinit();
	const allocator = arena.allocator();

	visited = try allocator.alloc([]bool, @intCast(a_max + 1));
	for (visited) |*v| {
		v.* = try allocator.alloc(bool, @intCast(b_max + 1));
		for (v.*) |*x| x.* = false;
	}

	const end_state: state = state{.a = 4, .b = 0};
	var curr_state: state = state{.a = 0, .b = 0};
	curr_state.a += 1;

	// BFS starts
	var state_next: state = undefined;
	// assert((curr_state.a != end_state.a) and (curr_state.b != end_state.b));
	while (curr_state.a != end_state.a or curr_state.b != end_state.b) {

		visited[curr_state.a][curr_state.b] = true;

		// @compileLog(@typeInfo(action).Enum);
		inline for (@typeInfo(action).Enum.fields) |ac| {
			state_next = next_state(curr_state, @enumFromInt(ac.value));
			try if (!state_visited(state_next))
				enqueue(state_next); // queue should never be full
		}

		curr_state = pop() catch break; // break if we finish the queue
	}

	if (curr_state.a != end_state.a and curr_state.b != end_state.b)
		try stdout.print("No end state found\n", .{})
	else
		try stdout.print("End state found a:{} b:{}\n", .{curr_state.a, curr_state.b});
}

fn patoi(comptime T: type, s: [*:0]u8) T {
	var ret: T = 0;
	var i: u8 = 0;

	if (s[i] == '-') i += 1;
	while (s[i] > 0) : (i += 1) {
		ret *= 10;
		ret += s[i] - '0';
	}
	return ret;
}

// get the next state given the action and the current state
fn next_state(curr: state, ac: action) state {
	var ret: state = curr;
	const a_max_cast: u8 = @intCast(a_max);
	const b_max_cast: u8 = @intCast(b_max);
	switch (ac) {
		.FillA => ret.a = a_max_cast,
		.FillB => ret.b = b_max_cast,
		.FillAwithB => {
			ret.a += ret.b;
			if (ret.a - a_max < 0)
				ret.b = 0
			else {
				ret.b = @intCast(if (ret.a - a_max > b_max) b_max else ret.a - a_max);
				ret.a = a_max_cast;
			}
		},
		.FillBwithA => {
			ret.b += ret.a;
			if (ret.b - b_max < 0)
				ret.a = 0
			else {
				ret.a = @intCast(if (ret.b - b_max > a_max) a_max else ret.b - b_max);
				ret.b = b_max_cast;
			}
		},
		.EmptyA => ret.a = 0,
		.EmptyB => ret.b = 0,
	}
	return ret;
}
