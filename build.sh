#!/bin/bash

oci_cmd="start-guest guest-state create-guest"

mkdir -p target/usr/share/runPHI
for i in $oci_cmd; do
    cp tools/$i target/usr/share/runPHI
done

cp -r tools/utils/ target/usr/share/runPHI/

mkdir -p target/usr/sbin
cp runphi.sh target/usr/sbin


# here should be place a block to compile built-in stuffs (like kernel/ramdisk supported by hypervs)
# also a section to check the system architecture and set it based on the detected architecture.
