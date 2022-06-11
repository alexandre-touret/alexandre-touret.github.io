---
id: 155
title: Au secours! Spotify Connect ne fonctionne plus sur MoodeAudio
date: 2019-03-15T09:49:36+01:00




timeline_notification:
  - "1552639776"
publicize_linkedin_url:
  - www.linkedin.com/updates?topic=6512243228153122817
publicize_twitter_user:
  - touret_alex
tags:
  - moodeaudio
  - planetlibre
  - spotify
---
Après avoir mis à jour mon mot de passe Spotify ( oui, il faut modifier régulièrement ses mots de passe ) , j'ai eu un petit soucis sur [MoodeAudio](http://moodeaudio.org/) ( version 4.4) et notamment sur la connexion avec Spotify.

![moode](/assets/images/2019/03/moode-r44.png){: .align-center}

Après quelques recherches sur [le forum de moodeaudio](http://moodeaudio.org/forum/showthread.php?tid=765&page=2), j'ai trouvé la correction qui allait bien.

Voici comment faire :

D'abord on se connecte via SSH sur le raspberry pi

```bash
$ ssh pi@192.168.0.xx
```


Puis on lance la commande:

```bash
$ sudo mv /var/local/www/spotify_cache/credentials.json /home/pi/
$ sudo reboot
```


Normalement, [Spotify Connect](https://www.spotify.com/fr/connect/) devrait fonctionner après le redémarrage 🙂