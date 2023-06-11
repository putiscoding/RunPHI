# RunPHI

## General info
rumPHI comes with a build script that automates the process. For now, being in the testing phase, the user will have to:
copy to /usr/share/runPHI
the scripts present in tools together with utils. The built-ins folder will also go there. This is because in a future iteration we will expect a build file with kernels and then we will expect one with cross-compiling. In that case the user will have to export the entire /usr/share/runPHI content to the target.

## QEMU/KVM apic-demo on x86

This code has been tested through qemu-system_x86 ( quemu vers 7.0.0 ) in a nested setup with Lubuntu 22.04 LTS as HOST and Ubuntu 18.04 LTS as guest

Run the command: 

/path/to/qemu7.0.0/build/qemu-system-x86_64 -machine
    q35,kernel_irqchip=split -m 1G -enable-kvm \
    -smp 4 -device intel-iommu,intremap=on,
    x-buggy-eim=on \
    -cpu host,-kvm-pv-eoi,
    -kvm-pv-ipi,-kvm-asyncpf,
    -kvm-steal-time,-kvmclock \
    -drive file=LinuxInstallation.img, 
    format=raw|qcow2|...,id=disk,if=none \
    -device ide-hd,drive=disk -serial stdio -serial vc \
    -netdev user,id=net -device e1000e,
    addr=2.0,netdev=net \
    -device intel-hda,addr=1b.0 
    -device hda-duplex 
    -device pcie-pci-bridge 
    
   
    Where LinuxInstallation.img is the image of Ubuntu 18.04. Download and install Jailhouse in it following the official page. 
    Enable the root cell through qemu-x86.cell from Jailhouse source code. Install RunPHi in the root-cell and then create a Docker Image through the following Dckerfile: 
    
     FROM alpine:latest

    # Copy the apic
    -demo.bin file to the container
    COPY /path/to/jailhouse/inmates/apic-demo.bin /home/apic-demo.bin
    
    # Set the INMATES environmental variable
    ENV INMATE=/home/apic-demo.bin
    
    
    Follow instruction in the code and modify create-guest.sh. Call docker run.
