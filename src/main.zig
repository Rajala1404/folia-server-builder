const std = @import("std");

const ver: []const u8 = "1.0.3 (Zig)";
const veri: i32 = 103;

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    try stdout.print("Version: {s} \n", .{ver});

    try bw.flush();
}
