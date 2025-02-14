const std = @import("std");

const cache = @import("cache.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const cache_directories = try cache.get_cache_directories(allocator);
    defer cache.free_memory_resources(cache_directories);

    try cache.delete_cache_directories(cache_directories);
    try cache.create_cache_directories(cache_directories);
}
