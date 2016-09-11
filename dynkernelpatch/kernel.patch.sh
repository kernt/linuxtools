#!/bin/bash 
#
#
#
#
#
#
#
#
#
#
#
#
#NOTE: While kpatch is designed to work with any recent Linux kernel on any distribution, 
#the kpatch-build command has ONLY been tested and confirmed to work on 
#Fedora 20, RHEL 7, Oracle Linux 7, CentOS 7 and Ubuntu 14.04.
#
#First, make a source code patch against the kernel tree using diff, git, or quilt.
#As a contrived example, let's patch /proc/meminfo to show VmallocChunk in ALL CAPS so we can see it better:
#
cat meminfo-string.patch
sleep 10

# for example like this screen
#Index: src/fs/proc/meminfo.c
#===================================================================
#--- src.orig/fs/proc/meminfo.c
#+++ src/fs/proc/meminfo.c
#@@ -95,7 +95,7 @@ static int meminfo_proc_show(struct seq_
#        "Committed_AS:   %8lu kB\n"
#        "VmallocTotal:   %8lu kB\n"
#        "VmallocUsed:    %8lu kB\n"
#-       "VmallocChunk:   %8lu kB\n"
#+       "VMALLOCCHUNK:   %8lu kB\n"
# #ifdef CONFIG_MEMORY_FAILURE
#        "HardwareCorrupted: %5lu kB\n"
# #endif

echo "Build the patch module:"

kpatch-build -t vmlinux meminfo-string.patch
## should be like this output.
#Using cache at /home/jpoimboe/.kpatch/3.13.10-200.fc20.x86_64/src
#Testing patch file
#checking file fs/proc/meminfo.c
#Building original kernel
#Building patched kernel
#Detecting changed objects
#Rebuilding changed objects
#Extracting new and modified ELF sections
#meminfo.o: changed function: meminfo_proc_show
#Building patch module: kpatch-meminfo-string.ko
#SUCCESS

## NOTE: The -t vmlinux option is used to tell kpatch-build to only look for changes in the vmlinux base kernel image,
##        which is much faster than also compiling all the kernel modules. If your patch affects a kernel module, 
##        you can either omit this option to build everything, and have kpatch-build detect which modules changed, 
##        or you can specify the affected kernel build targets with multiple -t options.

#That outputs a patch module named kpatch-meminfo-string.ko in the current directory. Now apply it to the running kernel:

kpatch load kpatch-meminfo-string.ko
#loading core module: /usr/local/lib/modules/3.13.10-200.fc20.x86_64/kpatch/kpatch.ko
loading patch module: kpatch-meminfo-string.ko

echo "Done! The kernel is now patched."

grep -i chunk /proc/meminfo

#VMALLOCCHUNK:   34359337092 kB


exit 0
