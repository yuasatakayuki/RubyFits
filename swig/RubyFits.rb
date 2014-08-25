require "fits"

module Fits
  public
  #============================================
  # functions
  #============================================
  #syntax sugar for FitsFile.new(fileName)
  def open(fileName)
    return FitsFile.new(fileName)
  end

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

    def self.toString(dataType)
      case dataType
        when ANY
          return "ANY"
        when BIT
          return "BIT"
        when BYTE
          return "BYTE"
        when LOGICAL
          return "LOGICAL"
        when BOOLEAN
          return "BOOLEAN"
        when ASCII
          return "ASCII"
        when STRING
          return "STRING"
        when SHORT
          return "SHORT"
        when LONG
          return "LONG"
        when LONGLONG
          return "LONGLONG"
        when FLOATING
          return "FLOATING"
        when DOUBLE
          return "DOUBLE"
        when COMPLEX
          return "COMPLEX"
        when DOUBLECOMPLEX
          return "DOUBLECOMPLEX"
        when LONGARRDESC
          return "LONGARRDESC"
        when LLONGARRDESC
          return "LLONGARRDESC"
        else
          return "undefined"
      end
    end
  end

  #============================================
  # FitsFile class
  #============================================
  class FitsFile

    def initialize()

    end

    def self.constructFromTemplateString(templateString)      
      return construct_from_template_string(templateString)
    end

    def self.constructFromTemplateFile(templateFile)
      if(!File.exist?(templateFile))then
        STDERR.puts "FitsFile::constructFromTemplateFile() file not found"
        exit
      end
      templateString=File.read(templateFile)
      return construct_from_template_string(templateString)
    end

    def to_s
      result="FitsFile # of HDUs = #{self.getNHDU()} [ "
      getHDUs.each() {|hdu|
        result=result+"#{hdu.getHDUName()} "
      }
      result=result+"]"
      return result
    end

    def hdus()
      return getHDUs()
    end

    def getHDUs()
      result=[]
      for i in 0...self.getNHDU()
        result << getHDU(i)
      end
      return result
    end

    def getHDU(hduIndexOrName)
      hduPointer=self.hdu_(hduIndexOrName)
      if(hduPointer.hdutype==2)then
        if(hduIndexOrName.instance_of?(Fixnum))then
          return table(hduIndexOrName.to_i)
        else
          return table("#{hduIndexOrName}")
        end
      else
        return image(hduIndexOrName)
      end
    end

    def [](indexOrName)
      if(indexOrName.instance_of?(String) or indexOrName.instance_of?(Fixnum))then
        return getHDU(indexOrName)
      else
        return nil
      end
    end

    def <<(hdu)
      appendHDU(hdu)
    end

    def hdu(hduIndexOrName)
      return getHDU(hduIndexOrName)
    end

    def append(hdu)
      appendHDU(hdu)
    end

    def appendHDU(hdu)
      if(hdu.instance_of?(FitsHDU))then
        STDERR.puts "FitsFile::appendHDU(hdu): Cannot append an instance of FitsHDU to a FitsFile. Provide an instance of FitsImageHDU or FitsTableHDU."
        exit(-1)
      end
      if(hdu.isImageHDU)then
        self.append_image(hdu)
      else
        self.append_table(hdu)
      end
    end

  end

  #============================================
  # FitsHDU class
  #============================================
  class FitsHDU
    def to_s
      return "FitsHDU #{self.getHDUName} Type=#{self.getHDUTypeAsString()}"
    end

    def hduTypeAsString
      return self.getHDUTypeAsString()
    end

    def getHDUTypeAsString
      #const int IMAGE_HDU = 0;		/* IMAGE_HDU */
      #const int BINARY_TABLE_HDU = 2;	/* BINARY_TBL */
      #const int ASCII_TABLE_HDU = 1;	/* ASCII_TBL */
      case self.getHDUType
      when 0
        return "ImageHDU"
      when 1
        return "ASCIITableHDU"
      when 2
        return "BinaryTableHDU"
      when 127
        return "AnyTypeHDU"
      end
      return "InvalidHDUType"
    end

    def isImageHDU
      if(self.hdutype==0)then
        return true
      else
        return false
      end
    end

    def isTableHDU
      if(self.hdutype!=0)then
        return true
      else
        return false
      end
    end

    def appendHeaderRecord(key,value,comment="")
      appendHeaderRecord(FitsHeaderRecord.new(key,value,comment))
    end
    
    def appendHistory(str)
    	header_append("HISTORY", str )
    end

    def appendComment(str)
    	header_append("COMMENT", str )
    end

    def eraseHeaderRecord(key)
      if(key.instance_of?(String))then
        header_erase_records(key,0);
      else
        STDERR.puts "FitsHDU::eraseHeaderRecord(key) : provided argument was not a String instance."
      end
    end

    def eraseHeader(key)
      eraseHeaderRecord(key)
    end

    def eraseHeaderEntry(key)
      eraseHeaderRecord(key)
    end

    def getHeaders()
      result=[]
      for i in 0...(self.nHeaders)
        result << getHeader(i)
      end
      return result
    end

    def headers()
      return getHeaders()
    end

    def headerKeyValueComment(indexOrName)
      return header(indexOrName).keyValueComment
    end

    def assignHeader(keyword,value,comment="")
      if(header_index(keyword)<0)then
        header_append(keyword,value.to_s,comment)
      else
        header_assign(keyword,keyword,value.to_s,comment)
      end
    end

    def assignHeaderAsString(keyword,value,comment="")
      header_assign_string(keyword,keyword,value.to_s,comment)
    end

    def getHDUName
      return self.hduname
    end

    def setHDUName(name)
      assign_hduname(name)
    end

    def getHeaderRecord(indexOrKey)
      return header(indexOrKey)
    end

    def getHeaderLength
      return header_length
    end

    def getHDUType
      return hdutype
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
    alias setHeaderAsString assignHeaderAsString
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
  #add some syntax sugar for header record manipulation
  # headerRecord << value
  # headerRecord << [value, comment]
  class FitsHeaderRecord
    def initialize()

    end

    def initialize(key,value,comment="")
      self.assign(value)
      self.assign_comment(comment.to_s)
    end

    # to_s() is defined in fits_header_record.i

    def << (other)
      if(other.instance_of?(Array))then
        self.assign(other[0])
        self.assign_comment(other[1].to_s)
      else
        self.assign(other)
      end
    end

    def keyValueComment
      return "#{keyword} = #{self.to_s} // #{comment}"
    end
  end

  #============================================
  # FitsTableColumnDefinition
  #============================================
  class FitsTableColumnDefinition

    attr_accessor :ttype, :ttype_comment, :talas, :telem, :tunit, :tunit_comment
    attr_accessor :tdisp, :tform, :tdim

    def initialize(args={})
      @ttype=""
      @ttype_comment=""
      @talas=""
      @telem=""
      @tunit=""
      @tunit_comment=""
      @tdisp=""
      @tform=""
      @tdim=""

      @ttype= args[:ttype] unless args[:ttype]==nil
      @ttype_comment= args[:ttype_comment] unless args[:ttype_comment]==nil
      @talas=args[:talas] unless args[:talas]==nil
      @telem=args[:telem] unless args[:telem]==nil
      @tunit=args[:tunit] unless args[:tunit]=~nil
      @tunit_comment=args[:tunit_comment] unless args[:tunit_comment]==nil
      @tdisp=args[:tdisp] unless args[:tdisp]==nil
      @tform=args[:tform] unless args[:tform]==nil
      @tdim=args[:tdim] unless args[:tdim]==nil
    end

    def to_s()
      str="TTYPE=\"#{@ttype}\" TFORM=\"#{@tform}\" TTYPE_COMMENT=\"#{@ttype_comment}\" TALAS=\"#{@talas}\" TELEM=\"#{@telem}\" TUNIT=\"#{@tunit}\" TUNIT_COMMENT=\"#{@tunit_comment}\" TDISP=\"#{@tdisp}\" TDIM=\"#{@tdim}\""
      return str
    end
  end

  #============================================
  # FitsTableColumnDefinitions
  #============================================
  class FitsTableColumnDefinitions
    attr_accessor :columnDefinitions

    def initialize(args=[])
      @columnDefinitions=[]
      args.each(){ |e|
        @columnDefinitions << FitsTableColumnDefinition.new(e)
      }
    end

    def to_s()
      lines=[]
      @columnDefinitions.each(){|e|
        lines << e.to_s()
      }
      return lines.join("\n")
    end
  end


  #============================================
  # FitsTableHDU class
  #============================================
  class FitsTableHDU
    @@DefaultHeapSize=100*1024
    @@ByteSizeOfDouble=8

    def initialize
      @heapBytePosition=0
      @heapSize=0
    end

    def doubleHeap
      self.resizeHeap(@heapSize*2)
      @heapSize=@heapSize*2
      STDERR.puts "FitsTableHDU: heap size changed to #{@heapSize} bytes"
    end

    def allocateDefaultHeapSize()
      self.resizeHeap(@@DefaultHeapSize)
      @heapSize=@@DefaultHeapSize
    end

    def readVariableLengthArrayColumn(columnNameOrIndexOrColumn, rowIndex)
      #get column
      column=nil
      if(columnNameOrIndexOrColumn.instance_of?(FitsTableColumn))then
        column=columnNameOrIndexOrColumn
      else
        column=self[columnNameOrIndexOrColumn]
        if(column==nil)then
          STDERR.puts "FitsTableHDU::readVariableLengthArrayColumn() invalid column name or index #{columnNameOrIndexOrColumn}"
          exit
        end
      end

      #check if this HDU has heap allocated for VLA columns
      if(!column.isVariableLengthArray)then
        STDERR.puts "FitsTableHDU::readVariableLengthArrayColumn() column #{column.getColumnName} is not a variable-length array"
        exit
      end

      #read length
      arrayLength=column.array_length(rowIndex)
      heapBytePosition=column.array_heap_offset(rowIndex)

      #determine column type, and return data
      dataType=column.getDataTypeOfVariableLengthArray
      case dataType
      when FitsDataType::BYTE
        return self.read_uint_8_array_from_heap(heapBytePosition, arrayLength)
      when FitsDataType::SHORT
        return self.read_int_16_array_from_heap(heapBytePosition, arrayLength)
      when FitsDataType::LONG
        return self.read_int_32_array_from_heap(heapBytePosition, arrayLength)
      when FitsDataType::FLOATING
        return self.read_float_array_from_heap(heapBytePosition, arrayLength)
      when FitsDataType::DOUBLE
        return self.read_double_array_from_heap(heapBytePosition, arrayLength)
      else
        STDERR.puts "FitsTableHDU::readVariableLengthArrayColumn(): unsupported column data type #{FitsDataType.toString(dataType)}"
        exit
      end
    end

    def fillVariableLengthArrayColumn(columnNameOrIndexOrColumn, rowIndex, arrayOfData)
      if(@heapBytePosition==nil)then
        @heapBytePosition=0
        allocateDefaultHeapSize()
      end

      if(@heapSize==nil)then
        allocateDefaultHeapSize()
      end

      if(columnNameOrIndexOrColumn.instance_of?(FitsTableColumn))then
        column=columnNameOrIndexOrColumn
      else
        column=self[columnNameOrIndexOrColumn]
        if(column==nil)then
          STDERR.puts "FitsTableHDU::fillVariableLengthArrayColumn() invalid column name or index #{columnNameOrIndexOrColumn}"
          exit
        end
      end

      if(column.isVariableLengthArray)then
        #resize heap if necessary
        if(@heapBytePosition+arrayOfData.length*@@ByteSizeOfDouble>@heapSize)then
          self.doubleHeap()
        end

        #array descriptor
        column.assign_arrdesc(arrayOfData.length, @heapBytePosition, rowIndex);

        #switch depending on column data type
        dataType=column.getDataTypeOfVariableLengthArray
        case dataType
        when FitsDataType::BYTE
          @heapBytePosition=self.put_uint_8_array_to_heap(@heapBytePosition, arrayOfData)
        when FitsDataType::SHORT
          @heapBytePosition=self.put_int_16_array_to_heap(@heapBytePosition, arrayOfData)
        when FitsDataType::LONG
          @heapBytePosition=self.put_int_32_array_to_heap(@heapBytePosition, arrayOfData)
        when FitsDataType::FLOATING
          @heapBytePosition=self.put_float_array_to_heap(@heapBytePosition, arrayOfData)
        when FitsDataType::DOUBLE
          @heapBytePosition=self.put_double_array_to_heap(@heapBytePosition, arrayOfData)
        else
          STDERR.puts "FitsTableHDU.fillVariableLengthArrayColumn(): unsupported column data type #{FitsDataType.toString(dataType)}"
          exit
        end
      else
        STDERR.puts "FitsTableHDU.fillVariableLengthArrayColumn(): column #{columnNameOrIndex} is not a variable-length-array column"
        exit
      end
    end

    def to_s
      result="FitsTableHDU #{getHDUName} nColumns=#{self.nColumns()} nRows=#{self.nRows()}"
    end

    def getColumns()
      result=[]
      for i in 0...self.nColumns
        result << self.column(i)
      end
      return result
    end

    def columns()
      return getColumns
    end

    def <<(column)
      appendColumn(column)
    end

    def append(column)
      appendColumn(column)
    end

    def appendColumn(column)
      if(!column.instance_of?(FitsTableColumn))then
        STDERR.puts "FitsTableHDU::appendColumn(or <<) : Provided object is not an instance of FitsTableColumn."
        return
      end

      if(column.getNEntries() < self.getNEntries())then
        column.resize(self.getNEntries())
        STDERR.puts "FitsTableHDU::appendColumn(or <<) : Appended column was resized to have #{self.getNEntries()}."
      elsif(column.getNEntries() > self.getNEntries())then
        self.resize(column.getNEntries())
        STDERR.puts "FitsTableHDU::appendColumn(or <<) : Destination table was resized to have #{column.getNEntries()}."
      end
      column.setParentTable(self)
      self.append_a_col(column)
    end
    
    def getColumnNames()
      names=[]
      for i in 0...(self.getNColumns) do
        names << getColumnName(i)
      end
      return names
    end

    def row(index)
      result=[]
      for n in 0...self.nColumns
        result << self.getColumn(n)[index]
      end
      return result
    end

    def each_row
      for i in 0...(self[0].nRows)
        yield self.row(i)
      end
    end

    alias each each_row
    
    def getColumn(indexOrName)
      column=self.col(indexOrName)
      column.setParentTable(self)
      return column
    end

    alias column getColumn

    def [](indexOrName)
      if(indexOrName.instance_of?(String) or indexOrName.instance_of?(Fixnum))then
        if(indexOrName.instance_of?(Fixnum) and indexOrName<0)then
          STDERR.puts "FitsTableHDU::[] : It seems an invalid column index of #{indexOrName} was specified, and nil is returned."
          return nil
        end
        if(indexOrName.instance_of?(String) and getColumnIndex(indexOrName)<0)then
          STDERR.puts "FitsTableHDU::[] : It seems an invalid column name of #{indexOrName} was specified, and nil is returned."
          return nil
        end
        return getColumn(indexOrName)
      else
        STDERR.puts "FitsTableHDU::[] : It seems an invalid column index or name (#{indexOrName}) was specified, and nil is returned."
        return nil
      end
    end
    
  end

  #============================================
  # FitsTableColumn class
  #============================================
  class FitsTableColumn
    @@MaxDumpNumber=10

    @parentTableHDU

    def setParentTable(tableHDU)
      @parentTableHDU=tableHDU
    end

    def getParentTableHDU()
      return @parentTableHDU
    end

    def to_s
      dumpSize=[self.getNEntries,@@MaxDumpNumber].min
      result="Column named \"#{self.getColumnName}\" = [ "
      for i in 0...dumpSize do
        if(i!=dumpSize-1)then
          result=result + "#{self.getAsString(i)}, "
        else
          if(dumpSize<self.getNEntries)then
            result=result + "#{self.getAsString(i)}, ... (#{self.getNEntries} elements in total) ]"
          else
            result=result + "#{self.getAsString(i)} ]"
          end
        end
      end
      return result
    end

    def initializeWithNameAndFormat(ttype,tform)
      initialize_with_name_and_format(ttype,tform)
    end

    def [](indexOrRange)
      if(indexOrRange.instance_of?(Fixnum))then
        return self.getRowAt(indexOrRange)
      elsif(indexOrRange.instance_of?(Range))then
        return self.getRowRange(indexOrRange)
      else
        STDERR.puts "FitsTableColumn::[] : invalid index or range argument."
      end
    end
        
    def each
        self.getRowRange(0..(self.getNRows()-1)).each { |x| yield x } if block_given?
    end

    def getRowAt(rowIndex)
      #check if this column is a VLA
      if(self.isVariableLengthArray)then
        return @parentTableHDU.readVariableLengthArrayColumn(self, rowIndex)
      else
        #if this column is not a VLA column
        dataType=self.getDataType
        repeatLength=self.getRepeatLength()
        case dataType
        when FitsDataType::BIT
          if(repeatLength==1)then
            return self.bit_value(rowIndex)
          else
            result=[]
            for repeatIndex in 0...repeatLength
              result << self.bit_value(rowIndex,repeatIndex)
            end
            return result
          end
        when FitsDataType::BYTE
          if(repeatLength==1)then
            return self.byte_value(rowIndex)
          else
            result=[]
            for repeatIndex in 0...repeatLength
              result << self.byte_value(rowIndex,repeatIndex)
            end
            return result
          end
        when FitsDataType::LOGICAL, FitsDataType::BOOLEAN
          if(repeatLength==1)then
            return (self.logical_value(rowIndex) == 1)? true:false;
          else
            result=[]
            for repeatIndex in 0...repeatLength
              result << ( (self.logical_value(rowIndex,repeatIndex)==1)? true:false );
            end
            return result
          end
        when FitsDataType::ASCII, FitsDataType::STRING
          if(repeatLength==1)then
            return self.svalue(rowIndex)
          else
            result=[]
            for repeatIndex in 0...repeatLength
              result << self.svalue(rowIndex,repeatIndex)
            end
            return result
          end
        when FitsDataType::SHORT
          if(repeatLength==1)then
            return self.svalue(rowIndex)
          else
            result=[]
            for repeatIndex in 0...repeatLength
              result << self.svalue(rowIndex,repeatIndex)
            end
            return result
          end
        when FitsDataType::LONG
          if(repeatLength==1)then
            return self.lvalue(rowIndex)
          else
            result=[]
            for repeatIndex in 0...repeatLength
              result << self.lvalue(rowIndex,repeatIndex)
            end
            return result
          end
        when FitsDataType::LONGLONG
          if(repeatLength==1)then
            return self.llvalue(rowIndex)
          else
            result=[]
            for repeatIndex in 0...repeatLength
              result << self.llvalue(rowIndex,repeatIndex)
            end
            return result
          end
        when FitsDataType::FLOATING
          if(repeatLength==1)then
            return self.dvalue(rowIndex)
          else
            result=[]
            for repeatIndex in 0...repeatLength
              result << self.dvalue(rowIndex,repeatIndex)
            end
            return result
          end
        when FitsDataType::DOUBLE
          if(repeatLength==1)then
            return self.dvalue(rowIndex)
          else
            result=[]
            for repeatIndex in 0...repeatLength
              result << self.dvalue(rowIndex,repeatIndex)
            end
            return result
          end
        end
      end
    end

    def getRowRange(range)
      result=[]
      for index in range do
        result << getRowAt(index)
      end
      return result
    end

    def []=(indexOrRange,valueOrValueArray)
      if(indexOrRange.instance_of?(Fixnum))then
        rowIndex=indexOrRange.to_i
        self.assignSingleRow(rowIndex,valueOrValueArray)
      elsif(indexOrRange.instance_of?(Range))then
        self.assignRowRange(indexOrRange,valueOrValueArray)
      else
        STDERR.puts "FitsTableColumn::[]= : invalid index or range argument."
      end
    end

    def assignSingleRow(rowIndex,value)
      if(self.isVariableLengthArray())then #if VLA
        return @parentTableHDU.fillVariableLengthArrayColumn(self, rowIndex, value)
      else #if not VLA
        dataType=self.getDataType
        repeatLength=self.getRepeatLength()
        #do assignment
        case dataType
        when FitsDataType::BIT
          if(repeatLength==1)then
            result=self.assign_bit(value.to_i,rowIndex)
          else
            for repeatIndex in 0...repeatLength
              result=self.assign_bit(value[repeatIndex].to_i,rowIndex,repeatIndex)
            end
          end
        when FitsDataType::BYTE
          if(repeatLength==1)then
            result=self.assign_byte(value.to_i,rowIndex)
          else
            for repeatIndex in 0...repeatLength
              result=self.assign_byte(value[repeatIndex].to_i,rowIndex,repeatIndex,0)
            end
          end
        when FitsDataType::LOGICAL, FitsDataType::BOOLEAN
          if(repeatLength==1)then
            result=self.assign_logical( (value.to_i==1)? true:false ,rowIndex)
          else
            for repeatIndex in 0...repeatLength
              result=self.assign_logical( value[repeatIndex].to_i==1? true:false ,rowIndex,repeatIndex)
            end
          end
        when FitsDataType::ASCII, FitsDataType::STRING
          if(repeatLength==1)then
            result=self.assign(value.to_s,rowIndex)
          else
            for repeatIndex in 0...repeatLength
              result=self.assign(value.to_s,rowIndex,repeatIndex)
            end
          end
        when FitsDataType::SHORT
          if(repeatLength==1)then
            result=self.assign_short(value.to_i,rowIndex)
          else
            for repeatIndex in 0...repeatLength
              result=self.assign_short(value[repeatIndex].to_i,rowIndex,repeatIndex)
            end
          end
        when FitsDataType::LONG
          if(repeatLength==1)then
            result=self.assign(value.to_i,rowIndex)
          else
            for repeatIndex in 0...repeatLength
              result=self.assign(value[repeatIndex].to_i,rowIndex,repeatIndex)
            end
          end
        when FitsDataType::LONGLONG
          if(repeatLength==1)then
            result=self.assign(value.to_i,rowIndex)
          else
            for repeatIndex in 0...repeatLength
              result=self.assign(value[repeatIndex].to_i,rowIndex,repeatIndex)
            end
          end
        when FitsDataType::FLOATING
          if(repeatLength==1)then
            result=self.assign(value.to_f,rowIndex)
          else
            for repeatIndex in 0...repeatLength
              result=self.assign(value[repeatIndex].to_f,rowIndex,repeatIndex)
            end
          end
        when FitsDataType::DOUBLE
          if(repeatLength==1)then
            result=self.assign(value.to_f,rowIndex)
          else
            for repeatIndex in 0...repeatLength
              result=self.assign(value[repeatIndex].to_f,rowIndex,repeatIndex)
            end
          end
        end
      end
    end

    def assignRowRange(rowRange,valueArray)
      i=0
      for rowIndex in rowRange do
        assignSingleRow(rowIndex,valueArray[i])
        i=i+1
      end
    end

    def setVariableLengthArrayData(rowIndex,byteArray)
      if(@vlaPreviousRowIndex==nil)then
        @vlaPreviousRowIndex=0
        @vlaHeapOffset=0
      end
      if(!self.heap_is_used())then
        STDERR.puts "FitsTableColumn::setVariableLengthArrayData() : Variable Length Array access to non-VLA column (column=#{columnIndexOrName})."
        return
      end
      if(@parentTableHDU==nil)then
          STDERR.puts "FitsTableColumn::setVariableLengthArrayData() : This column does not have a parent TableHDU, and variable length array data cannot be written to heap."
          return
      end
      if(@vlaPreviousRowIndex!=0 && rowIndex<@vlaPreviousRowIndex)then
          STDERR.puts "FitsTableColumn::setVariableLengthArrayData() : Row index backword move was detected in variable length array. Output FITS file may not be valid." << std::endl;
      end
      assign_arrdesc( byteArray.length, @vlaHeapOffset, rowIndex, 0 )
      @parentTableHDU.put_heap_vector(@vlaHeapOffset, byteArray)
      @vlaHeapOffset+=byteArray.length
      @vlaPreviousRowIndex=rowIndex
    end
  end

  #============================================
  # FitsImageHDU class
  #============================================
  class FitsImageHDU
    def constructImage(x,y,z,type)
      init(type,x,y,z)
    end

    def getValue(x,y,z=0)
      return getPixelValue(x,y,z)
    end

    def getPixelValue(x,y,z=0)
      if(self.type()==Fits::DOUBLE_T)then
        if(self.nDimensions()==2)then
          return getDoubleValue(x,y)
        else
          return getDoubleValue(x,y,z)
        end
      elsif(self.type()==Fits::FLOAT_T)then
        if(self.nDimensions()==2)then
          return getDoubleValue(x,y)
        else
          return getDoubleValue(x,y,z)
        end
      else
        if(self.nDimensions()==2)then
          return getIntegerValue(x,y)
        else
          return getAsInteger(x,y,z)
        end
      end
    end

    def getXPixels(y)
      result=[]
      xSize=self.getXSize
      for x in 0...xSize do
        result << getPixelValue(x,y)
      end
      return result
    end

    def getYPixels(x)
      result=[]
      ySize=self.getYSize
      for y in 0...ySize do
        result << getPixelValue(x,y)
      end
      return result
    end

    def getTypeAsString()
      return typeToString(self.type())
    end
  end

  def getAsArray()
    result=[]
    xSize=self.getXSize
    for x in 0...xSize
      result << getYPixels(x)
    end
    return result
  end

  def typeToString(type)
    case type
    when ANY_T
      return "Any"
    when BIT_T
      return "Bit"
    when BYTE_T
      return "Byte"
    when LOGICAL_T
      return "Logical"
    when BOOL_T
      return "Boolean"
    when ASCII_T
      return "ASCII"
    when STRING_T
      return "String"
    when DOUBLE_T
      return "Double"
    when LONG_T
      return "Long"
    when LONGLONG_T
      return "LongLong"
    when FLOAT_T
      return "Floating"
    when DOUBLECOMPLEX_T
      return "DoubleComplex"
    when COMPLEX_T
      return "Complex"
    end
  end

  #============================================
  # Constants
  #============================================
  ANY_HDU = 127
  IMAGE_HDU = 0
  BINARY_TABLE_HDU = 2
  ASCII_TABLE_HDU = 1

  NUM_HDU_TYPES = 3

  ANY_T = 127;
  BIT_T = 88
  BYTE_T = 66
  LOGICAL_T = 76
  BOOL_T = 76
  ASCII_T = 65
  STRING_T = 65
  SHORT_T = 73
  LONG_T = 74
  LONGLONG_T = 75
  FLOAT_T = 69
  DOUBLE_T = 68
  COMPLEX_T = 67
  DOUBLECOMPLEX_T = 77;
  LONGARRDESC_T = 80;
  LLONGARRDESC_T = 81;

  SBYTE_T = 83
  USHORT_T = 85
  ULONG_T = 86
  ULONGLONG_T = 87

  ALL = 0x7fffffffffffffff #on Mac 64 bit
  INDEF = 8000000000000000 #on Mac 64 bit

end #end of module

