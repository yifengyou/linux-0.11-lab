#!/bin/bash
# build.sh -- a shell version of build.c for the new bootsect.s & setup.s
# author: falcon <wuzhangjin@gmail.com>
# update: 2008-10-10

bootsect=$1
setup=$2
kernel=$3
IMAGE=$4
ram_img=$5
root_dev=$6

# Set the biggest sys_size (Note: Need to document this magic number?)
SYS_SIZE=$((256*1024))

# by default, using the integrated floppy including boot & root image
if [ -z "$root_dev" ]; then
	DEFAULT_MAJOR_ROOT=0
	DEFAULT_MINOR_ROOT=0
else
	DEFAULT_MAJOR_ROOT=${root_dev:0:2}
	DEFAULT_MINOR_ROOT=${root_dev:2:3}
fi

# Write bootsect (512 bytes, one sector)
[ ! -f "$bootsect" ] && echo "Error: No bootsect binary file there" && exit -1
dd if=$bootsect bs=512 count=1 of=$IMAGE 2>&1 >/dev/null

# Write setup(4 * 512bytes, four sectors)
[ ! -f "$setup" ] && echo "Error: No setup binary file there" && exit -1
dd if=$setup seek=1 bs=512 count=4 of=$IMAGE 2>&1 >/dev/null

# Write kernel(< SYS_SIZE)
[ ! -f "$kernel" ] && echo "Error: No kernel binary file there" && exit -1
kernel_size=`wc -c $kernel | tr -C -d [0-9]`
[ $kernel_size -gt $SYS_SIZE ] && echo "Note: the kernel binary is too big"
dd if=$kernel seek=5 bs=512 of=$IMAGE 2>&1 >/dev/null

# Write Root FS
if [ -n "$ram_img" -a -f "$ram_img" ]; then
	dd if=$ram_img seek=256 bs=1024 of=$IMAGE conv=notrunc 2>&1 >/dev/null
fi

# Set "device" for the root image file
echo -ne "\x$DEFAULT_MINOR_ROOT\x$DEFAULT_MAJOR_ROOT" | dd ibs=1 obs=1 count=2 seek=508 of=$IMAGE conv=notrunc  2>&1 >/dev/null
