
# as -o syscall.o syscall.s
# ld -o syscall syscall.o

	.file "syscall.s"

.text
.globl _start

_start:
	movl $72,%eax
	int $0x80

	movl $0,%ebx
	movl $1,%eax
	int $0x80
