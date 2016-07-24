#Port knocking is a method of externally opening ports on a firewall 
#by generating a connection attempt on a set of prespecified closed ports. 
#Once a correct sequence of connection attempts is received, the firewall rules are dynamically modified to allow the 
#host which sent the connection attempts to connect over specific port(s). 
#A sample port Knocking example for ssh using iptables:

$IPT -N stage1
$IPT -A stage1 -m recent --remove --name knock
$IPT -A stage1 -p tcp --dport 3456 -m recent --set --name knock2
 
$IPT -N stage2
$IPT -A stage2 -m recent --remove --name knock2
$IPT -A stage2 -p tcp --dport 2345 -m recent --set --name heaven
 
$IPT -N door
$IPT -A door -m recent --rcheck --seconds 5 --name knock2 -j stage2
$IPT -A door -m recent --rcheck --seconds 5 --name knock -j stage1
$IPT -A door -p tcp --dport 1234 -m recent --set --name knock
 
$IPT -A INPUT -m --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A INPUT -p tcp --dport 22 -m recent --rcheck --seconds 5 --name heaven -j ACCEPT
$IPT -A INPUT -p tcp --syn -j door
