#!/bin/bash

workpath=/usr/share/runPHI
MNT_MAX_IT=30
OPT_MAX_IT=15
UMNT_MAX_IT=5

containerid="$1"
crundir="$2"
op="$3"
hyperv="$3"

bundle=$( cat "$crundir"/bundle )
configfile="$bundle"/config.json
mountpoint=""


case $hyperv in

  "XEN")

        mountpoint=$( cat "$crundir"/rootfs )

        for (( i=0 ; i < MNT_MAX_IT ; i++ ))
        do
    jq_type=$( jq -r  .[\"mounts\"][$i][\"type\"] "$configfile" )

    if test "$jq_type" = "null"
    then
        break
    fi

    if test "$jq_type" = "bind"
    then
        jq_des=$( jq -r  .[\"mounts\"][$i][\"destination\"] "$configfile" )
        jq_src=$( jq -r  .[\"mounts\"][$i][\"source\"] "$configfile" )

        if test "$op" = "mount"
        then
            jq_rw="rw"
            jq_bind="bind"
            jq_cmd=""
            for (( j=0 ; j < OPT_MAX_IT ; j++ ))
            do
                jq_opt=$( jq -r  .[\"mounts\"][$i][\"options\"][$j] "$configfile" )

                case "$jq_opt" in
                "null")
                    break
                    ;;
                "bind")
                    ;&
                "rbind")
                    jq_bind="$jq_opt"
                    ;;
                "rw")
                    ;&
                "ro")
                    jq_rw="$jq_opt"
                    ;;
                *)
                    jq_cmd+="$jq_opt,"
                    ;;
                esac
            done

            mkdir "$mountpoint$jq_des" 2> /dev/null
            mount -o "$jq_cmd$jq_bind" "$jq_src"  "$mountpoint$jq_des"
            if test "$jq_rw" = "ro"
            then
                mount -o "$jq_cmd$jq_bind,remount,ro" "$mountpoint$jq_des"
            fi
                        else
                                for (( j=0 ; j < UMNT_MAX_IT ; j++ ))
            do
                umount "$mountpoint$jq_des"
                if test "$?" = "0"
                then
                    break
                else
                    sleep 1
                fi
            done
        fi
    fi
        done
    ;;

  "Jailhouse")
        ##Check if $crundir/kernel and $crundir/initrd exists
        # in that case a linux non root-cell should be started and the mount became significative

        if test -a "$crundir"/kernel && test -a "$crundir"/initrd
        then
                ## Do something, for now not supported
                :
        fi
    ;;

  *)
        ##Open brackets for future RT_Hyperv
    ;;
esac
