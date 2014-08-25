%alias fitscc::read_stream "open,read";
%alias fitscc::writeToFile "saveToFile,writeToFile,write,save,writeTo,saveTo,saveAs";
%alias fitscc::length "getNHDU,getHDUSize,getHDULength,hduLength,nHDUs";
%alias fitscc::erase "deleteHDU,eraseHDU";
%alias fitscc::hduname "getHDUName,hduName";
%alias fitscc::extname "getExtensionName,extensionName,extName";
%alias fitscc::assign_hduname "setHDUName";
%alias fitscc::assign_extname "setExtensionName";
%alias fitscc::read_template "readTemplate";
%alias fitscc::read_template "constructFromTemplate";
//%alias fitscc::hdu "getHDU";

class fitscc{
public:
		/* Constructor. */
		fitscc();

    /* write a FITS file to stream (only for power users) */
    virtual ssize_t write_stream( const char *path );

    /* read a FITS file from stream                                          */
    /* These member functions accepts URL (http:// or ftp://) and compressed */
    /* files. (.gz or .bzip2)                                                */
    /* `path' arg can take string like "ftp://username:password@ftp.com/".   */
    ssize_t read_stream( const char *path );

    /* read a FITS template and create an instance */
    ssize_t read_template( int flags, const char *path );
    
    /* returns class level                                    */
    /* Class level is used when inherited classes are defined */
    int classlevel() const;

    /* This returns byte length of FITS file that will be written */
    ssize_t stream_length();
    /* not recommended */
    ssize_t stream_size();		/* same as stream_length() */

    /* returns length of HDUs */
    long length() const;
    /* not recommended */
    long size() const;			/* same as length() */
    /*
     * append an image HDU 
     */
    fitscc &append_image( const char *extname, long long extver );
    fitscc &append_image( const char *extname, long long extver,
			   int type, long naxisx[], long ndim, bool init_buf );
    fitscc &append_image( const char *extname, long long extver,
		 int type, long naxis0 = 0, long naxis1 = 0, long naxis2 = 0 );
    fitscc &append_image( const char *extname, long long extver,
				  const fits_image &src );
    fitscc &append_image( const fits_image &src );

    /*
     * append a binary table HDU or an ASCII table HDU 
     */
    fitscc &append_table( const char *extname, long long extver,
				  bool ascii = false );
    fitscc &append_table( const char *extname, long long extver,
			    const fits::table_def defs[], bool ascii = false );
    fitscc &append_table( const char *extname, long long extver,
			const fits::table_def_all defs[], bool ascii = false );
    fitscc &append_table( const char *extname, long long extver,
				  const fits_table &src );
    fitscc &append_table( const fits_table &src );

    /*
     * insert an image HDU
     */
    fitscc &insert_image( long index0, 
				  const char *extname, long long extver );
    fitscc &insert_image( const char *extname0,
				  const char *extname, long long extver );
    fitscc &insert_image( long index0,
			   const char *extname, long long extver,
			   int type, long naxisx[], long ndim, bool init_buf );
    fitscc &insert_image( long index0,
		 const char *extname, long long extver,
		 int type, long naxis0 = 0, long naxis1 = 0, long naxis2 = 0 );
    fitscc &insert_image( const char *extname0,
			   const char *extname, long long extver,
			   int type, long naxisx[], long ndim, bool init_buf );
    fitscc &insert_image( const char *extname0,
		 const char *extname, long long extver,
		 int type, long naxis0 = 0, long naxis1 = 0, long naxis2 = 0 );
    fitscc &insert_image( long index0,
				  const char *extname, long long extver, 
				  const fits_image &src );
    fitscc &insert_image( const char *extname0,
				  const char *extname, long long extver,
				  const fits_image &src );

    fitscc &insert_image( long index0, const fits_image &src );
    fitscc &insert_image(const char *extname0, const fits_image &src);

    /*
     * insert a binary table HDU or an ASCII table HDU 
     */
    fitscc &insert_table( long index0, 
                     const char *extname, long long extver, bool ascii=false );
    fitscc &insert_table( long index0, const fits_table &src );

    /* erase an HDU */
    fitscc &erase( long index0 );
    fitscc &erase( const char *extname0 );

    /* obtain number of HDU from an HDU name */
    long index( const char *extname ) const;
    long indexf( const char *fmt, ... ) const;
	
    /* .image() returns reference of an object of fits_image class */
    /* Programmers can access FITS image via this reference.       */
    virtual fits_image &image( long index );
    virtual fits_image &image( const char *extname );

    /* .table() returns reference of an object of fits_table class */
    /* Programmers can access FITS binary table or ASCII table via */
    /* this reference.                                             */
    virtual fits_table &table( long index );
    virtual fits_table &table( const char *extname );

    /* returns HDU type;                                                */
    /* FITS::IMAGE_HDU, FITS::BINARY_TABLE_HDU or FITS::ASCII_TABLE_HDU */
    virtual int hdutype( long index ) const;
    virtual int hdutype( const char *hduname ) const;
    /* same as hdutype() */
    virtual int exttype( long index ) const;
    virtual int exttype( const char *extname ) const;

    /* returns HDU name (value of EXTNAME in FITS header) */
    virtual const char *hduname( long index ) const;
    /* same as hduname() */
    virtual const char *extname( long index ) const;

    /* set HDU name */
    virtual fitscc &assign_hduname( long index, const char *hduname );
    /* same as assign_hduname() */
    virtual fitscc &assign_extname( long index, const char *extname );

    /* */
protected:
    int template_load( int flags, const char *templ );
};

%extend fitscc {
public:
	void writeToFile(const char* fileName){
		$self->write_stream(fileName);
	}

}

class FitsFile : public fitscc {
public:
	FitsFile();
	FitsFile(std::string fileName);

    /* .hdu() returns reference of an object of fits_hdu class. */
    /* This can be used to access FITS header of any HDU types. */
    virtual fits_hdu &hdu_( long index );
    virtual fits_hdu &hdu_( const char *extname );

    static FitsFile* construct_from_template_string( std::string templateString );
};