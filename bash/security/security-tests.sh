
echo "Verify No Accounts Have Empty Passwords"
awk -F: '($2 == "") {print}' /etc/shadow

echo "Lock all empty password accounts"
passwd -l $@

echo "Make Sure No Non-Root Accounts Have UID Set To 0"
awk -F: '($3 == "0") {print}' /etc/passwd

echo "search for World-Writable Files"
find /dir -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print

echo "search for no owner Files"
find /dir -xdev \( -nouser -o -nogroup \) -print

