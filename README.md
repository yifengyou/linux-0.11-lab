Linux-0.11
==========

The old Linux kernel source ver 0.11 which has been tested under modern Linux, Mac OSX.

* 2008-10-15, falcon <wuzhangjin@gmail.com>
* 2011-07-31, tigercn <moonlight.yang@gmail.com>
* 2012-04-30, yuanxinyu <yuanxinyu.hangzhou@gmail.com>
* 2015-03-15, falcon <wuzhangjin@gmail.com>

## Build on Linux

### Linux Setup

* A linux distribution: debian, ubuntu and mint are recommended
* Some tools: gcc gdb qemu cscope ctags

    $ apt-get install vim cscope exuberant-ctags build-essential qemu

### hack linux-0.11

    $ make help		// get help
    $ make  		// compile
    $ make start-hd	// boot it on qemu with hard disk image
    $ make debug-hd	// debug it via qemu & gdb, you'd start gdb to connect it.

    $ gdb images/kernel.sym
    (gdb) target remote :1234
    (gdb) b main
    (gdb) c

Optional

    $ echo "add-auto-load-safe-path $PWD/.gdbinit" > ~/.gdbinit  // let gdb auto load the commands in .gdbinit

## Build on Mac OS X

### Mac OS X Setup

* Install xcode from "App Store"
* Install Mac package manage tool: MacPorts from http://www.macports.org/install.php

  * Check your OS X version from "About This Mac", for example, Lion
  * Go to the "Mac OS X Package (.pkg) Installer" part and download the corresponding version
  * Self update MacPorts

    $ xcode-select -switch /Applications/Xcode.app/Contents/Developer
    $ sudo port -v selfupdate

* Install cross compiler gcc and binutils

    $ sudo port install qemu

* Install qemu

    $ sudo port install i386-elf-binutils i386-elf-gcc

* Install gdb. 'Cause port doesn't provide i386-elf-gdb, use the pre-compiled tools/mac/gdb.xz or download its source and compile it.

    $ cd tools/mac/ ; tar Jxf gdb.xz

Optional

    $ sudo port install cscope
    $ sudo port install ctags

    $ wget ftp://ftp.gnu.org/gnu/gdb/gdb-7.4.tar.bz2
    $ tar -xzvf gdb-7.4.tar.bz2
	$ cd gdb-7.4
	$ ./configure --target=i386-elf
	$ make


### hack linux-0.11

	same as section 1.2
