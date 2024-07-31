# Chapter 20: Storage

![storage-joke](https://preview.redd.it/e8mobun47o671.png?auto=webp&s=c09cfc2bbd77cd637d22dfdfcf1c60f76a4f464b)

Data storage systems are looking more and more like a giant set of Lego blocks that you can assemble in an infinite variety of configurations. You can build anything from a lightning-fast storage space for a mission critical database to a vast, archival vault that stores three copies of all data and can be rewound to any point in the past.

Mechanical hard drives remain a popular storage medium when capacity is the most important consideration, but solid state drives (SSDs) are preferred when performance-sensitive applications. Caching systems, both software and hardware, help combine the best features these storage types.

Running on top of real and virtual hardware are a variety of software components that mediate between the raw storage devices and the filesystem hierarchy seen by users. These components include device drivers, partitioning conventions, RAID implementations, logical volume v$managers, systems for virtualizing disks over a network, and the filesystem implementations themselves.

## Just want to add a disk

You want to install a hard disk and make it accessible through the filesystem. Step one is to attach the drive. In cloud environments you just need to setup the desired size and click "next". In the case of physical hardware, drives that communicate through a USB port can simply be powered on and plugged in. SATA and SAS drives need to be mounted in a bay, enclosure, or cradle. Then you have to reboot the system to make sure the OS is in a config that's reasonably reproducible at boot time.

### Linux recipe

First, run `lsblk` to list the system's disk and identify the new drive or `lsblk -o +MODEL,SERIAL` to get more details. Once you know which device file refers to the new disk (assume it's **/dev/sdb**), install a partition on the disk. Several commands and utilities can do this, including `fdisk`, `parted`, `gparted`, `cfdisk`, and `sfdisk`. Here's an example using `fdisk`:

![fdisk-recipe](./data/fdisk-recipe.png)

The device file for the newly created partition is the same as the device file for the disk as a whole, but with a number appended. For example, if the disk is **/dev/sdb**, the first partition will be **/dev/sdb1**. You can now format the partition with a filesystem. The `mkfs` command is used to create a filesystem on a partition. For example, to create an ext4 filesystem on **/dev/sdb1**, run:

```bash
sudo mkfs -t ext4 -L fermatfs /dev/sdb1
...
...
```

Next, create a mount point and mount the newly created filesystem.

```
sudo mkdir /fermatfs
sudo mount LABEL=fermatfs /fermatfs
```

To have the filesystem automatically mounted at boot time, edit the **/etc/fstab** file and duplicate one of the existing entries.

## Storage hardware

Even in today’s post-Internet world, computer data can be stored in only a few basic ways: hard disks, flash memory, magnetic tapes, and optical media. THe last two technologies have significant limitations that disqualify them from use as a system's primary filesystem.

After 40 years of traditional magnetic disk technology, performance-minded system builders finally received a practical alternative in the form of solid state disks (SSDs). These flash-memory-based devices offer a different set of tradeoffs from those of a standard disk, and they will be influencing the architectures of databases, filesystems, and operating systems for years to come.

![hdd-vs-ssd](./data/hdd-vs-ssd.png)

### Hard disks

A typical hard drive contains several rotating platters coated with magnetic film. They are read and written by tiny skating heads mounted on a metal arm that swings back and forth to position them. The heads float close to the surface of the platters but don’t actually touch them.

Reading from a platter is quick; it’s the mechanical maneuvering needed to address a particular sector that drives down random-access throughput. Delays come from two main sources.

A set of tracks on different platters that are all the same distance from the spindle is called a cylinder. The cylinder’s data can be read without any additional movement of the arm. Although heads move amazingly fast, they still move much more slowly than the disks spin around. Therefore, any disk access that does not require the heads to seek to a new position will be faster.

[![https://i0.wp.com/mycloudwiki.com/wp-content/uploads/2016/06/4-1.jpg?resize=640%2C547](https://i0.wp.com/mycloudwiki.com/wp-content/uploads/2016/06/4-1.jpg?resize=640%2C547)](https://www.youtube.com/watch?v=oEORcCQ62nQ)

Spindle speeds vary. 7,200 RPM remains the mass-market standard for enterprise and performance-oriented drives. A few 10,000 RPM and 15,000 RPM drives remain available at the high end. The faster the spindle speed, the faster the heads can move from one track to another. Higher rotational speeds decrease latency and increase the bandwidth of data transfers, but they also increase power consumption and heat generation.

**Drive types :**

Only two manufacturers of hard drives remain: Seagate and Western Digital. You may see a few other brands for sale, but they're all ultimately made by these same two companies.

Brands segment their hard disk offerings into a few general categories:

- **Value drives:** Performance isn’t a priority, but it’s usually decent. 
- **Mass-market performance drives:** They perform notably better than value drives on most benchmarks. As with value drives, firmware tuning emphasizes single-user patterns such as large sequential reads and writes.
- **NAS drives:** NAS stands for “network-attached storage,” but these drives are intended for use in all sorts of servers, RAID systems, and arrays--anywhere that multiple drives are housed and accessed together.
- **Enterprise drives:** expensive non-SATA interfaces and uncommon features such as 10000+ RPM spindle speeds.

### Solid state disks

SSDs spread reads and writes across banks of flash memory cells, which are individually rather slow in comparisson to modern hard disks. But because of parallelism, the SSD as a whole meets or exceeds the bandwidth of a traditional disk. 

**flash memory types:**

SSDs are constructed from several types of flash memory: SLC, MLC, TLC, and QLC. The main difference between these types is the number of bits stored in each cell. SLC stores one bit per cell, MLC stores two, TLC stores three, and QLC stores four. The more bits per cell, the cheaper the flash memory is to produce, but the slower and less reliable it is.

**Page clusters and pre-erasing:** 

Unlike hard drives where you can just overwrite data, flash memory has to be erased before you can put new data on it. SDs can't erase individual bits of information. They erase in chunks called clusters. Pre-erasing is the process of erasing sections of an SSD's memory in advance so that new data can be written quickly without having to wait for erasing to happen.

**Reliability:**

SSDs commonly experience minor errors that are automatically corrected, but even the best models can suffer occasional uncorrectable errors leading to data loss. These errors aren't strongly linked to age or workload, and affected SSDs usually continue to function normally afterwards. SSDs are reliable, but their failures are subtle. Regular monitoring is essential, and they shouldn't be used for long-term archiving. An isolated bad block isn't necessarily a cause for alarm.

### Hybrid drives

The initialism SSHD stands for “solid state hybrid drive” and is something of a triumph of marketing, designed as it is to encourage confusion with SSDs. SSHDs are just traditional hard disks with some extras on the logic board; in reality, they’re about as “solid state” as the average dishwasher.

### Advanced format and 4KiB blocks

The storage industry has transitioned to 4KiB blocks (Advanced Format) for efficiency. While most new devices can emulate older 512-byte sectors, it's important to be aware of potential misalignment issues, especially with older systems.

## Storage hardware interfaces

![storage-interfaces](https://www.researchgate.net/publication/342150780/figure/tbl1/AS:901954205126657@1592054048849/A-comparison-on-Storage-interfaces-for-IoT.png)

### SATA

Serial ATA (SATA) is the most common interface for hard drives. SATA has native support for hot swapping and optional command queueing. 

### PCI Express (PCIe)

PCIe (Peripheral Component Interconnect Express) is a high-speed serial bus that connects devices to the motherboard. It's used for SSDs and other high-performance storage devices.

When comparing PCIe to SATA, keep in mind that SATA’s speed of 6 Gb/s is quoted in gigabits per second. Full-width PCIe is actually more than 20 times faster than SATA.

| Version | Release Year | Bandwidth per Lane | Total Bandwidth (lane x16) | Notable Features |
|---------|--------------|---------------------|------------------------|-------------------|
| PCIe 1.0 | 2003 | 250 MB/s | 4 GB/s | Initial release |
| PCIe 2.0 | 2007 | 500 MB/s | 8 GB/s | Doubled bandwidth |
| PCIe 3.0 | 2010 | 985 MB/s | 15.75 GB/s | Improved encoding |
| PCIe 4.0 | 2017 | 1.97 GB/s | 31.5 GB/s | Doubled bandwidth again |
| PCIe 5.0 | 2019 | 3.94 GB/s | 63 GB/s | Improved signal integrity |
| PCIe 6.0 | 2022 | 7.88 GB/s | 126 GB/s | Pulse Amplitude Modulation 4-level (PAM4) signaling |
| PCIe 7.0 | Expected 2025 | ~15.75 GB/s | ~252 GB/s | In development |

**Lane Configurations :**

PCIe devices can use different numbers of lanes, typically denoted as x1, x4, x8, or x16:

- x1: 1 lane
- x4: 4 lanes
- x8: 8 lanes
- x16: 16 lanes

The total bandwidth of a PCIe slot or device is calculated by multiplying the bandwidth per lane by the number of lanes. The table above shows the maximum theoretical bandwidth for a x16 configuration, which is the highest commonly used in consumer and many professional devices.

### USB

The Universal Serial Bus (USB) is a popular option for connecting external hard disks.

| Version | Year | Max Data Rate | Key Highlights |
|---------|------|---------------|----------------|
| USB 1.1 | 1998 | 12 Mbit/s | Original widely-adopted standard |
| USB 2.0 | 2000 | 480 Mbit/s | Major speed increase, still common |
| USB 3.0 | 2008 | 5 Gbit/s | 10x faster than USB 2.0, introduced blue ports |
| USB 3.1 | 2013 | 10 Gbit/s | Doubled USB 3.0 speed |
| USB 3.2 | 2017 | 20 Gbit/s | Introduced multi-lane operation |
| USB4 | 2019 | 40 Gbit/s | Based on Thunderbolt 3, supports video output |
| USB4 v2.0 | 2022 | 80 Gbit/s | Latest announced version, not yet widely available |

**Note:** USB-C (introduced in 2014) is a connector type, not a USB version. It's compatible with USB 3.1 and later versions, offering reversible plug orientation.

## Attachment and low-level management of drives

The way a disk is attached to the system depends on the interface. The rest is all mounting brackets and cabling.

### Disk device files

A newly added disk is represented by device files in **/dev**. 

**Disk Device Naming Standards in Linux and FreeBSD:**

| Aspect | Linux | FreeBSD |
|--------|-------|---------|
| IDE/PATA Disks | /dev/hda, /dev/hdb, /dev/hdc, etc. (older systems) | /dev/ada0, /dev/ada1, etc. |
| SATA Disks | /dev/sda, /dev/sdb, /dev/sdc, etc. | /dev/ada0, /dev/ada1, etc. |
| NVMe Disks | /dev/nvme0n1, /dev/nvme0n2, /dev/nvme1n1, etc. | /dev/nvd0, /dev/nvd1, etc. |
| Virtual Disks | /dev/vda, /dev/vdb, etc. (for VMs) | /dev/vtbd0, /dev/vtbd1, etc. |
| Partitions | Appended numbers: sda1, sda2, nvme0n1p1, etc. | Appended letters: ada0p1, ada0p2, nvd0p1, etc. |
| Software RAID | /dev/md0, /dev/md1, etc. | /dev/mirror/name, /dev/stripe/name, etc. |
| Logical Volumes (LVM) | /dev/mapper/vgname-lvname | N/A (LVM not natively supported) |
| ZFS Pools | /dev/zd0, /dev/zd1, etc. (for zvols) | N/A (uses labels instead of device names) |

**Additional Notes:**

1. Linux:
   - Modern Linux systems often use persistent naming schemes like /dev/disk/by-id/ or /dev/disk/by-uuid/ for more stable device identification.
   - Newer versions may use /dev/sd* for all types of disks, including PATA.

2. FreeBSD:
   - Uses a unified ada* naming scheme for ATA (including both PATA and SATA) disks.
   - SCSI disks use /dev/da0, /dev/da1, etc.
   - Supports GEOM labels for persistent naming.

use `parted -l` to list the sizes, partition tables, model numbers, and manufacturers of all disks attached to the system. 

### ATA secure erase

ATA secure erase is a feature built into most modern hard drives that allows you to securely erase all data on the drive. This is useful if you're selling or giving away a drive and want to make sure no one can recover your data. The `hdparm` command can be used to perform an ATA secure erase.

```bash
sudo hdparm --user-master u --security-set-pass password /dev/sdX
sudo hdparm --user-master u --security-erase password /dev/sdX
```

### Hard disk monitoring with SMART

Self-Monitoring, Analysis, and Reporting Technology (SMART) is a monitoring system built into most modern hard drives. SMART can be used to predict hard drive failures by monitoring various drive statistics. The `smartctl` command can be used to view SMART data.

```bash
sudo smartctl -a /dev/nvme0
```

## The software side of storage: peeling the onion

If you are a basic user with basic needs on a system with GUI (like Windows or macOS or even a Linux desktop), you can just follow the GUI after plugging in a new disk. But if you are a system administrator or a power user, you need to understand the software side of storage.

### Elements of a storage system

![storage-mgmt-layer](./data/storage-mgmt-layer.png)

Exhibit A shows a typical set of software components that can mediate between a raw storage device and its end users.

- **Storage device** is anything that looks like a disk. This is the physical layer, consisting of the actual hardware used to store data, such as hard drives, SSDs, and other storage media.
- **Partition** is a fixed-size subsection of a storage device. Each partition has its own device file and acts much like an independent storage device.
- **Volume groups and logical volumes** These systems aggregate physical devices to form pools of storage called volume groups. An admin can then subdivide this pool into logical volumes in much the same way disk can be divided into partitions. For example, a 6TB disk and a 2TB disk could be aggregated into 8TB volume group and then split into 4TB logical volumes.

![pv-vg-lv](https://www.sysonion.de/wp-content/uploads/2019/01/LVM-Schaubild.jpg)

- **RAID array** (Redundant Array of Independent/Inexpensive Disks) combines multiple storage devices into one virtualized device. RAID can provide data redundancy (protection against data loss) and/or increase data throughput.
- **Filesystem** mediates between the raw bag of blocks presented by a partition, RAID array, or logical volume and the standard filesystem interface expected by programs: */var/spool/mail*, UNIX file types, permissions, and so on.

### Linux device mapper

The Linux device mapper is a kernel-level framework that provides a generic way to create virtual block devices. It's used by LVM, software RAID, and encryption systems to create virtual block devices that can be used like any other block device.

### Partitioning a disk

Partitioning a disk is the process of dividing it into smaller sections called partitions. Each partition acts like an independent storage device and has its own device file. 