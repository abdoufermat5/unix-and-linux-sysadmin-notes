# Root-squash, no-root-squash, all-squash

Let's say we have an NFS server (192.168.1.10) sharing a directory `/shared_data` with a client (192.168.1.20).

1. **root_squash** (Default behavior):
```bash
# In /etc/exports on NFS server
/shared_data    192.168.1.20(rw,root_squash)
```
With root_squash:
- If root user (UID 0) on the client accesses the share → mapped to anonymous user (typically nobody:nogroup, UID/GID 65534)
- Regular users retain their original UIDs/GIDs

Example:
```bash
# On client as root (UID 0)
touch /mnt/shared_data/file1    # Created as nobody:nogroup
ls -l /mnt/shared_data/file1    # Shows owner as nobody:nogroup

# On client as user bob (UID 1000)
touch /mnt/shared_data/file2    # Created as bob:bob
ls -l /mnt/shared_data/file2    # Shows owner as bob:bob
```

2. **no_root_squash**:
```bash
# In /etc/exports on NFS server
/shared_data    192.168.1.20(rw,no_root_squash)
```
With no_root_squash:
- Root user on client retains root privileges on shared directory
- Regular users retain their original UIDs/GIDs

Example:
```bash
# On client as root (UID 0)
touch /mnt/shared_data/file1    # Created as root:root
ls -l /mnt/shared_data/file1    # Shows owner as root:root

# On client as user bob (UID 1000)
touch /mnt/shared_data/file2    # Created as bob:bob
ls -l /mnt/shared_data/file2    # Shows owner as bob:bob
```

3. **all_squash**:
```bash
# In /etc/exports on NFS server
/shared_data    192.168.1.20(rw,all_squash)
```
With all_squash:
- ALL users (root and regular) are mapped to anonymous user
- Useful for public shares where you don't want to maintain UID/GID mapping

Example:
```bash
# On client as root (UID 0)
touch /mnt/shared_data/file1    # Created as nobody:nogroup
ls -l /mnt/shared_data/file1    # Shows owner as nobody:nogroup

# On client as user bob (UID 1000)
touch /mnt/shared_data/file2    # Created as nobody:nogroup
ls -l /mnt/shared_data/file2    # Shows owner as nobody:nogroup
```

Common use cases:
1. **root_squash**: Most common, default security measure
   - Use when you want normal users to retain their identities but prevent root access
   - Good for shared development directories

2. **no_root_squash**: Use with caution!
   - Backup systems that need root access
   - System maintenance tasks
   - Automated administrative scripts

3. **all_squash**: Public shares
   - Public read-only documentation
   - Shared resources where individual ownership doesn't matter
   - Anonymous FTP-like setups

You can also combine these with `anonuid` and `anongid` to specify which UID/GID to use for anonymous access:
```bash
/shared_data 192.168.1.20(rw,all_squash,anonuid=1001,anongid=1001)
```