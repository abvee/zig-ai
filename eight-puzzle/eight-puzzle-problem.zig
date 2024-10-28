const std = @import("std");
const assert = std.debug.assert;

// The number of tiles in the right position is the heuristic. Thus we maximize
// heuristics in this program.

const action = enum(i8){
	LEFT = -1,
	RIGHT = 1,
	UP = -3,
	DOWN = 3,
};

const all_actions: [4]action = .{
	.LEFT,
	.RIGHT,
	.UP,
	.DOWN,
};

pub fn main() void {
	var curr_state: [9]u8 = [9]u8{0,1,2,3,4,5,6,7,8};
	var zero_pos: i8 = 0; // index of the [0] in curr_state
	var h: u8 = 0; // current state heuristic

	if (std.os.argv.len == 10)
		unreachable; // TODO: add cmd line support
	
	while (h != 8) {

		var n_cost: u8 = h; // heuristics of the next states
		var next_state: [9]u8 = curr_state;
		var highest_h_action: action = undefined; // the action taken on the next state with the highest heuristic

		// get the next state with the highest heuristic and it's
		// associated action.
		for (all_actions) |ac| {
			if (!is_valid(zero_pos, ac))
				continue;
			next_state = nstate(curr_state, zero_pos, ac);
			const c = heuristic(next_state);
			if (c > n_cost) {
				n_cost = c;
				highest_h_action = ac;
			}
		}

		// change states to the next state with the highest heuristic.
		assert(highest_h_action != undefined);
		curr_state = nstate(curr_state, zero_pos, highest_h_action);
		zero_pos += @intFromEnum(highest_h_action);
		h = n_cost;
		// NOTE: every iteration HAS to have a next state with a higher cost
	}

	std.debug.print("Final state: {any}\n", .{curr_state});
	std.debug.print("Final Cost: {}\n", .{h});
}

inline fn nstate(curr_state: [9]u8, zero_pos: i8, ac_enum: action) [9]u8 {
	const ac = @intFromEnum(ac_enum);

	assert(curr_state[@intCast(zero_pos)] == 0);
	assert(zero_pos + ac >= 0);

	var next_state = curr_state;

	next_state[@intCast(zero_pos)] = next_state[@intCast(zero_pos + ac)];
	next_state[@intCast(zero_pos + ac)] = 0;

	return next_state;
}

inline fn is_valid(zero_pos: i8, ac_enum: action) bool {
	const ac = @intFromEnum(ac_enum);

	if (zero_pos + ac > 8 or zero_pos + ac < 0)
		return false;
	return true;
} 

inline fn heuristic(curr_state: [9]u8) u8 {
	var ret: u8 = 0;
	for (curr_state, 1..) |c, i|
		if (c == i)
			{ret += 1;};

	return ret;
}

test "cost" {
	const curr_state: [9]u8 = [9]u8{0,1,2,3,4,5,6,7,8};
	const other: [9]u8 = [9]u8{1,2,3,4,5,6,7,0,8};
	std.debug.print("{}\n", .{heuristic(curr_state)});
	std.debug.print("{}\n", .{heuristic(other)});
}

test "nstate" {
	var ss = nstate([9]u8{1,0,2,3,4,5,6,7,8}, 1, action[0]);
	std.debug.print("LEFT: {any}\n", .{ss});

	ss = nstate([9]u8{0,1,2,3,4,5,6,7,8}, 0, action[1]);
	std.debug.print("RIGHT: {any}\n", .{ss});

	ss = nstate([9]u8{4,1,2,3,0,5,6,7,8}, 4, action[2]);
	std.debug.print("UP: {any}\n", .{ss});

	ss = nstate([9]u8{4,1,2,3,0,5,6,7,8}, 4, action[3]);
	std.debug.print("DOWN: {any}\n", .{ss});
}
