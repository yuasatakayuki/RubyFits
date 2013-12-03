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
%}


%typemap (in) (std::vector <uint8_t> &) (std::vector <uint8_t> vec) {
  Check_Type ($input, T_ARRAY);
  int len = RARRAY_LEN ($input);
  vec.reserve (len);
  for (int i = 0; i < len; ++i) {
    VALUE ro = rb_ary_entry ($input, i);
    Check_Type (ro, T_FIXNUM);
    vec.push_back (FIX2UINT (ro));
  }
  $1 = &vec;
}


%include "std_string.i"
%include "std_vector.i"
%include "exception.i"

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