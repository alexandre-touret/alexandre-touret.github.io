---
id: 495
title: Installer Ubuntu 20.04 LTS sur un DELL Inspiron 13 5000
date: 2021-04-02T21:45:43+02:00


header:
  teaser: /assets/images/2021/04/dell-inspiron-13-5301-argent-01.jpg

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
<p class="has-drop-cap">
  <a href="https://blog.touret.info/2020/03/23/installer-ubuntu-18-04-lts-sur-un-dell-inspiron-14-3493/">Les confinements se suivent et se ressemblent</a>. Me voilà à installer Ubuntu sur un nouvel ordinateur.<br />A l&rsquo;instar de l&rsquo;ancien laptop que j&rsquo;ai acheté pour mon aînée, j&rsquo;ai acheté un DELL pour ma deuxième fille.<br />J&rsquo;ai opté pour un DELL Inspiron 5301.
</p>

  


<div class="wp-block-image">
  <figure class="aligncenter size-large is-resized"><img loading="lazy" src="/assets/images/2021/04/dell-inspiron-13-5301-argent-01.jpg?w=1024" alt="" class="wp-image-499" width="511" height="383" srcset="/assets/images/2021/04/dell-inspiron-13-5301-argent-01.jpg 2000w, /assets/images/2021/04/dell-inspiron-13-5301-argent-01-300x225.jpg 300w, /assets/images/2021/04/dell-inspiron-13-5301-argent-01-1024x768.jpg 1024w, /assets/images/2021/04/dell-inspiron-13-5301-argent-01-768x576.jpg 768w, /assets/images/2021/04/dell-inspiron-13-5301-argent-01-1536x1152.jpg 1536w, /assets/images/2021/04/dell-inspiron-13-5301-argent-01-1568x1176.jpg 1568w" sizes="(max-width: 511px) 100vw, 511px" /></figure>
</div>

A l&rsquo;instar de mon autre laptop, je j&rsquo;ai pas pris de risques. J&rsquo;ai opté pour un DELL qui est pleinement compatible avec Ubuntu. Oui j&rsquo;aurai pu installer un ordinateur avec Ubuntu pré-installé, mais je n&rsquo;ai pas eu le temps de faire un choix « serein ».

<p class="has-text-align-center">
  <br />
</p>

## Configuration du BIOS

Voila les paramètres que j’ai appliqué:

Dans le menu `"Storage"` puis `"SATA Operation"`: vous devez sélectionner AHCI au lieu de RAID.  
Dans le menu `"Change boot mode settings >UEFI Boot Mode"` , vous devez désactiver le `Secure Boot`.  
  
Une fois réalisé, vous pouvez redémarrer en appuyant sur la touche F12. Si vous n’arrivez pas à revenir sur le BIOS pour indiquer de booter sur votre clé USB, vous obtiendrez un écran d’erreur Windows dû à la configuration AHCI. Personnellement, en redémarrant une ou deux fois, j’ai obtenu un écran de démarrage avancé qui m’a permis de sélectionner le périphérique (ma clé USB) sur lequel démarrer.  
  
Maintenant vous pouvez accéder à l’installeur Ubuntu et profiter.

## Installation

J&rsquo;ai eu plusieurs fois des popup « erreur rencontré ». Ce n&rsquo;était pas bloquant. J&rsquo;ai continué.

Tout s&rsquo;est déroulé sans encombre. [Le matériel est très bien reconnu](https://certification.ubuntu.com/hardware/202007-28039).  
  
Les seuls logiciels que j&rsquo;ai installé sont pour l&rsquo;instant : VLC, Minecraft ( obligatoire dans la famille ) et Chromium.