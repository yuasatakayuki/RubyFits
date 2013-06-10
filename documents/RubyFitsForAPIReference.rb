
module Fits
	#Open fits file.
	def open(fileName)
	end
	
	#Represents data type used in RubyFits.
	class FitsDataType
		ANY = 127
		BIT = 88           #'X'
		BYTE = 66          #'B'
		LOGICAL = 76       #'L'
		BOOLEAN = 76       #'L'
		ASCII = 65         #'A'
		STRING = 65        #'A'
		SHORT = 73         #'I'
		LONG = 74          #'J'
		LONGLONG = 75      #'K'
		FLOATING = 69      #'E'
		DOUBLE = 68        #'D'
		COMPLEX = 67       #'C'
		DOUBLECOMPLEX = 77 #'M'
		LONGARRDESC = 80   #'P'
		LLONGARRDESC = 81  #'Q'
	end
	
#Represents FitsFile.	
class FitsFile
  	#Returns string that describes this FitsFile instance.
    def to_s
    end

	# Returns an array of HDUs.
    def getHDUs()
    end
	alias getHDUs hdus
	
	#Returns an HDU which is specified with a provided index or HDU name.
	#Index 0 corresponds to the Primary HDU.
    def getHDU(hduIndexOrName)
    end
	alias getHDU hdu
	
	#Returns an HDU which is specified with a provided index or HDU name.
	#Index 0 corresponds to the Primary HDU.
    def [](indexOrName)
    end

	#Appends an HDU.
    def <<(hdu)
    end

	#Appends an HDU.	
    def appendHDU(hdu)
    end
	alias appendHDU append

	#Opens a Fits file.
	def open(fileName)
	end
	alias open read
	alias open readStream
	
	#Write to a Fits file.
	def write(fileName)
	end
	alias write writeToFile
	alias write saveToFile
	alias write writeToFile
	alias write save
	alias write writeTo
	alias write saveTo
	alias write saveAs
	
	#Returns the number of HDUs.
	def length
	end
	alias length getNHDU
	alias length getHDUSize
	alias length getHDULength
	alias length hduLength
	alias length nHUs
	
	#Erases a specified HDU.
	def erase(indexOrName)
	end
	alias erase deleteHDU
	alias erase eraseHDU
	
	#Returns the name of a specified HDU.
	def hduname(indexOrName)
	end
	alias hduname getHDUName
	alias hduname hduName
	alias hduname extname
	alias hduname getExtensionName
	alias hduname extensionName
	alias hduname extName
	
	#Set HDU name.
	def setHDUName(name)
	end
	alias setHDUName setExtensionName

	#Returns HDU type (either of Fits:IMAGE_HDU, Fits:BINARY_TABLE_HDU, or Fits:ASCII_TABLE_HDU).
	def hdutype
	end
	alias hdutype exttype
  end

  #============================================
  # FitsHDU class
  #============================================
  class FitsHDU
    #Returns a string that describes this FitsHDU instance.
    def to_s
    end

	#Returns HDU type as a string. "IMAGE_HDU", "BINARY_TABLE_HDU", or "ASCII_TABLE_HDU".
    def hduTypeAsString
    end

	#Returns HDU type as a string. "IMAGE_HDU", "BINARY_TABLE_HDU", or "ASCII_TABLE_HDU".
    def getHDUTypeAsString
    end

	#Returns HDU type as a string. "IMAGE_HDU", "BINARY_TABLE_HDU", or "ASCII_TABLE_HDU".
    def getHDUType
    end

	#Returns true if this HDU is an ImageHDU.
    def isImageHDU
    end

	#Returns true if this HDU is a TableHDU.
    def isTableHDU
    end

	#Appends a header key-value pair.
    def appendHeaderRecord(key,value,comment="")
    end

	#Erases a specified header key-value pair.
    def eraseHeaderRecord(key)
    end

	#Erases a specified header key-value pair.
    def eraseHeader(key)
    end

	#Erases a specified header key-value pair.
    def eraseHeaderEntry(key)
    end
	
	#Returns an array of header key-value pairs.
    def getHeaders()
    end

	#Returns an array of header key-value pairs.
    def getHeaderRecord(indexOrKey)
    end

	#Returns an array of header key-value pairs.
    def headers()
    end

	#Returns a comment for a specified header key-value pair.
    def headerKeyValueComment(indexOrName)
    end

	#Adds a new key-value pair. Comment can be optionally specified.
    def assignHeader(keyword,value,comment="")
    end

	#Returns the HDU name.
    def getHDUName
    end

	#Sets the HDU name.
    def setHDUName(name)
    end

	#Returns the number of header key-vaule pair.
    def getHeaderLength
    end

    alias getHeader getHeaderRecord
    alias getHeaderEntry getHeaderRecord
    alias getHeaderSize getHeaderLength
    alias getNHeaderEntries getHeaderLength
    alias getHHeaders getHeaderLength
    alias nHeaders getHeaderLength
    alias nHeaderEntries getHeaderLength
    alias headerLength getHeaderLength
    alias headerSize getHeaderLength
    alias hduType getHDUType
    alias type getHDUType
    alias getType getHDUType

    alias addHeaderRecord assignHeader
    alias addHeaderEntry assignHeader
    alias addHeader assignHeader
    alias appendHeader assignHeader
    alias appendHeaderRecord assignHeader
    alias appendHeaderEntry assignHeader
    alias setHeader assignHeader
    alias setHeaderRecord assignHeader
    alias setHeaderEntry assignHeader
    alias insertHeader assignHeader
    alias insertHeaderEntry assignHeader
    alias insertHeaderRecord assignHeader
    alias setName setHDUName
    alias getName getHDUName
    alias hduName getHDUName
    alias name getHDUName
  end

  #============================================
  # FitsHeaderRecord
  #============================================

  #Represents a header key-value pair in the HDU header.
  class FitsHeaderRecord
  	#Constructs a new instance.
    def initialize()
    end

	#Constructs a new instance from a key-value pair and its comment.
    def initialize(key,value,comment="")
      self.assign(value)
    end

	#Returns a string that describes this instance.
	def to_s()
	end
	alias to_s getAsString
	alias to_s getStringValue
	alias to_s stringValue
	alias to_s toString

	#Returns value as a boolean.
	def to_b()
	end
	alias to_b getBooleanValue
	alias to_b getAsBoolean
	alias to_b booleanValue
	
	#Returns value as a long integer.
	def to_l()
	end 
	alias to_l getLongIntegerValue
	alias to_l getAsLongInteger
	alias to_l getAsLong
	alias to_l longValue
	
	#Returns value as a long long integer.
	def to_ll()
	end
	alias to_ll getLongLongIntegerValue
	alias to_ll getAsLongLongInteger
	alias to_ll getAsLongLong
	alias to_ll getAsInteger
	alias to_ll longlongValue
	
	#Returns value as a floating.
	def to_f()
	end
	alias to_f getFloatingValue
	alias to_f getAsFloating
	alias to_f floatingValue
	
	#Sets comment.
	def setComment(comment)
	end
	
	#Returns comment.
	def comment()
	end
	alias comment getComment
	
	#Returns keyword.
	def keyword()
	end
	alias keyword getKeyword
	
	
	#Returns value type.
	def type()
	end
	alias type getType
	
	#Sets key, value, and comment (optional).
	def setKeyValueComment(keyword, value, comment="")
	end
	
	#Assigns a new value (if other is not an array) or [value, comment] (if array).
	#An array with two elements should be passed.
    def << (other)
    end
	
	#Returns a stringified version of key-value pair and comment.
    def keyValueComment
    end
    
  end

  #============================================
  # FitsTableHDU class
  #============================================
  
  #Represents a Table HDU.
  class FitsTableHDU
  	#Returns a string that describes this instance.
    def to_s
    end

	#Returns an array of columns (FitsTableColumn).
    def getColumns()
    end
	alias getColumns columns

	#Append a column to this table HDU.
    def append(column)
    end
	alias append <<
	alias appendColumn

	#Returns a column at a specified index (0-start).
    def [](indexOrName)
    end
    
    #Returns an index of a column that has a specified name.
    def columnIndexOfName(columnName)
    end
	alias columnIndexOfName indexOfColumnName
	alias columnIndexOfName getIndexOfColumnName
	alias columnIndexOfName getColumnIndex
	
	#Returns a name of a column at a specified index.
	def columnNameOfIndex(index)
	end
	alias columnNameOfIndex nameOfColumnIndex
	alias columnNameOfIndex getNameOfColumnIndex
	alias columnNameOfIndex getColumnName
	
	#Returns the number of columns.
	def nColumns()
	end
	alias nColumns getNColumns
	alias nColumns getColumnLength
	alias nColumns colmunLength
	
	#Sets column name.
	def setColumnName(index,name)
	end
	alias setColumnName changeColumnName
	
	#Erase a column.
	def eraseColumns(indexOrName)
	end
	alias eraseColumns eraseColumn
	
	#Returns a column at a specified index (0-start) or that has a specified name.
	def getColumn(indexOrName)
	end
	alias getColumn column
	
	#Returns the number of rows.
	def nRows()
	end
	alias nRows getNRows
	alias nRows nEntries
	alias nRows getNEntries
	
	#Resize the row number.
	def resize(newRowNumber)
	end
	alias resize resizeRows
	alias resize resizeEntries
	
	#Appends a row.
	def appendRow()
	end
	alias appendRow appendEntry
	
	#Epands the row number by n.
	def appendRows(n)
	end
	alias appendRows appendEntries
	
	#Inserts a row into a specified position.
	def insertRow(index)
	end 
	alias insertRow insertEntry
	
	#Erases a row at a specified position.
	def eraseRow(index)
	end
	alias eraseRow eraseEntry
	
	#Erases a sets of rows starting at a specified index for n.
	def eraseRows(index,n)
	end
	
	#Moves a set of rows to new position.
	def modeRows(sourceIndex, n, destinationIndex)
	end
	
	#Appends a column (FitsTableColumn instance) to this Table HDU.
	def appendColumn(column)
	end
	alias appendColumn append
	
	#Inserts a column (FitsTableColumn instance) to a specified column position.
	def insertColumn(index,column)
	end
	alias insertColumn insert
	
	#Erases a column.
	def eraseColumn(indexOrName)
	end
	alias eraseColumn erase
	
  end

  #============================================
  # FitsTableColumn class
  #============================================
  
  #Represens a column of a TableHDU.
  class FitsTableColumn
    #Returns a string that describes this instance.
    def to_s
    end

	#Constructs a new column structure with a given ttype and tform.
	# ttype = name of the column.
	# tform = format of the column. e.g. J (an intger), 32B (byte array with 32 elements) or 120A (120-byte ASCII string)
    def initializeWithNameAndFormat(ttype,tform)
    end

	#Returns a row value (e.g. [32]) or an array of row values (e.g. [32...128]).
    def [](indexOrRange)
    end

	#Returns a value of a specified row.
    def getRowAt(rowIndex)
    end

	#Returns an array of values of a specified row range.
    def getRowRange(range)
    end

	#Assigns a value to a specified row or an array of values to a specified row range.
	# tableColumn[32]=3
	# tableColumn[0...5]=[1,2,3,4]
    def []=(indexOrRange,valueOrValueArray)
    end
	
	#Assigns a row value to a specified row.
    def assignSingleRow(rowIndex,value)
    end

	#Assigns an array of values to a specified row range.
    def assignRowRange(rowRange,valueArray)
    end

  end

  #============================================
  # FitsImageHDU class
  #============================================

	#Represents an ImageHDU.
	class FitsImageHDU
		#Constructs an image buffer.
		def constructImage(x,y,z,type)
		end
		
		#Returns pixel value.
		def getValue(x,y,z=0)
		end
		
		#Returns pixel value.
		def getPixelValue(x,y,z=0)
		end
		
		#Returns pixel values in the y-th bin in the X axis.
		def getXPixels(y)
		end
		
		#Returns a type string.
		def getTypeAsString()
		end
		
		#Returns a type string.
		def typeToString(type)
		end
		
		#Returns type of this image.
		def type
		end
		
		#Returns type of this image.
		def getType
		end
		
		#Returns the number of dimensions.
		def nDimensions
		end
		
		#Returns the number of dimensions.
		def nDims end
		
		#Returns the number of dimensions.
		def getNDimensions end
		#Returns the number of dimensions.
		def dimLength end
		#Returns the number of dimensions.
		def dimensionLength end
	end

end #end of module
