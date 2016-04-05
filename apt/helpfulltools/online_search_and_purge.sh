for i in  $(echo $(aptitude search '~i APPLICATION' -F ' %p' --disable-columns | awk '{if (NR==1 && NF==0) next};1')) ;do  aptitude -y purge $i ; done
