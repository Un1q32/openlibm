/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <i386/bsd_asm.h>

//__FBSDID("$FreeBSD: src/lib/msun/i386/e_log10f.S,v 1.4 2011/01/07 16:13:12 kib Exp $");
/* RCSID("$NetBSD: e_log10f.S,v 1.1 1996/07/03 16:50:22 jtc Exp $") */

ENTRY(log10f)
	fldlg2
	flds	4(%esp)
	fyl2x
	ret
END(log10f)

	
/* Enable stack protection */
#if defined(__ELF__)
.section .note.GNU-stack,"",%progbits
#endif
