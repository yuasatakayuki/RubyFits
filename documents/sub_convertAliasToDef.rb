IDLE=0
INSIDE_CLASS=1
INSIDE_METHOD=2

comments={}
argLists={}
state=IDLE
currentComment=""

open(ARGV[0]).each{|line|

	case(state)
		when IDLE
			puts line
			if(line.include?("class"))then
				state=INSIDE_CLASS
			end
			
		when INSIDE_CLASS
			if(line.include?("#"))then
				currentComment << line
				puts line
				next
			end
			
			if(line.include?("def"))then
				state=INSIDE_METHOD
				puts line
				methodName=line.split(" ")[1].split("(")[0]
				argList_=line.split(" ")[1].split("(")[1]
				if(argList_==nil)then
					argList_=")"
				elsif(!argList_.include?(")"))then
					argList_=")"
				end
				argList="(#{argList_}"
				comments[methodName]=currentComment
				argLists[methodName]=argList
				currentComment=""
				next
			end
			
			if(line.split(" ")[0]!=nil and line.split(" ")[0].include?("end"))then
				state=IDLE
				puts line
				comments={}
				argLists={}
				next
			end
			
			if(line.include?("alias"))then
				originalMethodName=line.split(" ")[1]
				aliasName=line.split(" ")[2]
				#puts "originalMethodName=#{originalMethodName}"
				#puts "aliasName=#{aliasName}"
				#puts "*******"
				puts comments[originalMethodName]
				puts "		def #{aliasName}#{argLists[originalMethodName]}"
				puts "		end"
				next
			end
			
			puts line
				
		when INSIDE_METHOD
			if(line.include?("end"))then
				state=INSIDE_CLASS
				puts line
			end
	end

}
