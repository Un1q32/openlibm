/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <i386/bsd_asm.h>

//__FBSDID("$FreeBSD: src/lib/msun/i386/s_scalbnf.S,v 1.4 2011/01/07 16:13:12 kib Exp $");
/* RCSID("$NetBSD: s_scalbnf.S,v 1.4 1999/01/02 05:15:40 kristerw Exp $") */

ENTRY(scalbnf)
	fildl	8(%esp)
	flds	4(%esp)
	fscale
	fstp	%st(1)		/* bug fix for fp stack overflow */
	ret
END(scalbnf)

.globl CNAME(ldexpf)
.set	CNAME(ldexpf),CNAME(scalbnf)

	
/* Enable stack protection */
#if defined(__ELF__)
.section .note.GNU-stack,"",%progbits
#endif
