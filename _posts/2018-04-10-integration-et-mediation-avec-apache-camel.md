---
id: 78
title: Intégration et médiation avec Apache Camel
date: 2018-04-10T15:15:05+02:00




header:
  teaser: /assets/images/2018/04/apache-camel-logo.png
og_image: /assets/images/2018/04/apache-camel-logo.png




timeline_notification:
  - "1523369709"
publicize_twitter_user:
  - touret_alex
tags:
  - camel
  - integration
  - planetlibre
---
Depuis quelques jours, je teste [Apache Camel](https://camel.apache.org/) pour la mise en œuvre  de médiations.


![camel](/assets/images/2018/04/apache-camel-logo.png){: .align-center}

[Apache Camel](https://camel.apache.org/) est un framework assez ancien. Il est similaire à [Spring Intégration](https://projects.spring.io/spring-integration/) et permet l' implémentation de [patterns d'intégration](http://www.enterpriseintegrationpatterns.com/patterns/messaging/Chapter1.html).

## Les patterns d'intégration

Qu'est-ce qu'un [pattern d'intégration](http://www.enterpriseintegrationpatterns.com/patterns/messaging/Chapter1.html) allez-vous me dire ? C'est une solution d'architecture ou plus simplement une recette de cuisine permettant d'avoir une solution toute prête à une problématique d'intégration donnée. L'ensemble de ces patterns est décrit sur [ce site](http://www.enterpriseintegrationpatterns.com/) ( ne vous attardez pas sur le look des années 90 &#8230; ).

Exemple :

![publish_subscribe](/assets/images/2018/04/publishsubscribesolution.gif){: .align-center}

Camel permet simplement de gérer l'intégration via un DSL.

### Choix d'implémentations

On peut faire pas mal de choses avec ce FRAMEWORK et de plusieurs manières. J'ai fait les choix d'implémentation suivants :

  * Tout se fera avec SPRING &#8230; et pas en XML 🙂
  * Il faut que toutes les médiations soient testables
  * J'exécute le code dans un FATJAR ( pourquoi avec springboot )

## Configuration de la route

Apache Camel définit les médiations dans des routes. Elles se définissent assez rapidement .

Les routes commencent par une instruction from et se terminent par une ou plusieurs instructions to.

Pour mon exemple, j'extrais les données d'une table et les stocke dans un fichier.

Tout se configure par des URLs. La première permet d'extraire les données via JPA/HIBERNATE. Une entité Address permet le requêtage. La seconde permet le stockage dans un fichier texte JSON.

Elles sont externalisées dans des fichiers de configuration pour faciliter les tests et accessibles via SPRING.

<script src="https://gist.github.com/alexandre-touret/470b84ac760c4f70d093753c63ec153b.js" ></script>

<script src="https://gist.github.com/alexandre-touret/470b84ac760c4f70d093753c63ec153b#file-camel-properties" ></script>

<script src="https://gist.github.com/alexandre-touret/470b84ac760c4f70d093753c63ec153b#file-routebuilder-java" ></script>

## Lancement de la route

Le lancement de la route se fait dans une méthode main() :

<script src="https://gist.github.com/alexandre-touret/40f3cfa13f5947aa922fc1f796668c59.js"></script>

## Tests

Camel fournit une API de test assez bien fournie. Elle permet notamment de mocker des endpoints existants (ex. : le fichier de sortie de mon cas de test).

Dans mon cas, j'ai décidé de remplacer la base de données que j'interroge en input par une [base HSQLDB chargée en mémoire](http://hsqldb.org/doc/guide/ch01.html#N101CA). Le fichier de sortie est, lui, remplacé dynamiquement par un [mock](https://camel.apache.org/mock.html). Pour ce faire, j'ai utilisé les « adviceWith »

<script src="https://gist.github.com/alexandre-touret/391305e01510e65703a26c46c2e233f5.js"></script>

## Pour aller plus loin

Il y a pas mal d'exemples sur le GITHUB de CAMEL. Vous pouvez également acheter [le livre « Camel In Action »](https://www.manning.com/books/camel-in-action-second-edition). Ca ne vaut pas [Effective Java](https://www.amazon.fr/dp/B00B8V09HY/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1) 🙂 , mais vu qu'il est écrit par le principal développeur, c'est une très bonne référence.

&nbsp;

&nbsp;