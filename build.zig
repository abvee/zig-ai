const std = @import("std");

pub fn build(b: *std.Build) void {
	const optimize = .ReleaseSafe;

	{
		const random_graph = b.addExecutable(.{
			.name = "random-graph",
			.root_source_file = b.path("random-graph.zig"),
			.target = b.host,
			.optimize = optimize,
		});
		b.installArtifact(random_graph);
	}

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
}
