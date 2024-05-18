const std = @import("std");

pub fn fuzz(input: []const u8) void {
    if (input.len == 4 and
        input[0] == 'D' and
        input[1] == 'i' and
        input[2] == 'e' and
        input[3] == '!')
        std.debug.panic("Dead!", .{});
}

export fn LLVMFuzzerTestOneInput(buf: [*]const u8, len: usize) c_int {
    fuzz(buf[0..len]);
    return 0;
}
