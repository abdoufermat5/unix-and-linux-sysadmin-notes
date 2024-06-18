# Unix-and-Linux-sysadmin-notes

Unix and Linux system administration handbook by Evi Nemeth Garth Snyder Trent R. Hein Ben Whaley Dan Mackin

![book cover](https://crescentvale.com/wp-content/uploads/2017/12/unix-and-linux-system-administration-handbook-3.jpg)

You can buy the book [here](https://www.amazon.com/UNIX-Linux-System-Administration-Handbook/dp/0134277554)

## POV

This repository is a collection of notes from the book *Unix and Linux system administration handbook by Evi Nemeth Garth Snyder Trent R. Hein Ben Whaley Dan Mackin*. I am reading the 5th edition of the book. This shit is a comprehensive guide to Unix and Linux system administration. 

## Path to the notes

The notes are organized in chapters. Each chapter has a `readme.md` file that contains the notes for that chapter. The notes are organized in a way that makes it easy to follow the book. I am not following the chapters in order. I am reading the book in a way that makes sense to me.

### List of chapters:

- [Chapter1: Where to start](./where-to-start/readme.md)
- [Chapter2: Booting and System Management Daemons](./booting-and-system-management-daemons/readme.md)
- [Chapter3: Access Control and Rootly Powers](./access-control-and-rootly-powers/readme.md)
- [Chapter4: Process Control](./process-control/readme.md)
- [Chapter5: The Filesystem](./the-filesystem/readme.md)
- [Chapter6: Software Installation and Management](./software-installation/readme.md)
- [Chapter7: Scripting and Shell](./scripts-and-shell/readme.md)
- [Chapter8: User Management](./user-management/readme.md)
- [Chapter9: Cloud Computing](./cloud-computing/readme.md)
- [Chapter10: Logging](./logging/readme.md)
- [Chapter11: Drivers and the Kernel](./drivers-and-the-kernel/readme.md)
- [Chapter12: Printing](./printing/readme.md)
- [Chapter13: TCP/IP Networking](./tcp-ip-networking/readme.md)
- [Chapter14: Physical Networking](./physical-networking/readme.md)
- [Chapter15: IP Routing](./ip-routing/readme.md)
- [Chapter16: DNS - The Domain Name System](./dns/readme.md)
- [Chapter17: Single Sign-On](./single-sign-on/readme.md)
- [Chapter18: Electronic Mail](./electronic-mail/readme.md)
- [Chapter19: Web Hosting](./web-hosting/readme.md)
- [Chapter20: Storage](./storage/readme.md)
- [Chapter21: The Network File System](./network-file-system/readme.md)
- [Chapter22: SMB - Server Message Block](./smb/readme.md)
- [Chapter23: Configuration Management](./config-management/readme.md)
- [Chapter24: Virtualization](./virtualization/readme.md)
- [Chapter25: Containers](./containers/readme.md)
- [Chapter26: Continuous Integration and Delivery](./continuous-integration-and-delivery/readme.md)
- [Chapter27: Security](./security/readme.md)
- [Chapter28: Monitoring](./monitoring/readme.md)
- [Chapter29: Performance Analysis](./performance-analysis/readme.md)
- [Chapter30: Data Center Basics](./data-center-basics/readme.md)
- [Chapter31: Methodology, Policy, and Politics](./methodology-policy-and-politics/readme.md)

## Testing lab

I've set up a testing lab to test the concepts discussed in the book. You will need to install docker and docker-compose to run the lab. 

To install docker and docker-compose, follow the instructions [here](https://docs.docker.com/get-docker/)

To run the lab, clone the repository and run the following command:

```bash
docker compose up -d --build
```

This will create two containers, one for the Debian server and the other for the CentOS server. You can access the containers using the following command:

```bash
docker exec -it lab-[debian|centos] bash
```

You will then be logged into the container. You can then run the commands discussed in the book to test the various concepts.

A volume is mounted to the `lab-[debian|centos]` container. You can use this volume to share files between your host machine and the container.

## Why I am reading this book

I am reading this book to learn more about Unix and Linux system administration. As a DevOps engineer, it's a must to know how to manage Unix and Linux systems. 
