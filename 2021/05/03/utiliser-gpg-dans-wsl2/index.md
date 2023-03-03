# Utiliser GPG dans WSL2


![pexel photo](/assets/images/2021/05/pexels-photo-261621.jpeg)

Pourquoi utiliser [GPG](https://fr.wikipedia.org/wiki/GNU_Privacy_Guard) ? Par exemple [pour signer les commits GIT](https://blog.touret.info/2019/08/09/verifier-les-commit-git-avec-gpg/). Maintenant comment faire quand on est sous Windows 10 et qu'on souhaite utiliser [le sous système Linux (WSL2)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)?


Sous GNU/Linux, l'installation et l'utilisation avec git est très simple. Avec [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10),&#8230; il faut un peu d'huile de coude 🙂

Je vais tâcher de décrire dans cet article les différentes manipulations nécessaires pour:

  * Importer une clé GPG existante
  * Utiliser GPG pour signer mes commits dans WSL2

## Importer une clé GPG existante

### Export de la clé GPG

#### Identifier l' ID de la clé

Lancez la commande suivante:

```bash
gpg --export ${ID} > public.key
gpg --export-secret-key ${ID} > private.key
```


### Import

```bash
gpg --import public.key
gpg --import private.key
```


### Vérification

Pour vérifier que la clé est bien configurée, vous pouvez lancer la commande suivante:

```bash
gpg --list-secret-keys --keyid-format LONG   alexandre@....
sec   rsa4096/CLE_ID 2019-12-20 [SC]
      ********************
uid                [  ultime ] Alexandre <alexandre@....>
ssb   rsa4096/SUB 2019-12-20 [E]

```


Si la clé n'est pas reconnue comme ultime ou comme de confiance, il faudra l'éditer:

```bash
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

Avant de configurer l'agent GPG, vous pouvez vous référer [à cet article](https://blog.touret.info/2019/08/09/verifier-les-commit-git-avec-gpg/) pour configurer GIT et GPG. La configuration est équivalente.

Ensuite, créez le fichier `~/.gnupg/gpg.conf` avec le contenu suivant:

```conf
# Uncomment within config (or add this line)
# This tells gpg to use the gpg-agent
use-agent
# Set the default key
default-key CLE_ID
```


Puis créez le fichier `~/.gnupg/gpg-agent.conf` avec le contenu ci-dessous:

```conf
default-cache-ttl 34560000
max-cache-ttl 34560000
pinentry-program /usr/bin/pinentry-curses
```


Le cache ici est défini en secondes. Il est mis ici à 400 jours.

Ce dernier fichier fait référence au programme `pinentry`. Vous pouvez vérifier sa présence grâce à la commande:

```bash
ls /usr/bin/pinentry-curses 
```


Si vous ne l'avez pas, vous pouvez l'installer grâce à la commande suivante:

```bash
sudo apt install pinentry-curses
```


Maintenant, on peut configurer l'environnement BASH en modifiant le fichier `~/.bashrc`

```bash
# enable GPG signing
export GPG_TTY=$(tty)
if [ ! -f ~/.gnupg/S.gpg-agent ]; then
    eval $( gpg-agent --daemon --options ~/.gnupg/gpg-agent.conf )
fi
export GPG_AGENT_INFO=${HOME}/.gnupg/S.gpg-agent:0:1
```


Redémarrez ensuite WSL2 pour que ça soit pris en compte. 

A la première utilisation de GPG ( par ex. lors d'un commit, vous aurez une interface [Ncurses](https://fr.wikipedia.org/wiki/Ncurses) qui apparaîtra dans votre prompt WSL2. Vous aurez à renseigner le mot de passe de votre clé.
