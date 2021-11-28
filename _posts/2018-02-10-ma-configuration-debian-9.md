---
id: 33
title: Ma Configuration Debian 9
date: 2018-02-10T08:58:47+01:00
author: admin
layout: post


timeline_notification:
  - "1518252334"
publicize_twitter_user:
  - littlewing1112
tags:
  - debian
  - Planet-Libre
---
Désolé de remettre ça&#8230; Je remets sur mon blog ma configuration Debian. Histoire de ne pas la perdre tant qu&rsquo;elle est dans mon historique .

<img loading="lazy" class=" size-full wp-image-39 aligncenter" src="/assets/img/posts/2018/02/220px-debian-openlogo-svg.png" alt="220px-Debian-OpenLogo.svg" width="220" height="291" /> 

Voici ce que j&rsquo;ai réalisé post-installation:

## Ajout dépôts supplémentaires

Dans le fichier /etc/apt/sources.list, ajouter les repo contrib et non-free . Activer également les mises à jour de sécurité.

<pre>deb http://ftp.fr.debian.org/debian/ stretch main non-free contrib
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
    

<div class="highlight highlight-source-shell">
  <pre>#apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 379CE192D401AB61
```

</div>

### Virtualbox

<pre># wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
```


Dans le fichier /etc/apt/sources.list.d/virtualbox.list

<pre>deb https://download.virtualbox.org/virtualbox/debian stretch contrib
```


### Spotify

Dans le fichier /etc/apt/sources.list.d/spotify.list

<pre>deb http://repository.spotify.com stable non-free
```


## Installation paquets supplémentaires

<pre># apt-get update
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

Pour ceux qui ne connaissent pas , [autofs](https://wiki.debian.org/AutoFs) est un outil permettant de monter directement des partages [nfs](https://linuxconfig.org/how-to-configure-nfs-on-debian-9-stretch-linux) et cicfs à l&rsquo;utilisation et non au démarrage de l&rsquo;ordinateur.

Dans le fichier /etc/auto.master

<pre>/mnt/SERV1/nfs /etc/auto.nfs --ghost, --timeout=60 
/mnt/SERV1/cifs /etc/auto.SERV1.cifs --ghost, --timeout=60 
/mnt/SERV2 /etc/auto.cifs --ghost, --timeout=60
```


ensuite insérer la configuration adéquate dans les fichiers référencés :

### auto.cicfs

<pre>data -fstype=cifs,credentials=/home/USER/.cred-file,user=littlewing,uid=1000,gid=1000 ://192.168.0.XX/REPERTOIRE
```


Les identifiants / mots de passe sont stockés dans un fichier .cred-file stocké à la racine du répertoire utilisateur.

Voici un exemple :

<pre>username=user
password=password
```


Le fichier auto.SERV1.cifs reprend la même structure

### auto.nfs

<pre>REP1 -fstype=nfs,rw,intr 192.168.0.XX:/volume1/REP1
REP2 -fstype=nfs,rw,intr 192.168.0.XX:/volume1/REP2
```


## Installation d&rsquo;atom

J&rsquo;ai choisi d&rsquo;installer [atom](https://atom.io/) via le package .deb fourni par [github](http://github.com/). Afin d&rsquo;automatiser l&rsquo;installation et la mise à jour, voici le script que j&rsquo;ai réalisé :

<pre>#!/bin/sh
SETUP_ROOT=/tmp
wget -O $SETUP_ROOT/atom.deb "https://atom.io/download/deb"
echo "Installation du paquet..."
dpkg -i $SETUP_ROOT/atom.deb
echo "Fini :)"
```


Ce script est placé dans le répertoire /usr/local/sbin et lancé comme suit :

<pre># upgrade-atom.sh
```


## Installation de Firefox

Afin d&rsquo;avoir la dernière version de firefox, voici le script que j&rsquo;ai réalisé:

<pre>#!/bin/sh
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

Voila l&rsquo;étape la plus importante, du moins pour mes enfants &#8230;

J&rsquo;ai crée le script /usr/local/bin/minecraft.sh

<pre>#!/bin/bash
cd /usr/local/minecraft
java -Xmx1G -Xms512M -cp /usr/local/minecraft/Minecraft.jar net.minecraft.bootstrap.Bootstrap
```


J&rsquo;ai placé le JAR en question dans le répertoire /usr/local/minecraft.

Enfin, j&rsquo;ai crée le fichier « lanceur gnome » /usr/share/applications/minecraft.desktop

<pre>[Desktop Entry] 
Name=Minecraft
Comment=
Categories=Game;BoardGame;
Exec=/usr/local/bin/minecraft.sh
Icon=Minecraft_Block
Terminal=false
Type=Application
StartupNotify=true
```


J&rsquo;ai également mis une icone SVG dans le répertoire /usr/share/icons/

## Optimisation du boot

Après toutes ces installations, il faut vérifier que les performances, notamment au démarrage ne sont pas trop altérées

Pour avoir le détail du boot, il faut utiliser la commande systemd-analyze

<pre>#systemd-analyze blame
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

<pre>#systemd-analyze critical-chain 
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

<pre># systemctl disable vboxautostart-service.service
```


et ainsi de suite pour tous les services inutiles au démarrage

## Analyse du démarrage d&rsquo;un service

Pour analyser le démarrage d&rsquo;un service, on peut utiliser la commande journalctl

<pre># journalctl -b -u NetworkManager-wait-online.service
```


&nbsp;

## Conclusion

Après toutes ces étapes, j&rsquo;ai un système opérationnel. Il manque pas mal d&rsquo;outils ( ex. maven, npm, intellij,&#8230;). Ces outils tiennent plus du poste de développement.

&nbsp;

&nbsp;

&nbsp;