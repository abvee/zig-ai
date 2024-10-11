const std = @import("std");
const stdout = std.getStdOut().writer();

const alpha: f32 = 1; // learning rate
const y_actual: f32 = 0.5; // actual output

const x: f32 = 0.35;
const y: f32 = 0.9;

const hnode = struct { // hidden node
	x1: * const f32, // input
	w1: f32,

	x2: * const f32, // input
	w2: f32,
};

// our hidden layer nodes:
var h1: hnode = hnode{
	.x1 = &x,
	.x2 = &y,
	.w1 = 0.1,
	.w2 = 0.8,
};

var h2: hnode = hnode {
	.x1 = &x,
	.x2 = &y,
	.w1 = 0.4,
	.w2 = 0.6,
};

// output nodes
const onode = struct {
	y1: f32,
	w1: f32,
	y2: f32,
	w2: f32,
};

var output: onode = onode{
	.y1 = undefined,
	.w1 = 0.3,
	.y2 = undefined,
	.w2 = 0.9,
};

pub fn main() !void {
	// std.debug.print("{}\n", .{h1.x1.*});
	var y_neural: f32 = undefined; // output of the neural net

	var epoch: u8 = 0;
	while (epoch < 255) : (epoch += 1) {
		// forward propogation
		// the inputs y1 and y2 are the outputs of the 2 hidden nodes
		output.y1 = sigmoid(net_input(h1.x1.*, h1.w1, h1.x2.*, h1.w2));
		output.y2 = sigmoid(net_input(h2.x1.*, h2.w1, h2.x2.*, h2.w2));

		y_neural = sigmoid(net_input(output.y1, output.w1, output.y2, output.w2));

		const e_value: f32 = y_neural - y_actual;
		if (e_value == 0) break;

		// 0 - output del, 1 - h1, 2 - h2
		var del_out: [3]f32 = [_]f32{0} ** 3;
		del_out[0] = y_neural * (1 - y_neural) * e_value;
		del_out[1] = output.y1 * (1 - output.y1) * del_out[0];
		del_out[2] = output.y2 * (1 - output.y2) * del_out[0];

		// change weights
		output.w1 += alpha * del_out[0] * output.y1;
		output.w2 += alpha * del_out[0] * output.y2;
		h1.w1 += alpha * del_out[1] * h1.x1.*;
		h1.w2 += alpha * del_out[1] * h1.x2.*;
		h2.w1 += alpha * del_out[1] * h2.x1.*;
		h2.w2 += alpha * del_out[1] * h2.x2.*;
	}
}

inline fn net_input(x1: f32, w1: f32, x2: f32, w2: f32) f32 {
	return x1 * w1 + x2 * w2;
}

const e: f32 = 2.71;
inline fn sigmoid(i: f32) f32 {
	return 1 / (1 + std.math.pow(f32, e, -i));
}
