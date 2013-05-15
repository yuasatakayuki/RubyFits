%rename(FitsImageHDU) fits_image;

%alias fits_image::type "getType";
%alias fits_image::dim_length "nDimensions,nDims,getNDimensions,dimLength,dimensionLength";
%alias fits_image::x_length "getXSize,getXLength,xLength,xSize";
%alias fits_image::y_length "getYSize,getYLength,yLength,ySize";
%alias fits_image::z_length "getZSize,getZLength,zLength,zSize";
%alias fits_image::convert_type "convertType";

%alias fits_image::bzero "getBZERO";
%alias fits_image::assign_bzero "setBSCALE";
%alias fits_image::bscale "getBZERO";
%alias fits_image::assign_bscale "setBSCALE";
%alias fits_image::blank "getBLANK";
%alias fits_image::assign_blank "setBLANK";

%alias fits_image::rotate_xy "rotate,rotateXY";

%alias fits_image::dvalue "getAsDouble,doubleValue,getDoubleValue";
%alias fits_image::lvalue "getAsLong,longValue";
%alias fits_image::llvalue "getAsLongLong,longlongValue,getAsInteger,getInteger,getIntegerValue,integerValue";
%alias fits_image::short_value "getAsShort,shortValue";
%alias fits_image::byte_value "getAsChar,getAsByte,charValue,byteValue";

%alias fits_image::assign_double "setDoubleValue,setDouble";
%alias fits_image::assign_longlong "setLongLongValue,setLongLong,setIntegerValue,setInteger";
%alias fits_image::assign_long "setLongValue,setLong";
%alias fits_image::assign_short "setShortValue,setShort";
%alias fits_image::assign_byte "setByteValue,setByte,setCharValue,setChar";


class fits_image: public fits_hdu {
public:
	//============================================
	// Type
	//============================================
	virtual int type() const;

	//============================================
	// Dimension and image size
	//============================================
	virtual long dim_length() const;
	virtual long x_length() const; /* same as col_length() */
	virtual long y_length() const; /* same as row_length() */
	virtual long z_length() const; /* same as layer_length() */
	
	virtual fits_image &convert_type(int new_type);
	virtual fits_image &convert_type(int new_type, double new_zero);
	virtual fits_image &convert_type(int new_type, double new_zero, double new_scale);
	virtual fits_image &convert_type(int new_type, double new_zero, double new_scale, long long new_blank);

	//============================================
	// BZERO, BSCALE, BLANK values
	//============================================
	virtual double bzero() const;
	virtual double bscale() const;
	virtual long long blank() const;
	virtual const char *bunit() const;

	virtual fits_image &assign_bzero(double zero, int prec = 15);
	virtual fits_image &assign_bscale(double scale, int prec = 15);
	virtual fits_image &assign_blank(long long blank);
	virtual fits_image &assign_bunit(const char *unit);

	//============================================
	// Manipulate image
	//============================================
	virtual void copy(fits_image *dest_img) const;
	virtual fits_image &rotate_xy(int angle);

	//============================================
	// Get pixel value
	//============================================
	virtual double dvalue(long axis0, long axis1 = FITS::INDEF, long axis2 = FITS::INDEF) const;
	virtual long lvalue(long axis0, long axis1 = FITS::INDEF, long axis2 = FITS::INDEF) const;
	virtual long long llvalue(long axis0, long axis1 = FITS::INDEF, long axis2 = FITS::INDEF) const;

	/* low-level access: does not apply BZERO and BSCALE */
	virtual short short_value(long axis0, long axis1 = FITS::INDEF, long axis2 = FITS::INDEF) const;
	virtual unsigned char byte_value(long axis0, long axis1 = FITS::INDEF, long axis2 = FITS::INDEF) const;

	//============================================
	// Set pixel value
	//============================================
	/* high-level access: applies BZERO and BSCALE */
	virtual fits_image &assign(double value, long axis0, long axis1 = FITS::INDEF, long axis2 = FITS::INDEF);

	/* low-level access: does not apply BZERO and BSCALE */
	virtual fits_image &assign_double(double value, long axis0, long axis1 = FITS::INDEF, long axis2 = FITS::INDEF);
	virtual fits_image &assign_longlong(long long value, long axis0, long axis1 = FITS::INDEF, long axis2 = FITS::INDEF);
	virtual fits_image &assign_long(long value, long axis0, long axis1 = FITS::INDEF, long axis2 = FITS::INDEF);
	virtual fits_image &assign_short(short value, long axis0, long axis1 = FITS::INDEF, long axis2 = FITS::INDEF);
	virtual fits_image &assign_byte(unsigned char value, long axis0, long axis1 = FITS::INDEF, long axis2 = FITS::INDEF);


	//============================================
	// Arith
	//============================================
	/* add an array object */
	virtual fits_image &addf(const fits_image &src_img, const char *exp_fmt, ...);

	/* subtract an array object */
	virtual fits_image &subtractf(const fits_image &src_img, const char *exp_fmt, ...);

	/* multiply an array object */
	virtual fits_image &multiplyf(const fits_image &src_img, const char *exp_fmt, ...);

	/* divide an array object */
	virtual fits_image &dividef(const fits_image &src_img, const char *exp_fmt, ...);

	/* returns trimmed array */
	virtual fits_image section(long col_index, long col_size = FITS::ALL, long row_index = 0, long row_size = FITS::ALL,
			long layer_index = 0, long layer_size = FITS::ALL) const;

};
