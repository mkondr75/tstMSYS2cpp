#!/usr/bin/env bash
set -e

ROOT=$(pwd)
ARCHDIR="$ROOT/kaldi_arch"
LOG="$ROOT/build_kaldi_dll.log"

OPENFST_LIB="$ROOT/../tools/openfst/src/lib/.libs/libfst.a"

echo "==== BUILD KALDI DLL FROM ARCHIVES ===="
echo "" > "$LOG"

cd "$ARCHDIR"

#
# Kaldi library order matters
#
KALDI_LIBS=(
kaldi-base.a
kaldi-util.a
kaldi-matrix.a
kaldi-tree.a
kaldi-feat.a
kaldi-transform.a
kaldi-fstext.a
kaldi-gmm.a
kaldi-hmm.a
kaldi-lat.a
kaldi-decoder.a
kaldi-cudamatrix.a
kaldi-ivector.a
kaldi-nnet2.a
kaldi-nnet3.a
kaldi-chain.a
kaldi-lm.a
kaldi-rnnlm.a
kaldi-online2.a
)
#kaldi-kaldi_export.a

echo "Linking kaldi.dll ..."
####
#g++ \
#-shared \
#-o "$ROOT/kaldi.dll" \
#-Wl,--whole-archive \
#"${KALDI_LIBS[@]}" \
#-Wl,--no-whole-archive \
#"$OPENFST_LIB" \
#-Wl,--exclude-libs,ALL \
#-Wl,--enable-auto-import \
#-Wl,--out-implib,"$ROOT/libkaldi.dll.a" \
#-L/ucrt64/lib \
#-lopenblas \
#-lgfortran \
#-lquadmath \
#-lpthread \
#-ldl \
#-lstdc++ \
#2>&1 | tee -a "$LOG"
####
####
g++ \
-shared \
-o "$ROOT/kaldi.dll" \
-Wl,--whole-archive \
"${KALDI_LIBS[@]}" \
-Wl,--no-whole-archive \
"$OPENFST_LIB" \
-Wl,--exclude-libs,ALL \
-Wl,--exclude-all-symbols \
-Wl,--enable-auto-import \
-Wl,--out-implib,"$ROOT/libkaldi.dll.a" \
-L/ucrt64/lib \
-lopenblas \
-lgfortran \
-lquadmath \
-lpthread \
-ldl \
-lstdc++ \
2>&1 | tee -a "$LOG"
####
#g++ \
#-shared \
#-o "$ROOT/kaldi.dll" \
#-Wl,--start-group \
#-Wl,--whole-archive \
#"${KALDI_LIBS[@]}" \
#-Wl,--no-whole-archive \
#-Wl,--end-group \
#"$OPENFST_LIB" \
#-Wl,--exclude-libs,ALL \
#-Wl,--enable-auto-import \
#-Wl,--out-implib,"$ROOT/libkaldi.dll.a" \
#-Wl,--hash-size=65536 \
#-L/ucrt64/lib \
#-lopenblas \
#-lgfortran \
#-lquadmath \
#-lpthread \
#-ldl \
#-lstdc++ \
#2>&1 | tee -a "$LOG"

echo
echo "==== RESULT ===="
ls -lh "$ROOT/kaldi.dll"
ls -lh "$ROOT/libkaldi.dll.a"

echo
echo "DONE."
