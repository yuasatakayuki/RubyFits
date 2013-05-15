require "RubyFits"
include Fits
f=FitsFile.new("sampleTable.fits")

#Primary HDU
pHDU=f.hdu(0)

puts pHDU
puts "Image type = #{pHDU.getTypeAsString()}"
puts "Image size = #{pHDU.getXSize} x #{pHDU.getYSize}"
puts "Pixel value:"
puts " (1,2) = #{pHDU.getPixelValue(1,2)}"
puts " (3,3) = #{pHDU.getPixelValue(3,3)}"
puts " (15,2) = #{pHDU.getPixelValue(15,2)}"
puts " (100,100) = #{pHDU.getPixelValue(100,100)} # <= this should be NaN because the pixel is outside the define size."

croppedImage=pHDU.section(1,2)


