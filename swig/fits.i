%module fits
%{
#include "sli/fits.h"
#include "sli/fitscc.h"
#include "sli/fits_hdu.h"
#include "sli/fits_image.h"
#include "sli/fits_header_record.h"
#include "sli/fits_table.h"
#include "FitsFile.h"
using namespace sli;

#include "ruby.h"
#include "ruby/intern.h"
extern "C" { VALUE rb_ary_new_capa(long capa); }

%}

%include "std_string.i"
%include "std_vector.i"
%include "exception.i"

/*
namespace std{
    %template(VectorFloat) vector< float >;
}
*/
%template(DoubleVector) std::vector< double >;


#include "sli/fits.h"
#include "sli/fitscc.h"
#include "sli/fits_hdu.h"
#include "sli/fits_image.h"
#include "sli/fits_header_record.h"
#include "sli/fits_table.h"


%include "fits_hdu.i"
%include "fits_image.i"
%include "fits_table.i"
%include "fits_table_col.i"
%include "fits_header_record.i"
%include "fitscc.i"
