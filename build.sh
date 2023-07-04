#!/bin/bash


# NB: 
# References are created in /target because cross compilation is expected in the future

oci_cmd="start-guest create-guest"


mkdir -p target/usr/share/runPHI
for i in $oci_cmd; do
    cp tools/$i target/usr/share/runPHI
done

#utils
cp -r tools/utils/ target/usr/share/runPHI/

#check-hyperv
cp check_hypervisor target/usr/share/runPHI/utils


mkdir -p target/usr/share/runPHI/config_generator
#config-generator
cp config_generator/generate_guest_config  target/usr/share/runPHI/config_generator
cp -r config_generator/utils  target/usr/share/runPHI/config_generator


#built-in
cp -r built-in  target/usr/share/runPHI/built-in


mkdir -p target/usr/sbin
cp runphi target/usr/sbin


# here should be place a block to compile built-in stuffs (like kernel/ramdisk supported by hypervs)
# also a section to check the system architecture and set it based on the detected architecture.

##### Just a sample 

### Support cross-compiling via ARCH variable
#
#	if [[ -z "$ARCH" ]]
#	then
# 		 ARCH=`uname -m`
#	fi
#	if [[ $ARCH = "x86_64" ]]
#	then
#	    export ARCH="x86"
#	elif [[ $ARCH = "aarch64" || $ARCH = "arm64" ]]
#	then
#	    export ARCH="arm64"
#	elif [[ $ARCH = "arm" || $ARCH = "arm32" ]]
#	then
#	    export ARCH="arm"
#	else
#	    echo Architecture not supported
#	    exit 1
#	fi
#
#
#
#
#
#
### Build the kernel and initrd
#
#	if test \! -f target/usr/share/runPHI/built-in/jail/kernel
#	then
#	    # Here a script which build the kernel should be implemented
#	    kernel/make-kernel
#	    cp kernel/out/kernel target/usr/share/runPHI
#	fi
#	if test \! -f target/usr/share/runPHI/built-in/jail/initrd
#	then
#	    # Here a script for initrd 
#	    initrd/make-initrd
#	    cp initrd/out/initrd target/usr/share/runX
#	fi
#
#
#

