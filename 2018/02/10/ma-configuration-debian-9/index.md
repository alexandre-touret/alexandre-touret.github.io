# Ma Configuration Debian 9

Désolé de remettre ça. Je remets sur mon blog ma configuration Debian. Histoire de ne pas la perdre tant qu'elle est dans mon historique .


{{< style "text-align:center" >}}
![debian](/assets/images/2018/02/220px-debian-openlogo-svg.png)
{{</ style >}}

Voici ce que j'ai réalisé post-installation:

## Ajout dépôts supplémentaires

Dans le fichier /etc/apt/sources.list, ajouter les repo contrib et non-free . Activer également les mises à jour de sécurité.

```ini
deb http://ftp.fr.debian.org/debian/ stretch main non-free contrib
deb-src http://ftp.fr.debian.org/debian/ stretch main non-free contrib

deb http://security.debian.org/debian-security stretch/updates main non-free contrib
deb-src http://security.debian.org/debian-security stretch/updates main non-free contrib

# stretch-updates, previously known as 'volatile'
deb http://ftp.fr.debian.org/debian/ stretch-updates main non-free contrib
deb-src http://ftp.fr.debian.org/debian/ stretch-updates main non-free contrib
```

## Logiciels tiers

### Etcher

    #echo "deb https://dl.bintray.com/resin-io/debian stable etcher" | sudo tee /etc/apt/sources.list.d/etcher.list
    

```bash
  <pre>#apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 379CE192D401AB61
```


### Virtualbox

```bash
# wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
```


Dans le fichier ``/etc/apt/sources.list.d/virtualbox.list``

```ini
deb https://download.virtualbox.org/virtualbox/debian stretch contrib
```


### Spotify

Dans le fichier /etc/apt/sources.list.d/spotify.list

```ini
deb http://repository.spotify.com stable non-free
```


## Installation paquets supplémentaires

```bash
# apt-get update
# apt-get install firmware-iwlwifi virtualbox-5.2\
ttf-mscorefonts-installer easytag tuxguitar-jsa htop\
 frescobaldi gparted grsync ntfs-config chromium autofs\
 openjdk-8-jdk openjdk-8-jre gnome-tweak-tool ntfs-config \
ntfs-3g cifs-utils geogebra-gnome arduino libmediainfo \
libmediainfo0v5 network-manager-openvpn-gnome dirmngr \
spotify-client spotify-client-gnome-support \
 etcher apt-transport-https etcher-electron vim \
fonts-powerline audacity ffmpeg lame unrar rar gdebi \
sound-juicer traceroute scala net-tools nmap \
gnome-shell-pomodoro hplip dig dnsutils build-essential \
linux-headers-amd64 firmware-linux-nonfree lshw ethtool \
libsane-hpaio xsane autofs vlc
```


## Configuration autofs

Pour ceux qui ne connaissent pas , [autofs](https://wiki.debian.org/AutoFs) est un outil permettant de monter directement des partages [nfs](https://linuxconfig.org/how-to-configure-nfs-on-debian-9-stretch-linux) et cicfs à l'utilisation et non au démarrage de l'ordinateur.

Dans le fichier /etc/auto.master

```ini
/mnt/SERV1/nfs /etc/auto.nfs --ghost, --timeout=60 
/mnt/SERV1/cifs /etc/auto.SERV1.cifs --ghost, --timeout=60 
/mnt/SERV2 /etc/auto.cifs --ghost, --timeout=60
```


ensuite insérer la configuration adéquate dans les fichiers référencés :

### auto.cicfs

```ini
data -fstype=cifs,credentials=/home/USER/.cred-file,user=littlewing,uid=1000,gid=1000 ://192.168.0.XX/REPERTOIRE
```


Les identifiants / mots de passe sont stockés dans un fichier .cred-file stocké à la racine du répertoire utilisateur.

Voici un exemple :

```ini
username=user
password=password
```


Le fichier auto.SERV1.cifs reprend la même structure

### auto.nfs

```ini
REP1 -fstype=nfs,rw,intr 192.168.0.XX:/volume1/REP1
REP2 -fstype=nfs,rw,intr 192.168.0.XX:/volume1/REP2
```


## Installation d'atom

J'ai choisi d'installer [atom](https://atom.io/) via le package .deb fourni par [github](http://github.com/). Afin d'automatiser l'installation et la mise à jour, voici le script que j'ai réalisé :

```bash
#!/bin/sh
SETUP_ROOT=/tmp
wget -O $SETUP_ROOT/atom.deb "https://atom.io/download/deb"
echo "Installation du paquet..."
dpkg -i $SETUP_ROOT/atom.deb
echo "Fini :)"
```


Ce script est placé dans le répertoire /usr/local/sbin et lancé comme suit :

```bash
# upgrade-atom.sh
```


## Installation de Firefox

Afin d'avoir la dernière version de firefox, voici le script que j'ai réalisé:

```bash
#!/bin/sh
SETUP_ROOT=/tmp
BIN_ROOT=/usr/local/firefox
DATE=`date +%Y-%m-%d`
OLD_EXE=/usr/lib/firefox-esr/firefox-esr
wget -O $SETUP_ROOT/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=fr"
echo "Extraction de l'archive..."
tar xjf $SETUP_ROOT/FirefoxSetup.tar.bz2 -C /usr/local
echo "Changement des droits utilisateur"
chown -R :users $BIN_ROOT
chmod a+x $BIN_ROOT/firefox
echo "Sauvegarde de l'ancien binaire et Creation des liens symboliques"
if [ -e $OLD_EXE ]
then
 OLD_BINARY=${OLD_EXE}_orig_${DATE}
 mv $OLD_EXE $OLD_BINARY
fi 
ln -s $BIN_ROOT/firefox $OLD_EXE
chmod a+x $OLD_EXE
echo "Fini :)"
```


## Minecraft

Voila l'étape la plus importante, du moins pour mes enfants &#8230;

J'ai crée le script /usr/local/bin/minecraft.sh

```bash
#!/bin/bash
cd /usr/local/minecraft
java -Xmx1G -Xms512M -cp /usr/local/minecraft/Minecraft.jar net.minecraft.bootstrap.Bootstrap
```


J'ai placé le JAR en question dans le répertoire /usr/local/minecraft.

Enfin, j'ai crée le fichier « lanceur gnome » /usr/share/applications/minecraft.desktop

```ini
[Desktop Entry] 
Name=Minecraft
Comment=
Categories=Game;BoardGame;
Exec=/usr/local/bin/minecraft.sh
Icon=Minecraft_Block
Terminal=false
Type=Application
StartupNotify=true
```


J'ai également mis une icone SVG dans le répertoire /usr/share/icons/

## Optimisation du boot

Après toutes ces installations, il faut vérifier que les performances, notamment au démarrage ne sont pas trop altérées

Pour avoir le détail du boot, il faut utiliser la commande systemd-analyze

```bash
#systemd-analyze blame
 8.113s NetworkManager-wait-online.service
 2.549s apt-daily-upgrade.service
 803ms networking.service
 228ms colord.service
 213ms dev-sda1.device
 145ms systemd-timesyncd.service
 128ms ModemManager.service
 102ms autofs.service
....
```


On peut également voir le chemin critique avec cette commande:

```bash
#systemd-analyze critical-chain 
The time after the unit is active or started is printed after the "@" character.
The time the unit takes to start is printed after the "+" character.

graphical.target @8.944s
└─multi-user.target @8.944s
 └─autofs.service @8.841s +102ms
 └─network-online.target @8.841s
 └─NetworkManager-wait-online.service @723ms +8.113s
 └─NetworkManager.service @642ms +80ms
 └─dbus.service @612ms
 └─basic.target @612ms
 └─paths.target @612ms
 └─acpid.path @610ms
 └─sysinit.target @608ms
 └─systemd-backlight@backlight:acpi_video0.service @1.042s +8ms
 └─system-systemd\x2dbacklight.slice @1.042s
 └─system.slice @119ms
 └─-.slice @108ms
```


### Désactivation des services

Par exemple, si vous voulez désactiver le service virtualbox au démarrage

```bash
# systemctl disable vboxautostart-service.service
```


et ainsi de suite pour tous les services inutiles au démarrage

## Analyse du démarrage d'un service

Pour analyser le démarrage d'un service, on peut utiliser la commande journalctl

```bash
# journalctl -b -u NetworkManager-wait-online.service
```

## Conclusion

Après toutes ces étapes, j'ai un système opérationnel. Il manque pas mal d'outils ( ex. maven, npm, intellij,&#8230;). Ces outils tiennent plus du poste de développement.
