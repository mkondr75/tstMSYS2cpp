#!/usr/bin/env bash

set -e

ROOT=$(pwd)
LOG="$ROOT/build_all.log"

OPENFST_LIB="$ROOT/../tools/openfst/src/lib/.libs/libfst.a"
OPENFST_INC="$ROOT/../tools/openfst/src/include"

echo "==== CLEAN OLD BUILD ===="
find . -name "*.o" -delete
find . -name "*.a" -delete
rm -f kaldi.dll
rm -f kaldi_link.log

echo "" > "$LOG"

########################################
# FLAGS (VOSK SAFE)
########################################

CXXFLAGS=(
-std=c++17
-O3
-Wa,-mbig-obj
-D_WIN32
-DMS_WIN64
-DHAVE_OPENBLAS
-DOPENFST_NO_MMAP
-DKALDI_NO_CUDA
-DHAVE_CUDA=0
-DKALDI_NO_EXPF
-fpermissive
-I"$ROOT"
-I"$OPENFST_INC"
-I/ucrt64/include
-I/ucrt64/include/openblas
)
########################################
# KALDI MODULES
########################################

DIRS=(
base
matrix
cudamatrix
util
tree
feat
transform
fstext
gmm
hmm
lat
decoder
ivector
nnet2
nnet3
online2
)

########################################
# BUILD STATIC LIBS
########################################

echo "==== BUILD STATIC LIBRARIES ===="

for dir in "${DIRS[@]}"; do

    echo "===== BUILD $dir ====="

    cd "$ROOT/$dir"

if [ "$dir" = "cudamatrix" ]; then
    # cudamatrix MUST be built fully (CPU backend)
    FILES=$(ls *.cc 2>/dev/null \
        | grep -v test \
        || true)
else
    FILES=$(ls *.cc 2>/dev/null \
        | grep -v test \
        | grep -v bin \
        | grep -v cuda-kernels \
        | grep -v nvtx \
        || true)
fi

    if [ -z "$FILES" ]; then
        cd "$ROOT"
        continue
    fi

    g++ "${CXXFLAGS[@]}" -c $FILES >> "$LOG" 2>&1

    ar rcs kaldi-$dir.a *.o

    cd "$ROOT"
done

########################################
# EXPORT ANCHOR
########################################

echo "==== BUILD EXPORT ANCHOR ===="

mkdir -p kaldi_export

cat > kaldi_export/kaldi_export.cc <<'EOF'

#include "base/kaldi-common.h"
#include "matrix/kaldi-matrix.h"
#include "matrix/kaldi-vector.h"

#include "decoder/faster-decoder.h"

#include "nnet2/am-nnet.h"
#include "nnet2/decodable-online.h"

#include "nnet3/nnet-nnet.h"
#include "nnet3/nnet-component-itf.h"

#include "online2/online-nnet3-decoding.h"

using namespace kaldi;

extern "C" {

__declspec(dllexport)
void kaldi_link_anchor()
{
    Matrix<float> m(16,16);
    Vector<float> v(16);

    m.SetZero();
    v.SetZero();

    // ---- nnet3 anchor ----
    nnet3::Nnet n3;

    // force component RTTI
    nnet3::Component *comp = nullptr;
    (void)comp;

    // ---- nnet2 anchor ----
    nnet2::AmNnet am_nnet;

    // decoder options usage
    FasterDecoderOptions opts;

}

}
EOF


g++ "${CXXFLAGS[@]}" \
-c kaldi_export/kaldi_export.cc \
-o kaldi_export/kaldi_export.o

########################################
# LINK DLL
########################################

echo "==== LINK kaldi.dll ===="

g++ -shared -o kaldi.dll \
kaldi_export/kaldi_export.o \
-Wl,--export-all-symbols \
-Wl,--enable-auto-import \
-Wl,--whole-archive \
base/kaldi-base.a \
matrix/kaldi-matrix.a \
cudamatrix/kaldi-cudamatrix.a \
util/kaldi-util.a \
tree/kaldi-tree.a \
feat/kaldi-feat.a \
transform/kaldi-transform.a \
fstext/kaldi-fstext.a \
gmm/kaldi-gmm.a \
hmm/kaldi-hmm.a \
lat/kaldi-lat.a \
decoder/kaldi-decoder.a \
ivector/kaldi-ivector.a \
nnet2/kaldi-nnet2.a \
nnet3/kaldi-nnet3.a \
online2/kaldi-online2.a \
"$OPENFST_LIB" \
-Wl,--no-whole-archive \
-L/ucrt64/lib \
-lopenblas \
-lgfortran \
-lquadmath \
-lpthread \
-ldl \
-lstdc++ \
2>&1 | tee kaldi_link.log

########################################
# RESULT
########################################

echo
echo "==== RESULT ===="
ls -lh kaldi.dll

echo
echo "Export check:"
nm kaldi.dll | grep kaldi_link_anchor || true

echo
echo "CUDA symbols check:"
grep CuMatrix kaldi_link.log || echo OK

echo
echo "==== BUILD COMPLETE ===="
