%rename(FitsHDU) fits_hdu;


class fits_hdu {
public:
	
	//============================================
	//Header manipulation
	//============================================
	/* Returns Header instance. */
	virtual fits_header_record &header( const char *keyword0 );
	virtual fits_header_record &header( long index0 );
		
	/* Set/Add header record. */
    virtual fits_hdu &header_assign( const char *keyword0, 
				     const char *keyword, const char *value, 
				     const char *comment );

    virtual fits_hdu &header_append( const char *keyword, const char *value, 
				     const char *comment );

    /* erase some header records */
    virtual fits_hdu &header_erase_records( const char *keyword0, long num_records );

    /* returns number of header records */
    virtual long header_length() const;

    virtual long header_index( const char *keyword0 ) const;

	//============================================
	//HDU manipulation
	//============================================
	/* returns type of HDU */
	virtual int hdutype() const;
	
	/* change a HDU name */
	virtual fits_hdu &assign_hduname( const char *hduname );
	
	/* returns HDU name */
	virtual const char *hduname() const;
	
};

%extend fits_hdu {
public:
	fits_hdu& header_assign_string(const char *keyword0, 
				     const char *keyword, const char *value, 
				     const char *comment ){
				     $self->header(keyword0).assign(value);
				     $self->header(keyword0).assign_comment(comment);
				     return *($self);
	}
}
