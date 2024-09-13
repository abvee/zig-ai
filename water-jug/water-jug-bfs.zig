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

pub fn main() !void {
	if (std.os.argv.len < 3) return ArgErrors.NotEnoughArguments;

	a_max = patoi(u8, std.os.argv[1]);
	b_max = patoi(u8, std.os.argv[2]);

	const state_end: state = state{.a = 4, .b = 0};
	var state_curr: state = state{.a = 0, .b = 0};
	state_curr.a += 1;
	_ = state_end;

	// BFS starts
	// @compileLog(@typeInfo(action));
	// @compileLog(@typeInfo(action).Enum);
	inline for (@typeInfo(action).Enum.fields) |ac| {
		print("{s}: {d}\n", .{ac.name, ac.value});
	}
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
