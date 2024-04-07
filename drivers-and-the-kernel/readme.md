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

There are actually two types of device files: block and character. A block device is read or written one block (a group of bytes, usually a multiple of 512) at a time; a character device can be read or written one byte at a time. The character "b" or "c" in the first column of the ls -l output indicates whether a device file is a block or character device.

It is sometimes convenient to implement an abstraction as a device driver even it controls no actual device. Such phantom devices are called pseudo-devices. For example, a user who logs in over the network is assigned a pseudo-TTY (PTY) that looks, feels, ad smells like a serial port from the perspective of higher-level software. Some pseudo-devices are used for debugging, such as `/dev/null`, which discards all data written to it, and `/dev/zero`, which returns an infinite number of zero bytes when read, or `/dev/urandom`, which returns an infinite number of random bytes when read.

When a program performs an operation on a device file, the kernel intercepts the reference, looks up the appropriate function name in a table, and transfers control to the appropriate part of the driver.

### Manual creation of device files

The `mknod` command can be used to create device files manually. The syntax is:

```bash
$ mknod /dev/mydevice type major minor
```

where type is either `b` for block or `c` for character, and major and minor are the major and minor device numbers, respectively.

### Modern device file management

The `udevd` daemon is responsible for managing device files in modern Linux systems. It creates device files dynamically as devices are discovered or added to the system. The `udev` daemon reads its configuration from the `/etc/udev` directory and from the `/lib/udev` directory. The configuration files in `/etc/udev` override those in `/lib/udev`.

![components-device-file](./data/components-device-file.png)

### Linux device management

**Sysfs:** a window into the souls of devices

Sysfs was added to the Linux kernel at version 2.6. It is a virtual, in-memory filesystem implemented by the kernel to provide detailed and well-organized information about the system’s available devices, their configurations, and their state. Sysfs device information is accessible both from within the kernel and from user space.

Sysfs is mounted at `/sys` and is organized as a hierarchy of directories and files. Each directory represents a device or a device class, and each file contains a piece of information about the device or class. The information in sysfs is read-only and is updated by the kernel as devices are discovered, added, or removed.

- Subdirectories of `/sys` :

| Directory     | Description                                                        |
| ------------- | ------------------------------------------------------------------ |
| /sys/block    | Information about block devices such as hard disks                 |
| /sys/bus      | Buses known to the kernel: PCI-E, SCSI, USB, etc.                  |
| /sys/class    | A tree organized by functional types of devices                    |
| /sys/dev      | Device information split between character and block devices       |
| /sys/devices  | An ancestrally correct representation of all discovered devices    |
| /sys/firmware | Interfaces to platform-specific subsystems such as ACPI            |
| /sys/fs       | A directory for some, but not all, filesystems known to the kernel |
| /sys/kernel   | Kernel internals such as cache and virtual memory status           |
| /sys/module   | Dynamic modules loaded by the kernel                               |
| /sys/power    | A few details about the system’s power state                       |


**udevadm:** the udev administration tool

The `udevadm` command queries device information, triggers events, controls the **udevd** daemon, and monitors udev and kernel events. 

`udevadm` expects one of six commands as its first argument:

- `info` : Display information about a device
For example, `udevadm info -a -p /sys/class/net/eth0` displays information about the network interface eth0.

- `trigger` : Trigger the kernel to process a device event
For example, `udevadm trigger --subsystem-match=block` triggers the kernel to process block device events.

- `settle` : Wait for all pending udev events to be processed
For example, `udevadm settle` waits for all pending udev events to be processed.

- `control` : starts and stops the udev daemon or forces it to reload its rules files
For example, `udevadm control --reload` forces the udev daemon to reload its rules files.

- `monitor` : Monitor udev events as they occur
For example, `udevadm monitor` displays udev events as they occur.

- `test` : Test a single device or a single event
For example, `udevadm test /sys/class/net/eth0` tests the network interface eth0.

All paths in udevadm output (such as `/devices/pci0000:00/…`) are relative to `/sys`, even though they may appear to be absolute pathnames.

udevd match keys:

![udevd-match-keys](./data/udevd-match-keys.png)

The assignment clauses specify actions udevd should take to handle any matching events. Their format is similar to that for match clauses.

THe most important assignment key is `NAME`, which indicates how `udevd` should name a new device.

Here's an example configuration for a USB flash drive. Suppose we want to make the drive's device name persist across insertions and we want the drive to be mouted and unmounted automatically.
    
```bash
$ lsusb
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 003: ID 0408:a061 Quanta Computer, Inc. HD User Facing
Bus 001 Device 004: ID 8087:0026 Intel Corp. AX201 Bluetooth
Bus 001 Device 007: ID 18f8:0f97 [Maxxter] Optical Gaming Mouse [Xtrem]
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

