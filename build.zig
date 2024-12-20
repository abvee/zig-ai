const std = @import("std");

pub fn build(b: *std.Build) void {
	const optimize = .ReleaseSafe;
	{
		const water_jug = b.addExecutable(.{
			.name = "water-jug",
			.root_source_file = b.path("water-jug/water-jug-bfs.zig"),
			.target = b.host,
			.optimize = optimize,
		});
		b.installArtifact(water_jug);
	}

	{
		const hill_climbing = b.addExecutable(.{
			.name = "hill-climbing",
			.root_source_file = b.path("hill-climbing/hill-climbing.zig"),
			.target = b.host,
			.optimize = optimize,
		});
		b.installArtifact(hill_climbing);
	}

	{
		const eight_puzzle = b.addExecutable(.{
			.name = "eight-puzzle",
			.root_source_file = b.path("eight-puzzle/eight-puzzle-problem.zig"),
			.target = b.host,
			.optimize = optimize,
		});
		b.installArtifact(eight_puzzle);
	}

	// perceptrons
	{
		const and_perceptron = b.addExecutable(.{
			.name = "and-perceptron",
			.root_source_file = b.path("perceptron/and-perceptron.zig"),
			.target = b.host,
			.optimize = optimize,
		});
		b.installArtifact(and_perceptron);

		const or_perceptron = b.addExecutable(.{
			.name = "or-perceptron",
			.root_source_file = b.path("perceptron/or-perceptron.zig"),
			.target = b.host,
			.optimize = optimize,
		});
		b.installArtifact(or_perceptron);
	}
	{
		const back_propagation = b.addExecutable(.{
			.name = "back-propagation-perception",
			.root_source_file = b.path("backprop-perceptron/backprop-perceptron.zig"),
			.target = b.host,
			.optimize = optimize,
		});
		b.installArtifact(back_propagation);
	}
}
