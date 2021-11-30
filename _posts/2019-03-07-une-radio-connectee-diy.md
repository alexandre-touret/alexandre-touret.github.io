---
id: 136
title: Une radio connectée DIY
date: 2019-03-07T08:30:44+01:00




timeline_notification:
  - "1551943845"
publicize_linkedin_url:
  - www.linkedin.com/updates?topic=6509324277303644160
publicize_twitter_user:
  - touret_alex
tags:
  - planetlibre
  - raspberry-pi
---
Dans la série j&rsquo;équipe ma maison en [Raspberry PI](https://www.raspberrypi.org/), j&rsquo;ai décidé de me doter d&rsquo;une station radio connectée qui me permettrait de « moderniser » un peu ma chaîne HI-FI.

Mes besoins sont:

  * Connexion en analogique à une chaîne HI-FI
  * Jouer des MP3/FLAC stockés dans un NAS
  * Jouer des web radios (ex. FIP, TSF JAZZ)
  * Connexion SPOTIFY
  * Une interface web sympa

Après quelques recherches, j&rsquo;ai donc opté pour une solution basée sur un [DAC JustBoom](https://www.justboom.co/product/justboom-dac-hat/), un Raspberry PI et la distribution [MoodeAudio](http://moodeaudio.org/).

Voici le DAC que l&rsquo;on branche directement sur le port GPIO du Raspberry PI:

<img loading="lazy" class="size-medium wp-image-156 aligncenter" src="/assets/images/2019/03/f1228179-02.jpg?w=292" alt="" width="292" height="300" srcset="/assets/images/2019/03/f1228179-02.jpg 432w, /assets/images/2019/03/f1228179-02-292x300.jpg 292w" sizes="(max-width: 292px) 100vw, 292px" /> 

 

L&rsquo;installation et la configuration du DAC se sont très bien passées. L&rsquo;installation se fait comme avec des LEGOs.<figure id="attachment_159" aria-describedby="caption-attachment-159" style="width: 300px" class="wp-caption aligncenter">

<img loading="lazy" class="size-medium wp-image-159" src="/assets/images/2019/03/img_20190306_234555.jpg?w=300" alt="" width="300" height="224" /> <figcaption id="caption-attachment-159" class="wp-caption-text">Que la lumière soit</figcaption></figure> 

 

Pour la configuration, j&rsquo;ai testé dans un premier temps [Volumio](https://volumio.org/) puis [MoodeAudio](http://moodeaudio.org/). Pour  l&rsquo;instant, je reste sur cette dernière. Toutes les fonctionnalités que je souhaite sont en standard. Pas besoin de plugins tiers.

Toutes les étapes d&rsquo; installation et de configuration pour que le DAC soit reconnu sont décrites [ici](https://www.justboom.co/software/configure-justboom-with-moode/). Les gens de chez JustBoom ont bien documenté la configuration pour les principales distributions.

Le seul reproche que je trouve à [MoodeAudio](http://moodeaudio.org) est l&rsquo;ergonomie. Sur un téléphone, ce n&rsquo;est pas top. Surtout sur l&rsquo;accès aux menus d&rsquo;administration. J&rsquo;ai du également ajouter des radios manuellement alors que dans Volumio, avec le plugin TuneIn, ça pouvait se faire automatiquement. Je me suis basé sur les informations fournies par [ce site](https://fluxradios.blogspot.com/2014/07/flux-url-tsf-jazz.html).

Quoi qu&rsquo;il en soit, tout ce que je souhaitais fonctionne super bien! [Spotify Connect](https://www.spotify.com/fr/connect/), l&rsquo;écoute de [TSF JAZZ](https://www.tsfjazz.com/), la lecture des morceaux de ma bibliothèque fonctionnent nickel !

 