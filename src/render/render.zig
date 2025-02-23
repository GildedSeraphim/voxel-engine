const std = @import("std");
const vk = @import("vulkan.zig");
const window = @import("window.zig");
const Allocator = std.mem.Allocator;

const Renderer = @This();

instance: vk.Instance,

pub fn initVulkan() !Renderer {
    const instance = try vk.Instance.createInstance();

    return Renderer{
        .instance = instance,
    };
}

pub fn destroy(self: Renderer) void {
    self.instance.destroy();
}
