Nice programm for Network Administrating



Introduction

Network security administrators sometimes need to be able to abort TCP/IP connections routed over 
their firewalls on demand. This would allow them to terminate connections such as SSH tunnels or VPNs 
left in place by employees over night, abort hacker attacks when they are detected, 
stop high bandwidth consuming downloads - etc. 
There are many potential applications.
This article describes how a Linux IPTables based firewall/router can be used to send the right 
combination of TCP/IP packets to both ends of a connection to cause them to abort the conversation. 
It describes the steps required to perform this task, 
and introduces a new open-source utility called "cutter" that automates the process.

http://www.digitage.co.uk/digitage/files/cutter


I hope i can show you some examples at next time.
