
# How a add a new system call

1. enter into the lab root directory

        $ cd /path/to/linux-0.11-lab/

2. apply the syscall changes

        $ patch -p1 < examples/syscall/syscall.patch

3. compile the kernel

        $ make

4. copy examples/syscall/syscall.s to the rootfile system: usr/root/
    * follow 'Hack Rootfs' of (linux-0.11-lab)/README.md
    * ex.:

            $ make hda # make sure hdc image is decompressed
            $ sudo mount -o offset=$((2*512)) rootfs/hdc-0.11.img /path/to/hdc
            $ sudo cp examples/syscall/syscall.s /path/to/hdc/usr/root/
            $ sync
            $ sudo umount /path/to/hdc

5. start the new kernel and new filesystem
    * ex.:
    
            $ make start-hd

6. compile and link

        $ as -o syscall.o syscall.s
        $ ld -o syscall syscall.o

7. run it in emulator

        $ ./syscall
        Hello, Linux 0.11 
