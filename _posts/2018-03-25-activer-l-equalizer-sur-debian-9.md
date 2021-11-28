---
id: 71
title: 'Activer l&rsquo; equalizer sur Debian 9'
date: 2018-03-25T13:38:27+02:00
author: admin
layout: post


timeline_notification:
  - "1521981511"
publicize_twitter_user:
  - touret_alex
tags:
  - debian
  - planetlibre
  - pulseaudio
---
Et oui, il y a un equalizer dans debian&#8230;.[Pulse Audio dispose d&rsquo;un equalizer](https://www.freedesktop.org/wiki/Software/PulseAudio/). Bon ce n&rsquo;est encore très user friendly, mais ça fonctionne!

## Installation de l&rsquo;equalizer

[code language= »bash »]  
#apt-get install pulseaudio-equalizer  
[/code]

## Activation

Ajouter les lignes suivantes dans le fichier /etc/pulse/default.pa

[code language= »text »]  
load-module module-equalizer-sink  
load-module module-dbus-protocol  
[/code]

Relancer le démon pulseaudio

[code language= »bash »]  
\# pulseaudio -k && pulseaudio -D  
[/code]

A ce stade, vous devriez avoir dans le panneau de configuration la référence à l&rsquo;equalizer

<img loading="lazy" class="alignnone size-full wp-image-74" src="/assets/img/posts/2018/03/sc3a9lection_001.png" alt="Sélection_001" width="431" height="177" srcset="/assets/img/posts/2018/03/sc3a9lection_001.png 431w, /assets/img/posts/2018/03/sc3a9lection_001-300x123.png 300w" sizes="(max-width: 431px) 100vw, 431px" /> 

## Lancement

En ligne de commande ( je vous disais que ce n&rsquo;était pas trop user-friendly), lancer la commande

[code language= »bash »]  
$ qpaeq &  
[/code]

On obtient cette interface:

<img loading="lazy" class="alignnone size-full wp-image-75" src="/assets/img/posts/2018/03/qpaeq_002.png" alt="qpaeq_002" width="1382" height="368" srcset="/assets/img/posts/2018/03/qpaeq_002.png 1382w, /assets/img/posts/2018/03/qpaeq_002-300x80.png 300w, /assets/img/posts/2018/03/qpaeq_002-1024x273.png 1024w, /assets/img/posts/2018/03/qpaeq_002-768x205.png 768w" sizes="(max-width: 1382px) 100vw, 1382px" /> 

Arrivé à ce niveau, je suis quand même un peu déçu/ Il n&rsquo;y a pas une vrai intégration dans debian ( pas de lanceur pour l&rsquo;equalizer ) et il n&rsquo;y a pas de presets configurés ( #souvienstoiwinamp)

J&rsquo;ai essayé de poster mon soucis sur IRC, mais je n&rsquo;ai pas encore eu de réponse. Je pense soumettre un bug dans les prochains jours.

&nbsp;