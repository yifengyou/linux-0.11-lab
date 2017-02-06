include ../Makefile.header

LDFLAGS += -r
CFLAGS	+= -I../include
CPP	+= -I../include

ifneq ($(RAMDISK),)
	CFLAGS	+= -DRAMDISK=$(RAMDISK)
endif

.c.o:
	@$(CC) $(CFLAGS) \
	-c -o $*.o $<

clean:
	@rm -f core *.o *.a tmp_make
	@for i in *.c;do rm -f `basename $$i .c`.s;done

dep:
	@sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	@(for i in *.c;do $(CPP) -M $$i;done) >> tmp_make
	@cp tmp_make Makefile

### Dependencies:
main.o: main.c ../include/unistd.h ../include/sys/stat.h \
 ../include/sys/types.h ../include/sys/times.h ../include/sys/utsname.h \
 ../include/utime.h ../include/time.h ../include/linux/tty.h \
 ../include/termios.h ../include/linux/sched.h ../include/linux/head.h \
 ../include/linux/fs.h ../include/linux/mm.h ../include/signal.h \
 ../include/asm/system.h ../include/asm/io.h ../include/stddef.h \
 ../include/stdarg.h ../include/fcntl.h
