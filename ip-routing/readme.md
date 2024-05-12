# Chapter 15: IP Routing

We're going deeper into routing and how IP packets are forwarded clearly.

There's a difference between the process of forwarding packets and the management of the routing table that drives this process.

## Packet Forwarding

![packet-forwarding](./data/packet-forwarding.png)

Router R1 connects two networks, and router R2 connects one of these nets to the outside world. A look at the routing tables for these hosts and routers lets us examine some specific packet forwarding scenarios. First, host A’s routing table:

![host-rtb](./data/host-rtb.png)

Host A has the simplest routing configuration of the four machines. The first two routes describe the machine's own network interfaces in standard routing terms. These entries exist so that forwarding to directly connected networks need not be handled as a special case. eth0 is host A’s Ethernet interface, and lo is the loopback interface, a virtual interface emulated in software. Entries such as these are normally added automatically when a network interface is configured. 

The default route on host A forwards all packets not addressed to the loopback address or to the **199.165.145** network to the router R1, whose address on this network is **199.165.145.24**. *Gateways must be only one hop away.*