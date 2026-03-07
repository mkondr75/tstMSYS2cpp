#!/usr/bin/env bash
set -e

ROOT=$(pwd)
OBJDIR="$ROOT/kaldi_objects"
ARCHDIR="$ROOT/kaldi_arch"
LOG="$ROOT/build_objects.log"

OPENFST_INC="$ROOT/../tools/openfst/include"

mkdir -p "$OBJDIR"
mkdir -p "$ARCHDIR"

rm -f "$OBJDIR"/*.o
rm -f "$ARCHDIR"/*.a

echo "" > "$LOG"

echo "==== BUILD ALL OBJECTS ===="
#-D_WIN32
#-DMS_WIN64
#-DOPENFST_NO_MMAP

CXXFLAGS=(
-std=c++17
-O3
-Wa,-mbig-obj
-DHAVE_OPENBLAS
-fpermissive
-I"$ROOT"
-I"$OPENFST_INC"
-I/ucrt64/include
-I/ucrt64/include/openblas
)

DIRS=(
base
matrix
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
chain
lm
rnnlm
online2
cudamatrix
)
#kaldi_export

########################################
# compile objects
########################################

for dir in "${DIRS[@]}"; do
    echo "===== COMPILE $dir ====="
    cd "$ROOT/$dir"
    shopt -s nullglob
    for f in *.cc; do
        [[ "$f" == *test* ]] && continue
        echo "compile $dir/$f"
        g++ "${CXXFLAGS[@]}" \
            -c "$f" \
            -o "$OBJDIR/${dir}_$(basename "$f" .cc).o" \
            >> "$LOG" 2>&1
    done
    cd "$ROOT"
done

########################################
# build static libraries
########################################

echo
echo "==== BUILD ARCHIVES ===="

for dir in "${DIRS[@]}"; do
    echo "archive kaldi-$dir.a"

    OBJS=$(ls "$OBJDIR"/${dir}_*.o 2>/dev/null || true)

    if [ -z "$OBJS" ]; then
        continue
    fi

    ar rcs "$ARCHDIR/kaldi-$dir.a" $OBJS
done

########################################
# result
########################################

echo
echo "==== RESULT ===="
ls -lh "$ARCHDIR"
echo
echo "Total archives:"
ls "$ARCHDIR" | wc -l