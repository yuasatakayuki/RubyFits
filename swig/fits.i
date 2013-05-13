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
class fits_image:public fits_hdu{};
%include "fits_table.i"
%include "fits_table_col.i"
%include "fits_header_record.i"
%include "fitscc.i"