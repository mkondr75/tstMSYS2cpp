#pragma once

#ifdef _WIN32

// ---- platform ----
#define KALDI_NO_EXPF
#define HAVE_OPENBLAS 1

// disable linux features
#define HAVE_EXECINFO_H 0
#define HAVE_POSIX_MEMALIGN 0
#define HAVE_PTHREAD 0

// allocator
#include <malloc.h>

#define KALDI_MEMALIGN(alignment, size, pp_orig) \
  *(pp_orig) = _aligned_malloc(size, alignment)

#define KALDI_MEMALIGN_FREE(x) \
  _aligned_free(x)

// dlopen replacement
// #define dlopen(a,b) NULL
// #define dlclose(a)
// #define dlsym(a,b) NULL

// pthread stub
// typedef int pthread_t;

#endif
