const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "vulkan-version",
        .root_source_file = b.path("src/main.zig"),
        .target = b.host,
    });

    exe.linkSystemLibrary("vulkan");
    exe.linkLibC();

    b.installArtifact(exe);
}
