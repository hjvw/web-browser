const std = @import("std");

const Text = struct {
    text: []const u8,
    parent: Element,
};

const Element = struct {
    tag: []const u8,
    attributes: []const u8,
    children: []type,
    parent: []const u8,
};

pub fn htmlparser(htmlcode: []const u8) !void {
    var in_tag: bool = undefined;
    for (htmlcode) |value| {
        if (value == 60) {
            in_tag = true;
            
        }
    }
}
