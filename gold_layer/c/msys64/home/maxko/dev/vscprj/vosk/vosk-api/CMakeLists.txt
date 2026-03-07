cmake_minimum_required(VERSION 3.16)
project(vosk-api LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. Флаги компиляции (ABI соответствие и оптимизация)
add_compile_options(
    -O3
    -Wa,-mbig-obj
    -fpermissive
    -DHAVE_OPENBLAS
    -D_FILE_OFFSET_BITS=64
)

# 2. Пути включения
include_directories(
    C:/msys64/home/maxko/dev/vscprj/kaldi/src
    C:/msys64/home/maxko/dev/vscprj/kaldi/tools/openfst/src/include
    C:/msys64/ucrt64/include
    C:/msys64/ucrt64/include/openblas
)

# 3. Таргет библиотеки
add_library(vosk SHARED
    src/language_model.cc
    src/model.cc
    src/recognizer.cc
    src/spk_model.cc
    src/postprocessor.cc
    src/vosk_api.cc
    vosk.def
)

target_compile_definitions(vosk PRIVATE VOSK_EXPORTS)

# 4. Линковка (Полная изоляция от внешних DLL)
target_link_libraries(vosk PRIVATE
    -Wl,--whole-archive
    # Расширения OpenFST
    "C:/msys64/home/maxko/dev/vscprj/kaldi/tools/openfst/src/extensions/lookahead/.libs/libfstlookahead.a"
    "C:/msys64/home/maxko/dev/vscprj/kaldi/tools/openfst/src/extensions/ngram/.libs/libfstngram.a"
    "C:/msys64/home/maxko/dev/vscprj/kaldi/tools/openfst/src/extensions/far/.libs/libfstfar.a"

    # Kaldi (Ваши 19 линий)
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-online2.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-rnnlm.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-lm.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-chain.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-nnet3.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-nnet2.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-ivector.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-cudamatrix.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-decoder.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-lat.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-hmm.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-gmm.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-fstext.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-transform.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-feat.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-tree.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-matrix.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-util.a
    C:/msys64/home/maxko/dev/vscprj/kaldi/src/kaldi_arch/kaldi-base.a
    -Wl,--no-whole-archive

    # Базовый OpenFST
    "C:/msys64/home/maxko/dev/vscprj/kaldi/tools/openfst/src/lib/.libs/libfst.a"

    # СЕКЦИЯ СТАТИКИ (Прямые пути к .a файлам)
    -Wl,--start-group
    "C:/msys64/ucrt64/lib/libopenblas.a"
    "C:/msys64/ucrt64/lib/libdl.a"
    "C:/msys64/ucrt64/lib/libgfortran.a"
    "C:/msys64/ucrt64/lib/libgomp.a"
    "C:/msys64/ucrt64/lib/libquadmath.a"
    "C:/msys64/ucrt64/lib/libwinpthread.a"
    m
    kernel32
    advapi32
    user32
    -Wl,--end-group
)

# 5. Опции линкера
target_link_options(vosk PRIVATE
    -static-libgcc
    -static-libstdc++
    -Wl,--exclude-libs,ALL
    -Wl,--enable-auto-import
)

# 6. Секция установки
install(TARGETS vosk RUNTIME DESTINATION bin LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)
install(FILES src/vosk_api.h DESTINATION include)
