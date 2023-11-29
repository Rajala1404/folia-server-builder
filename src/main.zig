const std = @import("std");
const builtin = @import("builtin");
const builder = @import("builder.zig");

const stdin = std.io.getStdIn();
const stdout = std.io.getStdOut();
const out = stdout.writer();
const eql = std.mem.eql;

//Global Constants
const ver: []const u8 = "1.0.3 (Zig)";
const veri: i32 = 103;

//Arguments
var debuggingArg = false;
var customDirArg = false;
var versionArg = false;
var buildArg = false;

//Global Placeholders
var path: []const u8 = "./";

pub fn main() !void {
    var args = std.process.args();
    while (args.next()) |arg| {
        if (eql(u8, arg, "--debug") or eql(u8, arg, "-d")) {
            debuggingArg = true;
            std.debug.print("Debugging enabled.\n", .{});
        }
        if (eql(u8, arg, "--custom-dir") or eql(u8, arg, "-cd")) {
            customDirArg = true;
        }
        if (eql(u8, arg, "--version") or eql(u8, arg, "-v")) {
            versionArg = true;
        }
        if (eql(u8, arg, "--build") or eql(u8, arg, "-b")) {
            buildArg = true;
        }
    }
    if (versionArg) {
        try out.print("Version: {s} \n", .{ver});
    }
    if (customDirArg) {
        if (debuggingArg) std.debug.print("[DEBUG] Asking for Path", .{});
        try getPath();
    }
    if (buildArg) {
        if (debuggingArg) std.debug.print("[DEBUG] try to acces builder.zig/main", .{});
        try builder.main(path);
    }
}

fn getPath() !void {
    var check = true;
    var input: []const u8 = undefined;
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
    if (builtin.os.tag == .windows) {
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
