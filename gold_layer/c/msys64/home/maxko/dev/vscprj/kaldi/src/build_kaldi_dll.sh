echo "==== EXTRACT OBJECTS ===="

OBJDIR=kaldi_objects
rm -rf "$OBJDIR"
mkdir "$OBJDIR"
OPENFST_LIB="c:\\msys64\\home\\maxko\\dev\\vscprj\\kaldi\\tools\\openfst\\src\\lib\\.libs\\libfst.a "


LIBS=(
../base/kaldi-base.a
../matrix/kaldi-matrix.a
../cudamatrix/kaldi-cudamatrix.a   # ← ВОТ ЭТО КЛЮЧ
../util/kaldi-util.a
../tree/kaldi-tree.a
../feat/kaldi-feat.a
../transform/kaldi-transform.a
../ivector/kaldi-ivector.a   # ← ДО nnet3
../fstext/kaldi-fstext.a
../gmm/kaldi-gmm.a
../hmm/kaldi-hmm.a
../lat/kaldi-lat.a
../decoder/kaldi-decoder.a
../nnet3/kaldi-nnet3.a
../nnet2/kaldi-nnet2.a
../online2/kaldi-online2.a
"$OPENFST_LIB"
)

cd "$OBJDIR"

for lib in "${LIBS[@]}"; do
    echo "extracting $lib"
    ar x "$lib"
done

cd ..
