---
id: 92
title: Installer docker ce sur Debian 9
date: 2018-09-26T12:28:21+02:00
author: admin
layout: post


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
Bon, ça fait quelques temps que je n&rsquo;ai rien posté&#8230;  
Voici un rapide tuto pour installer [docker-ce sur une debian9](https://docs.docker.com/install/linux/docker-ce/debian/). Oui, je sais, docker est déjà présent sur les dépôts, mais si vous souhaitez avoir une version un peu plus récente, vous pouvez passer par l&rsquo;installation de la version ce fournie par docker.

<img loading="lazy" class="alignnone size-medium wp-image-96" src="/assets/img/posts/2018/09/docker.png?w=300" alt="" width="300" height="268" srcset="/assets/img/posts/2018/09/docker.png 1354w, /assets/img/posts/2018/09/docker-300x268.png 300w, /assets/img/posts/2018/09/docker-1024x914.png 1024w, /assets/img/posts/2018/09/docker-768x685.png 768w" sizes="(max-width: 300px) 100vw, 300px" /> 

## Pré-requis

Supprimer les éventuelles installations de docker et docker-compose

[code language= »bash »]

#apt-get remove docker docker-compose  
[/code]

## Installation

Lancer les commandes suivantes:

[code language= »bash »]  
\# apt-get install apt-transport-https ca-certificates  
\# curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add &#8211;  
\# add-apt-repository \  
"deb [arch=amd64] https://download.docker.com/linux/debian \  
$(lsb_release -cs) \ stable"  
[/code]

Puis lancer

[code language= »bash »]

\# apt update

\# apt install docker-ce

[/code]

### Installation de docker-compose

Lancer les commandes suivantes:

[code language= »bash »]

\# curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

\# chmod a+x /usr/local/bin/docker-compose  
[/code]

## Configuration des droits

Pour lancer docker depuis un utiliser non root, il faut lancer les commandes suivantes:

[code language= »bash »]

\# groupadd docker

\# adduser monutilisateur docker

\# usermod -aG docker monutilisateur

[/code]

Après ceci, vaut mieux redémarrer le pc &#8230;

## Configuration du démon

Voici quelques config à appliquer pour que le démon soit accessible par des outils tels que le plugin maven ou encore configurer l&rsquo;accès à un proxy

### Configuration du port

Exécuter la commande:

[code language= »bash »]

\# systemctl edit docker.service

[/code]

Entrer le code suivant:

[code language= »bash »]

[Service]

ExecStart=

ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock

[/code]

Et l&rsquo;enregistrer sous /etc/systemd/system/docker.service.d/docker.conf

### Configuration du proxy

Avec la même commande

[code language= »bash »]

\# systemctl edit docker.service

[/code]

Entrer la configuration suivante:

[code language= »bash »]

[Service]

Environment="HTTP\_PROXY=http://mon\_proxy:mon_port/"

Environment="NO_PROXY=127.0.0.1"

[/code]

### Activation des configurations

Lancer les commandes suivantes:

[code language= »bash »]

\# systemctl daemon-reload # systemctl restart docker

[/code]

## Validation

Maintenant, vous pouvez valider votre configuration avec la commande:

[code language= »bash »]

$ docker run hello-world

[/code]