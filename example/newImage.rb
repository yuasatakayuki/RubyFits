require "RubyFits"
include Fits

#Create an image HDU whose size is 100x100, and has type of DOUBLE_T 

puts Fits::DOUBLE_T
imageHDU=FitsImageHDU.new
imageHDU.constructImage(100,100,0,Fits::DOUBLE_T)
puts imageHDU.getHDUName
imageHDU.setHDUName("SampleImage")

puts imageHDU
puts "Image type = #{imageHDU.getTypeAsString()}"
puts "Image size = #{imageHDU.getXSize} x #{imageHDU.getYSize}"
puts "Setting a value to (50,50)"
imageHDU.setDouble(3.14159,50,50)
puts " (50,50) = #{imageHDU.getValue(50,50)}"

f=FitsFile.new
f.appendHDU(imageHDU)
f.saveAs("newImage.fits")
puts "Created image was saved to newImage.fits"
