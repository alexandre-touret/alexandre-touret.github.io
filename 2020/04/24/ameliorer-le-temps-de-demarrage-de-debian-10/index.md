# Améliorer le temps de démarrage de Debian 10


Mon PC Lenovo a un SSD. Le temps de démarrage est actuellement de 11 sec. Ça commence à faire pas mal&#8230; J'ai eu donc envie de me pencher sur l'optimisation du démarrage ( encore une fois) . Voici comment gagner (facilement) quelques secondes au démarrage.

{{< figure src="/assets/images/2020/04/boot_time.png" title="Boot time" >}}

Tout d'abord, vous devez analyser les services qui prennent du temps au démarrage. Vous pouvez le faire avec cette commande:

```bash
systemd-analyze plot > plot.svg
```

J'ai obtenu le graphique suivant:

{{< figure src="/assets/images/2020/04/boot_avant.png" title="Boot initial" >}}

## Configuration GRUB

La première manipulation à réaliser est de désactiver le timeout de [GRUB](https://wiki.debian.org/Grub). Pour celà, vous pouvez modifier la variable `GRUB_TIMEOUT` dans le fichier `/etc/default/grub`:

```ini
GRUB_TIMEOUT=0
```


Ensuite, vous devez mettre à jour la configuration [GRUB](https://wiki.debian.org/Grub) en exécutant cette commande:

```bash
sudo update-grub2
```


Au prochain reboot, vous ne verrez plus le menu [GRUB](https://wiki.debian.org/Grub).

## Configuration NetworkManager

Dans mon cas, le service [`NetworkManager-wait-online.service` prenait près de 9 secondes](https://askubuntu.com/questions/1018576/what-does-networkmanager-wait-online-service-do). Après avoir lu [plusieurs billets](https://askubuntu.com/questions/1018576/what-does-networkmanager-wait-online-service-do) et rapports de bug, je me suis aperçu que je pouvais le désactiver au boot. Vous pouvez le faire en lançant la commande suivante

```bash
sudo systemctl disable NetworkManager-wait-online.service
```


## Configuration Apt

Un autre service qui prenait pas mal de temps était [apt-daily.timer qui vérifiait au boot](https://askubuntu.com/questions/1038923/do-i-really-need-apt-daily-service-and-apt-daily-upgrade-service) qu'il y avait des mises à jour de l'OS. Après quelques recherches, j' ai vu qu'on pouvait soit le désactiver ( ce qui n'est pas recommandé pour les mises à jour de sécurité ) soit décaler la recherche. J'ai choisi cette solution. Vous devez donc exécuter la commande suivante:

```bash
sudo systemctl edit apt-daily.timer
```


Et renseigner le contenu suivant:

```ini
[Timer]
OnBootSec=15min
OnUnitActiveSec=1d
AccuracySec=1h
RandomizedDelaySec=30min
```


Ce service sera donc lancé 15 minutes après le boot. Ce qui est largement suffisant.

**[EDIT]** Vous pouvez appliquer la même configuration pour le service `apt-daily-upgrade` en exécutant la commande:

```bash
sudo systemctl edit apt-daily-upgrade.timer
```


Ensuite, vous pouvez recharger la configuration en exécutant cette commande:

```bash
sudo systemctl daemon-reload
```


## Résultats

Après ces quelques manipulations qui peuvent prendre 5 minutes grand maximum, j'ai réussi à optimiser le boot en réduisant le démarrage à **5 secondes!**


{{< figure src="/assets/images/2020/04/boot_apres_header.png" title="Boot (après)" >}}

Vous pourrez trouver le détail ci-dessous:<figure class="wp-block-gallery aligncenter columns-1 is-cropped">

{{< figure src="/assets/images/2020/04/boot_apres-2.png" title="Détail du Boot (après)" >}}

