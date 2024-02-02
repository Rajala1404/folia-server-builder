const std = @import("std");
const builtin = @import("builtin");
const mainc = @import("main.zig");

pub fn createFile(dir: []const u8, winDir: []const u8, fileName: []const u8) !std.fs.File {
    if (builtin.os.tag == .windows) {
        const fdir = try std.fs.cwd().openDir(winDir, .{});
        const file = try fdir.createFile(fileName, .{});
        return file;
    } else {
        const fdir = try std.fs.cwd().openDir(dir, .{});
        const file = try fdir.createFile(fileName, .{ .read = true });
        return file;
    }
}

pub fn nextLine(reader: anytype, buffer: []u8) !?[]const u8 {
    const line = (try reader.readUntilDelimiterOrEof(buffer, '\n')) orelse return null;
    if (builtin.os.tag == .windows) {
        return std.mem.trimRight(u8, line, "\r");
    } else {
        return line;
    }
}
