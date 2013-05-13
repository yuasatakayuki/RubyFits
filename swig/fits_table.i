%rename(FitsTableHDU) fits_table;

%alias fits_table::col_index "columnIndexOfName,indexOfColumnName,getIndexOfColumnName,getColumnIndex";
%alias fits_table::col_name "columnNameOfIndex,nameOfColumnIndex,getNameOfColumnIndex,getColumnName";
%alias fits_table::col_length "nColumns,getNColumns,getColumnLength,colmunLength";
%alias fits_table::assign_col_name "setColumnName,changeColumnName";
%alias fits_table::erase_cols "eraseColumns,eraseColumn";
%alias fits_table::col "getColumn,column";
%alias fits_table::row_length "nRows,getNRows,nEntries,getNEntries";

%alias fits_table::resize_rows "resizeRows,resizeEntries,resize";
%alias fits_table::append_a_row "appendRow,appendEntry";
%alias fits_table::append_rows "appendRows,appendEntries";
%alias fits_table::insert_a_row "insertRow,insertEntry";
%alias fits_table::insert_rows "insertRows,insertEntries";
%alias fits_table::erase_a_row "eraseRow,eraseEntry";
%alias fits_table::erase_rows "eraseRows";
%alias fits_table::move_rows "moveRows,moveEntries";
%alias fits_table::swap_rows "swapRows,swapEntries";
%alias fits_table::flip_rows "flipRows,flipEntries";

//%alias fits_table::append_a_col "appendColumn,append";
%alias fits_table::insert_a_col "insertColumn,insert";
%alias fits_table::erase_a_col "eraseColumn,erase";

class fits_table : public fits_hdu {
public:

    /* complete initialization (added) */
    virtual fits_table &init( const fits::table_def defs[] );

    /* returns column number */
    virtual long col_index( const char *col_name ) const;

    /* returns column name (TTYPEn) */
    virtual const char *col_name( long col_index ) const;

    /* returns number of columns */
    virtual long col_length() const;
    /* not recommended */
    virtual long col_size() const;		/* same as col_length() */

    /* set/rename column name (TTYPEn) */
    virtual fits_table &assign_col_name( long col_index, const char *newname );
    virtual fits_table &assign_col_name( const char *col_name, 
					 const char *newname );

    /* erase columns */
    virtual fits_table &erase_cols( long index0, long num_cols );
    virtual fits_table &erase_cols( const char *col_name, long num_cols );

		/* get column pointer */
    virtual fits_table_col &col( long col_index );
    virtual fits_table_col &col( const char *col_name );

		//============================================
		// Row manipulation
		//============================================

    /* returns length of rows */
    virtual long row_length() const;
    
    /* appends blank rows */
    virtual fits_table &append_rows( long num_rows );

    /* changes length of rows */
    virtual fits_table &resize_rows( long num_rows );

    /* copy row into row */
    virtual fits_table &move_rows( long src_index, long num_rows,
				   long dest_index );

    /* swap rows */
    virtual fits_table &swap_rows( long src_index, long num_rows,
				   long dest_index );

    /* flip rows */
    virtual fits_table &flip_rows( long src_index, long num_rows );

    /* Note that heavy use of erase_rows() or insert_rows() might cause    */
    /* performance problems, since this needs memory copy for each column. */

    /* erase rows */
    virtual fits_table &erase_rows( long index, long num_rows );

    /* append a blank row */
    virtual fits_table &append_a_row();

    /* insert a blank row */
    virtual fits_table &insert_a_row( long index );

    /* erase a row */
    virtual fits_table &erase_a_row( long index );

    /* insert blank rows */
    virtual fits_table &insert_rows( long index, long num_rows );

		//============================================
		// Column manipulation
		//============================================
    /* append a column */
    virtual fits_table &append_a_col( const fits_table_col &src );

    /* insert a column */
    virtual fits_table &insert_a_col( long col_index, 
				      const fits_table_col &src );
    virtual fits_table &insert_a_col( const char *col_name, 
				      const fits_table_col &src );

    /* erase a column */
    virtual fits_table &erase_a_col( long col_index );
    virtual fits_table &erase_a_col( const char *col_name );

};

%extend fits_table {
public:
	fits_table &eraseColumn(long index0) {
		return $self->erase_cols(index0,1);
	}
	fits_table &eraseColumn(const char *col_name) {
		return $self->erase_cols(col_name,1);
	}
}

//============================================

