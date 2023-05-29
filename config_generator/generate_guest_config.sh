#!/bin/bash

workpath=/usr/share/runPHI/config_generator

containerid="$1"
crundir="$2"
hyperv="$3"

##
# To make possible also to use config-generator by its own, and not only by upside scripts, 
# Here a module which checks the regularity of "$crundir" should be implemented
#

##Create a new config file
#
if test "$hyperv" = "XEN"
then
        conf="$crundir"/config.cfg
elif test "$hyperv" = "Jailhouse"
then
        conf="$crundir"/config.c
else
        echo -e "Config generator: Hyperv not recognised \n"
        exit 1
fi

rm $conf &> /dev/null
touch $conf

##
#

$workpath/utils/CPU_config "$conf" "$hyperv" "$crundir"

$workpath/utils/MEM_config "$conf" "$hyperv" "$crundir"

$workpath/utils/BOOT_config "$conf" "$hyperv" "$crundir" "$containerid"

$workpath/utils/DEV_config "$conf" "$hyperv" "$crundir"

$workpath/utils/NET_config "$conf" "$hyperv" "$crundir"

echo "$conf"
