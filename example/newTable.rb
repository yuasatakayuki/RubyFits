require "RubyFits"
include Fits

sizeColumn=FitsTableColumn.new
rptColumn=FitsTableColumn.new

sizeColumn.initializeWithNameAndFormat("SIZE","1J")
rptColumn.initializeWithNameAndFormat("RPT","10J")

packet=[1,2,3,4,5,6,7,8,9,10]

sizeColumn.resize(100)
sizeColumn[sizeColumn.length-1]=123
rptColumn.resize(100)
rptColumn[0]=packet

#append the created column to a TableHDU
tableHDU=FitsTableHDU.new
tableHDU.resize(sizeColumn.length)
tableHDU.appendColumn(sizeColumn)
tableHDU.appendColumn(rptColumn)
puts tableHDU

#append the create TableHDU to a FitsFile
f=FitsFile.new
f.append tableHDU

#Write to a file
f.saveAs("table.fits")

