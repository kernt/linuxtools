mkdir -p myProject/{src,doc,tools,db} # exampl for dev Projekct
mkdir -p bin docs/personal docs/business lib # 
mkdir -p /home/user/mysite/{public_html/{css,js,images},logs} # example for Apache Home Dir


# Tests
echo pre-{{F..G},{3..4},{m..n}}-post
echo pre-{F..G}{3..4}{m..n}-post
echo file{0001..10}
echo file{0001..10..2}

seq 65 90 \
    | while read foo; do printf "%b\n" `printf '\\\\x%x\n' $foo`; done \
    | xargs mkdir
    
