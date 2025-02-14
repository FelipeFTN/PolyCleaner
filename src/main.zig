const std = @import("std");
const builtin = @import("builtin");

const consts = @import("constants.zig");

fn get_cache_directories(allocator: std.mem.Allocator) !std.ArrayList([]const u8) {
    var cache_directories = std.ArrayList([]const u8).init(allocator);

    if (builtin.target.isGnu()) {
        for (consts.LINUX_CACHE_DIRS) |dir| {
            try cache_directories.append(dir);
        }
    } else if (builtin.target.isDarwin()) {
        for (consts.MAC_OS_CACHE_DIRS) |dir| {
            try cache_directories.append(dir);
        }
    }

    return cache_directories;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var cache_directories = try get_cache_directories(allocator);
    defer cache_directories.deinit();

    for (cache_directories.items) |dir| {
        std.debug.print("Cache directory: {s}\n", .{dir});
    }
}
