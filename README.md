Linux-0.11
==========

The old Linux kernel source ver 0.11 which has been tested under modern Linux,  Mac OSX and Windows.

* 2011-07-31, tigercn <moonlight.yang@gmail.com>
* 2008-10-15, 2015-03-15, falcon <wuzhangjin@gmail.com>
* 2012-04-30, yuanxinyu <yuanxinyu.hangzhou@gmail.com>

## Build on Linux

### Linux Setup

* a linux distribution: debian , ubuntu and mint are recommended
* some tools: gcc gdb qemu

### hack linux-0.11

    $ make help		// get help
    $ make  		// compile
    $ make boot-hd		// boot it on qemu with hard disk image
    $ make debug-hd		// debug it via qemu & gdb, you'd start gdb to connect it.

    $ gdb images/kernel.sym
    (gdb) target remote :1234
    (gdb) b main
    (gdb) c

optional

    $ echo "add-auto-load-safe-path $PWD/.gdbinit" > ~/.gdbinit  // let gdb auto load the commands in .gdbinit

## Build on Mac OS X

### Mac OS X Setup

* install cross compiler gcc and binutils
* install qemu
* install gdb. you need download the gdb source and compile it to use gdb because port doesn't provide i386-elf-gdb, or you can use the pre-compiled gdb in the tools directory.

    $ sudo port install qemu
    $ sudo port install i386-elf-binutils i386-elf-gcc

optional

    $ wget ftp://ftp.gnu.org/gnu/gdb/gdb-7.4.tar.bz2
    $ tar -xzvf gdb-7.4.tar.bz2
	$ cd gdb-7.4
	$ ./configure --target=i386-elf
	$ make


### hack linux-0.11

	same as section 1.2


## Build on Windows

	todo...
