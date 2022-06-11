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
Dans la série j'équipe ma maison en [Raspberry PI](https://www.raspberrypi.org/), j'ai décidé de me doter d'une station radio connectée qui me permettrait de « moderniser » un peu ma chaîne HI-FI.

Mes besoins sont:

  * Connexion en analogique à une chaîne HI-FI
  * Jouer des MP3/FLAC stockés dans un NAS
  * Jouer des web radios (ex. FIP, TSF JAZZ)
  * Connexion SPOTIFY
  * Une interface web sympa

Après quelques recherches, j'ai donc opté pour une solution basée sur un [DAC JustBoom](https://www.justboom.co/product/justboom-dac-hat/), un Raspberry PI et la distribution [MoodeAudio](http://moodeaudio.org/).

Voici le DAC que l'on branche directement sur le port GPIO du Raspberry PI:

![dac](/assets/images/2019/03/f1228179-02.jpg){: .align-center}

L'installation et la configuration du DAC se sont très bien passées. L'installation se fait comme avec des LEGOs.

![it's alive](/assets/images/2019/03/img_20190306_234555.jpg){: .align-center}

Pour la configuration, j'ai testé dans un premier temps [Volumio](https://volumio.org/) puis [MoodeAudio](http://moodeaudio.org/). Pour  l'instant, je reste sur cette dernière. Toutes les fonctionnalités que je souhaite sont en standard. Pas besoin de plugins tiers.

Toutes les étapes d' installation et de configuration pour que le DAC soit reconnu sont décrites [ici](https://www.justboom.co/software/configure-justboom-with-moode/). Les gens de chez JustBoom ont bien documenté la configuration pour les principales distributions.

Le seul reproche que je trouve à [MoodeAudio](http://moodeaudio.org) est l'ergonomie. Sur un téléphone, ce n'est pas top. Surtout sur l'accès aux menus d'administration. J'ai du également ajouter des radios manuellement alors que dans Volumio, avec le plugin TuneIn, ça pouvait se faire automatiquement. Je me suis basé sur les informations fournies par [ce site](https://fluxradios.blogspot.com/2014/07/flux-url-tsf-jazz.html).

Quoi qu'il en soit, tout ce que je souhaitais fonctionne super bien! [Spotify Connect](https://www.spotify.com/fr/connect/), l'écoute de [TSF JAZZ](https://www.tsfjazz.com/), la lecture des morceaux de ma bibliothèque fonctionnent nickel !

 