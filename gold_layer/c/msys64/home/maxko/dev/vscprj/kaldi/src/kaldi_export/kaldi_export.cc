#include "base/kaldi-common.h"
#include "matrix/kaldi-matrix.h"
#include "matrix/kaldi-vector.h"

#include "decoder/faster-decoder.h"

#include "nnet2/nnet-nnet.h"
#include "nnet2/decodable-online-looped.h"

#include "nnet3/nnet-nnet.h"
#include "nnet3/nnet-simple-component.h"
#include "nnet3/nnet-general-component.h"

#include "online2/online-nnet3-decoding.h"

#include "cudamatrix/cu-matrix.h"

using namespace kaldi;
using namespace kaldi::nnet3;

extern "C" {

__declspec(dllexport)
void kaldi_link_anchor()
{
    Matrix<float> m(8,8);
    Vector<float> v(8);

    m.SetZero();
    v.SetZero();

    // ---- FORCE VTABLES ----
    MaxpoolingComponent a;
    BatchNormComponent b;
    StatisticsPoolingComponent c;
    NaturalGradientAffineComponent d;

    CuMatrix<float> gpu_stub;
}

}