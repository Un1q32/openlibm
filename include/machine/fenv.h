#ifndef _MACHINE_FENV_H_
#define _MACHINE_FENV_H_

#if defined(__arm__) || defined(__arm64__)
#include <machine/arm/fenv.h>
#elif defined(__i386__) || defined(__x86_64__)
#include <machine/x86/fenv.h>
#else
#error architecture not supported
#endif

#endif
