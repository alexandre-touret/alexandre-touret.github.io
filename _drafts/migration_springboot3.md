---
title: Migrer son application Spring Boot vers la version 3
date: 2022-12-26 08:00:00

header:
teaser: /assets/images/2022/08/maksym-tymchyk-vHO-yT1BDWk-unsplash.webp
og_image: /assets/images/2022/08/maksym-tymchyk-vHO-yT1BDWk-unsplash.webp

tags:
- spring
- java

---

Je suis actuellement en cours de préparation d'un workshop pour [l'édition 2023 de SnowcampIO](https://snowcamp.io/fr/).
J'aborderai dans ce dernier le versioning des APIs REST.
Pour illustrer ce sujet ô combien épineux, j'ai réalisé une plateforme "microservices" en utilisant différents composants de la [stack Spring](https://spring.io/).


| Container | Tools                                                        | Comments |
|---|--------------------------------------------------------------|---|
| API Gateway | Spring Cloud Gateway 2022.0.0-RC2                                |  |
| Bookstore API | JAVA 17,Spring Boot 3.0.X                                    |  |
| ISBN API | JAVA 17,Spring Boot 3.0.X                                    |  |
| Configuration Server | Spring Cloud Config 2022.0.0-RC2                                |  |
| Database | PostgreSQL                                                   |  |
| Authorization Server | JAVA 17,Spring Boot 3.0.X, Spring Authorization Server 1.0.0 |  |


En résumé, j'utilise Spring Boot, Cloud, Security, Authorization Server, Circuit Breaker, Spring Data,...

J'ai démarré le développement avant l'annonce officielle de la version 3.0 de Spring Boot.
Ce n'était pas réellement obligatoire pour cet atelier, mais j'ai souhaité quand même migrer cette application dans la dernière version de Spring Boot/Framework.

Je vais décrire dans cet article comment j'ai réussi à migrer toute cette stack et les choix que j'ai fait pour que ça fonctionne.

Bien évidemment, cette application n'est pas une _"vraie"_ application en production.
Par exemple, je n'ai qu'une seule entité JPA...
Cependant, je la trouve représentative et espère (très modestement) que mon retour d'expérience pourra servir.

[La Pull Request correspondante est disponible sur GitHub](https://github.com/alexandre-touret/rest-apis-versioning-workshop/pull/11/files).

## Pré-requis

Une documentation existe.
Vous pouvez la consulter [ici](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.0-Migration-Guide).

## Dépendances et configuration des plugins

### JDK

Pour Spring Boot 3, il faut impérativement utiliser un JDK >=17.

### Mises à jour

L'une des premières actions à réaliser est de migrer votre application vers la version 2.7 au préalable.

À l'heure où j'écris cet article, la version de Spring Cloud est encore en version RC. J'ai donc dû ajouter le repository _"milestones"_ de Spring:

```groovy
repositories {
        maven { url 'https://repo.spring.io/milestone' }
        mavenCentral()
    }
```

Ensuite, j'ai utilisé les versions suivantes pour les différents composants spring:

* Spring Boot : 3.0.0
* Spring Cloud : 2022.0.0-RC2
* Spring Dependency Management : 1.1.0

Dans mon application, j'utilisais certains plugins Gradle pour la génération du code notamment [OpenAPIGenerator](https://openapi-generator.tech/docs/generators/spring/). Pour ce dernier, j'ai ajouté un paramètre pour le rendre compatible avec spring boot 3:

```groovy
 useSpringBoot3       : "true"
```

Bref, il faut impérativement tous les mettre à jour et vérifier la compatibilité !

## Ajout de nouvelles dépendances

Pour vérifier la pertinence de certaines propriétés dans la nouvelle version, Spring a mis à disposition ce plugin:

```groovy
   runtimeOnly 'org.springframework.boot:spring-boot-properties-migrator'
```

Il permet de notifier à l'exécution si un paramètre est déprécié ou totalement inutile.  
