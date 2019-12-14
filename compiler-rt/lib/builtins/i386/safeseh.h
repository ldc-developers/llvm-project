#ifdef _MSC_VER

#define WIN32_SAFE_SEH_HEADER \
.def    @feat.00; \
.scl    3; \
.type   0; \
.endef; \
.globl  @feat.00; \
.set    @feat.00, 1;

#else

#define WIN32_SAFE_SEH_HEADER

#endif
