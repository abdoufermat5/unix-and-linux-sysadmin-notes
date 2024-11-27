# Base image
FROM debian:latest

# copy conf
COPY eng.conf /etc/samba/eng.conf

# Install Samba and smbclient
RUN apt-get update && apt-get install -y samba smbclient

# Create shared directory, users, and groups
RUN mkdir -p /share/eng && \
    groupadd eng && \
    useradd -m ben -G eng && \
    useradd -m allan -G eng && \
    chmod -R 2770 /share/eng && \
    chown -R root:eng /share/eng

# Set Samba passwords for users
# RUN echo -e "benpwd123\nbenpwd123" | smbpasswd -s -a ben && \
#    echo -e "allanpwd123\nallanpwd123" | smbpasswd -s -a allan

# Append the shared configuration to smb.conf
RUN cat /etc/samba/eng.conf >> /etc/samba/smb.conf

# Expose Samba ports
EXPOSE 139 445

# Start Samba service
CMD ["sh", "-c", "service smbd start && tail -f /dev/null"]
