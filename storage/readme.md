# Chapter 20: Storage

![storage-joke](https://preview.redd.it/e8mobun47o671.png?auto=webp&s=c09cfc2bbd77cd637d22dfdfcf1c60f76a4f464b)

Data storage systems are looking more and more like a giant set of Lego blocks that you can assemble in an infinite variety of configurations. You can build anything from a lightning-fast storage space for a mission critical database to a vast, archival vault that stores three copies of all data and can be rewound to any point in the past.

Mechanical hard drives remain a popular storage medium when capacity is the most important consideration, but solid state drives (SSDs) are preferred when performance-sensitive applications. Caching systems, both software and hardware, help combine the best features these storage types.

Running on top of real and virtual hardware are a variety of software components that mediate between the raw storage devices and the filesystem hierarchy seen by users. These components include device drivers, partitioning conventions, RAID implementations, logical volume managers, systems for virtualizing disks over a network, and the filesystem implementations themselves.

## Just want to add a disk

You want to install a hard disk and make it accessible through the filesystem. Step one is to attach the drive. In cloud environments you just need to setup the desired size and click "next". In the case of physical hardware, drives that communicate through a USB port can simply be powered on and plugged in. SATA and SAS drives need to be mounted in a bay, enclosure, or cradle. Then you have to reboot the system to make sure the OS is in a config that's reasonably reproducible at boot time.

### Linux recipe

First, run `lsblk` (for list block devices) to list the system's disk and identify the new drive or `lsblk -o +MODEL,SERIAL` to get more details. Once you know which device file refers to the new disk (assume it's **/dev/sdb**), install a partition on the disk. Several commands and utilities can do this, including `fdisk`, `parted`, `gparted`, `cfdisk`, and `sfdisk`. Here's an example using `fdisk`:

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

| RAID Level | Min Disks | Description | Advantages | Disadvantages |
|------------|-----------|-------------|------------|---------------|
| RAID 0 | 2 | Striping without parity | High performance, full capacity | No fault tolerance |
| RAID 1 | 2 | Mirroring | Simple, good redundancy | 50% capacity loss |
| RAID 5 | 3 | Striping with distributed parity | Good balance of performance and redundancy | Write performance hit |
| RAID 6 | 4 | Striping with double distributed parity | Can survive two disk failures | More expensive, worse write performance |
| RAID 10 | 4 | Striped set of mirrors | High performance and good redundancy | 50% capacity loss |

These RAID levels are predefined standards. Users choose the appropriate level based on their needs for performance, redundancy, and storage capacity.

- **Filesystem** mediates between the raw bag of blocks presented by a partition, RAID array, or logical volume and the standard filesystem interface expected by programs: */var/spool/mail*, UNIX file types, permissions, and so on.

### Linux device mapper

The Linux device mapper is a kernel-level framework that provides a generic way to create virtual block devices. It's used by LVM, software RAID, and encryption systems to create virtual block devices that can be used like any other block device.

### Partitioning a disk

Partitioning a disk is the process of dividing it into smaller sections called partitions. Each partition acts like an independent storage device and has its own device file.

A few years ago it was impossible to partition a logical volume or RAID, only disks can be partitioned. You could of course put individual disk partitions under the control of a RAID controller or logical volume manager. Modern systems now allow partitioning, RAID, and LVM to be applied at any level.

In fact, partitioning is less desirable than logical volume management in most respects. It’s coarse and brittle and lacks features such as snapshot management. Partitioning decisions are difficult to revise later. The only notable advantages of partitioning over logical volume management are its simplicity and the fact that Windows and PC BIOSs understand and expect it.

All systems have a root “partition” that includes / and most of the local host’s configuration data. In theory, everything needed to bring the system up to single-user mode is part of the root partition. Various subdirectories (most commonly /var, /usr, /tmp, /share, and /home) can be broken out into their own partitions or volumes. Most systems also have at least one swap area.

**Traditional data disk partitioning scheme (Linux device names):**

![trad-part-scheme](./data/trad-part-scheme.png)

Some guide:

- Putting `/tmp` on a separate filesystem limits temporary files to a finite size and saves you from having to back them up.

- It’s useful to put users’ home directories on a separate partition or volume. Even if the root partition is corrupted or destroyed, user data has a good chance of remaining intact.
- Splitting swap space among several physical disks can potentially increase performance, although with today’s cheap RAM it’s usually better not to swap at all.
  
### Traditional partitioning

Despite the universal availability of logical volume managers, some situations still require or benefit from traditional partitioning.

- Only two partitioning scheme are used these days: MBR and GPT.
- Partitions have a defined location on the disk, so they guarantee locality of reference. Logical volumes do not (at least, not by default). This means data in a logical volume might be spread out more on the physical disk(s). By keeping data in a defined area, partitions can potentially offer slightly better performance, especially if they're placed on the faster outer tracks of the disk. This consideration is mainly relevant for systems using traditional HDDs and where disk I/O is a significant performance factor.
- RAID systems use disks or partitions of matched size. For example, if you have three disks of 1TB, 1.5TB, and 2TB, a typical RAID setup might only use 1TB from each disk. This ensures that data can be distributed evenly across all drives in the array. For the extra space, you can isolate it in a separate /spare partition for data infrequently accessed (suitable to not break the RAID performance). If the data on this extra partition is frequently accessed, it can slow down access to the RAID array (disk heads need to move back and forth between RAID portion and spare portion).

### MBR partitioning

Master Boot Record partitioning is an old Microsoft standard that dates back to the 1980s. It’s a cramped and ill-conceived format that can’t support disks larger than 2TB. Who knew disks could ever get that big?

MBR offers no advantages over GPT except that it’s the only format from which old PC hardware can boot Windows.

The MBR label occupies a single 512-byte disk block, most of which is consumed by boot code. Only enough space remains to define 4 partitions (termed `primary`). You can define one of those four to be an extended partition (it contains it's own subsidiary partition table). The windows partitioning system lets one partition be marked `active` and boot loaders look for this one to load the OS from it. Each partition also has a one-byte type attribute that is supposed to signal the partition’s contents.

The MS-DOS command for hard disks partitioning was called fdisk (now `diskpart` in modern windows), still used (at least the naming) on most MBR supported systems.

### GPT: GUID partition tables

Intel’s extensible firmware interface (EFI) project replaced the rickety conventions of PC BIOSs with a more modern and functional architecture. EFI (now UEFI) firmware is now standard for new PC hardware, and EFI’s partitioning scheme has gained universal support among operating systems.

The EFI partitioning scheme, known as a “GUID partition table” or GPT, removes the obvious weaknesses of MBR. It defines only one kind of partition (no more “logical partitions in the extended partition”), and you can create arbitrarily many of them. Each partition has a type specified by a 16-byte ID code (a globally unique ID, or GUID) that requires no central arbitration.

### Linux and FreeBSD partitioning

For Linux use `parted` or `gparted` (the GUI) and for FreeBSD you can use `gpart`.

## Logical Volume Management (LVM)

Imagine a world in which you don’t know exactly how large a partition needs to be. Six months after creating the partition, you discover that it is much too large, but that a neighboring partition doesn’t have enough space. Sound familiar? A logical volume manager lets you reallocate space dynamically from the greedy partition to the needy partition (without giving a damn on where it's neighboring or not!!!!!).

Logical volume management is essentially a supercharged and abstracted version of disk partitioning. It groups individual storage devices into `Volume Groups`. The blocks in a group can then be allocated to `logical volumes`, which are represented by block device files and act like disk partitions.

Logical volumes are more flexible and powerful than disk partitions.

![logical-vol-capacities](./data/logical-vol-capacities.png)

There are three types of LVM: `linear` volumes, `striped` and `mirrored` volumes.

- `Linear Volumes`: Data is written sequentially across one or more physical volumes. (No redundancy, No performance improvements but easy and simple)
- `Striped Volumes`: Data is divided into chunks and distributed across multiple physical volumes. (No redundancy, performance improved)
- `Mirrored Volumes`: Data is duplicated across two or more physical volumes. (Redundancy, performance improved, but usable capacity is divided by `N`)

### Linux logical volume management

Linux's volume manager, called LVM2, is essentially a clone of HP-UX's volume manager. Here a summary of commands:

![lvm-commands-linux](./data/lvm-commands-linux.png)

The top-level architecture of LVM is that individual disks and partitions (physical volumes) are gathered into storage pools called volume groups. Volume groups are then subdivided into logical volumes, which are the block devices that hold filesystems.

A physical volume needs to have an LVM label applied with `pvcreate`.

LVM uses "physical volumes" as a generic term for any block storage, whether it's a whole disk, partition, or RAID array, abstracting away the physical details.

It's also possible to control LVMs with simple `lvm` command (and its various subcommands).

A linux LVM configuration proceeds in a few distinct phases:

- Creating (defining, really) and initializing physical volumes
- Adding the PVs to a volume group
- Creating logical volumes on the VG

In the following example, we set up a 1TB hard disk (**/dev/sdb** and we assume it's already partitioned with all space in a single partition **/dev/sdb1**). Although using an unpartitioned disk with LVM is possible, creating a partition is recommended for better compatibility across different software and operating systems without impacting performance.

```bash
$ sudo pvcreate /dev/sdb1
Physical volume "/dev/sdb1" successfully created
$ sudo vgcreate DEMO /dev/sdb1
Volume group "DEMO" successfully created
$ sudo lvcreate -L 100G -n web1 DEMO
Logical volume "web1" created successfully
```

Here's an ouptput of the `vgdisplay` command;

![vgdisplay-out](./data/vgdisplay-out.png)

- **VG Access:** read/write - The volume group can be both read from and written to.
- **VG Status:** resizable - The size of this volume group can be changed.
- **Open LV:** 0 - There are currently no open logical volumes in this group.
- **Max PV:** 0 - There's no limit to the number of physical volumes that can be added.
- **Cur PV:** 1 - There is currently one physical volume in this group.
- **Act PV:** 1 - One physical volume is active.
- **VG Size:** 1000.00 GiB - The total size of the volume group is about 1 terabyte.
- **PE Size:** 4.00 MiB - Each Physical Extent (the smallest unit of storage allocation) is 4 megabytes.
- **Total PE:** 255990 - The total number of physical extents in the volume group.
- **Alloc PE / Size:** 0 / 0 - No physical extents have been allocated yet.
- **Free PE / Size:** 255990 / 1000.00 GiB - All physical extents are free, equaling the total size.

After the logical volume is created we can access it through **/dev/DEMO/web1**. We can for instance create a file system and mount it.

```bash
$ sudo mkfs /dev/DEMO/web1
$ sudo mkdir /mnt/web1
$ sudo mount /dev/DEMO/web1 /mnt/web1
```

*snapshots*

LVM snapshots, while useful for creating temporary backups, have limitations as a version control method due to their fixed size and potential for corruption if they run out of space, making them less versatile than similar features in ZFS or Btrfs.

To create **/dev/DEMO/web1-snap** as a snapshot of **/dev/DEMO/web1**, we would use the following command:

```bash
$ sudo lvcreade -L 100G -s -n web1-snap DEMO/web1
Logical volume "web1-snap" created
```

Note that the snapshot has its own name and that the source of the snapshot must be specified as `volume_group/volume`.

To check on the staus of your snapshots, run **lvdisplay**. If **lvdisplay** tells you that a snapshot is "inactive", that means it has run out of space and should be deleted. There's little you can do with a snapshot once it reaches this point!

*Filesystem resizing*

Filesystem overflows are more common than disk crashes, and one advantage of logical volumes is that they’re much easier to juggle and resize than are hard partitions. 

Suppose that in our example **/mnt/web1** has grown more than we predicted and needs another 100GB of space. We first check the VG to be sure additional space is available.

![vgdisplay-out2](./data/vgdisplay-out2.png)

200GB already consumed (100GB for the original filesystem and 100GB for the snapshot). 800GB available!

```bash
$ sudo umount /mnt/web1 # we unmount the filesystem first
$ sudo lvchange -an DEMO/web1 # needed to deactivate the volume for resizing purpose
$ sudo lvresize -L +100G DEMO/web1 # increase web1 to 200GB
Size of logical volume DEMO/web1 changed from 100.00 GiB (25600 extents) to 200.00 GiB (51200 extents).
Logical volume DEMO/web1 resized successfully.
$ sudo lvchange -ay DEMO/web1 # activate again
```

After the volume resize operation we can now resize the filesystem with the `resize2fs` (it will automatically determine the size of new filesystem from the volume).

```bash
sudo resize2fs /dev/DEMO/web1
```

Examining the output of `df` will show changes:

```bash
df -h /mnt/web1
```

