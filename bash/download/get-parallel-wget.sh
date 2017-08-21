#!/bin/bash
# Our custom function
cust_func(){
  wget -q "$1"
}
 
while IFS= read -r url
do
        cust_func "$url" &
done < list.txt
 
wait
echo "All files are downloaded."
