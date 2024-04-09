# Chapter 12: Printing

![gutenberg printing press](gutenberg printing press.png)

Ages ago, there were three common printing systems: BSD, System V, and CUPS (Common Unix Printing System). Today, Linux and FreeBSD both use CUPS, an up-to-date, sophisticated, network- and security-aware printing system. 

Printing relies on a handful of pieces:

- A print "spooler" that collects and schedules jobs. The word “spool” originated as an acronym for Simultaneous Peripheral Operation On-Line.
- User-level utilities (cmd or GUI) that talk to the spooler
- Back ends that talk to the printing devices themselves
- A network protocol that lets spoolers communicate and transfer jobs.

## CUPS 

CUPS is the most common printing system in use today. It was developed by Michael Sweet at Easy Software Products, which was later acquired by Apple. CUPS is now maintained by Apple.

CUPS servers are web servers, and the clients are web clients. The CUPS server listens on port 631, and you can access the web interface by pointing your browser to `http://localhost:631`. If you need secure communication with the daemon, you can use `https://localhost:433`.