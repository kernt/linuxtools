#!/bin/bash

# das letzte Feld jeder Eingabezeile ausgeben
  awk '{ print $NF }' /etc/hosts
  
  # die 10. Eingabezeile ausgeben
  awk 'NR == 10' /etc/passwd
  
  # alle Zeilen ausgeben, die entweder "root" oder "false" enthalten
  # (also Suche wie bei egrep)
  awk '/root|false/' /etc/passwd
  
  # Gesamtzahl der Eingabe-Zeilen ausgeben
  awk 'END { print NR }' /etc/passwd
  
  # das erste und letzte Feld der Eingabezeilen 5 bis 10 ausgeben
  awk -F: 'NR == 5, NR == 10 { print $1, $NF }' /etc/passwd
  
  # das erste und vorletzte Feld der letzten Eingabezeile ausgeben
  awk -F: 'END { print $1, $(NF-1) }' /etc/passwd
  
  # passwd-Eintrag für die aktuelle UID ausgeben
  awk -F: "\$3 == $UID" /etc/passwd
  awk -F: -v uid=$UID '$3 == uid' /etc/passwd
  
  # Ausgabe von Zeilen mit mehr als 2 Feldern
  awk 'NF > 2' /etc/hosts
  
  # Ausgabe von Zeilen, deren Feld 3 kleiner als 50 ist
  awk -F: '$3 < 50' /etc/passwd
  
  # Ausgabe von Zeilen, deren letztes Feld "false" enthält
  awk -F: '$NF ~ /false/' /etc/passwd
  
  # Ausgabe der Anzahl von Zeilen, deren letztes Feld "false" enthält;
  # Anmerkung: das Semikolon vor END ist nicht nötig
  awk -F: '$NF ~ /false/ { anz++ } ; END { print anz }' /etc/passwd
  
  # Ausgabe von nicht leeren Zeilen
  awk NF /etc/hosts
  
  # ermittle, wie oft jeder Wert des letzten Feldes der Eingabezeilen vorkommt
  awk -F: '
    { ANZ[$NF]++ }
    END { for (w in ANZ) printf("%s: %d\n", w, ANZ[w]) }
  ' /etc/passwd
  
# tausche Feld 1 und 2 der ersten 10 Eingabezeilen;
# gib restliche Zeilen unverändert aus
awk -F: '
    BEGIN { OFS = FS }
    NR < 11 { t = $1; $1 = $2; $2 = t }
    1
  ' /etc/passwd
  
# ermittle die längste Eingabe-Zeile
  awk '
    length($0) > max { max = length($0) ; fn = FILENAME ; fnr = FNR ; line = $0 }
    END { if (fnr) printf("%d Zeichen in Zeile %d in Datei %s\n%s\n", max, fnr, fn, line) }
  ' /etc/{hosts,passwd}
  
# gib die UIDs der Nutzer, die die bash als Login-Shell haben, fallend sortiert
# aus; anschließend wird noch die Anzahl dieser Nutzer ausgegeben
  awk -F: '
    BEGIN { sort = "sort -rn" }
    $7 ~ /bash/ { print $3 | sort ; anz++ }
    END { close(sort) ; printf("Anzahl: %d\n", anz) }
  ' /etc/passwd

Numbers and Counting

Print the total number of lines that have the name Bill.

awk '/Bill/{n++}; END {print n+0}' filename

Print line numbers using a tab instead of a space.

awk '{print FNR "\t" $0}' filename

Use awk to pull the seventh field (ex. url string) of each line of the logfile (logfile should be separated by spaces). Sort the fields then find the unique fields and count them. Then do a reverse sort on numeric count. Filter out anything but JPEG files and only give me the top 10 of that list. This is for things like counting unique hostnames or urls from a logfile.

awk '{print $7}' logfile | sort | uniq -c | sort -rn | grep "\.jpg" | head

Fields

Print the last field of each line of the file.

awk '{ print $NF }' filename

Count the lines in a file. Just like "wc -l".

awk 'END{print NR}' filename

Total the number of lines that contain the name Jose

awk '/Jose/{n++}; END {print n+0}' filename

Add up the numbers at the eighth position (field) of each line. Print the total.

awk '{ sum += $8 } END { print sum }' filename

If the fourth field starts with a number then print that fourth field.

awk '$4 ~ /^[0-9]/ { print $4 }' filename
Text Conversion and Substitution

Find and replace "dog" or "cat" or "bird" with "pet" on every line and print it out.

awk '{gsub(/dog|cat|bird,"pet");print}' filename

Find and replace "dog" with "cat" in every file with extension txt.

awk '{gsub("dog", "cat", $0); print > FILENAME}' *.txt

Find every line that begins with cat. In that line replace furry with nothing. Change the file called filename inline (-i).

sed -i '/^cat/{s/furry//}' filename

Find cat by itself on it's own line even if there are spaces or tabs before it or after it. Replace it with dog. Then print the line.

awk '{sub(/^[ \t]*cat .*$/,"dog");print}' filename

Find any line starting with the defined shell variable SHELLVAR (notice ' ' around it so it's evaluated). When the line is found substitute in foo or boo or coo with bar. Edit the file inline.

sed -i '/^'${SHELLVAR}'/s/\(foo\|boo\|coo\)/bar/' filename

From a unix os: convert DOS newlines (CR/LF) (removes the ^M) to Unix format. Works when each line ends with ^M (Ctrl-M).

awk '{sub(/\r$/,"");print}' filename

Remove all carriage returns from file and rewrite the edits back to same file. tr uses the octal form for cr.

tr -d "\015" < filename | tee > filename

From a unix os: Convert Unix newlines (LF) to DOS format.

awk '{sub(/$/,"\r");print} filename

Delete the leading whitespace (spaces or tabs) from front of each line. Text will end up flush left.

awk '{sub(/^[ \t]+/, ""); print}' filename

Delete the trailing whitespace (spaces or tabs) from end of each line.

awk '{sub(/[ \t]+$/, "");print}' filename

Delete leading and trailing whitespace from each line.

awk '{gsub(/^[ \t]+|[ \t]+$/,"");print}' filename

Delete the trailing whitespace (spaces or tabs) from end of each line.

awk '{sub(/[ \t]+$/, "");print}' filename

Insert 6 blank spaces at beginning of each line.

awk '{sub(/^/, "      ");print}' filename

Substitute "dog" with "cat" on lines that don't contain the word "pet".

awk '!/pet/{gsub(/dog/, "cat")};{print}' filename

Print the first 2 fields with a space between the output. Split the fields on the colon (field separator).

awk -F: '{print $1 " " $2}' filename

Swap the first 2 fields.

awk '{tmp = $1; $1 = $2; $2 = tmp; print}' filename

Remove the second field in each line and then print it.

awk '{ $1 = ""; print }' filename
Line Operations

Print the first 6 lines of a file.

awk 'NR <= 6' filename

Print the last line of a file

awk 'END{print}' filename

Print the lines matching the regular expression. (emulates grep).

awk '/regex_here/' filename

Print the lines that don't match the regular expression. (emulates grep -v).

awk '!/regex_here/' filename

Print the line before the regular expression match.

awk '/regex_here/{print x};{x=$0}' filename

Print the line after the regular expression match.

awk '/regex_here/{getline; print}' filename

Print the lines less than 50 characters.

awk 'length < 50' filename

Print the lines 20 through 30.

awk 'NR==20,NR==30' filename

Print the line 50.

awk 'NR==50 {print;exit}' filename

Print lines between the match starting at "Dog" and ending at "Cat".

awk '/Dog/,/Cat/' filename
File and Process Operations

Find a program by name from process listing that is not awk and kill it. Or try the programs pkill or killall.

ps aux | awk '/program_name/ && !/awk/ {print $2}' > kill

Create a 2 meg file (in 1 kilobyte blocks) in /tmp called zero. 1k can be changed to 1M for meg or 1G for gig in my version of dd.

dd if=/dev/zero of=/tmp/zero bs=1k count=2000

From the root dir (/) find all files with the .txt extention and delete them. Using xargs is faster than find's -exec.

find / -type f -name "*.txt" -print | xargs rm

To delete a file who's file name is a pain to define (ex. ^H^H^H) find it's inode number with the command "ls -il". Use the line below to find and delete a file who's (for example) inode number is 128128.

find . -inum 128128 | xargs rm

Mark the end of each line with a dollar sign so you can see where the filename ends. Good for finding file names with spaces at the end.

ls -lA | cat -e

To delete files with control characters in them like ^M or ^L use the control-V shell feature. This tells many shells to interpret the next input character as a literal character (instead of as a control character). Like below to delete a file with a space before the ctrl-L " ^L" you would issue the following keystrokes in this order (separated by commas) r,m, ,\, ,ctrl-v,ctrl-l. The \ escapes the space. The command looks like:

rm \ ^L

Synchronize files in a directory between 2 hosts using the program rsync. host1's /disk01 (source) is the remote host and /disk01 (destination) is a local directory. The destination is always made to look like the source even if files need to be deleted in the destination (--delete). The source's data is never touched. The source is always named first and the destination is always named second. Trailing / on the source as means copy the contents of this directory to the destination. Without the trailing / on the source you get the directory name copied with all it's files in it. Below uses ssh as the remote-shell program as the transport. It also turns on the lowest grade encryption to speed up the transfer.

rsync -av --delete --rsh="ssh -c arcfour -l root" host1.domain.lan:/disk01/ /disk01/
Misc

Take a file with a list of hostnames and login via ssh and get disk usage. SSH keys will need to be setup for auto login. Each command is back grounded so all commands are executed one after another.

for HOST in $(< ListOfHosts); do ssh $HOST `df -h` & done

Set group id and sticky bits on a dir.

chmod g=swrx,+t DIR/

Use wget grab all of a certain type of file listed on a web page and put them in the current dir. The example will use jpeg's.

wget -r -l1 --no-parent -A "*.jpg" http://www.website.com/pictures/ 


## Use awk to trim leading and trailing whitespace
echo "${output}" | awk '{gsub(/^ +| +$/,"")} {print "=" $0 "="}'
