const std = @import("std");
const print = std.debug.print;

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
var a_max: u8 = undefined;
var b_max: u8 = undefined;

// queue stuff
const enqueue = @import("queue.zig").enqueue;
const pop = @import("queue.zig").pop;

// visited

// check if the state has been visited
inline fn state_visited(c: state) bool {
	_ = c;
	return true;
}

pub fn main() !void {
	if (std.os.argv.len < 3) return ArgErrors.NotEnoughArguments;

	a_max = patoi(u8, std.os.argv[1]);
	b_max = patoi(u8, std.os.argv[2]);

	const end_state: state = state{.a = 4, .b = 0};
	var curr_state: state = state{.a = 0, .b = 0};
	curr_state.a += 1;
	_ = end_state;

	// BFS starts
	// @compileLog(@typeInfo(action));
	// @compileLog(@typeInfo(action).Enum);
	var next_state: state = undefined;
	while (curr_state.a != end_state.a and curr_state.b != end_state.b) {
		visited[curr_state.a][curr_state.b] = true;

		inline for (@typeInfo(action).Enum.fields) |ac| {
			next_state = next_state(curr_state, ac);
			if (!state_visited(next_state))
				enqueue(next_state);
		}

		curr_state = pop() catch break; // break if we finish the queue
	}

	if (curr_state.a != end_state.a and curr_state.b != end_state.b)
		print("Found end state:")
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
	switch (ac) {
		.FillA => curr.a = a_max,
		.FillB => curr.b = b_max,
		.FillAwithB => {
			curr.a += curr.b;
			if (curr.a - a_max < 0)
				curr.b = 0
			else {
				curr.b = if (curr.a - a_max > b_max) b_max else curr.a - a_max;
				curr.a = a_max;
			}
		},
		.FillBwithA => {
			curr.b += curr.a;
			if (curr.b - b_max < 0)
				curr.a = 0
			else {
				curr.a = if (curr.b - b_max > a_max) a_max else curr.b - b_max;
				curr.b = b_max;
			}
		},
		.EmptyA => curr.a = 0,
		.EmptyB => curr.b = 0,
	}
	return curr;
}
