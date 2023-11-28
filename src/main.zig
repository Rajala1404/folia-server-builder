const std = @import("std");

const stdin = std.io.getStdIn();
const stdout = std.io.getStdOut();
const out = stdout.writer();

const ver: []const u8 = "1.0.3 (Zig)";
const veri: i32 = 103;

var path: []const u8 = undefined;

pub fn main() !void {
    try out.print("Version: {s} \n", .{ver});
    try getPath();
}

fn getPath() !void {
    var check = true;
    var input: []const u8 = undefined;
    const eql = std.mem.eql;
    while (check) {
        try stdout.writeAll(
            \\Server Path: 
        );

        var buffer: [100]u8 = undefined;
        input = (try nextLine(stdin.reader(), &buffer)).?;
        try out.print("Path = \"{s}\"\n", .{input});
        while (check) {
            try stdout.writeAll(
                \\Is this Right? [Y/n] 
            );
            buffer = undefined;

            var i = (try nextLine(stdin.reader(), &buffer)).?;
            const possibleAnswer = [5][]const u8{ "Y", "y", "N", "n", "" };
            if (eql(u8, i, possibleAnswer[0]) or eql(u8, i, possibleAnswer[1]) or eql(u8, i, possibleAnswer[4])) {
                check = false;
                path = input;
            } else if (eql(u8, i, possibleAnswer[2]) or eql(u8, i, possibleAnswer[3])) {
                break;
            } else {
                try out.print("\"{s}\" is not a valid Answer\n", .{i});
            }
        }
    }
}

fn nextLine(reader: anytype, buffer: []u8) !?[]const u8 {
    var line = (try reader.readUntilDelimiterOrEof(buffer, '\n')) orelse return null;
    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, line, "\r");
    } else {
        return line;
    }
}

fn convertQTN(optional: ?[]const u8) []const u8 {
    if (optional) |value| {
        return &value;
    } else {
        return &[_]u8{};
    }
}
