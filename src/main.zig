const std = @import("std");
const c = @import("clibs.zig");
const window = @import("render/window.zig");
const math = @import("math.zig");
const vk = @import("render/vulkan.zig");
const render = @import("render/render.zig");

pub const window_width: usize = 800;
pub const window_height: usize = 600;

pub fn main() !void {
    const w = try window.Window.create(window_width, window_height, "Sample Window");
    defer w.destroy();

    const r = try render.initVulkan();
    defer r.destroy();

    while (!w.shouldClose()) {
        c.glfwPollEvents();
    }
}
