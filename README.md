*This project has been created as part of the 42 curriculum by sbeldjao*

---

# Inception
### One container is not enought. We need to go deeper...

---

## Description  
Broaden your system administration skills by working with Docker. In this project, you'll set up a complete infrastructure using Docker Compose, creating and managing multiple containerized services including NGINX with SSL/TLS, WordPress with php-fpm, and MariaDB. You'll gain hands-on experience with containerization, networking, volume management, and secure web service deployment within your own personal virtual machine.  

## Instructions  
In VirtualBox, launch the appropriate virtual machine.  
Connect to the virtual machine via SSH on port 4242.  

## Resources  
Youtube : 

IA : chatGPT  

## Project description  
*Technical choices :*
* **Debian vs Rocky Linux** : I already work with **Debian**, and it's a choice 100% open source, and a very stable OS.
* **AppArmor vs SELinux** : **AppArmor** seems more easy to implement.
* **UFW vs firewalld** : In my experience, **UFW** is very standard in the Debian's world (Debian, Ubuntu, Linux Mint, etc...).
* **VirtualBox vs UTM** : **VirtualBox** is installed on the 42's workstation :-)

---   

## Commands used in this project

### APT
apt update  
apt upgrade  
apt full-upgrade -y  
apt install  

nano /etc/apt/sources.list.d/debian.sources  

```bash
Types: deb deb-src
URIs: https://deb.debian.org/debian
Suites: trixie trixie-updates
## If you want access to contrib and non-free components,
## add " contrib non-free" after "non-free-firmware"
Components: main non-free-firmware
Enabled: yes
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb deb-src
URIs: https://security.debian.org/debian-security
Suites: trixie-security
Components: main non-free-firmware
Enabled: yes
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
```

### Open SSH
apt install ssh  
sshd_config *fichier de configuration par défaut*  
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.d/sshd_config_vm42.conf    *créer un fichier de configuration personalisée, qui sera chargé automatiquement*  
nano /etc/ssh/sshd_config.d/sshd_config_vm42.conf  

```bash
Port 4242
PermitRootLogin no
AllowUsers nom_utilisateur1 nom_utilisateur2

PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication yes
ChallengeResponseAuthentication no
UsePAM yes
```
systemctl restart ssh  

ssh-keygen -t ed25519 -C "@mail"                *générer un couple clé publique/privée*  
eval "$(ssh-agent -s)"                          *démarrer l'agent SSH en arrière plan*  
ssh-add ~/.ssh/id_ed25519                       *ajouter une clé SSH à ssh-agent*  
mkdir -p ~/.ssh                                 *créer le répertoire SSH de l'utilisateur*  
chmod 700 ~/.ssh                                *donner tous les droits sur le répertoire SSH uniquement à l'utilisateur*  
cat id_ed25519.pub >> ~/.ssh/authorized_keys    *copier une clé publique dans le fichier* **authorized_keys**  
chmod 600 ~/.ssh/authorized_keys                *donner les droits RW sur le fichier* **authorized_keys** *uniquement à l'utilisateur*  

### Hostname   
hostnamectl *ou* hostname               *Afficher le hotsname actuel*  
hostnamectl set-hostname new_hostname   *Modifier le hostname*  

### IP   
ip address  

sudo apt install resolvconf

sudo ifdown enp0s3  
sudo ifup enp0s3  
sudo systemctl restart networking  

nmcli connection show  
sudo nmcli connection down "Wired connection 1"  
sudo nmcli connection up "Wired connection 1"  

#### Configuration IP avec IFUPDOWN
nano /etc/network/interfaces
```
# The primary network interface
allow-hotplug enp0s3
#iface enp0s3 inet dhcp
iface enp0s3 inet static
    address 192.168.100.10
    netmask 255.255.255.0
    gateway 192.168.100.1
    dns-nameservers 1.1.1.1 8.8.8.8

# This is an autoconfigured IPv6 interface
iface enp0s3 inet6 auto
```
#### Configuration IP fixe avec Network Manager
sudo nmcli connection modify "Wired connection 1" \
    ipv4.method manual \
    ipv4.addresses 192.168.100.10/24 \
    ipv4.gateway 192.168.100.1 \
    ipv4.dns "192.168.100.1 8.8.8.8"

#### Configuration IP via DHCP
sudo nmcli connection modify "Wired connection 1" \
    ipv4.method auto \
    ipv4.addresses "" \
    ipv4.gateway "" \
    ipv4.dns ""

### Reboot / Shutdown
reboot  
shutdown --poweroff

## Docker
### Installation
**Uninstall all conflicting packages (old installation)**
```
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)
```
**Set up Docker's apt repository**
```
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
```
**Install the latest version**
```
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
**Verify that Docker is running**
```
sudo systemctl status docker
```
**Test Docker with the hello-world image**
```
sudo docker run hello-world
```
---
### Commandes docker
https://docs.docker.com/go/guides/  
docker [OPTIONS] COMMAND  

---
#### Common Commands
**run**         *Create and run a new container from an image*  
**exec**        *Execute a command in a running container*  
**ps**          *List containers*  
**build**       *Build an image from a Dockerfile*  
**bake**        *Build from a file*  
**pull**        *Download an image from a registry*  
**push**        *Upload an image to a registry*  
**images**      *List images*  
**login**       *Authenticate to a registry*  
**logout**      *Log out from a registry*  
**search**      *Search Docker Hub for images*  
**version**     *Show the Docker version information*  
**info**        *Display system-wide information*  

---
#### Management Commands
**builder**     *Manage builds*  
**buildx**      *Docker Buildx*  
**checkpoint**  *Manage checkpoints*  
**compose**     *Docker Compose*  
**container**   *Manage containers*  
**context**     *Manage contexts*  
**image**       *Manage images*  
**manifest**    *Manage Docker image manifests and manifest lists*  
**network**     *Manage networks*  
**plugin**      *Manage plugins*  
**system**      *Manage Docker*  
**volume**      *Manage volumes*  

---
#### Swarm Commands
**config**      *Manage Swarm configs*  
**node**        *Manage Swarm nodes*  
**secret**      *Manage Swarm secrets*  
**service**     *Manage Swarm services*  
**stack**       *Manage Swarm stacks*  
**swarm**       *Manage Swarm*  

---
#### Commands
**attach**      *Attach local standard input, output, and error streams to a running container*  
**commit**      *Create a new image from a container's changes*  
**cp**          *Copy files/folders between a container and the local filesystem*  
**create**      *Create a new container*  
**diff**        *Inspect changes to files or directories on a container's filesystem*  
**events**      *Get real time events from the server*  
**export**      *Export a container's filesystem as a tar archive*  
**history**     *Show the history of an image*  
**import**      *Import the contents from a tarball to create a filesystem image*  
**inspect**     *Return low-level information on Docker objects*  
**kill**        *Kill one or more running containers*  
**load**        *Load an image from a tar archive or STDIN*  
**logs**        *Fetch the logs of a container*  
**pause**       *Pause all processes within one or more containers*  
**port**        *List port mappings or a specific mapping for the container*  
**rename**      *Rename a container*  
**restart**     *Restart one or more containers*  
**rm**          *Remove one or more containers*  
**rmi**         *Remove one or more images*  
**save**        *Save one or more images to a tar archive (streamed to STDOUT by default)*  
**start**       *Start one or more stopped containers*  
**stats**       *Display a live stream of container(s) resource usage statistics*  
**stop**        *Stop one or more running containers*  
**tag**         *Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE*  
**top**         *Display the running processes of a container*  
**unpause**     *Unpause all processes within one or more containers*  
**update**      *Update configuration of one or more containers*  
**wait**        *Block until one or more containers stop, then print their exit codes*  

---
#### Global Options
**--config string**         *Location of client config files (default "/home/sergio/.docker")*  
**-c, --context string**    *Name of the context to use to connect to the daemon (overrides DOCKER_HOST env var and default context set with "docker context use")*  
**-D, --debug**             *Enable debug mode*  
**-H, --host string**       *Daemon socket to connect to*  
**-l, --log-level string**  *Set the logging level ("debug", "info", "warn", "error", "fatal") (default "info")*  
**--tls**                   *Use TLS; implied by --tlsverify*  
**--tlscacert string**      *Trust certs signed only by this CA (default "/home/sergio/.docker/ca.pem")*  
**--tlscert string**        *Path to TLS certificate file (default "/home/sergio/.docker/cert.pem")*  
**--tlskey string**         *Path to TLS key file (default "/home/sergio/.docker/key.pem")*  
**--tlsverify**             *Use TLS and verify the remote*  
**-v, --version**           *Print version information and quit*  

---
