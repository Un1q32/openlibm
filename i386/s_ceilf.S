/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <i386/bsd_asm.h>

//__FBSDID("$FreeBSD: src/lib/msun/i386/s_ceilf.S,v 1.4 2011/01/07 16:13:12 kib Exp $");
/* RCSID("$NetBSD: s_ceilf.S,v 1.3 1995/05/08 23:52:44 jtc Exp $") */

ENTRY(ceilf)
	pushl	%ebp
	movl	%esp,%ebp
	subl	$8,%esp

	fstcw	-4(%ebp)		/* store fpu control word */
	movw	-4(%ebp),%dx
	orw	$0x0800,%dx		/* round towards +oo */
	andw	$0xfbff,%dx
	movw	%dx,-8(%ebp)
	fldcw	-8(%ebp)		/* load modfied control word */

	flds	8(%ebp);		/* round */
	frndint

	fldcw	-4(%ebp)		/* restore original control word */

	leave
	ret
END(ceilf)

	
/* Enable stack protection */
#if defined(__ELF__)
.section .note.GNU-stack,"",%progbits
#endif
