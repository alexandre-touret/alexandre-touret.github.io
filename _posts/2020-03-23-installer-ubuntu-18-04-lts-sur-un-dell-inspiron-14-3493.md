---
id: 266
title: Installer Ubuntu 18.04 LTS sur un Dell Inspiron 14-3493
date: 2020-03-23T11:06:09+01:00
author: admin
layout: post


timeline_notification:
  - "1584957972"
publicize_twitter_user:
  - touret_alex
categories:
  - gnu/linux
tags:
  - Planet-Libre
  - ubuntu
---
Suite aux premières annonces de distanciation sociale ( avant que le confinement soit effectif ) j&rsquo;ai acheté en catastrophe un PC portable. Les critères étaient : 8Go de RAM, un disque SSD &#8230; et la compatibilité GNU/LINUX :).  
  
N&rsquo;ayant pas trop de temps pour chercher la bonne affaire ( technologique et financière ), j&rsquo; ai acheté un [Dell Inspiron 14-3493](https://www.dell.com/gh/business/p/inspiron-14-3493-laptop/pd).

<div class="wp-block-image">
  <figure class="aligncenter size-large is-resized"><img loading="lazy" src="/assets/img/posts/2020/03/dell-inspiron-14-3493.jpg?w=510" alt="" class="wp-image-279" width="576" height="401" srcset="/assets/img/posts/2020/03/dell-inspiron-14-3493.jpg 510w, /assets/img/posts/2020/03/dell-inspiron-14-3493-300x209.jpg 300w" sizes="(max-width: 576px) 100vw, 576px" /></figure>
</div>

  
  
Je n&rsquo;ai pas pris trop de risques. Bien que livré avec Windows 10, ce modèle est [déjà certifié compatible Ubuntu](https://certification.ubuntu.com/hardware/201907-27239).  
L&rsquo;installation d&rsquo;[Ubuntu](https://doc.ubuntu-fr.org/Accueil) se passe très bien. C&rsquo;est plié en moins de 30mn. Du coup, je ne la détaillerai pas dans cet article &#8211; si vous êtes intéressé, vous pouvez consulter [cet article](https://doc.ubuntu-fr.org/installation). Pour les pré-requis, c&rsquo;est une autre paire de manches &#8230;  
  
Voilà les différentes actions que j&rsquo;ai réalisé au préalable

## Redémarrer l&rsquo;ordinateur et accéder au BIOS

Là, j&rsquo;ai un peu galéré pour accéder au [BIOS](https://fr.wikipedia.org/wiki/BIOS_(informatique)). La seule manipulation que j&rsquo;ai trouvé et de lancer le menu « Démarrage avancé » puis sélectionner « Utiliser un périphérique ».  
  
Vous pouvez donc sélectionner le disque dur. Au boot en appuyant sur la touche F12 et/ou F2, vous pouvez accéder au BIOS.

## Configuration du BIOS

Voila les paramètres que j&rsquo;ai appliqué:

<p class="has-text-align-left">
  Dans le menu <code>"SATA Operation"</code>: vous devez sélectionner AHCI au lieu de RAID.<br />Dans le menu <code>"Change boot mode settings &gt;UEFI Boot Mode"</code> , vous devez désactiver le <code>Secure Boot</code>.<br /><br />Une fois réalisé, vous pouvez redémarrer en appuyant sur la touche F2 et/ou F12. Si vous n&rsquo;arrivez pas à revenir sur le BIOS pour indiquer de booter sur votre clé USB, vous obtiendrez un écran d&rsquo;erreur Windows dû à la configuration AHCI. Personnellement, en redémarrant une ou deux fois, j&rsquo;ai obtenu un écran de démarrage avancé qui m&rsquo;a permis de sélectionner le périphérique (ma clé USB) sur lequel démarrer.<br /><br />Maintenant vous pouvez accéder à l&rsquo;installeur Ubuntu et profiter 🙂
</p>

## Après l&rsquo;installation

Je n&rsquo;ai rien fait de particulier si ce n&rsquo;est configurer le trackpad. Pour cela, j&rsquo;ai [installé gnome-tweaks](https://www.omgubuntu.co.uk/2018/04/things-to-do-after-installing-ubuntu-18-04). Mis à part ça, tout fonctionne très bien!