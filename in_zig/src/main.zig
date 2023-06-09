const std = @import("std");

const writer = std.io.getStdOut().writer();
const reader = std.io.getStdIn().reader();

// 1.8
var spaces: u32 = 0;
fn whitespace_counter() void {
    var tabs: u32 = 0;
    var lines: u32 = 0;
    var chars: u32 = 0;

    while (reader.readByte() catch null) |byte| {
        switch (byte) {
            ' ' => spaces += 1,
            '\t' => tabs += 1,
            '\n' => lines += 1,
            else => {},
        }
        chars += 1;
    }

    writer.print(
        "spaces = {d};\ntabs = {d};\nlines = {d};\nall chars = {}.\n",
        .{ spaces, tabs, lines, chars },
    ) catch {};
}

// 1.9
fn dedup_spaces() void {
    var in_word = false;
    while (reader.readByte() catch null) |byte| {
        if (byte == ' ' and !in_word) continue;
        in_word = byte != ' ';
        writer.writeByte(byte) catch {};
    }
}

// 1.10
fn escape_stdin() void {
    while (reader.readByte() catch null) |byte| switch (byte) {
        '\t' => writer.writeAll("\\t") catch return,
        '\\' => writer.writeAll("\\\\") catch return,
        else => writer.writeByte(byte) catch return,
    };
}

pub fn main() !void {
    // dedup_spaces();
    escape_stdin();
}
