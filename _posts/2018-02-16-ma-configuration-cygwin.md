---
id: 56
title: Ma configuration CYGWIN
date: 2018-02-16T09:42:24+01:00
author: admin
layout: post


publicize_linkedin_url:
  - 'https://www.linkedin.com/updates?discuss=&scope=38123191&stype=M&topic=6370185391068246016&type=U&a=3o8p'
timeline_notification:
  - "1518770547"
publicize_twitter_user:
  - littlewing1112
tags:
  - cygwin
  - git
  - gnu/linux
  - Planet-Libre
---
Dans la série, [j&rsquo;essaye de sauvegarder toutes mes configurations](http://blog.touret.info/2018/02/10/ma-configuration-debian-9/), voici ce que j&rsquo;ai fait pour configurer correctement [cygwin](https://cygwin.com/).

Pour ceux qui ne connaissent pas ou qui n&rsquo;ont pas la chance d&rsquo;utiliser windows au travail, [cygwin](https://cygwin.com/) est un shell avec tous les outils GNU.

En attendant [d&rsquo;avoir windows 10 ( au travail ) et un BASH intégré](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/), il n&rsquo;y a pas mieux. Du moins à mon humble avis.<img loading="lazy" class="  wp-image-60 alignright" src="/assets/img/posts/2018/02/2000px-cygwin_logo-svg.png" alt="2000px-Cygwin_logo.svg.png" width="105" height="105" srcset="/assets/img/posts/2018/02/2000px-cygwin_logo-svg.png 2000w, /assets/img/posts/2018/02/2000px-cygwin_logo-svg-300x300.png 300w, /assets/img/posts/2018/02/2000px-cygwin_logo-svg-1024x1024.png 1024w, /assets/img/posts/2018/02/2000px-cygwin_logo-svg-150x150.png 150w, /assets/img/posts/2018/02/2000px-cygwin_logo-svg-768x768.png 768w, /assets/img/posts/2018/02/2000px-cygwin_logo-svg-1536x1536.png 1536w, /assets/img/posts/2018/02/2000px-cygwin_logo-svg-1568x1568.png 1568w" sizes="(max-width: 105px) 100vw, 105px" />

## GIT

### Complétion

On a besoin des fichiers suivants

  * [git-completion.bash](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash)
  * [git-prompt.sh](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh)

Je les ai téléchargé et placé dans le répertoire $HOME.

### Activation de la configuration et affichage de la branche en cours dans le prompt

J&rsquo;ai activé la configuration git en exécutant les scripts précédemment téléchargés.

Voici la personnalisation que j&rsquo;ai paramétré dans la variable d&rsquo;environnement PS1

https://gist.github.com/littlewing/d4b570813bb1b7bb44a393e69660827e

J&rsquo;ai également activé des propriétés qui étaient en commentaire dans ce fichier. Je ne les ai pas listée pour ne pas trop surcharger l&rsquo;article 🙂

### Configuration Nom et sécurité

https://gist.github.com/littlewing/4ef7484bc00bf607e3c8e28c1d53afba

## VIM

Que serait un prompt sans vim ?

J&rsquo;ai installé une suite de plugin : [The ultimate vimrc](https://github.com/amix/vimrc). Il faut cloner le repo GIT et lancer un script

    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh

&nbsp;

&nbsp;

&nbsp;

&nbsp;