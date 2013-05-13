require "RubyFits"
include Fits

f=FitsFile.new("sampleTable.fits")
puts f

#dump the 1-st and 3-rd header key-value records
puts f[1].headerKeyValueComment(1)
puts f[1].headerKeyValueComment(3)
puts f[1].headerKeyValueComment("TELESCOP")

#dump some header key-value records
puts f[1].header("TELESCOP")
puts f[1].header("RA_PNT").to_f

#retrieve header key-value record
f[1].headers.each { |headerRecord|
 puts headerRecord.keyword
}

#modify header records
f[1].header("TELESCOP") << "ASTRO-H"
f[1].setHeader("INSTRUME","SXS")
f[1].addHeader("NEWKEY",3.14159, "COMMENT")

#save to file
f.saveAs("openSave.fits")
