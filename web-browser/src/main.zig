const std = @import("std");
const parser = @import("HTMLparser.zig");
const request = @import("request.zig");
pub fn main() !void {
    const website: []const u8 = "https://ziglang.org";
    const z = try request.getHTML(website);
    _ = try parser.htmlparser(z);
    // std.debug.print("{s}", .{z});
}
