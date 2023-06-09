const std = @import("std");

const writer = std.io.getStdOut().writer();
const reader = std.io.getStdIn().reader();
// const gpa = std.heap.GeneralPurposeAllocator(.{}){};

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
        '\r' => writer.writeAll("\\r") catch return,
        '\\' => writer.writeAll("\\\\") catch return,
        else => writer.writeByte(byte) catch return,
    };
}

fn is_whitespace(byte: u8) bool {
    return switch (byte) {
        ' ', '\t', '\n', '\r' => true,
        else => false,
    };
}

// 1.12
fn slice_stdin_by_words() void {
    var in_word = false;
    while (reader.readByte() catch null) |byte| {
        if (is_whitespace(byte)) {
            if (in_word) {
                writer.writeByte('\n') catch return;
                in_word = false;
            }
        } else {
            writer.writeByte(byte) catch return;
            in_word = true;
        }
    }
}

// 1.10
fn stdin_words_length_vertical_whistogram() void {
    const max_len = 256;

    var word_lengths_cnt = [_]u16{0} ** max_len;
    var word_len: u16 = 0;
    while (reader.readByte() catch null) |byte| {
        if (is_whitespace(byte)) {
            if (word_len != 0) {
                if (max_len <= word_len) {
                    std.debug.print(
                        "Error: your word is too big for my buffer, maximal length is {d}, but your words length is {d}. Sorry :(\n",
                        .{ max_len, word_len },
                    );
                    return;
                }

                word_lengths_cnt[word_len] += 1;
                word_len = 0;
            }
        } else {
            word_len += 1;
        }
    }

    var range_start: u16 = 0;
    while (range_start < word_lengths_cnt.len and word_lengths_cnt[range_start] == 0) : (range_start += 1) {}

    var range_end: u16 = word_lengths_cnt.len - 1;
    while (0 < range_end and word_lengths_cnt[range_end] == 0) : (range_end -= 1) {}

    var max_cnt: u16 = 0;
    for (word_lengths_cnt[range_start..range_end]) |cnt| {
        if (max_cnt < cnt) max_cnt = cnt;
    }

    if (range_end - range_start == 0) {
        return;
    }

    const hystogram_height = 20.0;
    const hystogram_width = 40.0;

    const start = @intToFloat(f32, range_start);
    const end = @intToFloat(f32, range_end);
    const max = @intToFloat(f32, max_cnt);

    const x_step = (end - start) / hystogram_width;
    const y_step = max / hystogram_height;

    var y: f32 = max;
    while (0.0 < y) : (y -= y_step) {
        var x: f32 = start;
        while (x < end) : (x += x_step) {
            const curr_cnt = @intToFloat(f32, word_lengths_cnt[@floatToInt(u16, x)]);

            if (y <= curr_cnt) {
                writer.writeByte('#') catch {};
            } else {
                writer.writeByte('.') catch {};
            }
        }
        writer.print(" {d}\n", .{@trunc(y)}) catch {};
    }

    writer.print("# = {d:.3} char/s\n", .{x_step}) catch {};
}

pub fn main() !void {
    // whitespace_counter();
    // dedup_spaces();
    // escape_stdin();
    // slice_stdin_by_words();
    stdin_words_length_vertical_whistogram();
}
