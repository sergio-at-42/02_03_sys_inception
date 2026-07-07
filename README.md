*This project has been created as part of the 42 curriculum by sbeldjao*

---

# Born2beRoot
### Your very first own server.

---

## Description  
Step into the world of virtualization and learn how to create and manage isolated environments on a single machine.  
This project introduces key concepts that are foundational to modern infrastructure and cloud technologies, teaching learners essential system administration skills through hands-on virtual machine configuration and security implementation.  

## Instructions  
The *signature.txt* file was create with the **sha1sum sbeldjao.vdi** command.  
In VirtualBox, use a copy of **sbeldjao42** directory to launch the virtual machine **sbeldjao.vbox**.  
Connect to the virtual machine via SSH on port 4242.  

## Resources  
Youtube : 
*  Introduction Script Bash sur Linux <https://www.youtube.com/watch?v=gBCGeLjYBgQ&list=PLSuzYIVSEUT45ogJPAzxDsDSzFbYlKzJY&index=1>  
*  Script Bash - Maitrisez les conditions If, Else, Elif <https://www.youtube.com/watch?v=5nIz75sGq3A&list=PLSuzYIVSEUT45ogJPAzxDsDSzFbYlKzJY&index=2>  
*  Script Bash - Maitrisez les boucles For <https://www.youtube.com/watch?v=k-0uhLVI11M&list=PLSuzYIVSEUT45ogJPAzxDsDSzFbYlKzJY&index=3>  
*  Script Bash - Maitrisez les boucles While <https://www.youtube.com/watch?v=AJpe9VV9utQ&list=PLSuzYIVSEUT45ogJPAzxDsDSzFbYlKzJY&index=4>  

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

### SUDO
apt install sudo  
addusers sbeldjao sudo  
  
#### Ajouter un utilisateur a sudo  
adduser *user* sudo
usermod -aG sudo *user*

#### Edition de /etc/sudoers  
sudo visudo  

Defaults requiretty                     *Obligation d'utiliser un terminal interactif pour sudo*
Defaults timestamp_timeout=5            *Mémorise l’authentification, en minutes*  
Defaults logfile="/var/log/sudo.log"    *Definir le fichier de log pour sudo*  
Defaults passwd_tries=3                 *Nombre d'essai en cas d'erreur de mot de passe*
Defaults passprompt="[sudo] Password for %u: "  *Personnalise le prompt*  
Defaults badpass_message="Wrong password."  *message erreur*  
  
### Mot de passe  
sudo apt install libpam-pwquality  

sudo nano /etc/security/pwquality.conf  
* minlen            *longueur minimale*  
* minclass=1        *nombr minimum de caractère par classes*
* dcredit=-1	    *au moins 1 chiffre*  
* ucredit=-1	    *au moins 1 majuscule*  
* lcredit=-1	    *au moins 1 minuscule*  
* ocredit=-1	    *au moins 1 caractère spécial*  
* maxrepeat         *répétitions max*  
* difok             *différences avec ancien mdp*  
* retry             *tentatives*  
* enforce_for_root  *appliquer aussi a root*  
* dictcheck         *verification dans un dictionnaire*
```bash
difok = 7
minlen = 10
dcredit = -1
ucredit = -1
lcredit = -1
maxrepeat = 3
usercheck = 1
enforce_for_root
```

sudo nano /etc/login.defs
* PASS_MAX_DAYS	*expiration*  
* PASS_MIN_DAYS	*délai avant changement*  
* PASS_WARN_AGE	*avertissement*  
```bash
PASS_MAX_DAYS   30   
PASS_MIN_DAYS   2
PASS_WARN_AGE   7
```   
#### Activation de PAM  
sudo nano /etc/pam.d/common-password  
*Verifier la presence de :* **password requisite pam_pwquality.so retry=3**  
*Optionnel; hitorique des mots de passe :* **password requisite pam_pwhistory.so remember=5**  
  
#### Status du mot de passe  
chage -l *user*  
passwd --status  
  
### Open SSH
apt install ssh  
sshd_config *fichier de configuration par défaut*  
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.d/sshd_config_vm42.conf    *créer un fichier de configuration personalisée, qui sera chargé automatiquement*  
nano /etc/ssh/sshd_config.d/sshd_config_vm42.conf  

ssh-keygen -t ed25519 -C "@mail"                *générer un couple clé publique/privée*  
eval "$(ssh-agent -s)"                          *démarrer l'agent SSH en arrière plan*  
ssh-add ~/.ssh/id_ed25519                       *ajouter une clé SSH à ssh-agent*  
mkdir -p ~/.ssh                                 *créer le répertoire SSH de l'utilisateur*  
chmod 700 ~/.ssh                                *donner tous les droits sur le répertoire SSH uniquement à l'utilisateur*  
cat id_ed25519.pub >> ~/.ssh/authorized_keys    *copier une clé publique dans le fichier* **authorized_keys**  
chmod 600 ~/.ssh/authorized_keys                *donner les droits RW sur le fichier* **authorized_keys** *uniquement à l'utilisateur*  

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

### Hostname   
hostnamectl *ou* hostname               *Afficher le hotsname actuel*  
hostnamectl set-hostname new_hostname   *Modifier le hostname*  

### IP   
ip address  

### UFW (Uncomplicated Firewall)   
apt install ufw  
ufw status  
ufw status numbered  
sudo ufw enable  
ufw default deny incoming  
ufw default allow outgoing  
ufw allow 4242  
ufw deny 22  
ufw delete 2 4  

### ApArmor
aa-status   *état AppArmor*  
aa-enforce	*mode actif*  
aa-complain	*audit*  
aa-disable	*désactiver*  
aa-genprof	*créer profil*  

### SELinux   
apt install selinux-basics selinux-policy-default auditd   *Installer SELinux*  
selinux-activate   *configure SELinux, modifie le boot, prépare les labels*  
sestatus   *Vérifier le statut*  

**Modes SELinux**  
 - enforcing   *bloque selon les règles*  
 - permissive   *log seulement*  
 - disabled   *désactivé*  

**Changer le mode temporairement**  
 - setenforce 0   *permissive*  
 - setenforce 1   *enforcing*  

nano /etc/selinux/config  
*Options possibles*  
 - SELINUX=enforcing  
 - SELINUX=permissive  
 - SELINUX=disabled  
```
SELINUX=enforcing
```
ls -Z   *Vérifier les contextes*  
restorecon -Rv /   *Réparer les contextes*  

### Groups
groupadd user42 --users sbeldjao  
newgrp user42  
groups  

### Reboot / Shutdown
reboot  
shutdown --poweroff

### Script
nano monitoring.sh
chmod +x monitoring.sh

```bash
#!/usr/bin/env bash

color_reset="\e[0m"
color_frame="\e[0;34;46m"
color_content="\e[1;33;44m"
sp="                                                                                "
hd="════════════════════════════════════════════════════════════════════════════════"
vs="│"

disp_first_line() {
    local width="$1"
    echo -e "${color_frame}╒${hd:0:width - 2}╕${color_reset}"
}

disp_last_line() {
    local width="$1"
    echo -e "${color_frame}╘${hd:0:width - 2}╛${color_reset}"
}

disp_title() {
    local text="$1"
    local width="$2"
    local len=${#text}
    local pr=$((width-len-7))
    if (( len > width - 8 )); then
        echo "${text:0:width - 8}"
    fi
    echo -e "${color_frame}╞${hd:0:3}╡${text}╞${hd:0:pr}╡${color_reset}"
}

disp_content() {
    local text="$1"
    local width="$2"
    local len=${#text}
    if (( len > width - 2 )); then
        text=${text:0:max - 2}
    fi
    echo -e "${color_frame}${vs}${color_content}${text}${color_frame}${vs}${color_reset}"
}

strcenter() {
    local text="$1"
    local max="$2"
    local psp="                                        "
    local len=${#text}
    local pl=$(((max-len)/2))
    local pr=$((pl+(max-len)%2))

    if (( len > max )); then
        echo "${text:0:max}"
    else
        echo "${psp:0:pl}${text}${psp:0:pr}"
    fi
}

arg() {
    local a=$(($1+1))
    echo ${!a}
}

echo ""
disp_first_line 80

# Display Date and Time
text=$(date)
str=$(strcenter "${text}" 78)
disp_content "${str}" 80

text="Last boot : $(uptime -p)"
str=$(strcenter "${text}" 78)
disp_content "${str}" 80

# Display OS informations
disp_title "Operating sytem" 80

text="Architecture : $(uname -m)"
str1=$(strcenter "${text}" 39)
text="Kernel : $(uname -s)"
str2=$(strcenter "${text}" 39)
disp_content "${str1}${str2}" 80

text="Version : $(uname -r)"
str=$(strcenter "${text}" 78)
disp_content "${str}" 80

# Display Network informations
disp_title "Network" 80

text="Hostname: $(hostname)"
str=$(strcenter "${text}" 78)
disp_content "${str}" 80

ipv4=$(arg 1 $(hostname -I))
text="IP V4 : ${ipv4}"
str1=$(strcenter "${text}" 39)
mac=$(arg 2 $(ip link | grep "ether"))
text="MAC Addresse : ${mac}"
str2=$(strcenter "${text}" 39)
disp_content "${str1}${str2}" 80

connections=$(($(ss -tun | wc -l) - 1 ))
text="Active connections : ${connections}"
str1=$(strcenter "${text}" 39)
users=$(who | wc -l)
text="Users connected : ${users}"
str2=$(strcenter "${text}" 39)
disp_content "${str1}${str2}" 80

# Display CPUs informations
disp_title "CPUs" 80

nbsocket=$(arg 2 $(lscpu | grep "^Socket(s)"))
nbcore=$(arg 4 $(lscpu | grep "^Core(s)"))
nbpcpu=$((nbsocket*nbcore))
text="Number of physical processors: $nbpcpu"
str1=$(strcenter "${text}" 39)
nbvcpu=$(arg 2 $(lscpu | grep "^CPU(s)"))
text="Number of virtual processors: $nbvcpu"
str2=$(strcenter "${text}" 39)
disp_content "${str1}${str2}" 80

cpupourcent=$(echo "100 - $(arg 8 $(top -bn1 | grep "Cpu(s)"))" | bc)
text="CPU utilization rate : ${cpupourcent}%"
str=$(strcenter "${text}" 78)
disp_content "${str}" 80

# Display RAM informations
disp_title "RAM" 80

ramavaible=$(arg 7 $(free -h | grep "^Mem"))
text="Currently available RAM : ${ramavaible}"
str1=$(strcenter "${text}" 39)
ramused=$(arg 3 $(free | grep "^Mem"))
ramtotal=$(arg 2 $(free | grep "^Mem"))
rampourcent=$((100*ramused/ramtotal))
text="RAM utilization rate : ${rampourcent}%"
str2=$(strcenter "${text}" 39)
disp_content "${str1}${str2}" 80

# Display Storage informations
disp_title "Storage" 80

storageavaible=$(arg 2 $(df -h / | grep "^/"))
text="Currently available storage : ${storageavaible}"
str1=$(strcenter "${text}" 39)
storageused=$(arg 5 $(df -h / | grep "^/"))
text="Storage utilization rate : ${storageused}"
str2=$(strcenter "${text}" 39)
disp_content "${str1}${str2}" 80

if lsblk | grep -q "lvm"; then
    lvm="Active"
else
    lvm="Not Active"
fi
text="Logical Volume Manager (LVM) : ${lvm}"
str=$(strcenter "${text}" 78)
disp_content "${str}" 80

# Display SUDO informations
disp_title "sudo" 80

text="Number of commands executed with sudo : $(journalctl -q | grep "COMMAND=" | wc -l)"
str=$(strcenter "${text}" 78)
disp_content "${str}" 80

disp_last_line 80
echo ""
```
