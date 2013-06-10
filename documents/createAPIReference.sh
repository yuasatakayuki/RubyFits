#!/bin/bash

# 20130608 Takayuki Yuasa

sub_convertAliasToDef.rb RubyFitsForAPIReference.rb > tmp.rb
rdoc tmp.rb

cat << EOF
Open doc/index.html to see the API Reference of RubyFits.
EOF
