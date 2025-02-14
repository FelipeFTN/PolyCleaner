const std = @import("std");
const builtin = @import("builtin");

const consts = @import("constants.zig");
const libs = @import("libs.zig");

pub fn get_cache_directories(allocator: std.mem.Allocator) !std.ArrayList(libs.String) {
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

pub fn delete_cache_directories(cache_dirs: std.ArrayList(libs.String)) std.fs.Dir.DeleteTreeError!void {
    if (cache_dirs.items.len == 0) {
        std.debug.print("Error creating cache directories: cache_dirs is null\n", .{});
        return;
    }

    for (cache_dirs.items) |dir| {
        std.fs.cwd().deleteTree(dir.data) catch |err| {
            std.debug.print("Error deleting cache directory: {s} -> {s}\n", .{dir.data, @errorName(err)});
        };


        std.debug.print("Deleted cache directory: {s}\n", .{dir.data});
    }
}

pub fn create_cache_directories(cache_dirs: std.ArrayList(libs.String)) std.fs.Dir.MakeError!void {
    if (cache_dirs.items.len == 0) {
        std.debug.print("Error creating cache directories: cache_dirs is null\n", .{});
        return;
    }

    for (cache_dirs.items) |dir| {
        std.fs.cwd().makeDir(dir.data) catch |err| {
            std.debug.print("Error creating cache directory: {s} -> {s}\n", .{dir.data, @errorName(err)});
        };

        std.debug.print("Created cache directory: {s}\n", .{dir.data});
    }
}

pub fn free_memory_resources(cache_dirs: std.ArrayList(libs.String)) void {
    for (cache_dirs.items) |dir| {
        dir.deinit();
    }

    cache_dirs.deinit();
}
