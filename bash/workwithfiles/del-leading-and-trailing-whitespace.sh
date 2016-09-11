To trim leading and trailing whitespace using bash, try:

#turn it on
shopt -s extglob
output="    This is a test    "
 
### Trim leading whitespaces ###
output="${output##*( )}"
 
### trim trailing whitespaces  ##
output="${output%%*( )}
echo "=${output}="
 
# turn it off
shopt -u extglob
