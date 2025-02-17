// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include "../assembly.h"
#include "safeseh.h"

// float __floatdisf(di_int a);

// This routine has some extra memory traffic, loading the 64-bit input via two
// 32-bit loads, then immediately storing it back to the stack via a single 64-bit
// store.  This is to avoid a write-small, read-large stall.
// However, if callers of this routine can be safely assumed to store the argument
// via a 64-bt store, this is unnecessary memory traffic, and should be avoided.
// It can be turned off by defining the TRUST_CALLERS_USE_64_BIT_STORES macro.

#ifdef __i386__

.text
WIN32_SAFE_SEH_HEADER
.balign 4
DEFINE_COMPILERRT_FUNCTION(__floatdisf)
#ifndef TRUST_CALLERS_USE_64_BIT_STORES
	movd		4(%esp),	%xmm0
	movd		8(%esp),	%xmm1
	punpckldq	%xmm1,		%xmm0
	movq		%xmm0,		4(%esp)
#endif
	fildll		4(%esp)
	fstps		4(%esp)
	flds		4(%esp)
	ret
END_COMPILERRT_FUNCTION(__floatdisf)

#endif // __i386__

NO_EXEC_STACK_DIRECTIVE

