#!/usr/bin/env bash
set -e

ROOT=$(pwd)
OBJDIR="$ROOT/kaldi_objects"
LOG="$ROOT/build_objects.log"

OPENFST_INC="$ROOT/../tools/openfst/include"

mkdir -p "$OBJDIR"
rm -f "$OBJDIR"/*.o

echo "" > "$LOG"

echo "==== BUILD ALL OBJECTS ===="

CXXFLAGS=(
-std=c++17
-O3
-Wa,-mbig-obj
-D_WIN32
-DMS_WIN64
-DHAVE_OPENBLAS
-DOPENFST_NO_MMAP
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
kaldi_export
)

for dir in "${DIRS[@]}"; do
    echo "===== $dir ====="

    cd "$ROOT/$dir"
    shopt -s nullglob
    for f in *.cc; do
        [[ "$f" == *test* ]] && continue
        # [[ "$f" == *bin* ]] && continue

        echo "compile $dir/$f"

        g++ "${CXXFLAGS[@]}" \
            -c "$f" \
            -o "$OBJDIR/${dir}_$(basename "$f" .cc).o" \
            >> "$LOG" 2>&1
    done

    cd "$ROOT"
done

echo
echo "==== RESULT ===="
ls "$OBJDIR" | wc -l
