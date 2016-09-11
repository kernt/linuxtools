# Autostart with systemd
# Author: Tobias kern
#
#
#
#
#
# source : manpage
################################
# Your init scrit starter
# for example
#/etc/systemd/system/tmux@.service
# and copy into your script.
#
#

[Unit]
Description=Start tmux in detached session

[Service]
Type=oneshot
RemainAfterExit=yes
KillMode=none
User=%I
ExecStart=/usr/bin/tmux new-session -s %u -d
ExecStop=/usr/bin/tmux kill-session -t %u

[Install]
WantedBy=multi-user.target
