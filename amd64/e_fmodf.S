/*
 * Based on the i386 version written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <amd64/bsd_asm.h>

ENTRY(fmodf)
	movss	%xmm0,-4(%rsp)
	movss	%xmm1,-8(%rsp)
	flds	-8(%rsp)
	flds	-4(%rsp)
1:	fprem
	fstsw	%ax
	testw	$0x400,%ax
	jne	1b
	fstps	-4(%rsp)
	movss	-4(%rsp),%xmm0
	fstp	%st
	ret
END(fmodf)
