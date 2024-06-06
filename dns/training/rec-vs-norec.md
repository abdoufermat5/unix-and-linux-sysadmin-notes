# Recursive queries vs non-recursive queries

**Non-Recursive Query:**

1. **Using `dig`:**
   ```bash
   dig @<DNS_SERVER_IP> <DOMAIN_NAME> +norec
   ```
   * Replace `<DNS_SERVER_IP>` with the IP address of the DNS server you want to query (e.g., `8.8.8.8` for Google DNS).
   * Replace `<DOMAIN_NAME>` with the domain you want to look up (e.g., `www.example.com`).
   * The `+norec` option tells `dig` to perform a non-recursive query.

2. **Using `nslookup`:**
   ```bash
   nslookup -norec <DOMAIN_NAME> <DNS_SERVER_IP>
   ```

**Example:**

```bash
dig @8.8.8.8 www.example.com +norec 
```

**Recursive Query:**

1. **Using `dig`:**
   ```bash
   dig <DOMAIN_NAME> 
   ```
   * By default, `dig` will perform a recursive query if no DNS server is specified. It will use the DNS servers configured in your system's `/etc/resolv.conf` file.

2. **Using `nslookup`:**
   ```bash
   nslookup <DOMAIN_NAME>
   ```
   * Similar to `dig`, `nslookup` will perform a recursive query by default.

**Example:**

```bash
dig www.example.com
```

**Explanation:**

* **Non-Recursive:** Your query is sent directly to the specified DNS server. If that server has the information (either cached or authoritative), it will respond with the answer. If not, it will likely return an error or a referral.
* **Recursive:** Your query is sent to your local DNS server (usually your ISP's server). If that server doesn't have the answer, it will recursively query other servers until it finds the authoritative one and returns the answer to you.

**Additional Notes:**

* You might need to install `dig` on your system if it's not already available. It's usually included in `dnsutils` or similar packages.
* The output of these commands will show the response from the DNS server, including the IP address(es) associated with the domain you queried.
