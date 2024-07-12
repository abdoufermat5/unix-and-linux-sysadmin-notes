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