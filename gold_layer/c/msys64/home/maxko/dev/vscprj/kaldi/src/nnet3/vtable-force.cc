/*
#include "nnet3/nnet-general-component.h"
#include "nnet3/nnet-simple-component.h"

namespace kaldi {
namespace nnet3 {

// FORCE VTABLE EMISSION

MaxpoolingComponent force_maxpool;
BatchNormComponent force_bn;
StatisticsPoolingComponent force_stat;
NaturalGradientAffineComponent force_affine;

}
}
*/
/*
#include "nnet3/nnet-component-itf.h"
#include "nnet3/nnet-simple-component.h"
#include "nnet3/nnet-normalize-component.h"
#include "nnet3/nnet-convolutional-component.h"
#include "nnet3/nnet-general-component.h"

namespace kaldi {
namespace nnet3 {

// force vtables to be emitted

Component *force_component_1 = new RectifiedLinearComponent();
Component *force_component_2 = new AffineComponent();
Component *force_component_3 = new BatchNormComponent();
Component *force_component_4 = new ConvolutionComponent();

}
}
*/
#include "nnet3/nnet-nnet.h"

namespace kaldi {
namespace nnet3 {

// force linker to keep full nnet3 objects

void kaldi_force_nnet3_link()
{
    Nnet nnet;
}

}
}