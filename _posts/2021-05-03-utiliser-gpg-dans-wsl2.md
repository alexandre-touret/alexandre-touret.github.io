---
id: 505
title: Utiliser GPG dans WSL2
date: 2021-05-03T20:47:11+02:00

header:
  teaser: /assets/images/2021/05/pexels-photo-261621.jpeg

timeline_notification:
  - "1620067634"
publicize_twitter_user:
  - touret_alex
publicize_linkedin_url:
  - ""
  - logiciels libres
tags:
  - git
  - gpg
  - planetlibre
  - wsl2
---
<div class="wp-block-image">
  <figure class="aligncenter size-large is-resized"><img loading="lazy" src="/assets/images/2021/05/pexels-photo-261621.jpeg?w=1024" alt="" class="wp-image-511" width="641" height="480" srcset="/assets/images/2021/05/pexels-photo-261621.jpeg 1733w, /assets/images/2021/05/pexels-photo-261621-300x225.jpeg 300w, /assets/images/2021/05/pexels-photo-261621-1024x768.jpeg 1024w, /assets/images/2021/05/pexels-photo-261621-768x576.jpeg 768w, /assets/images/2021/05/pexels-photo-261621-1536x1152.jpeg 1536w, /assets/images/2021/05/pexels-photo-261621-1568x1176.jpeg 1568w" sizes="(max-width: 641px) 100vw, 641px" /><figcaption>Photo by Pixabay on <a href="https://www.pexels.com/photo/agreement-blur-business-close-up-261621/" rel="nofollow">Pexels.com</a></figcaption></figure>
</div>

<p class="has-drop-cap">
  Pourquoi utiliser <a href="https://fr.wikipedia.org/wiki/GNU_Privacy_Guard">GPG</a> ? Par exemple <a href="https://blog.touret.info/2019/08/09/verifier-les-commit-git-avec-gpg/">pour signer les commits GIT</a>. Maintenant comment faire quand on est sous Windows 10 et qu&rsquo;on souhaite utiliser <a href="https://docs.microsoft.com/en-us/windows/wsl/install-win10">le sous système Linux (WSL2)</a>?
</p>

Sous GNU/Linux, l&rsquo;installation et l&rsquo;utilisation avec git est très simple. Avec [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10),&#8230; il faut un peu d&rsquo;huile de coude 🙂

Je vais tâcher de décrire dans cet article les différentes manipulations nécessaires pour:

  * Importer une clé GPG existante
  * Utiliser GPG pour signer mes commits dans WSL2

## Importer une clé GPG existante

### Export de la clé GPG

#### Identifier l&rsquo; ID de la clé

Lancez la commande suivante:

```java
gpg --export ${ID} > public.key
gpg --export-secret-key ${ID} > private.key
```


### Import

```java
gpg --import public.key
gpg --import private.key
```


### Vérification

Pour vérifier que la clé est bien configurée, vous pouvez lancer la commande suivante:

```java
gpg --list-secret-keys --keyid-format LONG   alexandre@....
sec   rsa4096/CLE_ID 2019-12-20 [SC]
      ********************
uid                [  ultime ] Alexandre <alexandre@....>
ssb   rsa4096/SUB 2019-12-20 [E]

```


Si la clé n&rsquo;est pas reconnue comme ultime ou comme de confiance, il faudra l&rsquo;éditer:

```java
gpg --edit-key CLE_ID
Please decide how far you trust this user to correctly verify other users' keys
(by looking at passports, checking fingerprints from different sources, etc.)
  1 = I don't know or won't say
  2 = I do NOT trust
  3 = I trust marginally
  4 = I trust fully
  5 = I trust ultimately
  m = back to the main menu
Your decision? 
```


Si vous ne voulez pas trop vous compliquer, je vous conseille de répondre `5`.

## Configuration GPG pour WSL2

Avant de configurer l&rsquo;agent GPG, vous pouvez vous référer [à cet article](https://blog.touret.info/2019/08/09/verifier-les-commit-git-avec-gpg/) pour configurer GIT et GPG. La configuration est équivalente.

Ensuite, créez le fichier `~/.gnupg/gpg.conf` avec le contenu suivant:

```java
# Uncomment within config (or add this line)
# This tells gpg to use the gpg-agent
use-agent
# Set the default key
default-key CLE_ID
```


Puis créez le fichier `~/.gnupg/gpg-agent.conf` avec le contenu ci-dessous:

```java
default-cache-ttl 34560000
max-cache-ttl 34560000
pinentry-program /usr/bin/pinentry-curses
```


Le cache ici est défini en secondes. Il est mis ici à 400 jours.

Ce dernier fichier fait référence au programme `pinentry`. Vous pouvez vérifier sa présence grâce à la commande:

```java
ls /usr/bin/pinentry-curses 
```


Si vous ne l&rsquo;avez pas, vous pouvez l&rsquo;installer grâce à la commande suivante:

```java
sudo apt install pinentry-curses
```


Maintenant, on peut configurer l&rsquo;environnement BASH en modifiant le fichier `~/.bashrc`

```java
# enable GPG signing
export GPG_TTY=$(tty)
if [ ! -f ~/.gnupg/S.gpg-agent ]; then
    eval $( gpg-agent --daemon --options ~/.gnupg/gpg-agent.conf )
fi
export GPG_AGENT_INFO=${HOME}/.gnupg/S.gpg-agent:0:1
```


Redémarrez ensuite WSL2 pour que ça soit pris en compte. 

A la première utilisation de GPG ( par ex. lors d&rsquo;un commit, vous aurez une interface [Ncurses](https://fr.wikipedia.org/wiki/Ncurses) qui apparaîtra dans votre prompt WSL2. Vous aurez à renseigner le mot de passe de votre clé.