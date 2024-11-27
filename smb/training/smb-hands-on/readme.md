
# **Samba Hands on Lab**

This lab simulates a basic network with a Samba server and multiple client machines. The setup involves two network segments:

- **Trusted Network**: Ben’s and Allan’s PCs
- **Untrusted Network**: Malicious User's PC

The goal of this setup is to test different network interactions, including Samba file sharing and security configurations between trusted and untrusted machines.

### **Lab Setup Overview**

- **Samba Server (`smb-server`)**:
  - Provides a file share that is accessible by trusted clients (Ben and Allan).
  - Configured with the `eng` share that is only accessible by members of the `eng` group.
  
- **Ben’s PC (`ben-pc`)**:
  - A trusted machine that has access to the `eng` share from the Samba server.

- **Allan’s PC (`allan-pc`)**:
  - Another trusted machine that has access to the `eng` share.

- **Malicious User’s PC (`malicious-user-pc`)**:
  - A machine on an untrusted network, isolated from the Samba server and the trusted machines.

### **Requirements**
- Docker
- Docker Compose

### **Setup Instructions**

1. **Clone the Repository** (if applicable):
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Build and Start the Containers**:
   In the project directory (where `docker-compose.yml` is located), run the following command to build and start the containers:
   ```bash
   docker-compose up --build -d
   ```

3. **Accessing the Containers**:
   Once the containers are up and running, you can interact with each of the services:

   - **Samba Server**: You can check the server’s status and configuration inside the `smb-server` container.
     ```bash
     docker exec -it smb-server bash
     ```

   - **Ben’s PC**: To interact with Ben’s PC container, use:
     ```bash
     docker exec -it ben-pc bash
     ```

   - **Allan’s PC**: Similarly, access Allan’s PC:
     ```bash
     docker exec -it allan-pc bash
     ```

   - **Malicious User’s PC**: Access the malicious user’s machine to simulate untrusted behavior:
     ```bash
     docker exec -it malicious-user-pc bash
     ```

4. **Interacting with the Samba Server**:
   - From **Ben’s PC** and **Allan’s PC**, you should be able to access the shared folder from the Samba server:
     ```bash
     smbclient //smb-server/eng -U ben
     ```
     or
     ```bash
     smbclient //smb-server/eng -U allan
     ```

   - **Malicious User’s PC** should not have access to the Samba share if configured correctly.

5. **Stopping the Containers**:
   To stop the containers, run the following command:
   ```bash
   docker-compose down
   ```

---

### **Network Configuration**

- **Trusted Network**: Ben’s PC and Allan’s PC are on the `trusted_network` and can communicate with the Samba server.
  
- **Untrusted Network**: The Malicious User’s PC is on a different network (`untrusted_network`) and cannot directly access the Samba server or the trusted machines.

### **Security Testing**
- The trusted machines (Ben and Allan) can access the Samba share.
- The malicious user should not be able to access the shared folder.
- You can simulate potential security vulnerabilities or test firewall/ACL rules between trusted and untrusted networks.

---

### **Troubleshooting**

- **Containers Keep Stopping**:
  - Ensure the Dockerfiles for all containers have an appropriate command to keep them running (e.g., `tail -f /dev/null` or an interactive shell).
  - Check the logs of the containers for errors using:
    ```bash
    docker logs <container-name>
    ```

- **Network Isolation Issues**:
  - Ensure that each container is on the correct network (`trusted_network` or `untrusted_network`) by inspecting the network configuration in the Docker Compose file.

- **Can authenticate through smb client**:
  - You have to add user's to Samba password database:
  ```bash
  smbpasswd -a ben
  ```
  - If necessary you should enable the user too:
  ```bash
  smbpasswd -e ben
  ```

---

### **File and Directory Permissions on Samba Server**

The Samba server has the following configuration:
- **Share Name**: `eng`
- **Access Control**: The share is only accessible by users in the `eng` group (Ben and Allan).
- **Permissions**:
  - Files are created with `0660` permissions.
  - Directories are created with `2770` permissions and the `setgid` bit is set.
  - The share is not browseable, ensuring it is hidden from general listings.

You can modify these settings by editing the `smb.conf` or `eng.conf` configuration files inside the container.

---

### **Docker Compose File (`docker-compose.yml`) Overview**

```yaml
version: '3.9'

services:
  smb-server:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: smb-server
    networks:
      trusted_network:

  ben-pc:
    build:
      context: .
      dockerfile: Dockerfile.clients
    container_name: ben-pc
    networks:
      trusted_network:
    
  allan-pc:
    build:
      context: .
      dockerfile: Dockerfile.clients
    container_name: allan-pc
    networks:
      trusted_network:
    
  malicious-user-pc:
    build:
      context: .
      dockerfile: Dockerfile.clients
    container_name: malicious-user-pc
    networks:
      untrusted_network:

networks:
  trusted_network:
    driver: bridge
  untrusted_network:
    driver: bridge
```

- **`smb-server`**: The Samba server container providing file shares.
- **`ben-pc`, `allan-pc`**: Trusted client containers that have access to the `eng` share.
- **`malicious-user-pc`**: A container simulating a malicious user on an untrusted network.

### **Conclusion**

This lab setup simulates a network environment with a Samba server, trusted, and untrusted clients. You can use it to test Samba sharing, network isolation, and security settings like access control and group-based file sharing.

---