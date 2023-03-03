# Erreur 139 à l'exécution d'un container docker

Voici un rapide article sur un problème rencontré récemment. Lors de l'exécution d'un container docker, j'ai eu une [erreur SIGSEGV 139](https://medium.com/better-programming/understanding-docker-container-exit-codes-5ee79a1d58f6). Un crash avec aucune log. 

Bref que du bonheur 🙂
  
Avant d'aller plus loin voici mon environnement:

  * [Debian 10](http://www.debian.org/)
  * [Docker CE](https://docs.docker.com/install/linux/docker-ce/debian/) 19.03.8

Après quelques recherches, je me suis rendu compte qu'on pouvait reproduire ce comportement en exécutant cette commande:

```bash
docker run -it gcc:4.8.5
```


Une des raisons trouvées serait [un problème de compatibilité avec le noyau 4.8.5](https://github.com/moby/moby/issues/28705) (oui ça remonte&#8230;).  
Une solution est d'activer l'émulation [vsyscall](https://davisdoesdownunder.blogspot.com/2011/02/linux-syscall-vsyscall-and-vdso-oh-my.html). 

  
Voici la configuration à effectuer:  
Dans le fichier `/etc/default/grub`, ajouter la ligne suivante:

```ini
GRUB_CMDLINE_LINUX_DEFAULT="quiet vsyscall=emulate"
```


Puis lancer les commandes suivantes:

```bash
$ sudo update-grub 
$ sudo reboot
```


Maintenant le container devrait pouvoir s'exécuter correctement.
