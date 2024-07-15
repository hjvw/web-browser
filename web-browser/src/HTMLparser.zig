const std = @import("std");
const rem = @import("rem");

pub fn htmlparser(html: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const allocator = gpa.allocator();

    var alloc = std.heap.page_allocator;
    const decoded_input = try utf8DecodeStringRuntime(html, &alloc);

    var dom = rem.Dom{ .allocator = allocator };
    defer dom.deinit();

    var parser = try rem.Parser.init(&dom, decoded_input, allocator, .report, false);
    defer parser.deinit();

    try parser.run();

    const errors = parser.errors();
    std.debug.assert(errors.len == 0);

    const stdout = std.io.getStdOut().writer();
    const document = parser.getDocument();
    try rem.util.printDocument(stdout, document, &dom, allocator);
}

fn utf8DecodeStringRuntime(string: []const u8, allocator: *std.mem.Allocator) ![]u21 {
    var decoded_len: usize = 0;
    var i: usize = 0;
    while (i < string.len) {
        i += std.unicode.utf8ByteSequenceLength(string[i]) catch return error.InvalidUTF8;
        decoded_len += 1;
    }

    var result = try allocator.alloc(u21, decoded_len);
    var utf8_iter = std.unicode.Utf8Iterator{ .bytes = string, .i = 0 };
    i = 0;
    while (utf8_iter.nextCodepoint()) |codepoint| {
        result[i] = codepoint;
        i += 1;
    }

    return result;
}
