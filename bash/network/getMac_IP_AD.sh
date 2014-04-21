function getMacV6IpAdd() {
MACIPV6=$(ip -f inet6 addr show eth0 | grep "inet6" | awk '{ print $2 }')
echo ${MACIPV6}
}

# Beispiel : getMacV6IpAdd

function getMacAdd() {
MACADD=$(ip  addr show eth0 | grep "link/ether" | awk '{print $2}')
echo ${MACADD}
}
