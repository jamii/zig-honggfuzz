const std = @import("std");

export fn LLVMFuzzerTestOneInput(buf: [*]const u8, len: usize) c_int {
    const input = buf[0..len];

    if (input.len == 4 and
        input[0] == 'D' and
        input[1] == 'i' and
        input[2] == 'e' and
        input[3] == '!')
        std.debug.panic("Dead!", .{});

    return 0;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    const path = args[1];
    const cwd = std.fs.cwd();
    const file = try cwd.openFile(path, .{ .mode = .read_only });
    const input = try file.readToEndAlloc(allocator, std.math.maxInt(usize));

    std.debug.assert(LLVMFuzzerTestOneInput(input.ptr, input.len) == 0);
}
