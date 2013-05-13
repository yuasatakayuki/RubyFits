#include "fitscc.h"
#include "fits_table_col.h"
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

namespace Fits {
class FitsTableColumn;
}

/*
class FitsTableColumn: sli::fits_table_col {
public:
	void initializeColumn(const char *ttype, const char *ttype_comment, const char *talas, const char *telem,
	const char *tunit, const char *tunit_comment, const char *tdisp, const char *tform, const char *tdim) {
		using namespace sli;
		using namespace std;
		sli::fits::table_def defs[] = { { ttype, ttype_comment, talas, telem, tunit, tunit_comment, tdisp, tform, tdim }, {
				NULL } };
		fits_table* newTable = new fits_table;
		newTable->init(defs);
		fits_table_col column = newTable->col(ttype);
		this->init(column);
		delete newTable;
	}

	FitsTableColumn() {
	}
	FitsTableColumn(std::string ttype, std::string tform) {
		initializeColumn(ttype.c_str(), "", "", "", "", "", "", tform.c_str(), "");
	}

	void initializeWithOptions(std::string ttype, std::string tform, std::map<std::string, std::string> options) {
		initializeColumn(ttype.c_str(), options["TTYPECOMMENT"].c_str(), options["TALAS"].c_str(), options["TELEM"].c_str(),
				options["TUNIT"].c_str(), options["TUNITCOMMENT"].c_str(), options["TDISP"].c_str(), tform.c_str(),
				options["TDIM"].c_str());
	}

};
*/
