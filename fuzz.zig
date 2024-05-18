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
