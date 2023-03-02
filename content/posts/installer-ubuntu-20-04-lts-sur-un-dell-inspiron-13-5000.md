---
id: 495
title: Installer Ubuntu 20.04 LTS sur un DELL Inspiron 13 5000
date: 2021-04-02T21:45:43+02:00

featuredImage: /assets/images/2021/04/dell-inspiron-13-5301-argent-01.jpg

featuredImagePreview: /assets/images/2021/04/dell-inspiron-13-5301-argent-01.jpg

publicize_twitter_user:
  - touret_alex
timeline_notification:
  - "1617396348"
  - logiciels libres
tags:
  - dell
  - planetlibre
  - ubuntu
---
[Les confinements se suivent et se ressemblent](https://blog.touret.info/2020/03/23/installer-ubuntu-18-04-lts-sur-un-dell-inspiron-14-3493/). Me voilà à installer Ubuntu sur un nouvel ordinateur.

A l'instar de l'ancien laptop que j'ai acheté pour mon aînée, j'ai acheté un DELL pour ma deuxième fille.J'ai opté pour un DELL Inspiron 5301.


A l'instar de mon autre laptop, je j'ai pas pris de risques. J'ai opté pour un DELL qui est pleinement compatible avec Ubuntu. Oui j'aurai pu installer un ordinateur avec Ubuntu pré-installé, mais je n'ai pas eu le temps de faire un choix « serein ».


## Configuration du BIOS

Voila les paramètres que j’ai appliqué:

Dans le menu `"Storage"` puis `"SATA Operation"`: vous devez sélectionner AHCI au lieu de RAID.  
Dans le menu `"Change boot mode settings >UEFI Boot Mode"` , vous devez désactiver le `Secure Boot`.  
  
Une fois réalisé, vous pouvez redémarrer en appuyant sur la touche F12. Si vous n’arrivez pas à revenir sur le BIOS pour indiquer de booter sur votre clé USB, vous obtiendrez un écran d’erreur Windows dû à la configuration AHCI. Personnellement, en redémarrant une ou deux fois, j’ai obtenu un écran de démarrage avancé qui m’a permis de sélectionner le périphérique (ma clé USB) sur lequel démarrer.  
  
Maintenant vous pouvez accéder à l’installeur Ubuntu et profiter.

## Installation

J'ai eu plusieurs fois des popup « erreur rencontré ». Ce n'était pas bloquant. J'ai continué.

Tout s'est déroulé sans encombre. [Le matériel est très bien reconnu](https://certification.ubuntu.com/hardware/202007-28039).  
  
Les seuls logiciels que j'ai installé sont pour l'instant : VLC, Minecraft ( obligatoire dans la famille ) et Chromium.