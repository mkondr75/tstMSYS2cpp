# generated with cmake/gen_cmake_skeleton.py, DO NOT MODIFY.
set(PUBLIC_HEADERS
    agglomerative-clustering.h
    ivector-extractor.h
    logistic-regression.h
    plda.h
    voice-activity-detection.h
)

add_library(kaldi-ivector
    agglomerative-clustering.cc
    ivector-extractor.cc
    logistic-regression.cc
    plda.cc
    voice-activity-detection.cc
)

target_include_directories(kaldi-ivector PUBLIC 
     $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/..>
     $<INSTALL_INTERFACE:include/kaldi>
)

target_link_libraries(kaldi-ivector PUBLIC
    kaldi-transform
    kaldi-gmm
    kaldi-tree
    kaldi-util
    kaldi-matrix
    kaldi-base
    -lcblas
    -llapack
)

if(KALDI_BUILD_TEST)
    add_kaldi_test_executable(NAME ivector-extractor-test SOURCES ivector-extractor-test.cc DEPENDS kaldi-ivector kaldi-hmm)
    add_kaldi_test_executable(NAME logistic-regression-test SOURCES logistic-regression-test.cc DEPENDS kaldi-ivector)
    add_kaldi_test_executable(NAME plda-test SOURCES plda-test.cc DEPENDS kaldi-ivector)
endif()

install(TARGETS kaldi-ivector
    EXPORT kaldi-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT kaldi
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT kaldi
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT kaldi
)
install(FILES ${PUBLIC_HEADERS} DESTINATION include/kaldi/ivector COMPONENT kaldi)

