#include "sli/fitscc.h"
#include "sli/fits_table_col.h"
#include <string>
#include <iostream>
#include <map>

class FitsFile: public sli::fitscc {
public:
	FitsFile() {
	}
	FitsFile(std::string fileName) {
		this->read_stream(fileName.c_str());
	}

	/* .hdu() returns reference of an object of fits_hdu class. */
	/* This can be used to access FITS header of any HDU types. */
	virtual sli::fits_hdu &hdu_(long index) {
		return this->hdu(index);
	}
	virtual sli::fits_hdu &hdu_(const char *extname) {
		return this->hdu(extname);
	}
};
