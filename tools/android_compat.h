#pragma once
#ifndef FALLTHROUGH
# if defined(__has_cpp_attribute) && __has_cpp_attribute(fallthrough)
#  define FALLTHROUGH [[fallthrough]]
# else
#  define FALLTHROUGH ((void)0)
# endif
#endif
