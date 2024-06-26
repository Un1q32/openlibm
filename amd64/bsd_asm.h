/*-
 * Copyright (c) 1990 The Regents of the University of California.
 * All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * William Jolitz.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	from: @(#)DEFS.h	5.1 (Berkeley) 4/23/90
 * $FreeBSD: src/sys/amd64/include/asm.h,v 1.18 2007/08/22 04:26:07 jkoshy Exp $
 */

#ifndef _BSD_ASM_H_
#define _BSD_ASM_H_

#ifdef __APPLE__
#include "../i386/osx_asm.h"
#define CNAME(x) EXT(x)
#else
#include "bsd_cdefs.h"

#ifdef PIC
#define	PIC_PLT(x)	x@PLT
#define	PIC_GOT(x)	x@GOTPCREL(%rip)
#else
#define	PIC_PLT(x)	x
#define	PIC_GOT(x)	x
#endif

/*
 * CNAME and HIDENAME manage the relationship between symbol names in C
 * and the equivalent assembly language names.  CNAME is given a name as
 * it would be used in a C program.  It expands to the equivalent assembly
 * language name.  HIDENAME is given an assembly-language name, and expands
 * to a possibly-modified form that will be invisible to C programs.
 */
#define CNAME(csym)		csym
#define HIDENAME(asmsym)	.asmsym

#define _START_ENTRY	.p2align 4,0x90

#if defined(__ELF__)
#define _ENTRY(x)	.text; _START_ENTRY; \
			.globl CNAME(x); .type CNAME(x),@function; CNAME(x):
#define	END(x)		.size x, . - x

#elif defined(_WIN32)
#ifndef _MSC_VER
#define END(x) .end
#define _START_ENTRY_WIN .text; _START_ENTRY
#else
#define END(x) end
#define _START_ENTRY_WIN .code; _START_ENTRY
#endif
#define _ENTRY(x)	_START_ENTRY_WIN; \
            .globl CNAME(x); .section .drectve; .ascii " -export:", #x; \
            .section .text; .def CNAME(x); .scl 2; .type 32; .endef; CNAME(x):
#endif

#ifdef PROF
#define	ALTENTRY(x)	_ENTRY(x); \
			pushq %rbp; movq %rsp,%rbp; \
			call PIC_PLT(HIDENAME(mcount)); \
			popq %rbp; \
			jmp 9f
#define	ENTRY(x)	_ENTRY(x); \
			pushq %rbp; movq %rsp,%rbp; \
			call PIC_PLT(HIDENAME(mcount)); \
			popq %rbp; \
			9:
#else
#define	ALTENTRY(x)	_ENTRY(x)
#define	ENTRY(x)	_ENTRY(x)
#endif


#define RCSID(x)	.text; .asciz x

#undef __FBSDID
#if !defined(lint) && !defined(STRIP_FBSDID)
#define __FBSDID(s)	.ident s
#else
#define __FBSDID(s)	/* nothing */
#endif /* not lint and not STRIP_FBSDID */

#endif
#endif /* !_BSD_ASM_H_ */
