const std = @import("std");
const c = @import("../clibs.zig");
const window = @import("window.zig");
const math = @import("../math.zig");
const Allocator = std.mem.Allocator;

const builtin = @import("builtin");
const debug = (builtin.mode == .Debug);

const validation_layers: []const [*c]const u8 = if (!debug) &[0][*c]const u8{} else &[_][*c]const u8{
    "VK_LAYER_KHRONOS_validation",
};

pub const Error = error{
    out_of_host_memory,
    out_of_device_memory,
    initialization_failed,
    layer_not_present,
    extension_not_present,
    incompatible_driver,
    unknown_error,
};

pub fn mapError(result: c_int) !void {
    return switch (result) {
        c.VK_SUCCESS => {},
        c.VK_ERROR_OUT_OF_HOST_MEMORY => Error.out_of_host_memory,
        c.VK_ERROR_OUT_OF_DEVICE_MEMORY => Error.out_of_device_memory,
        c.VK_ERROR_INITIALIZATION_FAILED => Error.initialization_failed,
        c.VK_ERROR_LAYER_NOT_PRESENT => Error.layer_not_present,
        c.VK_ERROR_EXTENSION_NOT_PRESENT => Error.extension_not_present,
        c.VK_ERROR_INCOMPATIBLE_DRIVER => Error.incompatible_driver,
        else => Error.unknown_error,
    };
}

pub const Instance = struct {
    handle: c.VkInstance,

    pub fn createInstance() !Instance {
        const extensions = window.getExtensions();

        var app_info: c.VkApplicationInfo = .{
            .sType = c.VK_STRUCTURE_TYPE_APPLICATION_INFO,
            .pApplicationName = "Voxel Game",
            .applicationVersion = c.VK_MAKE_VERSION(1, 0, 0),
            .pEngineName = "No engine",
            .engineVersion = c.VK_MAKE_VERSION(1, 0, 0),
            .apiVersion = c.VK_API_VERSION_1_0,
        };

        var create_info: c.VkInstanceCreateInfo = .{
            .sType = c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
            .pApplicationInfo = &app_info,
            .enabledExtensionCount = @intCast(extensions.len),
            .ppEnabledExtensionNames = extensions.ptr,
            .enabledLayerCount = @intCast(validation_layers.len),
            .ppEnabledLayerNames = validation_layers.ptr,
        };

        var instance: c.VkInstance = undefined;

        try mapError(c.vkCreateInstance(&create_info, null, &instance));

        return Instance{
            .handle = instance,
        };
    }

    pub fn destroy(self: Instance) void {
        c.vkDestroyInstance(self.handle, null);
    }
};
