#!/usr/bin/env bash
set -e

ROOT=$(pwd)
OBJDIR=$ROOT/kaldi_objects
LOG=$ROOT/kaldi_link.log

OPENFST_LIB="$ROOT/../tools/openfst/src/lib/.libs/libfst.a"

mkdir -p "$OBJDIR"
rm -rf "$OBJDIR"/*

echo "==== EXTRACT OBJECTS ===="

LIBS=(
base/kaldi-base.a
matrix/kaldi-matrix.a
util/kaldi-util.a
tree/kaldi-tree.a
feat/kaldi-feat.a
transform/kaldi-transform.a
fstext/kaldi-fstext.a
gmm/kaldi-gmm.a
hmm/kaldi-hmm.a
lat/kaldi-lat.a
decoder/kaldi-decoder.a
ivector/kaldi-ivector.a
nnet2/kaldi-nnet2.a
nnet3/kaldi-nnet3.a
chain/kaldi-chain.a
online2/kaldi-online2.a
lm/kaldi-lm.a
cudamatrix/kaldi-cudamatrix.a
)

for lib in "${LIBS[@]}"; do
    echo "extract $lib"
    (cd "$OBJDIR" && ar x "$ROOT/$lib")
done

echo "objects count:"
ls "$OBJDIR" | wc -l

echo extracting openfst
(cd "$OBJDIR" && ar x "$OPENFST_LIB")

echo "==== LINK DLL ===="

g++ -shared \
-o kaldi.dll \
-Wl,--export-all-symbols \
-Wl,--enable-auto-import \
-Wl,--whole-archive \
"$OBJDIR"/*.o \
-Wl,--no-whole-archive \
-L/ucrt64/lib \
-lopenblas \
-lgfortran \
-lquadmath \
-lpthread \
-ldl \
-lstdc++ \
2>&1 | tee "$LOG"

echo
echo "==== RESULT ===="
ls -lh kaldi.dll
