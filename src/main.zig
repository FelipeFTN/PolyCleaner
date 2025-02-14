const std = @import("std");
const builtin = @import("builtin");

const consts = @import("constants.zig");
const libs = @import("libs.zig");

fn get_cache_directories(allocator: std.mem.Allocator) !std.ArrayList(libs.String) {
    var cache_directories = std.ArrayList(libs.String).init(allocator);

    // Try to get the HOME environment variable, if it doesn't exist (null), use the default value.
    const HOME = std.posix.getenv("HOME") orelse "~";
    std.debug.print("HOME: {s}\n", .{HOME});

    if (builtin.target.isGnu()) {
        for (consts.LINUX_CACHE_DIRS) |dir| {
            var directory = try libs.String.init(dir, allocator);
            directory = try directory.replace("$HOME", HOME);

            try cache_directories.append(directory);
        }
    } else if (builtin.target.isDarwin()) {
        for (consts.MAC_OS_CACHE_DIRS) |dir| {
            var directory = try libs.String.init(dir, allocator);
            directory = try directory.replace("$HOME", HOME);

            try cache_directories.append(directory);
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
        std.debug.print("Cache directory: {s}\n", .{dir.data});
    }
}
