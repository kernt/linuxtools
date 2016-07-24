#How to remove duplicates line from multiple text file in Perl?
#
#The syntax is:
perl -lne '$seen{$_}++ and next or print;' input > output
perl -lne '$seen{$_}++ and next or print;' data.txt > output.txt
#more output.txt
