# Chapter 16: DNS - The Domain Name System

![dns-joke](https://miro.medium.com/v2/resize:fit:1400/1*FHMRtwmo71YhrJihYwIEZQ.png)

Users and user-level programs like to refer to resources by name (e.g., amazon.com), but low-level network software understands only IP addresses (e.g., 54.239.17.6). Mapping between names and addresses is the best known and arguably most important function of DNS, the Domain Name System. DNS includes other elements and features, but almost without exception they exist to support this primary objective.

## DNS Architecture

DNS is a distributed database.  Under this model, one site stores the data for computers it knows about, another site stores the data for its own set of computers, and the sites cooperate and share data when one site needs to look up the other’s data. From an administrative point of view, the DNS servers you have configured for your domain answer queries from the outside world about names in your domain; they also query other domains’ servers on behalf of your users.

### Queries and Responses

A DNS query consists of a name and a record type. The answer returned is a set of "resource records" (RRs) that are responsive to the query. *Responsive* doesn't necessarily mean *dispositive*; the answer may be a referral to another server, or a negative response indicating that the name doesn't exist.

The most common query type is the A record, which maps a name to an IP address. 

![dns-example](./data/dns-example.png)

First, a human types the name of a desired site into a web browser. The browser then calls the DNS *resolver* library to look upthe corresponding address. The resolver library constructs a query for an A record and sends it to a name server, which returns the A record in its response. Finally, the browser can connect to the site using the IP address.

### DNS service providers

Years ago, every sysadmin had to set up and maintain a DNS server for their organization. Today, the landscape is different. If an organization maintains its own DNS servers, it is likely for internal use only. 

Microsoft's Active Directory system includes an integrated DNS server that meshes nicely with the other Microsoft-flavored services found in corporate environments. Howerver, AD is suitable only for internal use. It should never be exposed to the internet.

Every organization still needs an external-facing DNS server. Amazon Route 53, Cloudflare, GoDaddy, and many others offer DNS services. These services are inexpensive and reliable, and they can handle the load of even the busiest websites.

It's also possible to set up and maintain your own DNS server (internal or external). You have dozens of DNS implementations to choose from, but the most popular is BIND (Berkeley Internet Name Domain). BIND dominates the DNS server market with over 75% of the market share.

## DNS for lookus

### client resolver

**resolv.conf**
Each host on the network should be a DNS client. You configure it in the **/etc/resolv.conf** file. Here is an example:

```
search example.com api.example.com
nameserver ip-address                ; ns1
nameserver ip-address2               ; ns2
```

The `search` line list the domains to query if a hostname is not fully qualified. For example if a user issues the command `ssh abdoufermat` the resolver will try to resolve `abdoufermat.example.com` first, then `abdoufermat.api.example.com`. 

The name servers listed in `resolv.conf` must be configured to allow your host to submit queries. They must also be recursive; that is, they must answer queries to the best of their ability and not refer the client to another server.

DNS servers are contacted in order. As long as the first server continues to respond, the others are ignored. If the first server fails to respond, the client will try the second server, and so on. Each server is tried in turn, up to four times. The timeout interval increases with each attempt. The default timeout is 5 seconds, but it can be adjusted with the `timeout` option in `resolv.conf`.

**nsswitch.conf**
Both FreeBSD and Linux use the `nsswitch.conf` file to specify how hostname-to-IP address mappings should be performed and whether DNS should be tried first, last, or not at all. If no switch file is present, the default is to use DNS first, then files.

```
hosts: dns [!UNAVAIL=return] files
```

If name service is provided for you by an outside, you might be done after configuring `resolv.conf` and `nsswitch.conf`. 



## DNS Namespace

![dns-namespace](https://www.omnisecu.com/images/tcpip/dns-namespace-hierarchy.jpg?ezimgfmt=ngcb3/notWebP)

The DNS namespace is organized into a tree that contains both forward mappings and reverse mappings:

- **Forward mappings map hostnames to IP addresses (and other records),**
- **and reverse mappings map IP addresses to hostnames.**

![dns-zone-tree](./data/dns-zone-tree.png)

Every complete hostname (e.g., nubark.atrust.com) is a node in the forward branch of the tree, and (in theory) every IP address is a node in the reverse branch.

To allow the same DNS system to manage both names (which have the most significant information on the right), and IP addresses (on left), the IP branch of the namespace is inverted by listing the octets of the IP address backwards. For example if host `nubark.atrust.com` has IP `63.173.189.1`, the corresponding node of the forward branch is `nubark.atrust.com.` and the node of the reverse branch is `1.189.173.53.in-addr.arpa.`. Both of these names end with a dot, just as the full pathnames of files always start with slash. That makes the **Fully Qualified Domain Names** or FQDNs.

Two types of TLDs exists: country code domains (ccTLDs) and generic domains (gTLDs). 

<div style="font-family: Arial, sans-serif; background-color: #98F5F9; border: 1px solid #ddd; border-radius: 5px; padding: 15px; margin: 20px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <p style="color: #555;">
        <strong>ICANN</strong> (Internet Corporation for Assigned Names and Numbers) accredits various agencies to be part of its shared registry project for registering names in the <strong>gTLDs</strong> (generic Top-Level Domains) such as <code>.com</code>, <code>.net</code>, and <code>.org</code>.
    </p>
    <p style="color: #555;">
        To register for a <strong>ccTLD</strong> (country code Top-Level Domain) name, check the <strong>IANA</strong> (Internet Assigned Numbers Authority) web page:
    </p>
    <p style="text-align: center;">
        <a href="https://iana.org/cctld" style="color: #1a73e8; text-decoration: none; font-weight: bold;">iana.org/cctld</a>
    </p>
    <p style="color: #555;">
        This page will help you find the registry in charge of a particular country’s domain name registration.
    </p>
</div>


### Registering a domain name

To obtain a second-level domain name (such as example.com), you must apply to a registrar for the appropriate TLD. To complete the registration forms, you must choose a name that is not already taken and identify a technical contact person, an administrative contact person, and at least two hosts that will be name servers for your domain. 

### Creating your own subdomains

If you have a registered domain name, you can create subdomains by adding records to your zone file. For example, if you have registered example.com, you can create subdomains such as sales.example.com, support.example.com, and so on.

## How DNS Works

Name servers around the world work together to answer queries. They distribute information maintained by whichever administrator is closest to the query target.

### Name servers

A name server performs several chores:

- It answers queries about your site’s hostnames and IP addresses.
- It asks about both local and remote hosts on behalf of your users.
- It caches the answers to queries so that it can answer faster next time.
- It communicates with other local name servers to keep DNS data synchronized.

Name servers deal with "zones", where a zone is essentially a domain minus its subdomains.

![ns-taxonomy](./data/ns-taxonomy.png)

### Authoritative and caching-only servers

Master, slave, and caching-only servers are distinguished by two characteristics: where the data comes from, and whether the server is authoritative for the domain. Each zone typically has one master name server. The master server keeps the official copy of the zone’s data on disk. The system administrator changes the zone’s data by editing the master server’s data files.

A slave server gets its data from the master server through a “zone transfer” operation. 

A caching-only name server loads the addresses of the servers for the root domain from a startup file and accumulates the rest of its data by caching answers to the queries it resolves. A caching-only server is not authoritative for any domain (which means it doesn’t have the official copy of the data for any domain).

An authoritative answer from a name server is “guaranteed” to be accurate; a nonauthoritative answer might be out of date. However, a very high percentage of nonauthoritative answers are perfectly correct. Master and slave servers are authoritative for their own zones, but not for information they may have cached about other domains.*

### Recursive and nonrecursive servers

Name servers are either recursive or nonrecursive. If a nonrecursive server has the answer to a query cached from a previous transaction or is authoritative for the domain to which the query pertains, it provides an appropriate response. Otherwise, instead of returning a real answer, it returns a referral to the authoritative servers of another domain that are more likely to know the answer. A client of a nonrecursive server must be prepared to accept and act on referrals.

Authoritative-only servers (e.g., root servers and top-level domain servers) are all nonrecursive, but since they may process tens of thousands of queries per second we can excuse them for cutting corners. For example, a root server might return a referral to a top-level domain server, which in turn might return a referral to a second-level domain server, which might return a referral to a subdomain server, which might return the answer.

A recursive server returns only real answers and error messages. It follows referrals itself, relieving clients of this responsibility. In other respects, the basic procedure for resolving a query is essentially the same.

### Resource records

Each site maintains one or more pieces of the distributed database that makes up the world-wide DNS system. Each RR contains a name, a class, a type, and a value. The name is the domain name to which the RR pertains. The class is usually IN (Internet). The type specifies the kind of data in the value field. The value is the data itself.

For example:

In the forward file called `atrust.com`:

```text
nubark      IN      A     63.173.189.1
            IN      MX    10 mailserver.nubark.atrust.com.
```

In the reverse file called `63.173.189.rev`:

```text
1       IN      PTR   nubark.atrust.com.
```

<div style="font-family: Arial, sans-serif; background-color: #98F5F9; border: 1px solid #ddd; border-radius: 5px; padding: 15px; margin: 20px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
Resource records are the <span><a href="https://en.wikipedia.org/wiki/Lingua_franca" style="color: #1a73e8; text-decoration: none; font-weight: bold;">lingua franca</a></span> of DNS and are independent of the configuration files that control the operation of any given DNS server implementation. They are also the pieces of data that flow around the DNS system and become cached at various locations.
</div>

### Delegation

All name servers read the identities of the root servers from a local config file or have them built into the code. The root servers know the name servers for com, net, edu, fi, de, and other top-level domains. Farther down the chain, edu knows about colorado.edu, berkeley.edu, and so on. Each domain can delegate authority for its subdomains to other name servers.

Example:

![dns-delegation](./data/dns-delegation.png)

We want to lookup the address for the machine *vangogh.cs.berkeley.edu* from the machine *lair.cs.colorado.edu*. The resolver on *lair* sends a query to the local name server (*ns.cs.colorado.edu*). The local name server sends a query to the root server for the *edu* domain. The root server returns a referral to the *edu* name server. The *edu* name server returns a referral to the *berkeley.edu* name server. The *berkeley.edu* name server returns a referral to the *cs.berkeley.edu* name server. The *cs.berkeley.edu* name server returns the address for *vangogh.cs.berkeley.edu*. The local name server caches the answer and returns it to the resolver on *lair*.

The local name server is a recursive server. It follows referrals until it gets an answer. 

### Caching and efficiency

Caching increases the efficiency of lookups: a cached answer is almost free and is usually correct because hostname-to-address mappings change infrequently. An answer is saved for a period of time called the “time to live” (TTL), which is specified by the owner of the data record in question.

The longer the TTL, the less network traffic is generated by DNS lookups. However, the longer the TTL, the longer it takes for changes to propagate through the DNS system.

If you have a specific service that is load-balanced across multiple servers, you can set a low TTL for the service’s DNS record. This way, if one of the servers goes down, you can quickly update the DNS record to point to the remaining servers.

DNS servers can also cache negative responses. If a server receives a query for a nonexistent domain, it caches the negative response for a period of time. This prevents the server from repeatedly querying the authoritative server for the nonexistent domain.

### Multiple answers and round-robin DNS load balancing

A DNS server can return multiple answers to a query. For example, if a domain has multiple mail servers, the DNS server can return all of their IP addresses. The client can then try each address in turn until it finds a server that is available.

Round-robin DNS load balancing is a simple way to distribute the load across multiple servers. For example, if a domain has multiple web servers, the DNS server can return all of their IP addresses in a different order each time it receives a query. The client can then try each address in turn, distributing the load across the servers.

Large sites uses load-balancing software (such as HAProxy)

### Debugging tools

Five command-line tools that query the DNS database are distributed with BIND: `dig`, `nslookup`, `host`, `drill`, and `delv`. 

By default, `dig` and `drill` query the DNS server listed in `/etc/resolv.conf`. 

Example:

```bash
$ dig nubark.atrust.com
```

The `+trace` option tells `dig` to follow referrals from the root servers down to the authoritative servers.
    
```bash
$ dig +trace nubark.atrust.com
```

## The DNS Database

A zone’s DNS database is a set of text files maintained by the system administrator on the zone’s master name server. They contain two types of entries: parser commands and resource records. But only resource records are really important.

### Parser commands

Parser commands are directives to the DNS server software. They are not part of the DNS database itself. They are used to control the behavior of the server and to include other files.

Three parser commands ($ORIGIN, $TTL, and $INCLUDE) are standard for all DNS implementations, and a fourth ($GENERATE) is specific to BIND.

- `$ORIGIN` sets the default domain name for the zone. If a name in a resource record is not fully qualified, the server appends the origin to it. The origin is set to the zone’s name by default.
- `$TTL` sets the default time-to-live for the zone. If a TTL is not specified in a resource record, the server uses the default TTL. The default TTL is 86400 seconds (24 hours).
- `$INCLUDE` includes another file in the zone file. This is useful for breaking up a large zone file into smaller, more manageable pieces.

### Resource records

Resource records are the heart of the DNS database. They contain the data that the DNS server uses to answer queries. Each resource record has five fields: name, class, type, TTL, and data.

- The name is the domain name to which the resource record pertains.
- The class is usually IN (Internet).
- The type specifies the kind of data in the data field. The most common types are A (address), MX (mail exchange), CNAME (canonical name), and NS (name server).
- The TTL is the time-to-live for the resource record. It specifies how long the record can be cached by other DNS servers. The default TTL is set by the $TTL directive in the zone file.
- The data is the actual data for the resource record. The format of the data field depends on the type of the resource record.

![dns-record-types](./data/dns-record-types.png)

### The SOA record

An SOA (Start of Authority) record marks the beginning of a zone, a group of resource records located at the same place within the DNS namespace. The data for a DNS domain usually includes at least two zones: one for translating hostnames to IP addresses, called the forward zone, and others that map IP addresses back to hostnames, called reverse zones.

Each zone has exactly one SOA record. The SOA record includes the name of the zone, the primary name server for the zone, a technical contact, and various timeout values. Comments are introduced by a semicolon. Here’s an example:

```text
; SOA record for the zone atrust.com
atrust.com.  IN  SOA  ns1.atrust.com.  hostmaster.atrust.com. (
    2022010101 ; serial number
    86400      ; refresh
    7200       ; retry
    3600000    ; expire
    172800     ; minimum
)
```

The SOA record has five fields:

- The name of the zone. The name of the zone is the same as the name of the SOA record. This value can be changed with the $ORIGIN directive.
- The class of the zone. The class of the zone is usually IN (Internet).
- The type of the SOA record. The type of the SOA record is always SOA.
- The primary name server for the zone. The primary name server is the server that has the official copy of the zone data.
- The technical contact for the zone. The technical contact is the person responsible for maintaining the zone data.

The parentheses enclose the SOA record’s data fields. The data fields are:

**The serial number:** The serial number is used by slave servers to determine when to get fresh data. It can be any 32-bit integer and should be incremented every time the data file for the zone is changed
If by accident you set a really large value on the master and that value is transferred to the slaves, then correcting the value on the master will not help. The slaves request new data only if the master’s serial number is larger than theirs.

You can fix in two ways:

- Arithmetic Fix: Add a large value (2^31) to the inflated serial number, let slaves update, then set the desired serial number. This approach uses sequence space properties (detailed in "DNS and BIND" book and RFC1982).
- Manual Fix: Change the serial number on the master, stop the slave servers, delete their backup data files, restart the slaves to force them to reload from the master. This method is complex if slaves are geographically distributed and managed by different sysadmins.

The next four fields are timeouts in seconds, that control how long data can be cached at various points in the world-wide DNS database.

The minimum field is the minimum TTL for the zone. It specifies how long a negative response can be cached by other DNS servers. The default minimum TTL is 86400 seconds (24 hours).

The expire field specifies how long a slave server can go without contacting the master server before it stops answering queries for the zone. The default expire value is 3600000 seconds (1000 hours).

The retry field specifies how long a slave server should wait before retrying a failed zone transfer. The default retry value is 7200 seconds (2 hours).

The refresh field specifies how often a slave server should check with the master server for updates to the zone. The default refresh value is 86400 seconds (24 hours).

### The NS record

The NS (Name Server) record specifies the authoritative name servers for the zone and delegates subdomains to other organizations. 

The format of the NS record is:

```text
zone    [ttl]   [IN]    NS      hostname
```

for example:

```text
                      NS   ns1.atrust.com.
                      NS   ns2.atrust.com.
booklab               NS   ubuntu.booklab.atrust.com.
                      NS   ns1.atrust.com.
```

The first two lines delegate the zone `atrust.com` to the name servers `ns1.atrust.com` and `ns2.atrust.com`. The third line delegates the subdomain `booklab.atrust.com` to the name servers `ubuntu.booklab.atrust.com` and `ns1.atrust.com`. 

### The A record

The A (Address) record maps a hostname to an IP address. The format of the A record is:

```text
hostname    [ttl]   [IN]    A       ip-address
```

for example:

```text
ns1                  IN      A      63.173.189.1
```

In this example, the name is not dot-terminated, so the name server adds the default domain name to it to form the fully qualified domain name `ns1.atrust.com.`.

### AAAA records

The AAAA record maps a hostname to an IPv6 address. The format of the AAAA record is:

### PTR records

The PTR (Pointer) record maps an IP address to a hostname. The format of the PTR record is:

```text
ip-address    [ttl]   [IN]    PTR     hostname
```

For example the PTR record in the 189.173.63.in-addr.arpa zone file that corresponds to the A record for ns1.atrust.com is:

```text
1             IN      PTR     ns1.atrust.com.
```

### MX records

The MX (Mail Exchange) system is used to route email more efficiently. 

The format of the MX record is:

```text
name    [ttl]   [IN]    MX      preference    host ...
```

For example:

```text
somehost       IN      MX      10    mailserver.atrust.com.
               IN      MX      20    mail-relay3.atrust.com.
```

MX records are useful in many situations:

- When you have a central mail hub or service provider for incoming mail
- When you want to filter mail for spam or viruses before delivering it
- When the destination host is down
- When the destination host isn’t directly reachable from the Internet
- When the local sysadmin knows where mail should be sent better than your correspondents do (i.e., always)

### CNAME records

The CNAME (Canonical Name) record is used to create an alias for a hostname. The format of the CNAME record is:

```text
nickname    [ttl]   [IN]    CNAME    hostname
```

When DNS software encounters a CNAME record, it stops its query for the nickname and re-queries for the real name. If a host has a   CNAME record, other records (A, MX, NS, etc) for that host must refer to its real name, not its nickname.

CNAME records can nest eight deep. That is, a CNAME record can point to another CNAME, and that CNAME can point to a third CNAME, and so on, up to seven times; the eighth target must be the real hostname.

You can avoid CNAMEs altogether by using multiple A records for the same hostname. 

RFC1033 requires the "apex" of a zone (the root domain or naked domain) to have an A record, not a CNAME.

You can do this:

```text
www.example.net.  IN  CNAME some-name.somecloud.net.
```

But you can't do this:

```text
example.net.  IN  CNAME some-name.somecloud.net.
```

### SRV records

SRV records are a type of DNS record designed to specify the location of services within a domain, offering a more structured and flexible alternative to traditional CNAME records. This enables clients to discover the hostname and port of services like FTP servers without relying on conventions or additional CNAME entries. 

The format of the SRV record is:

```text
_service.proto.name    [ttl]   [IN]    SRV    priority weight port target
```

where `service` is a service defined in the IANA assigned numbers database ([numbers](https://www.iana.org/numbers.htm)), `proto` is either `tcp` or `udp`, `name` is the domain name, `priority` is the priority of the target host, `weight` is the relative weight for records with the same priority, `port` is the port on which the service is running, and `target` is the canonical hostname of the machine providing the service.

![srv-atrust](./data/srv-atrust.png)

### TXT records

A TXT record adds arbitrary text to a host’s DNS records. For example, some sites have a TXT record that identifies them:

```text
             IN      TXT    "Application for atrust.com"
```

This record directly follows the SOA and NS records for the atrust.com zone and so inherits the name field from them.

The format of the TXT record is:

```text
name    [ttl]   [IN]    TXT    "info"...
```

## The BIND software

BIND (Berkeley Internet Name Domain) is the most widely used DNS software on the Internet. It is a complete and mature implementation of the DNS protocol. BIND is open source and is maintained by the Internet Systems Consortium (ISC).

### Components of BIND

BIND consists of several components:

- The `named` daemon is the DNS server that answers queries about hostnames and IP addresses.
- A resolver library that queries DNS servers on behalf of client programs.
- Several command-line tools for querying DNS servers and testing DNS configurations.
- A program called `rndc` that controls the operation of the `named` daemon.

### COnfiguration files

The primary configuration file is **named.conf**, which serves as the main configuration file for BIND. It defines global server options, logging settings, access controls, zone definitions, and other crucial parameters.

Within named.conf, additional files are often included for better organization and modularity. Some of these key files include:

*   **named.conf.options:** Contains default settings for options like recursion, DNSSEC validation, query logging, and forwarder configuration.
*   **named.conf.local:** Often used to define zones that are specific to the local server, such as reverse lookup zones or private DNS zones.
*   **named.conf.zones:** Lists the zones that BIND is authoritative for, along with their associated zone files.

Zone files, typically named after the domain they represent (e.g., example.com.zone), contain the actual DNS records for a particular zone, such as A records for IP addresses, MX records for mail servers, and CNAME records for aliases.

![bind-statements](./data/bind-statements.png)


## Split DNS and the view statement

Split DNS is a configuration in which a DNS server provides different sets of DNS information based on the source of the DNS request. This is useful for organizations that want to provide different DNS responses to internal and external users.

The `view` statement in BIND allows you to configure split DNS. With views, you can define different sets of DNS records for different clients based on their IP addresses. This enables you to provide different DNS responses to internal and external users, or to users in different geographical locations.

The syntax for the view statement is:

```text
view "view-name" {
    match-clients { client-ip-address; };
    match-destinations { destination-ip-address; };
    match-recursive-only yes | no;
    view-options;
    zone "zone-name" {
        zone-options;
    };
};
```

For example:

```text
view "internal" {
    match-clients { our-network; };  // Only clients in our network
    recursion yes;
    zone "example.com" {
        type master;
        file "internal-example.db";
    };
};

view "external" {
    match-clients { any; };  // Any client
    recursion no;
    zone "example.com" {
        type master;
        file "external-example.db";
    };
};
```

The order of the view statements is important. BIND processes the views in the order they are defined in the configuration file. The first view that matches the client’s IP address is used to determine which DNS records to return.

## DNS Security issues

By default, anyone on the Internet can investigate your domain with individual queries from tools such as **dig**, **host**, **nslookup**, and **drill**. In some cases, they can dump your entire DNS database.

To address such vulnerabilities, name servers support various types of access control that key off of host and network addresses or cryptographic authentication. 

![sec-feat-bind](./data/sec-feat-bind.png)


### DNSSEC

DNSSEC is a set of DNS extensions that authenticate the origin of zone data and verify its integrity by using public key cryptography. That is, the extensions allow DNS clients to ask the questions "Did this DNS data really come from the zone’s owner?" and "Is this really the data sent by the zone’s owner?"

DNSSEC relies on a cascading chain of trust. The root servers validate information for the top-level domains, the top-level domains validate information for the second-level domains, and so on.

Each zone has its own public and private key pair. It has two sets of keys: a zone-signing key (ZSK) and a key-signing key (KSK). The ZSK is used to sign the zone’s data, and the KSK is used to sign the ZSK.

### DNNSEC resource records

DNSSEC introduces several new resource records (5 in total):

- **DS** (Designated Signer): A DS record is used to establish a chain of trust between parent and child zones. The parent zone signs the child zone’s public key with its private key and publishes the DS record in its zone file.

Example:

```text
example.com.  IN  DS  12345 5 1 1234567890abcdef1234567890abcdef1234567890abcdef
```

- DNSKEY: The DNSKEY record contains the public key for a zone. It is used to verify the digital signatures in the zone’s RRSIG records. Keys included in the DNSKEY record can be either ZSKs or KSKs. To differentiate between the two, the DNSKEY record includes a flag field that indicates the key’s purpose (256 for KSKs and 257 for ZSKs). [manually-performing-dnssec-validation](https://blog.manton.im/2017/03/manually-performing-dnssec-validation.html)
- RRSIG: The RRSIG record contains a digital signature for a set of resource records. It is used to verify the authenticity and integrity of the data in the zone. The RRSIG record is generated by signing the data in the zone with the zone’s private key.
- NSEC or NSEC3: The NSEC record is used to prove the nonexistence of a DNS record. It lists the types of records that exist between two existing records in the zone. The NSEC3 record is similar to the NSEC record but provides additional security by hashing the record names.
For example a server might respond to a query for A records named `bork.atrust.com` with an NSEC record that certifies the nonexistence of any A records between `bark.atrust.com` and `bundt.atrust.com`.

### Zone signing

To sign a zone, you need to generate a key pair for the zone, sign the zone’s data with the private key, and publish the public key in the zone’s DNSKEY record. The signed data is stored in a separate file called a signed zone file.

The process of signing a zone is called zone signing. It involves the following steps:

1. Keypair generation: you generate ZSK and KSK key pairs for the zone.

For ZSK:

```bash
$ dnssec-keygen -a RSASHA256 -b 1024 -n ZONE example.com
# output: Kexample.com.+008+12345 (meaning it has generated Kexample.com.+008+12345.key and Kexample.com.+008+12345.private)
```

For KSK:

```bash
$ dnssec-keygen -f KSK -a RSASHA256 -b 2048 -n ZONE -f KSK example.com
# output: Kexample.com.+008+54321
```

Then copies the public keys to the zone file:

```bash
$ cat Kexample.com.*.key >> example.com
```

2. Zone signing: Now that you’ve got keys, you can sign your zones with the dnssec-signzone command, which adds RRSIG and NSEC or NSEC3 records for each resource record set. These commands read your original zone file and produce a separate, signed copy named zonefile.signed.

```bash
$ dnssec-signzone -o example.com -N increment -k Kexample.com.+008+54321 example.com Kexample.com.+008+12345
``` 

Signed zone files are typically four to ten times larger than the original zone, and all your nice logical ordering is lost. A line such as

![signed-zone](./data/signed-zone.png)

### DNSSEC chain of trust

When Name servers query they use EDNS0 (Extension Mechanisms for DNS) and set the DNSSEC-aware option in the DNS header of the packet. When answering a query that arrives with that bit set, they include the signature data with their answer.

A client that receives signed answers can validate the response by checking the record’s signatures with the appropriate public key. But it gets this key from the zone’s own DNSKEY record. But how does it know that the DNSKEY record is valid? It doesn’t. It has to get the DS record from the parent zone and validate that with the parent’s public key. And so on, all the way up to the root.

### DNSSEC key rollover

Ok not going deeper. Here's the process:

1. Generate a new ZSK.
2. Include it in the zone file.
3. Sign or re-sign the zone with the KSK and the old ZSK.
4. Signal the name server to reload the zone; the new key is now there.
5. Wait 24 hours (the TTL); now everyone has both the old and new keys.
6. Sign the zone again with the KSK and the new ZSK.
7. Signal the name server to reload the zone.
8. Wait another 24 hours; now everyone has the new signed zone.
9. Remove the old ZSK at your leisure, e.g., the next time the zone changes.

### DNSSEC tools

With the advent of BIND 9.10 comes a new debugging tool. The Domain Entity Lookup and Validation engine (DELV) looks much like dig but has a better understanding of DNSSEC. In
fact, delv checks the DNSSEC validation chain with the same code that is used by the BIND 9 named itself.

In addition to the DNSSEC tools that come with BIND, four other tools are available: `ldns`, `DNSSEC-Tools`, `OpenDNSSEC`, and `RIPE`.

