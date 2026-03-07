#!/usr/bin/env bash
set -e

ROOT=$(pwd)
LOG="$ROOT/build_nnet.log"

OPENFST_INC="$ROOT/../tools/openfst/include"

echo "==== REBUILD NNET MODULES ===="
echo "" > "$LOG"

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
nnet2
nnet3
online2
)

build_dir () {

    DIR=$1

    echo "===== BUILD $DIR ====="

    cd "$ROOT/$DIR"

    rm -f *.o kaldi-$DIR.a

    FILES=$(ls *.cc \
        | grep -v test \
        | grep -v bin)

    echo "files:"
    echo "$FILES"

    g++ "${CXXFLAGS[@]}" -c $FILES >> "$LOG" 2>&1

    ar rcs kaldi-$DIR.a *.o

    cd "$ROOT"
}

for d in "${DIRS[@]}"; do
    build_dir "$d"
done

echo
echo "==== VERIFY ===="

nm nnet3/kaldi-nnet3.a | grep MaxpoolingComponent || true

echo
echo "DONE"