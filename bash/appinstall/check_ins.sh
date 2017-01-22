# check is app installed and then return 0 if not  return 1

APP="$@"

if [ "$(dpkg -s ${APP} | grep -i "Status:" | awk '{print $4}' 2>/dev/null)" != "installed" ]; then
	exit 1
fi

# as function 
# if [ "$(dpkg -s ${APP} | grep -i "Status:" | awk '{print $4}' 2>/dev/null)" != "installed" ]; then
# 	return 1
# fi
