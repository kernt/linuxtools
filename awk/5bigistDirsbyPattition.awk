PART=($(awk '$1~/^\/dev/ {print $2}' /proc/mounts));for i in ${PART[@]};do echo;df -h $i;sudo du --max-depth=1 -kx $i|sort -nr|awk '{printf("%7.1f GB\t%s\n", ($1/1024)/1024,$0)}'|head -n6;done
