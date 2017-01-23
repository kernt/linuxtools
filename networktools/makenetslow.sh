!/bin/bash
sudo tc qdisc add dev lo root netem delay 500ms

exit 0
