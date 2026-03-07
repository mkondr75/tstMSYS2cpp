# generated with cmake/gen_cmake_skeleton.py, DO NOT MODIFY.
set(PUBLIC_HEADERS
    kaldi-kws.h
    kws-functions.h
    kws-scoring.h
)

add_library(kaldi-kws
    kws-functions.cc
    kws-functions2.cc
    kws-scoring.cc
)

target_include_directories(kaldi-kws PUBLIC 
     $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/..>
     $<INSTALL_INTERFACE:include/kaldi>
)

target_link_libraries(kaldi-kws PUBLIC
    kaldi-lat
    kaldi-hmm
    kaldi-tree
    kaldi-util
    kaldi-matrix
    kaldi-base
    -lcblas
    -llapack
)


install(TARGETS kaldi-kws
    EXPORT kaldi-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT kaldi
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT kaldi
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT kaldi
)
install(FILES ${PUBLIC_HEADERS} DESTINATION include/kaldi/kws COMPONENT kaldi)

