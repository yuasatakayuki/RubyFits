%rename(FitsHDU) fits_hdu;

%alias fits_hdu::header "getHeaderRecord,getHeader,getHeaderEntry";
%alias fits_hdu::header_assign "addHeaderRecord,addHeaderEntry,addHeader,appendHeader,appendHeaderRecord,appendHeaderEntry,setHeader,setHeaderRecord,setHeaderEntry,insertHeader,insertHeaderEntry,insertHeaderRecord";
%alias fits_hdu::header_length "getHeaderLength,getHeaderSize,getNHeaderEntry,getHHeaders,nHeaders,nHeaderEntries,headerLength,headerSize";


%alias fits_hdu::hdutype "getHDUType,hduType,type,getType";
%alias fits_hdu::hduname "getHDUName,getName,hduName,name";
%alias fits_hdu::asign_hduname "setHDUName";

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
				     const fits_header_record &obj );
    virtual fits_hdu &header_assign( const char *keyword0, 
				     const char *keyword, const char *value, 
				     const char *comment );
    virtual fits_hdu &header_assign( const char *keyword0, 
				const char *keyword, const char *description );

    /* erase some header records */
    virtual fits_hdu &header_erase_records( const char *keyword0, long num_records );

    /* returns number of header records */
    virtual long header_length() const;


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