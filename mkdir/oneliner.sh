mkdir -p myProject/{src,doc,tools,db} # exampl for dev Projekct
mkdir -p bin docs/personal docs/business lib # 
mkdir -p /home/user/mysite/{public_html/{css,js,images},logs} # example for Apache Home Dir


# Tests
echo pre-{{F..G},{3..4},{m..n}}-post
echo pre-{F..G}{3..4}{m..n}-post
echo file{0001..10}
echo file{0001..10..2}

# bash 4 only
echo {0001..9999}
echo {a..z..3}

$ echo {1..10..2}
1 3 5 7 9

$ echo {10..1..2}
10 8 6 4 2

seq 65 90 \
    | while read foo; do printf "%b\n" `printf '\\\\x%x\n' $foo`; done \
    | xargs mkdir
    
    
# Sources
http://wiki.bash-hackers.org/syntax/expansion/brace
