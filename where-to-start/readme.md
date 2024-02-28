# Chapter 1: Where to start

## Table of most popular linux distributions

![table](./data/table-of-linux-distros.png)

The most viable distributions are not necessarily the most corporate. For example, we expect Debian GNU/Linux to remain viable for a long time despite the fact that Debian is not a company, doesn’t sell anything, and offers no enterprise-level support. Debian benefits from a committed group of contributors and from the enormous popularity of the Ubuntu distribution, which is based on it.

## Example of a Linux distribution

> Debian (pronounced *deb-ian*, named after Debra and Ian Murdock) is one of the oldest and most well-regarded distributions. It is a noncommercial project with more than a thousand contributors worldwide. Debian maintains an ideological commitment to community development and open access, so there’s never any question about which parts of the distribution are free or redistributable.

Debian defines three release that are maintained simultaneously:

- stable: targeting the production servers,
- unstable: with current packages that may have bugs and security vulnerabilities,
- testing: a mix of stable and unstable.


> Ubuntu: is based on Debian and maintains Debian's commitment to free and open-source software. Ubuntu is a commercial distribution, and it is backed by a company called Canonical.

Ubuntu version numbers derive from the year and month of release, so 18.04 was released in April 2018. Each release also has a code name, such as Bionic Beaver for 18.04 or Focal Fossa for 20.04.

Two versions of Ubuntu are released every year, one in April and one in October. The April release is a long-term support (LTS) release, which is supported for five years. The October release is supported for nine months.

> Red Hat has been a dominant force in the Linux world for more than two decades, and its distributions are widely used in North America and beyond. By the numbers, Red Hat, Inc., is the most successful open source software company in the world.

Red Hat Enterprise Linux, often shortened to RHEL, targets production environments at large enterprises that require support and consulting services to keep their systems running smoothly. Somewhat paradoxically, RHEL is open source but requires a license. If you’re not willing to pay for the license, you’re not going to be running Red Hat.

Red Hat also sponsors Fedora, a community-driven distribution that is a proving ground for new technologies that may eventually be included in RHEL. Fedora is a good choice for developers and enthusiasts who want to stay on the cutting edge of Linux.
s
> CentOS is a free, open source, community-driven distribution that is functionally compatible with RHEL. The CentOS distribution lacks the RHEL branding and logos, but it is otherwise identical to RHEL. CentOS is a good choice for organizations that want the benefits of RHEL without the cost.

> SUSE Linux Enterprise Server (SLES) is a commercial distribution that is popular in Europe. SLES is developed and maintained by the German company SUSE. SUSE also sponsors openSUSE, a community-driven distribution that is a proving ground for new technologies that may eventually be included in SLES.


> FreeBSD, first release in late 1993, is the most widely used of the BSD derivatives. Unlike Linux, FreeBSD is a complete operating system, not just a kernel. Both the kernel and userland software are licensed under the permissive BSD License, a fact that encourages development by and additions from the business community.


## The man pages

Man pages are concise descriptions of indidual commands, drivers; file formats, or library routines. THey do not address more general topics such as "How do I install a new device?" or "WHy is this system so damn slow?"

On Linux systems, you can find out the current default search path with the *manpath* command. If necessary, you can set the MANPATH environment variable to override the default search path.

```bash
$ export MANPATH=/home/share/localman:/usr/share/man
```

## Other Sources

- [Dark Reading](https://www.darkreading.com/) : Security news, research, and analysis.
- [Devops Reactions](http://devopsreactions.tumblr.com/) : A collection of gifs that capture the feelings of sysadmins and developers.
- [Linux](https://www.linux.com/) : The Linux Foundation's official website.
- [Linux Foundation](https://www.linuxfoundation.org/) : Employer of Linus Torvalds and steward of the Linux kernel.
- [LWN](https://lwn.net/) : A weekly publication that covers the Linux kernel and other open source software.
- [Servers for hackers](https://serversforhackers.com/) : High-quality videos, forums, and articles on administration

## What is on my machine?

```bash
$ which gcc
/usr/bin/gcc
```

The *which* command searches the directories in your PATH environment variable for the specified command. If the command is found, the full path to the command is printed. If the command is not found, nothing is printed.

There is also a *whereis* command that searches for the binary, source, and manual page files for a command.

```bash
$ whereis gcc
gcc: /usr/bin/gcc /usr/lib/gcc /usr/share/gcc /usr/share/man/man1/gcc.1.gz
```

If you are looking for a file, you can use the *locate* command. The *locate* command searches a database of files and directories on your system. The database is updated periodically by the *updatedb* command.

```bash
$ locate my-unbelivable-script.sh
/home/abdou/my-unbelivable-script.sh
```

## Specialization and adjacent disciplines

- **DevOps**: DevOps is not so much a specific function as a culture or operational philosophy. It aims to improve the efficiency of building and delivering software, especially at large sites that have many interrelated services and teams. Organizations with a DevOps practice promote integration among engineering teams and may draw little or no distinction between development and operations. Experts who work in this area seek out inefficient processes and replace them with small shell scripts or large and unwieldy Chef repositories.

- **Site Reliability Engineering (SRE)**: Site reliability engineers value uptime and correctness above all else. Monitoring networks, deploying production software, taking pager duty, planning future expansion, and debugging outages all lie within the realm of these availability crusaders. Single points of failure are site reliability engineers’ nemeses.

- **Architects**: Systems architects have deep expertise in more than one area. They use their experience to design distributed systems. Their job descriptions may include defining security zones and segmentation, eliminating single points of failure, planning for future growth, ensuring connectivity among multiple networks and third parties, and other site-wide decision making. Good architects are technically proficient and generally prefer to implement and test their own designs.