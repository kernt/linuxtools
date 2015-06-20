tree -a -L 1 --inodes /     # shows inodes peer dir
function every() { sed -n -e "${2}q" -e "0~${1}p" ${3:-/dev/stdin}; }       # Print every Nth line (to a maximum)+
function every() { N=$1; S=1; [ "${N:0:1}" = '-' ] && N="${N:1}" || S=0; sed -n "$S~${N}p"; }   # Print every Nth line
wget -q -O - http://www.example.com/automation/remotescript.sh | bash /dev/stdin parameter1 parameter2 # Run bash script from web in local machine
