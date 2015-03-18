# check is app installed and then return 0 if not  return 1
if [ "$(dpkg -s wget | grep -i "Status:" | awk '{print $4}' 2>/dev/null)" != "installed" ]; then
	return 1
fi
