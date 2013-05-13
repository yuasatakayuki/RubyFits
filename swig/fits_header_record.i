%alias fits_header_record::svalue "to_s,getAsString,getStringValue,stringValue,toString";
%alias fits_header_record::bvalue "to_b,getBooleanValue,getAsBoolean,booleanValue";
%alias fits_header_record::lvalue "to_l,getLongIntegerValue,getAsLongInteger,getAsLong,longValue";
%alias fits_header_record::llvalue "to_ll,getLongLongIntegerValue,getAsLongLongInteger,getAsLongLong,getAsInteger,longlongValue";
%alias fits_header_record::dvalue "to_f,getFloatingValue,getAsFloating,floatingValue";

%alias fits_header_record::assign_comment "setComment";
%alias fits_header_record::comment "getComment";

%alias fits_header_record::keyword "getKeyword";


class fits_header_record {
public:
const char *svalue() const;

    /* Set a pair of [keyword, value, comment] or [keyword, description]. */
    /* Description is used for HISTORY or COMMENT records.                */

    virtual fits_header_record &assign( const char *keyword, const char *value,
					const char *comment );
    virtual fits_header_record &assign( const char *keyword,
					const char *description );

    /* high-level member functions to set a value.   */
    /* Single quotations of a string such as "'ABC'" */
    /* are not required.                             */
    /*   prec: precision (number of digit)           */
    virtual fits_header_record &assign( const char *str );
    virtual fits_header_record &assign( bool tf );
    virtual fits_header_record &assign( int val );
    virtual fits_header_record &assign( long val );
    virtual fits_header_record &assign( long long val );
    virtual fits_header_record &assign( double val, int prec = 15 );
    virtual fits_header_record &assign( float val, int prec = 6 );

    /* member functions to set a comment */
    virtual fits_header_record &assign_comment( const char *str );

    /* This returns FITS::DOUBLE_T in case of real number, FITS::LONGLONG_T */
    /* in case of integer number, FITS::DOUBLECOMPLEX_T in case of complex  */
    /* number, FITS::BOOL_T in case of boolean number, and FITS::STRING_T   */
    /* in case of others.                                                   */
    virtual int type() const;

    /* member functions to return keyword string */
    virtual const char *keyword() const;

    /* member functions to return comment string */
    virtual const char *comment() const;

    /* high-level member functions to return a value for each type */
    virtual bool bvalue() const;
    virtual long lvalue() const;
    virtual long long llvalue() const;
    virtual double dvalue() const;
};


%extend fits_header_record {
	virtual fits_header_record &operator<<(const char* value){
		return $self->assign(value);
	}
	virtual fits_header_record &operator<<(bool value){
		return $self->assign(value);
	}
	virtual fits_header_record &operator<<(int value){
		return $self->assign(value);
	}
	virtual fits_header_record &operator<<(long value){
		return $self->assign(value);
	}
	virtual fits_header_record &operator<<(long long value){
		return $self->assign(value);
	}
	virtual fits_header_record &operator<<(double value){
		return $self->assign(value);
	}
	virtual fits_header_record &operator<<(float value){
		return $self->assign(value);
	}
}
