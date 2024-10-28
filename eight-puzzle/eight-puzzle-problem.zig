const std = @import("std");
const assert = std.debug.assert;

const action = [4]i8{
	-1, // LEFT
	1, // RIGHT
	-3, // UP
	3, // DOWN
};

pub fn main() void {
	var curr_state: [9]u8 = [9]u8{0,1,2,3,4,5,6,7,8};
	var zero_pos: i8 = 0; // index of the [0] in curr_state
	var h: u8 = 0; // heuristic
	// NOTE: We maximize costs

	if (std.os.argv.len == 10)
		unreachable; // TODO: add cmd line support
	
	while (h != 8) {

		var n_cost: u8 = h; // costs of the next states
		var next_state: [9]u8 = curr_state;
		var highest_h_action: i8 = undefined; // the action taken on the next state with the highest heuristic

		// get the next state with the highest heuristic and it's
		// associated action.
		for (action) |ac| {
			if (!is_valid(zero_pos, ac))
				continue;
			next_state = nstate(curr_state, zero_pos, ac);
			const c = heuristic(next_state);
			if (c > n_cost) {
				n_cost = c;
				highest_h_action = ac;
			}
		}

		// change states according to the next state with the highest heuristic
		// cost
		assert(highest_h_action != undefined);
		curr_state = nstate(curr_state, zero_pos, highest_h_action);
		zero_pos += highest_h_action;
		h = n_cost;
		// NOTE: every iteration HAS to have a next state with a higher cost
	}

	std.debug.print("Final state: {any}\n", .{curr_state});
	std.debug.print("Final Cost: {}\n", .{h});
}

inline fn nstate(curr_state: [9]u8, zero_pos: i8, ac: i8) [9]u8 {
	assert(curr_state[@intCast(zero_pos)] == 0);
	assert(zero_pos + ac >= 0);

	var next_state = curr_state;

	next_state[@intCast(zero_pos)] = next_state[@intCast(zero_pos + ac)];
	next_state[@intCast(zero_pos + ac)] = 0;

	return next_state;
}

inline fn is_valid(zero_pos: i8, ac: i8) bool {
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
	const curr_state: [9]u8 = [9]i8{0,1,2,3,4,5,6,7,8};
	const other: [9]i8 = [9]i8{1,2,3,4,5,6,7,0,8};
	std.debug.print("{}\n", .{heuristic(curr_state)});
	std.debug.print("{}\n", .{heuristic(other)});
}

test "nstate" {

	var ss = nstate([9]i8{0,1,2,3,4,5,6,7,8}, 0, @intFromEnum(action.RIGHT));
	std.debug.print("RIGHT: {any}\n", .{ss});

	ss = nstate([9]i8{1,0,2,3,4,5,6,7,8}, 1, @intFromEnum(action.LEFT));
	std.debug.print("LEFT {any}\n", .{ss});

	ss = nstate([9]i8{4,1,2,3,0,5,6,7,8}, 4, @intFromEnum(action.UP));
	std.debug.print("UP: {any}\n", .{ss});

	ss = nstate([9]i8{4,1,2,3,0,5,6,7,8}, 4, @intFromEnum(action.DOWN));
	std.debug.print("DOWN: {any}\n", .{ss});
}
