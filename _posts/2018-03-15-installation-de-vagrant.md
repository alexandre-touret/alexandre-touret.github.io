---
id: 68
title: Installation de Vagrant
date: 2018-03-15T12:05:55+01:00
author: admin
layout: post


publicize_linkedin_url:
  - 'https://www.linkedin.com/updates?discuss=&scope=38123191&stype=M&topic=6380005983703355392&type=U&a=aIHA'
timeline_notification:
  - "1521111959"
publicize_twitter_user:
  - touret_alex
  - logiciels libres
tags:
  - Planet-Libre
  - vagrant
---
[Vagrant](http://vagrantup.com/) est un outil permettant de construire des environnements de travail virtualisés hébergés sur vmware, virtualbox ou encore docker. Il permet par exemple de construire et gérer une VM dans un seul et même workflow et d&rsquo;éviter les exports et partages de machines virtuelles ( tout est déclaré dans un seul et même fichier ).

<img loading="lazy" class="  wp-image-69 alignright" src="/assets/img/posts/2018/03/vagrant.png" alt="Vagrant" width="128" height="156" srcset="/assets/img/posts/2018/03/vagrant.png 999w, /assets/img/posts/2018/03/vagrant-246x300.png 246w, /assets/img/posts/2018/03/vagrant-840x1024.png 840w, /assets/img/posts/2018/03/vagrant-768x936.png 768w" sizes="(max-width: 128px) 100vw, 128px" /> 

Voici comment je l&rsquo;ai installé sur ma [debian 9](http://blog.touret.info/2018/02/10/ma-configuration-debian-9/).

## Installation

Le paquet fourni dans la distribution n&rsquo;est pas compatible avec la version de virtualbox fournie dans l[e repo virtualbox.org](https://www.virtualbox.org/wiki/Linux_Downloads). j&rsquo;ai donc installé la version disponible sur le site de [vagrant](https://www.vagrantup.com/downloads.html).

[code language= »bash »]  
\# dpkg -i vagrant\_2.0.2\_x86_64.deb  
[/code]

## Configuration

### Proxy

Si vous avez un proxy, il faut effectuer le paramétrage suivant

[code language= »bash »]  
$ export http_proxy= »http://user:password@host:port »  
$ export https_proxy= »http://user:password@host:port »  
$ vagrant plugin install vagrant-proxyconf  
$ export VAGRANT\_HTTP\_PROXY= »http://user:password@host:port »  
$ export VAGRANT\_NO\_PROXY= »127.0.0.1&Prime;  
[/code]

[code language= »bash »]  
$vagrant box add \  
precise64 https://files.hashicorp.com/precise64.box  
`$ export VAGRANT_DEFAULT_PROVIDER`=virtualbox [/code]

## Installation d&rsquo;une VM

Voici un exemple pour une VM virtualbox basée sur ubuntu

[code language= »bash »]  
$ mkdir ~/vagrant  
$ cd ~/vagrant  
$ vagrant init pristine ubuntu-budgie-17-x64  
$ vagrant up [/code]

Avec ces quelques commandes j&rsquo;obtiens un environnement ubuntu hébergé sur virtualbox sans avoir à installer et configurer la vm. Pour l&rsquo;instant je ne rentre pas trop dans les détails de la construction des images. Peut-être que je m&rsquo;y plongerai prochainement&#8230;