require "RubyFits"
include Fits
f=FitsFile.new("sampleTable.fits")

#HDU access
puts "The file contains #{f.nHDUs} HDUs."
puts "============================================"
for i in 0...(f.hdus.length)
	puts "#{i} #{f.hdus[i]}"
end
puts "============================================"
puts

#Header access
puts "Header access example1:"
puts "============================================"
i=0
nHeaderDumps=10
f.hdu(0).headers.each {|entry|
	puts "#{entry.keyword} = #{entry.to_s} // #{entry.comment}"
	if(i>nHeaderDumps)then
		break
	end
	i=i+1
}
puts "..."
puts "============================================"
puts



puts "Header access example2:"
puts "============================================"
record=f.hdu(0).header("TELESCOP")
puts "TELESCOP = #{record.toString}"
puts "Comment: #{record.getComment}"

puts "Assigning new value/comment..."

record << [3.141592,"New value"]
puts "TELESCOP = #{record.toString}"
puts "Comment: #{record.getComment}"
puts "============================================"
puts


puts "TableHDU access example1:"
puts "============================================"
tableHDU=f.getHDU("SPECTRUM")
puts "TableHDU #{tableHDU.getHDUName()} has #{tableHDU.nColumns()} columns and #{tableHDU.nRows} rows."
tableHDU.columns.each {|column|
	puts column
}
puts "============================================"
puts


puts "TableHDU access example2:"
puts "============================================"
tableHDU=f.getHDU("SPECTRUM")
puts tableHDU["COUNTS"][100]
puts tableHDU["COUNTS"][100...120].join(",")
puts "============================================"