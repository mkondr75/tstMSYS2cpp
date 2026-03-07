#!/usr/bin/env bash
set -e

ROOT=$(pwd)
LOG="$ROOT/build_chain_lm.log"

OPENFST_INC="$ROOT/../tools/openfst/include"

echo "==== BUILD chain + lm ===="
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

########################################
build_lib () {

DIR=$1
LIB=$2

echo "===== BUILD $DIR ====="

cd "$ROOT/$DIR"

rm -f *.o "$LIB"

FILES=$(ls *.cc 2>/dev/null \
 | grep -v test \
 | grep -v bin \
 || true)

if [ -z "$FILES" ]; then
    echo "NO FILES IN $DIR"
    cd "$ROOT"
    return
fi

g++ "${CXXFLAGS[@]}" -c $FILES >> "$LOG" 2>&1

ar rcs "$LIB" *.o

cd "$ROOT"
}

########################################

build_lib chain kaldi-chain.a
build_lib lm kaldi-lm.a

########################################

echo
echo "==== RESULT ===="

ls -lh chain/kaldi-chain.a
ls -lh lm/kaldi-lm.a

echo
echo "DONE"
