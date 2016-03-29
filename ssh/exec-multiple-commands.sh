file=/tmp/file.log
ssh ${options} ${login} "if [ ! -e '$file' ] ; then touch '$file' ; fi"
