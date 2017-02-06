OS = $(shell uname)

# indicate the path of the bochs
#BOCHS=$(shell find tools/ -name "bochs" -perm 755 -type f)
BOCHS=bochs

#
# if you want the ram-disk device, define this to be the
# size in blocks.
#
RAMDISK =  -DRAMDISK=2048

# This is a basic Makefile for setting the general configuration
include Makefile.header

LDFLAGS	+= -Ttext 0 -e startup_32
CFLAGS	+= $(RAMDISK) -Iinclude
CPP	+= -Iinclude

#
# ROOT_DEV specifies the default root-device when making the image.
# This can be either FLOPPY, /dev/xxxx or empty, in which case the
# default of hd1(0301) is used by 'build'.
#
#ROOT_DEV= 021d	# FLOPPY B
#ROOT_DEV= 0301	# hd1

ARCHIVES=kernel/kernel.o mm/mm.o fs/fs.o
DRIVERS =kernel/blk_drv/blk_drv.a kernel/chr_drv/chr_drv.a
MATH	=kernel/math/math.a
LIBS	=lib/lib.a

.c.s:
	@$(CC) $(CFLAGS) -S -o $*.s $<
.s.o:
	@$(AS)  -o $*.o $<
.c.o:
	@$(CC) $(CFLAGS) -c -o $*.o $<

all:	Image

Image: boot/bootsect boot/setup kernel.sym ramfs
	@cp -f images/kernel.sym images/kernel.tmp
	@$(STRIP) images/kernel.tmp
	@$(OBJCOPY) -O binary -R .note -R .comment images/kernel.tmp images/kernel
	tools/build.sh boot/bootsect boot/setup images/kernel images/Image rootfs/$(RAM_IMG) $(ROOT_DEV)
	@rm images/kernel.tmp
	@rm -f images/kernel
	@sync

disk: Image
	@dd bs=8192 if=images/Image of=/dev/fd0

boot/head.o: boot/head.s
	@make head.o -C boot/

kernel.sym: boot/head.o init/main.o \
		$(ARCHIVES) $(DRIVERS) $(MATH) $(LIBS)
	@$(LD) $(LDFLAGS) boot/head.o init/main.o \
	$(ARCHIVES) \
	$(DRIVERS) \
	$(MATH) \
	$(LIBS) \
	-o images/kernel.sym
	@nm images/kernel.sym | grep -v '\(compiled\)\|\(\.o$$\)\|\( [aU] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)'| sort > images/kernel.map

kernel/math/math.a:
	@make -C kernel/math

kernel/blk_drv/blk_drv.a:
	@make -C kernel/blk_drv

kernel/chr_drv/chr_drv.a:
	@make -C kernel/chr_drv

kernel/kernel.o:
	@make -C kernel

mm/mm.o:
	@make -C mm

fs/fs.o:
	@make -C fs

lib/lib.a:
	@make -C lib

boot/setup: boot/setup.s
	@make setup -C boot

boot/bootsect: boot/bootsect.s
	@make bootsect -C boot

tmp.s:	boot/bootsect.s images/kernel.sym
	@(echo -n "SYSSIZE = (";ls -l images/kernel.sym | grep kernel.sym \
		| cut -c25-31 | tr '\012' ' '; echo "+ 15 ) / 16") > tmp.s
	@cat boot/bootsect.s >> tmp.s

clean:
	@make clean -C rootfs
	@rm -f images/Image images/kernel.map tmp_make core boot/bootsect boot/setup
	@rm -f init/*.o images/kernel.sym boot/*.o typescript* info bochsout.txt
	@rm -f calltree/*.dot calltree/*.jpg
	@for i in mm fs kernel lib boot; do make clean -C $$i; done 
info:
	@make clean
	@script -q -c "make all"
	@cat typescript | col -bp | grep -E "warning|Error" > info
	@cat info

distclean: clean
	@rm -f tag cscope* linux-0.11.*

backup: clean
	@(cd .. ; tar cf - linux | compress16 - > backup.Z)
	@sync

dep:
	@sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	@(for i in init/*.c;do echo -n "init/";$(CPP) -M $$i;done) >> tmp_make
	@cp tmp_make Makefile
	@for i in fs kernel mm; do make dep -C $$i; done

tag: tags
tags:
	@ctags -R

cscope:
	@cscope -Rbkq

hda:
	@make hda -C rootfs

flp:
	@make flp -C rootfs

ramfs:
	@make ramfs -C rootfs

start:
	@$(SETROOTDEV) images/Image 0000
	$(QEMU) -m 16M -boot a -fda images/Image

start-fd: flp
	@$(SETROOTDEV) images/Image 021d
	$(QEMU) -m 16M -boot a -fda images/Image -fdb rootfs/$(FLP_IMG)

start-hd: hda
	@$(SETROOTDEV) images/Image 0301
	$(QEMU) -m 16M -boot a -fda images/Image -hda rootfs/$(HDA_IMG)

debug:
	@echo $(OS)
	@$(SETROOTDEV) images/Image 0000
	$(QEMU) -m 16M -boot a -fda images/Image -s -S #-nographic #-serial '/dev/ttyS0'

debug-fd: flp
	@echo $(OS)
	@$(SETROOTDEV) images/Image 021d
	$(QEMU) -m 16M -boot a -fda images/Image -fdb rootfs/$(FLP_IMG) -s -S #-nographic #-serial '/dev/ttyS0'

debug-hd: hda
	@echo $(OS)
	@$(SETROOTDEV) images/Image 0301
	$(QEMU) -m 16M -boot a -fda images/Image -hda rootfs/$(HDA_IMG) -s -S #-nographic #-serial '/dev/ttyS0'

bochs-debug:
	@$(BOCHS) -q -f tools/bochs/bochsrc/bochsrc-hd-dbg.bxrc	

bochs:
ifeq ($(BOCHS),)
	@(cd tools/bochs/bochs-2.3.7; \
	./configure --enable-plugins --enable-disasm --enable-gdb-stub;\
	make)
endif

bochs-clean:
	@make clean -C tools/bochs/bochs-2.3.7

cg: callgraph
callgraph:
	@tools/calltree -b -np -m init/main.c | tools/tree2dotx > calltree/linux-0.11.dot
	@dot -Tjpg calltree/linux-0.11.dot -o calltree/linux-0.11.jpg

help:
	@echo "<<<<This is the basic help info of linux-0.11>>>"
	@echo ""
	@echo "Usage:"
	@echo "     make --generate a kernel floppy Image with a fs on hda1"
	@echo "     make start -- start the kernel in qemu"
	@echo "     make start-fd -- start the kernel with fs in floppy"
	@echo "     make start-hd -- start the kernel with fs in hard disk"
	@echo "     make debug -- debug the kernel in qemu & gdb at port 1234"
	@echo "     make debug-fd -- debug the kernel with fs in floppy"
	@echo "     make debug-hd -- debug the kernel with fs in hard disk"
	@echo "     make disk  -- generate a kernel Image & copy it to floppy"
	@echo "     make cscope -- genereate the cscope index databases"
	@echo "     make tags -- generate the tag file"
	@echo "     make cg -- generate callgraph of the system architecture"
	@echo "     make clean -- clean the object files"
	@echo "     make distclean -- only keep the source code files"
	@echo ""
	@echo "Note!:"
	@echo "     * You need to install the following basic tools:"
	@echo "          ubuntu|debian, qemu|bochs, ctags, cscope, calltree, graphviz "
	@echo "          vim-full, build-essential, hex, dd, gcc 4.3.2..."
	@echo "     * Becarefull to change the compiling options, which will heavily"
	@echo "     influence the compiling procedure and running result."
	@echo ""
	@echo "Author:"
	@echo "     * 1991, linus write and release the original linux 0.95(linux 0.11)."
	@echo "     * 2005, jiong.zhao<gohigh@sh163.net> release a new version "
	@echo "     which can be used in RedHat 9 along with the book 'Explaining "
	@echo "     Linux-0.11 Completly', and he build a site http://www.oldlinux.org"
	@echo "     * 2008, falcon<wuzhangjin@gmail.com> release a new version which can be"
	@echo "     used in ubuntu|debian 32bit|64bit with gcc 4.3.2, and give some new "
	@echo "     features for experimenting. such as this help info, boot/bootsect.s and"
	@echo "     boot/setup.s with AT&T rewritting, porting to gcc 4.3.2 :-)"
	@echo ""
	@echo "<<<Be Happy To Play With It :-)>>>"

### Dependencies:
init/main.o: init/main.c include/unistd.h include/sys/stat.h \
  include/sys/types.h include/sys/times.h include/sys/utsname.h \
  include/utime.h include/time.h include/linux/tty.h include/termios.h \
  include/linux/sched.h include/linux/head.h include/linux/fs.h \
  include/linux/mm.h include/signal.h include/asm/system.h \
  include/asm/io.h include/stddef.h include/stdarg.h include/fcntl.h
