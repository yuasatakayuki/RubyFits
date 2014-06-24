require "RubyFits"
include Fits

inputFile="newImage.fits"

if(!File.exist?(inputFile))then
	STDERR.puts "Error: file #{inputFile} not found."
	STDERR.puts "Please first execute 'ruby newImage.rb' that creates newImage.fits as an output file."
	exit
end

f=FitsFile.new(inputFile)

#Primary HDU
pHDU=f.hdu(0)

puts pHDU
puts "Image type = #{pHDU.getTypeAsString()}"

puts "Reading image as an array"
imageArray=pHDU.getAsArray()

puts "Image size = #{imageArray.length} x #{imageArray[0].length}"

puts "Pixel value:"
puts " (1,2) = #{imageArray[1][2]}"
puts " (3,3) = #{imageArray[3][3]}"
puts " (15,2) = #{imageArray[15][2]}"
puts " (88,99) = #{imageArray[88][99]}"
