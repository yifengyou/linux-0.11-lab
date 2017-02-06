#!/bin/bash
#
# build.sh -- a shell version of build.c for the new bootsect.s & setup.s
# author: falcon <wuzhangjin@gmail.com>
# update: 2008-10-10

bootsect=$1
setup=$2
kernel=$3
IMAGE=$4

# Set the biggest sys_size (Note: Need to document this magic number?)
SYS_SIZE=$((256*1024))

# Write bootsect (512 bytes, one sector)
[ ! -f "$bootsect" ] && echo "Error: No bootsect binary file there" && exit -1
dd if=$bootsect bs=512 count=1 of=$IMAGE &>/dev/null

# Write setup(4 * 512bytes, four sectors)
[ ! -f "$setup" ] && echo "Error: No setup binary file there" && exit -1
dd if=$setup seek=1 bs=512 count=4 of=$IMAGE &>/dev/null

# Write kernel(< SYS_SIZE)
[ ! -f "$kernel" ] && echo "Error: No kernel binary file there" && exit -1
kernel_size=`wc -c $kernel | tr -C -d [0-9]`
[ $kernel_size -gt $SYS_SIZE ] && echo "Note: the kernel binary is too big"
dd if=$kernel seek=5 bs=512 of=$IMAGE &>/dev/null
