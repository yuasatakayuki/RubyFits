%rename(FitsTableColumn) fits_table_col;

%alias fits_table_col::name "getName,getColumnName,columnName";
%alias fits_table_col::assign_name "setName,setColumnName";

%alias fits_table_col::type "getType,getDataType";
%alias fits_table_col::elem_length "elementLength,repetationLength,repeatLength,repetationSize,repeatSize,getElementLength,getRepetationLength,getRepetationSize,getRepeatLength,getRepeatSize";

%alias fits_table_col::tunit "getUnit,unit,getTUNIT";
%alias fits_table_col::assign_tunit "setUnit,setTUNIT";
%alias fits_table_col::erase_tunit "eraseUnit,eraseTUNIT";

%alias fits_table_col::length "nRows,nEntries,getNEntries,getNRows";
%alias fits_table_col::resize "setNRows,setNEntries,expand";


%alias fits_table_col::dvalue "getAsFloating";
%alias fits_table_col::lvalue "getAsLong";
%alias fits_table_col::llvalue "getAsLongLong,getAsInteger";
%alias fits_table_col::bvalue "getAsBoolean";
%alias fits_table_col::svalue "getAsString";


%alias fits_table_col::heap_is_used "isVariableLengthArray,isVariableLength,variableLength,variableLength?";
%alias fits_table_col::heap_type "getDataTypeOfVariableLengthArray,variableLengthArrayDataType";
%alias fits_table_col::max_array_length "getMaxLength,getMaxSize,getMaxLengthForVariableLengthArray,getMaxSizeForVariableLengthArray";
%alias fits_table_col::array_length "arrayLength,getArrayLengthOfRow,getArrayLength";

%alias fits_table_col::construct_from_table_column_definition "constructFromTableColumnDefinition";

class fits_table_col {
public:
		/* get/set column name (TTYPEn) */
		virtual const char *name() const;
		virtual fits_table_col &assign_name( const char *new_name );

    /*
     * obtain type, byte-length, etc.
     *
     * When .type() == FITS::STRING_T, member functions such as .bytes()
     * return special values:
     *                           .bytes()  .dcol_len  .drow_len  .elem_length()
     * TFORMn=120A                 120         1           1          1
     * TFORMn=120A10                10        12           1         12
     * TFORMn=120A10,TDIMn=(6,2)    10         6           2         12
     * TFORMn=120A,TDIMn=(10,6,2)   10         6           2         12
     *
     * .type() == FITS::BIT_T is also special, i.e., .bytes() returns 1.
     *
     * See fits.h for type code definition.
     */
    virtual int type() const;		/* returns FITS::DOUBLE_T for 16D    */
    virtual long bytes() const;		/* sizeof(double). returns 1 for 1X  */
    virtual long elem_length() const;	/* return 16 for 16D                 */
    virtual long elem_byte_length() const;	/* .bytes() * .elem_length() */
    virtual long dcol_length() const;	/* returns 8 when TDIM = (8,2)       */
    virtual long drow_length() const;	/* returns 2 when TDIM = (8,2)       */


    /* returns value of TUNITn */
    virtual const char *tunit() const;
    /* for TUNITn */
    virtual fits_table_col &assign_tunit( const char *unit );
    virtual fits_table_col &erase_tunit();

    /*
     * Member functions to obtain length of rows. 
     */
    virtual long length() const;
    virtual long size() const;				/* same as length() */

    /* resize number of rows */
    virtual fits_table_col &resize( long num_rows );

		//============================================
		//Read Row
		//============================================

    /*
     * high-level APIs to read a cell.
     *  - TSCAL and TZERO are applied.
     *  - NULL value is handled.
     */

    /* dvalue() member functions return NAN when the cell has NULL value.    */
    /* Programmers can write the code to detect NULL of any types like this: */
    /*   if ( ! isfinite( tbl.col("FOO").dvalue(i)) ) printf("It is NULL");  */
    virtual double dvalue( long row_index ) const;
    virtual double dvalue( long row_index,
			  long elem_index, long repetition_idx = 0 ) const;

    /* return value of lvalue(), llvalue() and bvalue() cannot be used */
    /* to test NULL or non-NULL value.                                 */

    virtual long lvalue( long row_index ) const;
    virtual long lvalue( long row_index,
			 long elem_index, long repetition_idx = 0 ) const;

    virtual long long llvalue( long row_index ) const;
    virtual long long llvalue( long row_index,
			      long elem_index, long repetition_idx = 0 ) const;

    virtual bool bvalue( long row_index ) const;
    virtual bool bvalue( long row_index,
			 long elem_index, long repetition_idx = 0 ) const;

    /* svalue() member functions return NULL value string when the */
    /* cell has NULL value.  The NULL value string can be defined  */
    /* by assign_null_svalue().                                    */
    virtual const char *svalue( long row_index );
    virtual const char *svalue( long row_index,
				long elem_idx, long repetition_idx = 0 );
	
		/* LOGICAL_T */
    virtual int logical_value( long row_index ) const;
    virtual int logical_value( long row_index,
			      long elem_index, long repetition_idx = 0 ) const;

    /* SHORT_T */
    virtual short short_value( long row_index ) const;
    virtual short short_value( long row_index,
			      long elem_index, long repetition_idx = 0 ) const;

    /* BYTE_T */
    virtual unsigned char byte_value( long row_index ) const;
    virtual unsigned char byte_value( long row_index,
				long elem_idx, long repetition_idx = 0 ) const;

    /* BIT_T */
    virtual long bit_value( long row_index ) const;
    virtual long bit_value( long row_index,
			    long elem_index, long repetition_idx = 0, 
			    int nbit = 1 ) const;

		//============================================
		//Write rows
		//============================================
    /*
     * high-level APIs to write a cell.
     *  - TSCAL and TZERO are applied.
     *  - NULL value is handled.
     */

    /* assign(NAN) sets NULL value to a cell of a columns of any types. */
    virtual fits_table_col &assign( double value, long row_index );
    virtual fits_table_col &assign( double value, long row_index,
			       long elem_index, long repetition_idx = 0 );

    virtual fits_table_col &assign( float value, long row_index );
    virtual fits_table_col &assign( float value, long row_index,
			       long elem_index, long repetition_idx = 0 );

    virtual fits_table_col &assign( long long value, long row_index );
    virtual fits_table_col &assign( long long value, long row_index,
			       long elem_index, long repetition_idx = 0 );

    virtual fits_table_col &assign( long value, long row_index );
    virtual fits_table_col &assign( long value, long row_index,
			       long elem_index, long repetition_idx = 0 );

    virtual fits_table_col &assign( int value, long row_index );
    virtual fits_table_col &assign( int value, long row_index,
			       long elem_index, long repetition_idx = 0 );

    /* Giving NULL value string to `value' arg will set NULL     */
    /* value to a cell.  The NULL value string can be defined by */
    /* assign_null_svalue().                                     */
    virtual fits_table_col &assign( const char *value, long row_index );
    virtual fits_table_col &assign( const char *value, long row_index,
			       long elem_index, long repetition_idx = 0 );

    /*
     * low-level APIs to write a cell.
     */

    /* LOGICAL_T                                                      */
    /* argument `value' takes 'T', 'F' or '\0'. ('\0' indicates NULL) */
    virtual fits_table_col &assign_logical( int value, long row_index );
    virtual fits_table_col &assign_logical( int value, long row_index,
				long elem_index, long repetition_idx = 0 );

    /* SHORT_T */
    virtual fits_table_col &assign_short( short value, long row_index );
    virtual fits_table_col &assign_short( short value, long row_index,
			      long elem_index, long repetition_idx = 0 );

    /* BYTE_T */
    virtual fits_table_col &assign_byte( unsigned char value, long row_index );
    virtual fits_table_col &assign_byte( unsigned char value, long row_index,
			     long elem_index, long repetition_idx = 0 );

    /* BIT_T */
    virtual fits_table_col &assign_bit( long value, long row_index );
    virtual fits_table_col &assign_bit( long value, long row_index,
		      long elem_index, long repetition_idx = 0, int nbit = 1 );
		      
		      
		//============================================
		//Variable length array
		//============================================ 
    /*
     * obtain heap information
     */
    virtual bool heap_is_used() const;	/* returns true when TFORM is ?P?    */
    virtual int heap_type() const;	/* returns FITS::DOUBLE_T for 1PD    */
    virtual long heap_bytes() const;	/* returns sizeof(double) when 1PD   */
    virtual long max_array_length() const;	/* returns 999 when 1PD(999) */

    /* returns length of variable length array at specified row */
    virtual long array_length( long row_idx, long elem_idx = 0 ) const;
};

%extend fits_table_col {
	
	void initialize_column(const char *ttype, const char *ttype_comment, const char *talas, const char *telem, 
	const char *tunit, const char *tunit_comment, const char *tdisp, const char *tform, const char *tdim) {
		using namespace sli;
		using namespace std;
		sli::fits::table_def defs[] = { { ttype, ttype_comment, talas, telem, tunit, tunit_comment, tdisp, tform, tdim }, {
				NULL } };
		fits_table* newTable = new fits_table;
		newTable->init(defs);
		fits_table_col column = newTable->col(ttype);
		$self->init(column);
		delete newTable;
	}

	//renamed to initializeWithNameAndFormat
	void initialize_with_name_and_format(std::string ttype, std::string tform){
		using namespace sli;
		using namespace std;
		sli::fits::table_def defs[] = { { ttype.c_str(), "","","","","","", tform.c_str(),"" }, {
				NULL } };
		fits_table* newTable = new fits_table;
		newTable->init(defs);
		fits_table_col column = newTable->col(ttype.c_str());
		$self->init(column);
		delete newTable;
	}

}
/*
class FitsTableColumn : public fits_table_col {
public:	
	void initializeColumn(
	const char *ttype,
	const char *ttype_comment,
	const char *talas,
	const char *telem,
	const char *tunit,
	const char *tunit_comment,
	const char *tdisp,
	const char *tform,
	const char *tdim);
	
	FitsTableColumn();
	FitsTableColumn(std::string ttype, std::string tform);
	void initializeWithOptions(std::string ttype, std::string tform, std::map<std::string, std::string> options);
};
*/