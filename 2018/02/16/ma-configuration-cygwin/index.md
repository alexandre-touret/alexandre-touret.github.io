# Ma configuration CYGWIN

Dans la série, [j'essaye de sauvegarder toutes mes configurations](http://blog.touret.info/2018/02/10/ma-configuration-debian-9/), voici ce que j'ai fait pour configurer correctement [cygwin](https://cygwin.com/).

Pour ceux qui ne connaissent pas ou qui n'ont pas la chance d'utiliser windows au travail, [cygwin](https://cygwin.com/) est un shell avec tous les outils GNU.

En attendant [d'avoir windows 10 ( au travail ) et un BASH intégré](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/), il n'y a pas mieux. Du moins à mon humble avis.

## GIT

### Complétion

On a besoin des fichiers suivants

  * [git-completion.bash](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash)
  * [git-prompt.sh](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh)

Je les ai téléchargé et placé dans le répertoire $HOME.

### Activation de la configuration et affichage de la branche en cours dans le prompt

J'ai activé la configuration git en exécutant les scripts précédemment téléchargés.

Voici la personnalisation que j'ai paramétré dans la variable d'environnement PS1:

<script src="https://gist.github.com/alexandre-touret/d4b570813bb1b7bb44a393e69660827e.js"></script>

J' ai également activé des propriétés qui étaient en commentaire dans ce fichier. Je ne les ai pas listée pour ne pas trop surcharger l'article 🙂

### Configuration Nom et sécurité

<script src="https://gist.github.com/alexandre-touret/4ef7484bc00bf607e3c8e28c1d53afba.js"></script>

## VIM

Que serait un prompt sans vim ?

J'ai installé une suite de plugin : [The ultimate vimrc](https://github.com/amix/vimrc). Il faut cloner le repo GIT et lancer un script

```bash
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
``` 

