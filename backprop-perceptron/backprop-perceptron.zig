const std = @import("std");

const alpha: f32 = 1; // learning rate
const y_actual: f32 = 0.5; // actual output

const x1: f32 = 0.35;
const x2: f32 = 0.9;

const hnode = struct { // hidden node
	x1: * const f32, // input
	w1: f32,

	x2: * const f32, // input
	w2: f32,
};

// our hidden layer nodes:
var h1: hnode = hnode{
	.x1 = &x1,
	.x2 = &x2,
	.w1 = 0.1,
	.w2 = 0.8,
};

var h2: hnode = hnode {
	.x1 = &x1,
	.x2 = &x2,
	.w1 = 0.1,
	.w2 = 0.8,
};

pub fn main() !void {
	std.debug.print("{}\n", .{h1.x1.*});
}
