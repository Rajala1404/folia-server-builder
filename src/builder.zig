const std = @import("std");
const builtin = @import("builtin");
const mainC = @import("main.zig");
const utils = @import("utils.zig");

const eql = std.mem.eql;

//Global Const
const winTempDir: []const u8 = "C:\\Temp\\Folia\\";
const tempDir: []const u8 = "/tmp/Folia/";

//Golbal Placeholders
var gitName: []const u8 = undefined;
var gitEmail: []const u8 = undefined;
var path: []const u8 = "./";

pub fn main() !void {
    path = mainC.path;
    try askGit();
}

fn askGit() !void {
    const stdout = std.io.getStdOut();
    const out = stdout.writer();
    const stdin = std.io.getStdIn();
    var checkName = true;
    var checkEmail = false;
    var input: []const u8 = undefined;
    while (checkName) {
        try stdout.writeAll(
            \\Git Name: 
        );

        var buffer: [100]u8 = undefined;
        input = (try utils.nextLine(stdin.reader(), &buffer)).?;
        try out.print("gitName = \"{s}\"\n", .{input});
        while (checkName) {
            try stdout.writeAll(
                \\Is this Right? [Y/n] 
            );
            var buffer2: [100]u8 = undefined;

            var i = (try utils.nextLine(stdin.reader(), &buffer2)).?;
            const possibleAnswer = [5][]const u8{ "Y", "y", "N", "n", "" };
            if (eql(u8, i, possibleAnswer[0]) or eql(u8, i, possibleAnswer[1]) or eql(u8, i, possibleAnswer[4])) {
                checkName = false;
                checkEmail = true;
                gitName = input;
            } else if (eql(u8, i, possibleAnswer[2]) or eql(u8, i, possibleAnswer[3])) {
                break;
            } else {
                try out.print("\"{s}\" is not a valid Answer\n", .{i});
            }

            const file = try utils.createFile(tempDir, winTempDir, "gitName");
            defer file.close();
            const bytes_written = try file.writeAll(gitName);
            _ = bytes_written;
        }
    }

    while (checkEmail) {
        try stdout.writeAll(
            \\Git Email: 
        );

        var buffer: [100]u8 = undefined;
        input = (try utils.nextLine(stdin.reader(), &buffer)).?;
        try out.print("gitEmail = \"{s}\"\n", .{input});
        while (checkEmail) {
            try stdout.writeAll(
                \\Is this Right? [Y/n] 
            );
            var buffer2: [100]u8 = undefined;

            var i = (try utils.nextLine(stdin.reader(), &buffer2)).?;
            const possibleAnswer = [5][]const u8{ "Y", "y", "N", "n", "" };
            if (eql(u8, i, possibleAnswer[0]) or eql(u8, i, possibleAnswer[1]) or eql(u8, i, possibleAnswer[4])) {
                checkEmail = false;
                gitEmail = input;
            } else if (eql(u8, i, possibleAnswer[2]) or eql(u8, i, possibleAnswer[3])) {
                break;
            } else {
                try out.print("\"{s}\" is not a valid Answer\n", .{i});
            }
        }
        const file = try utils.createFile(tempDir, winTempDir, "gitEmail");
        defer file.close();
        const bytes_written = try file.writeAll(gitEmail);
        _ = bytes_written;
    }
}
