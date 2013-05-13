require "RubyFits"
include Fits

#create an empty column
column=FitsTableColumn.new

#set column name and format
column.initializeWithNameAndFormat("COUNTS","1J")

#set number of entries
column.resize(128)

#fill rows with (row number * 2).
for i in 0...column.nRows
	column[i]=i*2
end

#another example of filling rows
column[1..3]=[10,11,12]

#append the created column to a TableHDU
tableHDU=FitsTableHDU.new
tableHDU.resize(128)
tableHDU.appendColumn(column)
puts tableHDU

#append the create TableHDU to a FitsFile
f=FitsFile.new
f.append tableHDU

#Write to a file
f.saveAs("createNewTable.fits")
