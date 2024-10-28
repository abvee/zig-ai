const std = @import("std");

const action = enum(i8) {
	LEFT = -1,
	RIGHT = 1,
	UP = -3,
	DOWN = 3,
};

pub fn main() void {
	const curr_state: [9]i8 = [9]i8{0,1,2,3,4,5,6,7,8};
	const zero_pos: u8 = 0; // index of the [0] in curr_state

	if (std.os.argv.len == 10)
		unreachable; // TODO: add cmd line support
	
	inline for (@typeInfo(action).Enum.fields) |ac| {

		std.debug.print("{}\n", .{ac});

		if (is_valid(zero_pos, ac.value)) {
			const next_state = nstate(curr_state, zero_pos, ac.value);
			_ = next_state;
		}
	}
}

inline fn nstate(curr_state: [9]i8, zero_pos: u8, ac: i8) [9]i8 {
	_ = zero_pos;
	_ = ac;
	return curr_state;
}

inline fn is_valid(zero_pos: u8, ac: i8) bool {
	_ = zero_pos;
	_ = ac;
	return true;
} 
