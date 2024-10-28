const std = @import("std");
const assert = std.debug.assert;

const action = enum(i8) {
	LEFT = -1,
	RIGHT = 1,
	UP = -3,
	DOWN = 3,
};

pub fn main() void {
	var curr_state: [9]i8 = [9]i8{0,1,2,3,4,5,6,7,8};
	var zero_pos: i8 = 0; // index of the [0] in curr_state
	var h: u8 = 0; // heuristic
	// NOTE: We maximize costs

	if (std.os.argv.len == 10)
		unreachable; // TODO: add cmd line support
	
	while (h != 8) {
		inline for (@typeInfo(action).Enum.fields) |ac| {
			const next_state = if (is_valid(zero_pos, ac.value))
				nstate(curr_state, zero_pos, ac.value)
				else curr_state;
			const n_cost = cost(next_state);
			if (n_cost > h) {
				h = n_cost;
				curr_state = next_state;
				zero_pos += ac.value;
			}
		}
	}

	std.debug.print("Final state: {any}\n", .{curr_state});
	std.debug.print("Final Cost: {}\n", .{h});
}

inline fn nstate(curr_state: [9]i8, zero_pos: i8, ac: i8) [9]i8 {
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

inline fn cost(curr_state: [9]i8) u8 {
	var ret: u8 = 0;
	for (curr_state, 1..) |c, i|
		if (c == i)
			{ret += 1;};

	return ret;
}

test "cost" {
	const curr_state: [9]i8 = [9]i8{0,1,2,3,4,5,6,7,8};
	const other: [9]i8 = [9]i8{1,2,3,4,5,6,7,0,8};
	std.debug.print("{}\n", .{cost(curr_state)});
	std.debug.print("{}\n", .{cost(other)});
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
