---
title: Gérer plusieurs clés et plusieurs repo GIT
date: 2018-11-16T13:39:04+01:00

tags:
  - git
  - planetlibre
---
En attendant d'avoir plus d'imagination, voici un rapide tuto pour gérer plusieurs référentiels GIT avec des clés SSH différentes.

Imaginons que vous deviez vous connecter sur différents serveurs GIT (ex. github et gitlab) avec des emails différents et donc des clés RSA différentes ( oui je sais ce cas n'arrive pas souvent ). Le tout sous Windows et GNU/LINUX. Sous GNU/LINUX ont peut le gérer différemment via la commande ssh-add.

Pour pouvoir gérer ceci de manière simple, j'ai fait la manipulation suivante :

Dans le répertoire ``~/.ssh``, j'ai crée les différentes clés avec [la doc fournie par GITHUB](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/). Puis, j'ai crée le fichier ``~/.ssh/config`` avec le contenu suivant:


```
Host monhost1.fr
HostName monhost1.fr
User git
IdentityFile ~/.ssh/id_rsa

Host monhost2.fr
HostName monhost2.fr
User git
IdentityFile ~/.ssh/nouvellecle_rsa
```


Et voilà !

Après avoir fait les différentes configurations coté serveur (c.-a-d. ajout des clés publiques), je peux interagir avec les différents serveurs (pull, push).

En espérant que ça puisse servir à d'autres.
