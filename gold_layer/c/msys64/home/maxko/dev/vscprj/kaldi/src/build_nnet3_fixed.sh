#!/usr/bin/env bash
set -e

ROOT=$(pwd)
LOG="$ROOT/build_nnet3.log"

OPENFST_INC="$ROOT/../tools/openfst/include"

echo "==== FULL NNET3 BUILD ===="
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

cd nnet3

rm -f *.o kaldi-nnet3.a

################################
# sources
################################

FILES=$(find . -maxdepth 1 -name "*.cc" \
 | grep -v test \
 | grep -v bin)

# ADD FORCE FILE
FILES="$FILES vtable-force.cc"

echo "$FILES"

g++ "${CXXFLAGS[@]}" -c $FILES >> "$LOG" 2>&1

ar rcs kaldi-nnet3.a *.o

cd ..

echo
echo "==== VERIFY ===="

nm nnet3/kaldi-nnet3.a | grep MaxpoolingComponent
