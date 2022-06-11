---
id: 188
title: Vérifier les commit GIT avec GPG
date: 2019-08-09T16:13:21+02:00

timeline_notification:
  - "1565363602"
publicize_twitter_user:
  - touret_alex
  - logiciels libres
tags:
  - git
  - github
  - gitlab
  - gpg
  - planetlibre
---
Juste pour un pense bête, voici comment paramétrer [GIT](https://git-scm.com/) et [GITHUB](https://github.com/)/[GITLAB](https://about.gitlab.com/) pour signer les commits avec [GPG](https://gnupg.org).

![sign](/assets/images/2019/08/kelly-sikkema-c3rk5toz0qa-unsplash.jpg?w=612){: .align-center}

## Configuration GPG

Exécutez la commande suivante :

```bash
gpg --full-generate-key
Sélectionnez une clé RSA (question 1) de 4096 bits (question 2).
```

Une fois cette commande effectuée, vous pouvez récupérer votre clé GPG avec cette commande:


```bash
gpg --list-secret-keys --keyid-format LONG alexandre@....
/home/alexandre/.gnupg/pubring.kbx
----------------------------------
sec rsa4096/XXXXXXXXXX 2019-08-09 [SC]
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
uid [ ultime ] Alexandre Touret <mon.mail.github.ou.gitlab@monprovider.fr>
ssb rsa4096/XXXXXXXXXX 2019-08-09 [E]
```

Ensuite, il faut exécuter cette commande 

```bash
gpg --armor --export XXXXXXXXXX
```

## Configuration GIT

Indiquez la clé GPG à GIT
```bash
git config --local user.signingkey XXXXXXXXXXXX
```


Et indiquez que vous voulez signer tous vos commits

```bash
git config --local commit.gpgsign true
```


Si vous ne faites pas cette dernière commande, vous devrez ajouter l'option -S à chaque exécution de la commande git commit.

Exemple:
```bash
git -a -S -m "Ajout javadoc"
```


## Configuration GITHUB

Sur Github ( il y a la même chose sur gitlab), vous pouvez [dans vos paramètres](https://github.com/settings/keys) ajouter cette clé . De cette manière, vos prochains commits envoyés seront vérifiés.


En espérant que ça serve à d'autres 🙂
