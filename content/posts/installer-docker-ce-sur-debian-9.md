---
id: 92
title: Installer docker ce sur Debian 9
date: 2018-09-26T12:28:21+02:00

featuredImage: /assets/images/2018/09/docker.png

featuredImagePreview: /assets/images/2018/09/docker.png
og_image: /assets/images/2018/09/docker.png



geo_public:
  - "0"
timeline_notification:
  - "1537961302"
publicize_twitter_user:
  - touret_alex
tags:
  - debian
  - docker
  - planetlibre
---
Bon, ça fait quelques temps que je n'ai rien posté&#8230;  
Voici un rapide tuto pour installer [docker-ce sur une debian9](https://docs.docker.com/install/linux/docker-ce/debian/). Oui, je sais, docker est déjà présent sur les dépôts, mais si vous souhaitez avoir une version un peu plus récente, vous pouvez passer par l'installation de la version ce fournie par docker.

## Pré-requis

Supprimer les éventuelles installations de docker et docker-compose


```bash
#apt-get remove docker docker-compose  
```

## Installation

Lancer les commandes suivantes:

```bash
# apt-get install apt-transport-https ca-certificates  
# curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add &#8211;  
# add-apt-repository \  
"deb [arch=amd64] https://download.docker.com/linux/debian \  
$(lsb_release -cs) \ stable"  
```

Puis lancer

```bash
# apt update
# apt install docker-ce
```

### Installation de docker-compose

Lancer les commandes suivantes:

```bash
# curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# chmod a+x /usr/local/bin/docker-compose  
```

## Configuration des droits

Pour lancer docker depuis un utiliser non root, il faut lancer les commandes suivantes:

```bash
# groupadd docker
# adduser monutilisateur docker
# usermod -aG docker monutilisateur
```

Après ceci, vaut mieux redémarrer le pc &#8230;

## Configuration du démon

Voici quelques config à appliquer pour que le démon soit accessible par des outils tels que le plugin maven ou encore configurer l'accès à un proxy

### Configuration du port

Exécuter la commande:

```bash
# systemctl edit docker.service
```

Entrer le code suivant:

```ini
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock
```
Et l'enregistrer sous /etc/systemd/system/docker.service.d/docker.conf

### Configuration du proxy

Avec la même commande

```bash
# systemctl edit docker.service
```

Entrer la configuration suivante:

```ini
[Service]
Environment="HTTP\_PROXY=http://mon\_proxy:mon_port/"
Environment="NO_PROXY=127.0.0.1"
```

### Activation des configurations

Lancer les commandes suivantes:

```bash
# systemctl daemon-reload # systemctl restart docker
```

## Validation

Maintenant, vous pouvez valider votre configuration avec la commande:

```bash
$ docker run hello-world
```