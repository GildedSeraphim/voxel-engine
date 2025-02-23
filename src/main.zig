const std = @import("std");
const c = @import("clibs.zig");
const math = @import("math.zig");

pub const window_width: usize = 800;
pub const window_height: usize = 600;

pub fn main() !void {
    std.debug.print("Hello World!\nDimensions are {} and {}", .{ window_width, window_height });
}
