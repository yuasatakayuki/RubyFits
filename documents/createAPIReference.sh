#!/bin/bash

# 20130608 Takayuki Yuasa

ruby sub_convertAliasToDef.rb RubyFitsForAPIReference.rb > RubyFits.rb
rdoc RubyFits.rb
rm RubyFits.rb

cat << EOF
Open doc/index.html to see the API Reference of RubyFits.
EOF
