---
id: 78
title: Intégration et médiation avec Apache Camel
date: 2018-04-10T15:15:05+02:00
author: admin
layout: post


timeline_notification:
  - "1523369709"
publicize_twitter_user:
  - touret_alex
tags:
  - camel
  - integration
  - Planet-Libre
---
Depuis quelques jours, je teste [Apache Camel](https://camel.apache.org/) pour la mise en œuvre  de médiations.

<img loading="lazy" class=" size-full wp-image-80 aligncenter" src="/assets/img/posts/2018/04/apache-camel-logo.png" alt="Apache-camel-logo" width="349" height="171" srcset="/assets/img/posts/2018/04/apache-camel-logo.png 349w, /assets/img/posts/2018/04/apache-camel-logo-300x147.png 300w" sizes="(max-width: 349px) 100vw, 349px" /> 

[Apache Camel](https://camel.apache.org/) est un framework assez ancien. Il est similaire à [Spring Intégration](https://projects.spring.io/spring-integration/) et permet l&rsquo; implémentation de [patterns d&rsquo;intégration](http://www.enterpriseintegrationpatterns.com/patterns/messaging/Chapter1.html).

## Les patterns d&rsquo;intégration

Qu&rsquo;est-ce qu&rsquo;un [pattern d&rsquo;intégration](http://www.enterpriseintegrationpatterns.com/patterns/messaging/Chapter1.html) allez-vous me dire ? C&rsquo;est une solution d&rsquo;architecture ou plus simplement une recette de cuisine permettant d&rsquo;avoir une solution toute prête à une problématique d&rsquo;intégration donnée. L&rsquo;ensemble de ces patterns est décrit sur [ce site](http://www.enterpriseintegrationpatterns.com/) ( ne vous attardez pas sur le look des années 90 &#8230; ).

Exemple :

<img loading="lazy" class="alignnone size-full wp-image-79" src="/assets/img/posts/2018/04/publishsubscribesolution.gif" alt="PublishSubscribeSolution" width="504" height="330" /> 

&nbsp;

Camel permet simplement de gérer l&rsquo;intégration via un DSL.

### Choix d&rsquo;implémentations

On peut faire pas mal de choses avec ce FRAMEWORK et de plusieurs manières. J&rsquo;ai fait les choix d&rsquo;implémentation suivants :

  * Tout se fera avec SPRING &#8230; et pas en XML 🙂
  * Il faut que toutes les médiations soient testables
  * J&rsquo;exécute le code dans un FATJAR ( pourquoi avec springboot )

## Configuration de la route

Apache Camel définit les médiations dans des routes. Elles se définissent assez rapidement .

Les routes commencent par une instruction from et se terminent par une ou plusieurs instructions to.

Pour mon exemple, j&rsquo;extrais les données d&rsquo;une table et les stocke dans un fichier.

Tout se configure par des URLs. La première permet d&rsquo;extraire les données via JPA/HIBERNATE. Une entité Address permet le requêtage. La seconde permet le stockage dans un fichier texte JSON.

Elles sont externalisées dans des fichiers de configuration pour faciliter les tests et accessibles via SPRING.

https://gist.github.com/littlewing/470b84ac760c4f70d093753c63ec153b

https://gist.github.com/littlewing/470b84ac760c4f70d093753c63ec153b#file-camel-properties

https://gist.github.com/littlewing/470b84ac760c4f70d093753c63ec153b#file-routebuilder-java

## Lancement de la route

Le lancement de la route se fait dans une méthode main() :

https://gist.github.com/littlewing/40f3cfa13f5947aa922fc1f796668c59

## Tests

Camel fournit une API de test assez bien fournie. Elle permet notamment de mocker des endpoints existants (ex. : le fichier de sortie de mon cas de test).

Dans mon cas, j&rsquo;ai décidé de remplacer la base de données que j&rsquo;interroge en input par une [base HSQLDB chargée en mémoire](http://hsqldb.org/doc/guide/ch01.html#N101CA). Le fichier de sortie est, lui, remplacé dynamiquement par un [mock](https://camel.apache.org/mock.html). Pour ce faire, j&rsquo;ai utilisé les « adviceWith »

https://gist.github.com/littlewing/391305e01510e65703a26c46c2e233f5

## Pour aller plus loin

Il y a pas mal d&rsquo;exemples sur le GITHUB de CAMEL. Vous pouvez également acheter [le livre « Camel In Action »](https://www.manning.com/books/camel-in-action-second-edition). Ca ne vaut pas [Effective Java](https://www.amazon.fr/dp/B00B8V09HY/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1) 🙂 , mais vu qu&rsquo;il est écrit par le principal développeur, c&rsquo;est une très bonne référence.

&nbsp;

&nbsp;