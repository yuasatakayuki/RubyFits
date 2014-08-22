%rename(FitsTableHDU) fits_table;

#ifdef SWIGRUBY
%typemap (in) (std::vector <int16_t> &) (std::vector <int16_t> vec) {
  Check_Type ($input, T_ARRAY);
  int len = RARRAY_LEN ($input);
  vec.reserve (len);
  for (int i = 0; i < len; ++i) {
    VALUE ro = rb_ary_entry ($input, i);
    Check_Type (ro, T_FIXNUM);
    vec.push_back (FIX2INT (ro));
  }
  $1 = &vec;
}
%typemap (in) (std::vector <float> &) (std::vector <float> vec) {
  Check_Type ($input, T_ARRAY);
  int len = RARRAY_LEN ($input);
  vec.reserve (len);
  for (int i = 0; i < len; ++i) {
    VALUE ro = rb_ary_entry ($input, i);
    Check_Type (ro, T_FLOAT);
    vec.push_back (NUM2DBL(ro));
  }
  $1 = &vec;
}
#endif

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

%alias fits_table::get_heap "getHeap";
%alias fits_table::put_heap "putHeap";
%alias fits_table::resize_heap "resizeHeap,setHeapSize";
%alias fits_table::heap_length "heapLength,getHeapLength";

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

    /* low-level member functions for heap area                        */
    /* Note that there are no guarantee of byte alignment in heap area */
    /* and data in it are stored in big-endian.                        */

    /* return address of heap area */
    virtual void *heap_ptr();

    /* obtain raw data of heap area */
    /*   offset: byte offset        */
    virtual ssize_t get_heap( void *dest_buf, size_t buf_size ) const;
    virtual ssize_t get_heap( long offset, 
                  void *dest_buf, size_t buf_size ) const;

    /* set raw data of heap area */
    /*   offset: byte offset     */
    //virtual ssize_t put_heap( const void *src_buf, size_t buf_size );
    virtual ssize_t put_heap( long offset, const void *src_buf, size_t buf_size );

    /* change length of heap area */
    virtual fits_table &resize_heap( size_t sz );

    /* returns length of heap area */
    virtual size_t heap_length();

};

%extend fits_table {
public:
	fits_table &eraseColumn(long index0) {
		return $self->erase_cols(index0,1);
	}

	fits_table &eraseColumn(const char *col_name) {
		return $self->erase_cols(col_name,1);
	}

    size_t put_heap_vector( long offset, std::vector<uint8_t>& data ){
        if(data.size()!=0){
            $self->put_heap(offset, (const void*)&(data.at(0)), data.size());
        }
    }

    size_t put_uint8_array_to_heap( long bytePosition, std::vector<uint8_t>& data ){
        long size=(long)data.size();
        if(size!=0){
            $self->put_heap(bytePosition, (const void*)&(data.at(0)), size);
            //adjust endian
            $self->reverse_heap_endian(bytePosition, FITS::BYTE_T, (long)size);
        }
        return bytePosition+data.size()*sizeof(uint8_t);
    }

    size_t put_int16_array_to_heap( long bytePosition, std::vector<int16_t>& data ){
        size_t size=data.size();
        if(size!=0){
            int16_t* bufferPointer;
            mdarray_short buffer(false,&bufferPointer);
            buffer.resize(data.size());
            for(size_t i=0;i<data.size();i++){
                bufferPointer[i]=data[i];
            }
            buffer.reverse_endian(false, 0, size);
            $self->put_heap(bytePosition, buffer.data_ptr(), size*sizeof(int16_t));
        }
        return bytePosition+size*sizeof(int16_t);
    }

    size_t put_int32_array_to_heap( long bytePosition, std::vector<int32_t>& data ){
        size_t size=data.size();
        if(size!=0){
            int32_t* bufferPointer;
            mdarray_int32 buffer(false,&bufferPointer);
            buffer.resize(data.size());
            for(size_t i=0;i<data.size();i++){
                bufferPointer[i]=data[i];
            }
            buffer.reverse_endian(false, 0, size);
            $self->put_heap(bytePosition, buffer.data_ptr(), size*sizeof(int32_t));
        }
        return bytePosition+size*sizeof(int32_t);
    }

    size_t put_float_array_to_heap(long bytePosition, std::vector<float>& data){
        using namespace std;
        using namespace sli;
        size_t size=data.size();
        if(size!=0){
            float *bufferPointer;
            mdarray_float buffer(false,&bufferPointer);
            buffer.resize(data.size());
            for(size_t i=0;i<data.size();i++){
                bufferPointer[i]=data[i];
            }
            buffer.reverse_endian(false, 0, size);
            $self->put_heap(bytePosition, buffer.data_ptr(), size*sizeof(float));
        }
        return bytePosition+data.size()*sizeof(float);
    }

    size_t put_double_array_to_heap(long bytePosition, std::vector<double>& data){
        using namespace std;
        using namespace sli;
        size_t size=data.size();
        if(size!=0){
            double *bufferPointer;
            mdarray_double buffer(false,&bufferPointer);
            buffer.resize(data.size());
            for(size_t i=0;i<data.size();i++){
                bufferPointer[i]=data[i];
            }
            buffer.reverse_endian(false, 0, size);
            $self->put_heap(bytePosition, buffer.data_ptr(), size*sizeof(double));
        }
        return bytePosition+data.size()*sizeof(double);
    }

}

//============================================

