#!/bin/bash
# source : https://www.pantz.org/software/ssh/using_ssh_and_sudo_instead_of_root_for_remote_commands.html
for HOST in $(< /home/user/hosts); do
  echo ""
  echo "###############"
  echo "# HOSTNAME: $HOST"
  echo "###############"
  # This line is for back grounding each command to execute them on all systems at once
  # ssh -q -o ConnectTimeout=3 $HOST "echo password | sudo -S $* >/dev/null 2>&1 &"
 
  ssh -q -o ConnectTimeout=3 $HOST "echo password | sudo -S $*"

  if [ $? -ne 0 ]; then
    echo "---- COULD NOT CONNECT TO $HOST ----"
  fi
