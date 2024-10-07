const state = @import("water-jug-bfs.zig").state;
const std = @import("std");
const print = std.debug.print;
const stdout = std.io.getStdOut().writer();

// queue stuff
const MAX = 100;
var queue: [MAX]state = [_]state{state{.a = 0, .b = 0}} ** MAX;
var front: usize = queue.len;
var rear: usize = 0;
const QueueError: type = error{QueueEmpty, QueueFull};

pub fn enqueue(x: state) QueueError!void {
	if (rear == front) return QueueError.QueueFull;

	if (front == queue.len) front = 0;
	queue[rear] = x;
	rear = (rear + 1) % queue.len;
}

pub fn pop() QueueError!state {
	if (front == queue.len) return QueueError.QueueFull;

	const ret = queue[front];

	if ((front + 1) % queue.len == rear) {
		rear = 0;
		front = queue.len;
	} else front = (front + 1) % queue.len;

	return ret;
}

inline fn print_queue() void {
	for (queue) |i|
		stdout.print("(a:{},b:{}) ", .{i.a, i.b}) catch {};
	stdout.print("f: {} r: {}\n", .{front, rear}) catch {};
}

test "Queue overflow" {
	// You need to have a capture group ??
	for (0..MAX) |_| {
		try enqueue(state{.a = 9, .b = 9});
		print_queue();
	}
	enqueue(state{.a = 9, .b = 9}) catch |err|
		std.debug.print("Error: {}", .{err});
}

test "Queue underflow" {
	for (0..MAX) |_| {
		_ = try pop();
		print_queue();
	}
	_ = pop() catch |err|
		std.debug.print("Error: {}", .{err});
}
