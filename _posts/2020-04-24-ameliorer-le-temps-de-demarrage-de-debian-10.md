---
id: 344
title: Améliorer le temps de démarrage de Debian 10
date: 2020-04-24T20:06:13+02:00


header:
  teaser: /assets/images/2020/04/boot_avant.png

timeline_notification:
  - "1587755176"
publicize_twitter_user:
  - touret_alex
  - logiciels libres
tags:
  - debian
  - planetlibre
---
Mon PC Lenovo a un SSD. Le temps de démarrage est actuellement de 11 sec. Ça commence à faire pas mal&#8230; J'ai eu donc envie de me pencher sur l'optimisation du démarrage ( encore une fois) . Voici comment gagner (facilement) quelques secondes au démarrage.

<figure class="wp-block-image size-large">
<img loading="lazy" width="819" height="45" src="/assets/images/2020/04/boot_time.png?w=819" alt="" class="wp-image-346" srcset="/assets/images/2020/04/boot_time.png 819w, /assets/images/2020/04/boot_time-300x16.png 300w, /assets/images/2020/04/boot_time-768x42.png 768w" sizes="(max-width: 819px) 100vw, 819px" /> 
</figure> 

Tout d'abord, vous devez analyser les services qui prennent du temps au démarrage. Vous pouvez le faire avec cette commande:

```bash
systemd-analyze plot > plot.svg
```


J'ai obtenu le graphique suivant:<figure class="wp-block-gallery aligncenter columns-1 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="/assets/images/2020/04/boot_avant.png"><img loading="lazy" width="6066" height="4013" src="/assets/images/2020/04/boot_avant.png" alt="" data-id="350" class="wp-image-350" srcset="/assets/images/2020/04/boot_avant.png 6066w, /assets/images/2020/04/boot_avant-300x198.png 300w, /assets/images/2020/04/boot_avant-1024x677.png 1024w, /assets/images/2020/04/boot_avant-768x508.png 768w, /assets/images/2020/04/boot_avant-1536x1016.png 1536w, /assets/images/2020/04/boot_avant-2048x1355.png 2048w, /assets/images/2020/04/boot_avant-1568x1037.png 1568w" sizes="(max-width: 6066px) 100vw, 6066px" /></a></figure>
  </li>
</ul><figcaption class="blocks-gallery-caption">Avant</figcaption></figure> 

## Configuration GRUB

La première manipulation à réaliser est de désactiver le timeout de [GRUB](https://wiki.debian.org/Grub). Pour celà, vous pouvez modifier la variable `GRUB_TIMEOUT` dans le fichier `/etc/default/grub`:

```java
GRUB_TIMEOUT=0
```


Ensuite, vous devez mettre à jour la configuration [GRUB](https://wiki.debian.org/Grub) en exécutant cette commande:

```java
sudo update-grub2
```


Au prochain reboot, vous ne verrez plus le menu [GRUB](https://wiki.debian.org/Grub).

## Configuration NetworkManager

Dans mon cas, le service [`NetworkManager-wait-online.service` prenait près de 9 secondes](https://askubuntu.com/questions/1018576/what-does-networkmanager-wait-online-service-do). Après avoir lu [plusieurs billets](https://askubuntu.com/questions/1018576/what-does-networkmanager-wait-online-service-do) et rapports de bug, je me suis aperçu que je pouvais le désactiver au boot. Vous pouvez le faire en lançant la commande suivante

```java
sudo systemctl disable NetworkManager-wait-online.service
```


## Configuration Apt

Un autre service qui prenait pas mal de temps était [apt-daily.timer qui vérifiait au boot](https://askubuntu.com/questions/1038923/do-i-really-need-apt-daily-service-and-apt-daily-upgrade-service) qu'il y avait des mises à jour de l'OS. Après quelques recherches, j' ai vu qu'on pouvait soit le désactiver ( ce qui n'est pas recommandé pour les mises à jour de sécurité ) soit décaler la recherche. J'ai choisi cette solution. Vous devez donc exécuter la commande suivante:

```java
sudo systemctl edit apt-daily.timer
```


Et renseigner le contenu suivant:

```java
[Timer]
OnBootSec=15min
OnUnitActiveSec=1d
AccuracySec=1h
RandomizedDelaySec=30min
```


Ce service sera donc lancé 15 minutes après le boot. Ce qui est largement suffisant.

**[EDIT]** Vous pouvez appliquer la même configuration pour le service `apt-daily-upgrade` en exécutant la commande:

```java
sudo systemctl edit apt-daily-upgrade.timer
```


Ensuite, vous pouvez recharger la configuration en exécutant cette commande:

```java
sudo systemctl daemon-reload
```


## Résultats

Après ces quelques manipulations qui peuvent prendre 5 minutes grand maximum, j'ai réussi à optimiser le boot en réduisant le démarrage à **5 secondes!**<figure class="wp-block-image size-large">

<img loading="lazy" width="783" height="55" src="/assets/images/2020/04/boot_apres_header.png?w=783" alt="" class="wp-image-360" srcset="/assets/images/2020/04/boot_apres_header.png 783w, /assets/images/2020/04/boot_apres_header-300x21.png 300w, /assets/images/2020/04/boot_apres_header-768x54.png 768w" sizes="(max-width: 783px) 100vw, 783px" /> </figure> 

Vous pourrez trouver le détail ci-dessous:<figure class="wp-block-gallery aligncenter columns-1 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="/assets/images/2020/04/boot_apres-2.png?w=287"><img loading="lazy" width="1102" height="3930" src="/assets/images/2020/04/boot_apres-2.png?w=287" alt="" data-id="362" data-link="https://blog.touret.info/boot_apres-2/" class="wp-image-362" srcset="/assets/images/2020/04/boot_apres-2.png 1102w, /assets/images/2020/04/boot_apres-2-84x300.png 84w, /assets/images/2020/04/boot_apres-2-287x1024.png 287w, /assets/images/2020/04/boot_apres-2-768x2739.png 768w, /assets/images/2020/04/boot_apres-2-431x1536.png 431w, /assets/images/2020/04/boot_apres-2-574x2048.png 574w" sizes="(max-width: 1102px) 100vw, 1102px" /></a></figure>
  </li>
</ul><figcaption class="blocks-gallery-caption">Après</figcaption></figure>