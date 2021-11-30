---
id: 278
title: Répéter avec JjazzLab tout seul dans son garage
date: 2020-04-12T14:47:48+02:00


header:
  teaser: /assets/images/2020/04/thomas-litangen-sp9hcrasmpe-unsplash.jpg

enclosure:
  - |
    https://en.wikipedia.org/wiki/File:MIDI_sample.mid?qsrc=3044
    0
    audio/midi
    
timeline_notification:
  - "1586699272"
publicize_twitter_user:
  - touret_alex
tags:
  - debian
  - musique
  - planetlibre
---
Avec les contraintes liées au confinement, les [répétitions](http://george-abitbol.fr/v/c0bce857) se font de plus en plus rares. Pour ne pas perdre la main, il y a quelques logiciels qui permettent de jouer d&rsquo;un instrument et d&rsquo; improviser tout en ayant une bande son en fond musical.

<div class="wp-block-image">
  <figure class="aligncenter size-large"><img src="/assets/images/2020/04/thomas-litangen-sp9hcrasmpe-unsplash.jpg?w=1024" alt="" class="wp-image-303" /></figure>
</div>

Il y a plusieurs logiciels payants/propriétaires sur différentes plateformes:

  * [Band in a box](https://www.bandinabox.com/bb.php?os=win&lang=fr)
  * [irealpro](https://www.apple.com/fr/mac/garageband/)
  * [Garage band](https://www.apple.com/fr/mac/garageband/)
  * [Jjazzlabs](https://www.jjazzlab.com/en/)

J&rsquo;ai découvert ce dernier récemment en naviguant sur le site [Linux Mao](http://linuxmao.org/JJazzLab). Il a l&rsquo;avantage d&rsquo;être gratuit ([le moteur est sous licence LGPL 3.0](https://github.com/jjazzboss/JJazzLab-X), pas le logiciel en tant que tel), de fonctionner sous GNU/LINUX, d&rsquo; offrir un son pas mal du tout et de permettre la configuration de la dynamique au fur et à mesure du morceau.

Je vais expliquer comment l&rsquo;installer sur [Debian](https://www.debian.org/).

## Configuration Midi

### Activation des périphériques virtuels MIDI

Créer un fichier `/etc/modules.load.d/midi.conf` avec le contenu suivant:

```java
snd-virmidi
```


Ensuite créer le fichier `/etc/modprobe.d/midi.conf` avec le contenu suivant:

```java
options snd-virmidi midi_devs=1
```


Logiquement à ce stade, lors du prochain reboot, vous aurez un périphérique virtuel MIDI activé. En attendant vous pouvez lancer la commande suivante

```java
$ sudo modprobe snd-virmidi midi_devs=1
```


### Synthétiser du MIDI

Pour faire fonctionner ce logiciel, il faut installer une banque de son ( [au format SF2](https://fr.wikipedia.org/wiki/SoundFont)) et un logiciel permettant de l&rsquo;utiliser pour synthétiser du MIDI.  
La banque de son recommandée est disponible via [ce lien](https://musical-artifacts.com/artifacts/1036). Téléchargez là et copiez la dans un répertoire accessible.

Pour le second, il vous faudra installer [fluidsynth](http://www.fluidsynth.org/). Voic les quelques commandes à lancer:

```java
$ sudo apt install fluid-synth qsynth
```


### Petite vérification&#8230;

Avant d&rsquo; aller plus loin dans la configuration de fluidsynth, vous pouvez vous assurer que tout est OK [en récupérant un fichier MIDI](https://en.wikipedia.org/wiki/File:MIDI_sample.mid?qsrc=3044) et en lançant la commande suivante:

```java
$ fluidsynth -a pulseaudio -m alsa_seq -l -i /opt/JJazzLab-2.0-Linux/JJazzLab-SoundFont.sf2  MIDI_sample.mid
```


Normalement vous devriez avoir du son.

### Configurer fluidsynth

Lancez qsynth et cliquez sur le bouton « configuration »

Vous trouverez ci-dessous la configuration que j&rsquo;ai appliqué. Elle diffère légèrement de [celle présentée dans la documentation](https://www.jjazzlab.com/en/doc/fluidsynth/).<figure class="wp-block-gallery columns-3 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><img loading="lazy" width="656" height="442" src="/assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-04-39.png?w=656" alt="" data-id="307" data-link="https://blog.touret.info/capture-de28099c3a9cran-du-2020-04-12-15-04-39/" class="wp-image-307" srcset="/assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-04-39.png 656w, /assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-04-39-300x202.png 300w" sizes="(max-width: 656px) 100vw, 656px" /></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><img loading="lazy" width="656" height="442" src="/assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-05-02.png?w=656" alt="" data-id="308" data-link="https://blog.touret.info/capture-de28099c3a9cran-du-2020-04-12-15-05-02/" class="wp-image-308" srcset="/assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-05-02.png 656w, /assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-05-02-300x202.png 300w" sizes="(max-width: 656px) 100vw, 656px" /></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><img loading="lazy" width="656" height="442" src="/assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-05-13.png?w=656" alt="" data-id="309" data-link="https://blog.touret.info/capture-de28099c3a9cran-du-2020-04-12-15-05-13/" class="wp-image-309" srcset="/assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-05-13.png 656w, /assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-05-13-300x202.png 300w" sizes="(max-width: 656px) 100vw, 656px" /></figure>
  </li>
</ul></figure> 

Pensez à redémarrer fluidsynth après application de ces nouveaux paramètres.

### Configurer aconnect

Disclaimer: La c&rsquo;est la partie la plus obscure&#8230;

<div class="wp-block-image is-style-default">
  <figure class="aligncenter size-large is-resized"><img loading="lazy" src="/assets/images/2020/04/pegi_18_annotated_2009-2010.png?w=819" alt="" class="wp-image-312" width="247" height="302" srcset="/assets/images/2020/04/pegi_18_annotated_2009-2010.png 819w, /assets/images/2020/04/pegi_18_annotated_2009-2010-246x300.png 246w, /assets/images/2020/04/pegi_18_annotated_2009-2010-768x938.png 768w" sizes="(max-width: 247px) 100vw, 247px" /></figure>
</div>

Il faut maintenant « brancher » la sortie du synthétiseur virtuel MIDI à fluidsynth pour que le son MIDI soit interprété par ce dernier à travers sa banque de son. Ce n&rsquo;est pas intuitif, je vous avais prévenu &#8230;  
Je ne vous parle pas de la pseudo interface graphique à aconnect. La ligne de console est plus parlante ( c&rsquo;est pour dire ) .

Exécutez la commande suivante:

```java
$ aconnect -lo                                            
client 14: 'Midi Through' [type=noyau]
    0 'Midi Through Port-0'
client 24: 'Virtual Raw MIDI 2-0' [type=noyau,card=2]
    0 'VirMIDI 2-0     '
client 128: 'FLUID Synth (JJLAB)' [type=utilisateur,pid=17838]
    0 'Synth input port (JJLAB:0)'
```


Dans mon cas, je vais avoir à connecter le client 24:0 au synthétiseur 128:0 grâce à la commande :

```java
$ aconnect 24:0 128:0
```


Maintenant, si on relance la commande `aconnect -lo` on obtient le résultat suivant:

```java
client 14: 'Midi Through' [type=noyau]
    0 'Midi Through Port-0'
client 24: 'Virtual Raw MIDI 2-0' [type=noyau,card=2]
    0 'VirMIDI 2-0     '
	Connexion À: 128:0
client 128: 'FLUID Synth (JJLAB)' [type=utilisateur,pid=17838]
    0 'Synth input port (JJLAB:0)'
	Connecté Depuis: 24:0
```


Attention, cette commande devra être lancée ( ainsi que fluidsynth) avant chaque démarrage de jjazzlab.

## Installation de Jjazzlab

Téléchargez les binaires sur [ce site](https://www.jjazzlab.com/en/download/), puis décompressez l&rsquo;archive dans le répertoire `/opt` par ex.

Vous devez également installer java

```java
$ sudo apt install openjdk-11-jdk
```


Ensuite, vous devez créer le fichier `~/.local/share/applications/jjazzlab.desktop` avec le contenu suivant:

```java
[Desktop Entry]
Type=Application
Name=JJazzLab
GenericName=JJazzLab
Icon=
Exec="/opt/JJazzLab-2.0-Linux/bin/jjazzlab"
Terminal=false
Categories=Audio;Music;Player;AudioVideo;
```


Maintenant vous pouvez directement démarrer JJazzlab via le menu.

## Configuration

Une fois jjazzlab démarré, vous devez aller dans le menu « Tools>Options » et sélectionnez les valeurs suivantes:<figure class="wp-block-image size-large">

<img loading="lazy" width="750" height="692" src="/assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-29-27.png?w=750" alt="" class="wp-image-316" srcset="/assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-29-27.png 750w, /assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-29-27-300x277.png 300w" sizes="(max-width: 750px) 100vw, 750px" /> </figure> 

Ouvrez un fichier example (ex. sunny ) 

Cliquez sur le menu décrit par un clavier

<div class="wp-block-image">
  <figure class="aligncenter size-large"><img loading="lazy" width="341" height="48" src="/assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-34-11.png?w=341" alt="" class="wp-image-317" srcset="/assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-34-11.png 341w, /assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-34-11-300x42.png 300w" sizes="(max-width: 341px) 100vw, 341px" /></figure>
</div>

Puis configurez comme suit:<figure class="wp-block-image size-large">

<img loading="lazy" width="828" height="591" src="/assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-35-04.png?w=828" alt="" class="wp-image-318" srcset="/assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-35-04.png 828w, /assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-35-04-300x214.png 300w, /assets/images/2020/04/capture-de28099c3a9cran-du-2020-04-12-15-35-04-768x548.png 768w" sizes="(max-width: 828px) 100vw, 828px" /> </figure> 

Maintenant vous pouvez [télécharger les standards fournis sur le site](https://www.jjazzlab.com/docs/JJazzLab-Realbook.zip) et improviser dessus 🙂