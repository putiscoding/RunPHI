#!/bin/bash


### MEM Block
#
#
###

conf="$1"
hyperv="$2"
crundir="$3"

bundle=$( cat "$crundir"/bundle )
configfile="$bundle"/config.json

###This region of code could be extended through code to retrieve other specific Docker's flags which set MEM limitations
##
mem_res=$(jq  -c -r '.["linux"]["resources"]["memory"]["reservation"]' "$configfile") #Domain memory in MB, (--memory-reservation="")
mem_limit=$(jq  -c -r '.["linux"]["resources"]["memory"]["limit"]' "$configfile") #Maximum domain memory in MB, (-m, --memory="")


case $hyperv in

  "XEN")
                ## By default Docker flags exposes mem limitation in bytes in the json file
                ## Xen cfg takes this limitation in MB
                exp=$((10**6))
                if test -n "$mem_res"
                then
                        mem_res=$(((mem_res / exp) +1))
                        echo "memory = $mem_res" >> $conf
                else
                        echo "memory = 1024" >> $conf
                fi

                if test -n "$mem_limit"
                then
                        mem_limit=$(((mem_limit / exp) +1))
                        echo "maxmem = $mem_res" >> $conf
                fi
        ;;

  "Jailhouse")
    ;;

  *)
    ##Future implementation bracket
    ;;

esac
