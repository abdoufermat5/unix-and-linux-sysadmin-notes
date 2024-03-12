# Preboot eXecution Environment (PXE)

Preboot Execution Environment (PXE) defines a method for booting computers using a network interface, independent of local storage devices or installed operating systems (OSs). On platforms with UEFI firmware, PXE is supported by a network stack in the client firmware. The network’s DHCP provides a path to a boot server and network bootstrap program (NBP), downloads it into the computer's local memory using TFTP, verifies the image, and executes the NBP.

- In a Windows Deployment Services (WDS) environment, the NBP is provided by `wdsmgfw.efi`.
- In a Linux environment, the NBP is provided by UEFI-enabled boot loaders such as GRUB, GRUB2 or ELILO.

## History

PXE was introduced as part of the Wired for Management Baseline (WfM) Specification by Intel Corporation in 1997. It was described in a separate PXE 1.0 specification since Wired for Management 2.0. Later, the 2.1 update was published in September 1999.

PXE 2.1 describes the IPv4-based network boot process. It does not cover IPv6-based PXE, but this is described in the UEFI 2.2 specification. The UEFI 2.6 specification describes the IPv6-based PXE process in Section 23.3.1. The DHCP6 options used in PXE process are also described in the UEFI specification.

## Related protocols

The UEFI specification introduces the following protocols related to PXE boot:

- PXE Base Code Protocol – provides several features to utilize the PXE-compatible devices, for network access and network booting.
- PXE Base Code Callback Protocol – provides callback function which will be invoked when the PXE Base Code Protocol is about to transmit, has received, or is waiting to receive a packet.
- Load File Protocol – loads the boot file to specified buffer, which allows the boot manager to boot the file later.

## PXE DHCP Timeout

In IPv4-based PXE, DHCP discovery will be retried four times. The four timeouts are 4, 8, 16 and 32 seconds respectively, to compliant with PXE 2.1 specification. The initial retransmission timeout is 4 seconds and maximum retransmission timeout for each retry is 32 seconds. PXE client should wait for the timeout then select most preferred offer among all the received offers.

## PXE Boot process

The following picture shows a typical IPv4 PXE
![BootProcess](../data/PXE_Boot.png)

**Step 1-4**  is DHCP protocol with several extended DHCP option tags. The client should broadcast a DHCP Discover message with "PXEClient" extension tags to trigger the DHCP process. Then it should select offers, get the address configuration and boot path information, and complete the standard DHCP protocol by sending a request for the selected address to the server and waiting for the Ack. It might also need to perform DNS resolution to translate the server's host address to IP address.

**Step 5-6** takes place between the client and a Boot Server. The client should select and discover a Boot Server from the obtained server list in step 1-4. This phase is not a part of standard DHCP protocol, but uses the DHCP Request and Ack message format as a convenient for communication. The client should send the request message to port 67 (broadcast) or port 4011 (multicast/unicast) of the selected boot server, and wait a DHCP ack for the boot file name and MTFTP configuration parameters.

**step 7-9** is the downloading of the network bootstrap program (NBP). The client will load the NBP into the computer’s local memory using TFTP, verify the image and execute it finally.

- In a Windows Deployment Services (WDS) environment, the NBP is provided by `wdsmgfw.efi`.
- In a Linux environment, the NBP is provided by UEFI-enabled boot loaders such as GRUB, GRUB2 or ELILO.

Take UEFI PXE with Microsoft WDS as example, the NBP would continue to download several files to client platform. After the downloading finished, the WDS loader calls ExitBootService() and transits to Runtime phase. The OS kernel starts execution and takes over the control to the system. The OS network stack is also started for handling network operations.

## PXE Limitations

PXE is a great tool for booting a large number of computers over a network. However, it has some limitations:

- PXE uses UDP as transport protocol. TCP is not supported.
- Router/Switch “fast learning spanning tree” may drop UDP packets.
- PXE is designed to work within a corporate network, not outside of a company firewall.
- PXE server must be on same subnet.
- Requires Modifications to the DHCP Server
- PXE uses TFTP qnd does not support a seccure transport method like HTTPS.

## Setting up PXE

The most widely used PXE boot system is H. Peter Anvin's PXELINUX, which is part of hist SYSLINUX suite of boot loaders for every occasion. Another option is IPXE, which supports additional bootstrapping modes, including support for wireless networks.

PXELINUX supplies a boot file that you install in the TFTP server's **tftpboot** directory. To boot from the network, a PC downloads the PXE boot loader and its configuration from the TFTP server. The configuration file lists one or more options for operating systems to boot. The system can boot through to a specific OS installation without any user intervention, or it can display a custom boot menu.

PXELINUX uses the PXE API for its downloads and is therefore hardware independent all the way through the boot process.

On the DHCP side, ISC's (the Internet Systems Consortium's) DHCP server is the most widely used for PXE information. Alternatively, there's Dnsmasq, a lightweight server with DNS, DHCP, and netboot support. Or we can simply use Cobbler.


