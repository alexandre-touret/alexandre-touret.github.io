---
id: 195
title: Mocker des méthodes « final » avec Mockito
date: 2019-08-16T08:26:57+02:00




featuredImagePreview: /assets/images/2019/08/logo-mockito.png
featuredImage: /assets/images/2019/08/logo-mockito.png
images: ["/assets/images/2019/08/logo-mockito.png"]


timeline_notification:
  - "1565940418"
publicize_twitter_user:
  - touret_alex
tags:
  - java
  - mockito
  - planetlibre
  - tests-unitaires
---
Auparavant, dans nos tests, quand on voulait [mocker](https://fr.wikipedia.org/wiki/Mock_(programmation_orient%C3%A9e_objet)) des [méthodes « final »](https://fr.wikipedia.org/wiki/Final_(Java)) ou [statiques](https://stackoverflow.com/questions/2671496/java-when-to-use-static-methods), on devait passer par [PowerMock](https://github.com/powermock/powermock).

Depuis peu, si on utilise Mockito ( >2.1) , on n'a plus besoin d'ajouter PowerMock pour mocker des méthodes « final ».

Bon il reste toujours la gestion des méthodes statiques à gérer autrement qu'avec [Mockito](https://github.com/mockito/mockito), mais cela va dans le bon sens.

Voici comment activer en quelques commandes le mocking des méthodes « final ».

Dans le répertoire src/test/resources, il faut créer un répertoire mockito-extensions avec un fichier nommé org.mockito.plugins.MockMaker.

```bash
src/test/resources
└── mockito-extensions
└── org.mockito.plugins.MockMaker
```


A l'intérieur de ce fichier, vous devrez ajouter le contenu suivant :
```bash
mock-maker-inline
```


Avec cette configuration, vous pourrez dorénavant mocker des méthodes « final » 🙂

Enjoy