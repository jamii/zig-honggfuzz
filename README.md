Demo of how to use honggfuzz for coverage-guided persistent fuzzing of zig programs.

Zig [doesn't currently support llvm sanitizers](https://github.com/ziglang/zig/issues/5484) so we have a few options for workarounds.

* `fuzz-perf.sh` uses perf counters for black-box fuzzing. This seems pretty ineffective - after 10 minutes it can't crash `fuzz.zig`.
* `fuzz-c.sh` compiles the zig to c and then use clang to insert instrumentation. This crashes `fuzz.zig` almost instantly.
* I briefly tried libipt and qemu too, but neither was straightforward.

After finding a crash you'll get a file named something like `SIGSEGV.PC.5555555cdf75.STACK.1833310e12.CODE.128.ADDR.0.INSTR.mov____(%rax,%r13,8),%r15.fuzz` in the current directory. You can debug it like this:

```
gdb ./fuzz
run 'SIGSEGV.PC.5555555cdf75.STACK.1833310e12.CODE.128.ADDR.0.INSTR.mov____(%rax,%r13,8),%r15.fuzz'
```

If you used the `fuzz-c.sh` method then your debug info will be gone, so you may want to make a debug build directly instead:

```
zig build-exe ./fuzz.zig -O Debug -femit-bin=fuzz
gdb ./fuzz
run 'SIGSEGV.PC.5555555cdf75.STACK.1833310e12.CODE.128.ADDR.0.INSTR.mov____(%rax,%r13,8),%r15.fuzz'
```