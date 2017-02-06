If want to compile the bochs yourself, please make sure:

- Compile it with gdbstub support:

        $ cd bochs-x.x.x
        $ ./configure --enable-plugins --enable-disasm --enable-gdb-stub
