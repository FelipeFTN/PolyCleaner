const std = @import("std");

pub const String = struct {
    data: []const u8,
    allocator: std.mem.Allocator,

    pub fn init(s: []const u8, allocator: std.mem.Allocator) !String {
        const data = try allocator.dupe(u8, s); // Proper allocation
        return .{ .data = data, .allocator = allocator };
    }

    pub fn contains(self: String, substr: []const u8) bool {
        return std.mem.indexOf(u8, self.data, substr) != null;
    }

    pub fn replace(self: String, old: []const u8, new: []const u8) !String {
        const index = std.mem.indexOf(u8, self.data, old) orelse return self;

        // Calculate new size
        const new_len: usize = @intCast(self.data.len + new.len - old.len);

        // Allocate new memory
        const new_data = try self.allocator.alloc(u8, new_len);

        // Copy parts into new buffer
        std.mem.copyForwards(u8, new_data[0..index], self.data[0..index]); // Copy before `old`
        std.mem.copyForwards(u8, new_data[index .. index + new.len], new); // Copy `new`
        std.mem.copyForwards(u8, new_data[index + new.len ..], self.data[index + old.len ..]); // Copy after `old`

        return .{ .data = new_data, .allocator = self.allocator };
    }

    pub fn deinit(self: String) void {
        self.allocator.free(self.data);
    }
};
