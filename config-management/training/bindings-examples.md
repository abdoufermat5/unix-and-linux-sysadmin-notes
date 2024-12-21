# Bindings

Example variable bindings in Ansible:

```yaml
# group_vars/webservers.yml
http_port: 80
max_clients: 200
document_root: /var/www/html

# playbook.yml
- hosts: webservers
  tasks:
    - name: Configure Apache
      template:
        src: apache.conf.j2
        dest: /etc/apache2/apache2.conf
```

Teamplate bindings:

```text
# templates/apache.conf.j2
Listen {{ http_port }}
DocumentRoot {{ document_root }}

<Directory {{ document_root }}>
    AllowOverride All
    MaxClients {{ max_clients }}
</Directory>
```

Inventory bindings:

```yaml
# inventory.yml
all:
  children:
    webservers:
      hosts:
        web1.example.com:
          http_port: 8080
        web2.example.com:
          http_port: 80
    dbservers:
      hosts:
        db1.example.com:
          mysql_port: 3306
```

Host and Group Variable Precedence:

```yaml
# host_vars/web1.example.com.yml
http_port: 8080
ssl_enabled: true

# group_vars/all.yml
http_port: 80
ssl_enabled: false
```

Role-based Bindings:

```yaml
# roles/webserver/defaults/main.yml
http_port: 80
ssl_enabled: false

# roles/webserver/tasks/main.yml
- name: Install Apache
  apt:
    name: apache2
    state: present

- name: Configure Apache
  template:
    src: apache.conf.j2
    dest: /etc/apache2/apache2.conf
  vars:
    custom_port: "{{ http_port }}"
```

Conditional bindings:

```yaml
# playbook.yml
- hosts: all
  tasks:
    - name: Install packages based on OS
      package:
        name: "{{ item }}"
        state: present
      vars:
        packages:
          RedHat:
            - httpd
            - mod_ssl
          Debian:
            - apache2
            - apache2-ssl
      loop: "{{ packages[ansible_os_family] }}"
```

Facts as bindings:

```yaml
# playbook.yml
- hosts: all
  tasks:
    - name: Configure system based on available memory
      template:
        src: system.conf.j2
        dest: /etc/system.conf
      vars:
        max_workers: "{{ (ansible_memtotal_mb / 512) | int }}"
```

Environment-specific Bindings:

```yaml
# environments/production/group_vars/all.yml
environment: production
log_level: warn
backup_retention: 30

# environments/staging/group_vars/all.yml
environment: staging
log_level: debug
backup_retention: 7
```