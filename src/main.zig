const std = @import("std");
const c = @import("clibs.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var result: c.VkResult = undefined;
    var createInfo = std.mem.zeroes(c.VkInstanceCreateInfo);
    var instance: c.VkInstance = undefined;
    var versionSupported: u32 = undefined;

    result = c.vkEnumerateInstanceVersion(&versionSupported);
    if (result != c.VK_SUCCESS) {
        try stdout.print("Failed to get Vulkan version. Vulkan might not be installed.", .{});
        return error.VulkanNotFound;
    }

    const major: u32 = c.VK_VERSION_MAJOR(versionSupported);
    const minor: u32 = c.VK_VERSION_MINOR(versionSupported);
    const patch: u32 = c.VK_VERSION_PATCH(versionSupported);

    try stdout.print("Vulkan is installed\n", .{});
    try stdout.print("Supported Vulkan version: {}.{}.{}\n", .{ major, minor, patch });

    createInfo.sType = c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    result = c.vkCreateInstance(&createInfo, null, &instance);

    if (result != c.VK_SUCCESS) {
        try stdout.print("Failed to create Vulkan instance. Error code: {}\n", .{result});
        return error.InstanceNotCreated;
    }

    c.vkDestroyInstance(instance, null);
    try stdout.print("Successfully created and destroyed a Vulkan instance.\n", .{});
}
