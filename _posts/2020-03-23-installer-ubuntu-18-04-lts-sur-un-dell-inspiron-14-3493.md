---
id: 266
title: Installer Ubuntu 18.04 LTS sur un Dell Inspiron 14-3493
date: 2020-03-23T11:06:09+01:00


header:
  teaser: /assets/images/2020/03/dell-inspiron-14-3493.jpg

timeline_notification:
  - "1584957972"
publicize_twitter_user:
  - touret_alex
tags:
  - planetlibre
  - ubuntu
---
Suite aux premières annonces de distanciation sociale ( avant que le confinement soit effectif ) j'ai acheté en catastrophe un PC portable. Les critères étaient : 8Go de RAM, un disque SSD &#8230; et la compatibilité GNU/LINUX :).  
  
N'ayant pas trop de temps pour chercher la bonne affaire ( technologique et financière ), j' ai acheté un [Dell Inspiron 14-3493](https://www.dell.com/gh/business/p/inspiron-14-3493-laptop/pd).

![dell-inspiron-14-](/assets/images/2020/03/dell-inspiron-14-3493.jpg){: .align-center}
  
Je n'ai pas pris trop de risques. Bien que livré avec Windows 10, ce modèle est [déjà certifié compatible Ubuntu](https://certification.ubuntu.com/hardware/201907-27239).  
L'installation d'[Ubuntu](https://doc.ubuntu-fr.org/Accueil) se passe très bien. C'est plié en moins de 30mn. Du coup, je ne la détaillerai pas dans cet article &#8211; si vous êtes intéressé, vous pouvez consulter [cet article](https://doc.ubuntu-fr.org/installation). Pour les pré-requis, c'est une autre paire de manches &#8230;  
  
Voilà les différentes actions que j'ai réalisé au préalable

## Redémarrer l'ordinateur et accéder au BIOS

Là, j'ai un peu galéré pour accéder au [BIOS](https://fr.wikipedia.org/wiki/BIOS_(informatique)). La seule manipulation que j'ai trouvé et de lancer le menu « Démarrage avancé » puis sélectionner « Utiliser un périphérique ».  
  
Vous pouvez donc sélectionner le disque dur. Au boot en appuyant sur la touche F12 et/ou F2, vous pouvez accéder au BIOS.

## Configuration du BIOS

Voila les paramètres que j'ai appliqué:

<p class="has-text-align-left">
  Dans le menu <code>"SATA Operation"</code>: vous devez sélectionner AHCI au lieu de RAID.<br />Dans le menu <code>"Change boot mode settings >UEFI Boot Mode"</code> , vous devez désactiver le <code>Secure Boot</code>.<br /><br />Une fois réalisé, vous pouvez redémarrer en appuyant sur la touche F2 et/ou F12. Si vous n'arrivez pas à revenir sur le BIOS pour indiquer de booter sur votre clé USB, vous obtiendrez un écran d'erreur Windows dû à la configuration AHCI. Personnellement, en redémarrant une ou deux fois, j'ai obtenu un écran de démarrage avancé qui m'a permis de sélectionner le périphérique (ma clé USB) sur lequel démarrer.<br /><br />Maintenant vous pouvez accéder à l'installeur Ubuntu et profiter 🙂
</p>

## Après l'installation

Je n'ai rien fait de particulier si ce n'est configurer le trackpad. Pour cela, j'ai [installé gnome-tweaks](https://www.omgubuntu.co.uk/2018/04/things-to-do-after-installing-ubuntu-18-04). Mis à part ça, tout fonctionne très bien!