#!/bin/bash

workpath=/usr/share/runPHI/

workpath=/usr/share/runX

containerid="$1"
hyperv="$2"

case $hyperv in

  "XEN")
                xl unpause "$1"
        ;;

  "Jailhouse")

                ## al posto di fare questo controllo qua posso utilizzare lo state-guest che va implementato
                #
                if test -a "$crundir"/kernel && test -a "$crundir"/initrd
                then
                        echo -e "Linux non-root cell "$1" has already been running, connect to Guest through ssh root from localhost to port number exposed \n"
                else
                        jailhouse cell start "$containerid"
                fi
    ;;

  *)
    ##Future implementation bracket
    ;;
esac