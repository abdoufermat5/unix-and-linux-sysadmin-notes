# Chapter 11: Drivers and the Kernel

![drivers-kernel](https://www.researchgate.net/publication/301370659/figure/fig1/AS:356133665161219@1461920290608/Device-drivers-in-the-Linux-kernel.png)

The kernel is the central government of a UNIX or Linux system. It’s responsible for enforcing rules, sharing resources, and providing the core services that user processes rely on.

The kernel hides the details of the system's hardware underneath an abstract, high-level interface. It's akin to an API for application programmers: a well-defined interface that provides useful facilities for interacting with the system. This interface provides five basic features:

- Management and abstraction of hardware devices
- Processes and threads (and ways to communicate among them)
- Management of memory (virtual memory and memory-space protection)
- I/O facilities (filesystems, network interfaces, serial interfaces, etc.)
- Housekeeping functions (startup, shutdown, timers, multitasking, etc.)

Only device drivers are aware of the specific capabilities and communication protocols of the system’s hardware. User programs and the rest of the kernel are largely independent of that knowledge. 

For example, a filesystem on disk is very different from a network filesystem, but the kernel's VFS layer makes them look the same to user processes and to other parts of the kernel.

---

## Kernel version numbering

### Linux kernel versions

 You can check with `uname -r` to see what kernel a given system is running.
 Linux kernels are named according to the rules of so-called semantic versioning, that is, they include three components: a major version, a minor version, and a patch level. At present, there is no predictable relationship between a version number and its intended status as a stable or development kernel; kernels are blessed as stable when the developers decide that they’re stable.

## Devices and their drivers

A device driver is an abstraction layer that manages the system’s interaction with a particular type of hardware so that the restof the kernel doesn't need to know its specifics. The driver translates between the hardware commands understood by the device and a stylized programming interface defined(and used by the kernel). 

### Device files and device numbers

In most cases, device drivers are part of the kernel; they are not user processes. However, a driver can be accessed both from within the kernel and from user space, usually through "device files" that live in **/dev** directory.

Most non-network devices have one or more corresponding files in /dev. Complex servers may support hundreds of devices. By virtue of being device files, the files in /dev each have a major and minor device number associated with them. The kernel uses these numbers to map device-file references to the corresponding driver.

The major device number identifies the driver with which the file is associated (in other words, the type of device). The minor device number usually identifies which particular instance of a given device type is to be addressed. The minor device number is sometimes called the unit number.

```bash
$ ls -l /dev/sda
brw-rw---- 1 root disk 8, 0 2024-04-05 14:50 /dev/sda
```

This example shows the first SCSI/SATA/SAS disk on a Linux system. It has a major device number of 8 and a minor device number of 0. The major device number 8 is associated with the SCSI disk driver, and the minor device number 0 is the first disk on the system.

