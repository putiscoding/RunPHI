#!/bin/bash

workpath=/usr/share/runPHI/

containerid="$1"
crundir="$2"
hyperv="$3"
guestconsole="$4"
conf=""

### Return /path/to/configuration_file
# in case you are testing runPHI in qemu-system-x86 comment below section and set 
# conf=$workpath/built-in/jail/qemu-x86.cell
#
conf=$($workpath/config_generator/generate_guest_config $containerid "$crundir" "$hyperv")

#The mount utility is used to adjust rootfs in case the user uses a -v or --mounts flags
#At the moment it's supported only under XEN since Jailhouse uses a .cpio fs and do not give full
#possibility to user into modify it
$workpath/utils/mount  $containerid "$crundir" mount "$hyperv"
$workpath/utils/create $containerid "$crundir" "$conf" "$hyperv"

#guest console is set when -t flag is provided 
#allocate_console.sh is useful for Hypervisor like XEN or BAO which give the possibility 
# to start Guest with fully fledged OS
# Jailhouse gives only the option to start non-root linux cell but the user can connect to it
# only through ssh
if test "$guestconsole"
    then
        $workpath/utils/allocate_console $containerid "$crundir" "$guestconsole" "$hyperv"
fi
