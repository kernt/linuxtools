 awk '/The/' text.txt

Or you'd like to see all lines that start with "rs":

awk '/^rs/' text.txt

Or perhaps most usefully, you want to strip the top 5 lines out of a file:

awk 'NR > 5' text.txt

try to pipe the result to column -t:

...| awk '{print $5"\t\t" $3"\t"$4}'|column -t

if your fields are tab separated the following one line script could print a table with cell borders

sed -e 's/\t/_|/g' table.txt |  column -t -s '_' | awk '1;!(NR%1){print "-----------------------------------------------------------------------";}'

To find the sum of all entries in second column and add it as the last record.

$ awk -F"," '{x+=$2;print}END{print "Total,"x}' file
Item1,200
Item2,500
Item3,900
Item2,800
Item1,600
Total,3000

- See more at: http://www.theunixschool.com/2012/06/awk-10-examples-to-group-data-in-csv-or.html#sthash.hXAHSEIA.dpuf


You could use awk for this. Change '$2' to the nth column you want.

awk -F "\"*,\"*" '{print $2}' textfile.csv


