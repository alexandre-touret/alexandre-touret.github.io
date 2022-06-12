---
id: 71
title: "Activer l' equalizer sur Debian 9"
date: 2018-03-25T13:38:27+02:00


header:
  teaser: /assets/images/2018/03/sc3a9lection_001.png
og_image: /assets/images/2018/03/sc3a9lection_001.png




timeline_notification:
  - "1521981511"
publicize_twitter_user:
  - touret_alex
tags:
  - debian
  - planetlibre
  - pulseaudio
---
Et oui, il y a un equalizer dans debian&#8230;.[Pulse Audio dispose d'un equalizer](https://www.freedesktop.org/wiki/Software/PulseAudio/). Bon ce n'est encore très user friendly, mais ça fonctionne!

## Installation de l'equalizer


```bash
apt-get install pulseaudio-equalizer  
```

## Activation

Ajouter les lignes suivantes dans le fichier /etc/pulse/default.pa

```ini
load-module module-equalizer-sink  
load-module module-dbus-protocol  
```

Relancer le démon pulseaudio

```bash
\# pulseaudio -k && pulseaudio -D  
```

A ce stade, vous devriez avoir dans le panneau de configuration la référence à l'equalizer

![camel](/assets/images/2018/03/sc3a9lection_001.png){: .align-center}

## Lancement

En ligne de commande ( je vous disais que ce n'était pas trop user-friendly), lancer la commande

```bash
$ qpaeq &  
```

On obtient cette interface:

![camel](/assets/images/2018/03/qpaeq_002.png){: .align-center}

Arrivé à ce niveau, je suis quand même un peu déçu/ Il n'y a pas une vrai intégration dans debian ( pas de lanceur pour l'equalizer ) et il n'y a pas de presets configurés ( #souvienstoiwinamp)

J'ai essayé de poster mon soucis sur IRC, mais je n'ai pas encore eu de réponse. Je pense soumettre un bug dans les prochains jours.