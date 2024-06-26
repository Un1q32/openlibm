/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <i386/bsd_asm.h>

//__FBSDID("$FreeBSD: src/lib/msun/i386/e_sqrtf.S,v 1.4 2011/01/07 16:13:12 kib Exp $");
/* RCSID("$NetBSD: e_sqrtf.S,v 1.2 1995/05/08 23:50:14 jtc Exp $") */

ENTRY(sqrtf)
	flds	4(%esp)
	fsqrt
	ret
END(sqrtf)

	
/* Enable stack protection */
#if defined(__ELF__)
.section .note.GNU-stack,"",%progbits
#endif
