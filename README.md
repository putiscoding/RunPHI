# RunPHI

## Goal and Scope

RunPHI is a young project that arises the need to find a processing environment homogeneous for multi-domain applications, supporting mobility of workloads between cloud and edge.
The objective concerns the transfer of consolidated technologies and de facto standards of the cloud computing in resource-constrained computing environments at the edge.

Currently the project aims to offer a solution for the seamless deployment of applications, distributed in the various computational domains of IoT, via the new concept of Partitioned Containers.
According to that vision, OS-Virtualization (i.e containers) is used as enabling technology for Cloud through the supprt of Orchestration Systems while stronger isolation, both temporal and spatial, is guaranteed with the help of Partitioning Hypervisor at the edge.
The same container must be distributed transparently on a high-end server with a fully-fladged hypervisor (i.e Linux) or on a low-end device with a partitioning hypervisor.

Right now RunPHI supports the translation of OCI commands by creating hardware partitions, relying on Jailhouse Hypervisor, starting from Docker's container descriptions.

## Architecture 

RunPHI is a new OCI-compliant low-level runtime which static partition the hardware, according to container's specifications, for isolation and security requirements. 

It relies on:
- a layer that manages the OCI compliance by interfacing with the containerd shim.
- a layer that allows recognition of the hypervisor running upon the hardware.
- a module that automatically manages the hardware configuration based on container description files and underlying partitioning hypervisor.
- provides a CLI for partition lifecycle management by abstracting hardware details.

The configuration module is based on:
- a layer that takes care of domain booting configuration
- a layer for network configuration
- a layer for devices
- a layer for CPU management
- a layer that manages the amount of RAM allocated to the guest

## Set-up 

Currently RunPHI only supports Jailhouse Hypervisor. 
For this reason, you must first make sure that the environment in which you work:
- has Jailhouse enabled and root cell running.
- supports containerd and that it is installed correctly in the root cell.

After that you need to:
- download the RunPHI source code and run build.sh
- enable RunPHI as containerd low-level runtime:  mv /usr/sbin/runPHI /usr/bin/runc

## Use Cases 

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
    
    +--------------+  	   +-------------+	 +------------+
|  Root Cell   | 	   |   Kernel 	 |	 |	          |
|--------------|  	   |-------------|	 |	          |
| ContainerD   |  	   |   initrd    |	 | Bare Metal |
|     |        |  	   |-------------|	 |    APP     |
|   RunPHI     |  	   |  container  |	 |	          |
|     |        |  	   | rootfs.cpio |	 |	          |
| create-guest-+------>|             |	 |	          |
|      \-------+------------------------>|	          | 
+--------------+-------+-------------+---+------------+
|                         Jailhouse              	  |
+-----------------------------------------------------+
    
   
    Where LinuxInstallation.img is the image of Ubuntu 18.04. Download and install Jailhouse in it following the official page. 
    Enable the root cell through qemu-x86.cell from Jailhouse source code. Install RunPHi in the root-cell and then create a Docker Image through the following Dckerfile: 
    
     FROM alpine:latest

    # Copy the apic
    -demo.bin file to the container
    COPY /path/to/jailhouse/inmates/apic-demo.bin /home/apic-demo.bin
    
    # Set the INMATES environmental variable
    ENV INMATE=/home/apic-demo.bin
    
    
    Follow instruction in the code and modify create-guest.sh. Call docker run.
