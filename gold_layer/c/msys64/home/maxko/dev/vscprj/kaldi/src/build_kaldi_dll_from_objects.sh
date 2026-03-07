#!/usr/bin/env bash
set -e

ROOT=$(pwd)
OBJDIR="$ROOT/kaldi_objects"
LOG="$ROOT/kaldi_link.log"
OPENFST_LIB="$ROOT/../tools/openfst/src/lib/.libs/libfst.a"

echo "==== LINK KALDI DLL FROM OBJECTS ===="

rm -f kaldi.dll
rm -f objects.rsp
rm -f "$LOG"

########################################
# rebuild object list (ВАЖНО)
########################################

echo "Generating object list..."

#find "$OBJDIR" -name "*.o" | sort > objects.rsp
#COUNT=$(wc -l < objects.rsp)
#echo "objects count: $COUNT"
#if [ "$COUNT" -lt 100 ]; then
#    echo "ERROR: objects missing"
#    exit 1
#fi

#for f in "$OBJDIR"/*.o; do
#    winpath=$(cygpath -m "$f")
#    echo "$winpath" >> objects.rsp
#done

for dir in \
base \
matrix \
cudamatrix \
util \
tree \
feat \
transform \
fstext \
gmm \
hmm \
lat \
lm \
rnnlm \
ivector \
nnet2 \
nnet3 \
chain \
online2 \
kaldi_export \
decoder
do
    find kaldi_objects -name "${dir}_*.o" >> objects.rsp
done

########################################
# LINK
########################################
g++ -r \
@objects.rsp \
-o kaldi_all.o
#-Wl,--large-address-aware \ #to -Wl,--dynamicbase
#-Wl,--dynamicbase
#-Wl,--image-base,0x140000000 \
#-Wl,--export-all-symbols \

#это оаботало 
#g++ -shared \
#-o kaldi.dll \
#kaldi_all.o \
#-Wl,--enable-auto-import \
#-Wl,--image-base,0x140000000 \
#-Wl,--out-implib,libkaldi.dll.a \
#"$OPENFST_LIB" \
#-L/ucrt64/lib \
#-lopenblas \
#-lgfortran \
#-lquadmath \
#-lpthread \
#-ldl \
#-lstdc++ \
#2>&1 | tee "$LOG"

g++ \
-shared \
-o kaldi.dll \
kaldi_all.o \
"$OPENFST_LIB" \
-Wl,--exclude-libs,ALL \
-Wl,--enable-auto-import \
-Wl,--image-base,0x140000000 \
-Wl,--out-implib,libkaldi.dll.a \
-L/ucrt64/lib \
-lopenblas \
-lgfortran \
-lquadmath \
-lpthread \
-ldl \
-lstdc++ \
2>&1 | tee "$LOG"



#g++ \
#-shared \
#-o kaldi.dll \
#-Wl,--export-all-symbols \
#-Wl,--enable-auto-import \
#-Wl,--allow-multiple-definition \
#@objects.rsp \
#"$OPENFST_LIB" \
#-L/ucrt64/lib \
#-lopenblas \
#-lgfortran \
#-lquadmath \
#-lpthread \
#-ldl \
#-lstdc++ \
#2>&1 | tee "$LOG"

########################################
# RESULT
########################################

echo
echo "==== RESULT ===="
ls -lh kaldi.dll
