---
id: 241
title: Passer votre application Java8 en Java11
date: 2020-02-03T15:44:27+01:00
author: admin
layout: post


timeline_notification:
  - "1580741068"
publicize_twitter_user:
  - touret_alex
tags:
  - java
  - Planet-Libre
---
Java 8 est encore largement utilisé dans les entreprises aujourd&rsquo;hui. Il y a même certains frameworks qui n&rsquo;ont pas encore sauté le pas.  
Je vais essayer d&rsquo;exposer dans cette article les étapes à réaliser pour migrer (simplement) votre application JAVA8 en JAVA 11.

Dans cet article, je prendrai comme postulat que l&rsquo;application se construit avec Maven.

<div class="wp-block-image">
  <figure class="aligncenter size-large"><img src="/assets/img/posts/2020/02/blake-wisz-eevhwmstyg8-unsplash-1.jpg?w=683" alt="" class="wp-image-270" /></figure>
</div>

## Pré-requis

Tout d&rsquo;abord vérifiez votre environnement d&rsquo;exécution cible! Faites un tour du coté de la documentation et regardez le support de JAVA.

Si vous utilisez des FRAMEWORKS qui utilisent des FAT JARS, faites de même (ex. pour spring boot, utilisez au moins la version 2.1.X).

Ensuite, vous aurez sans doute à mettre à jour maven ou gradle. Préférez les dernières versions.

## Configuration maven

Les trois plugins à mettre à jour obligatoirement sont :

  * [maven-compiler-plugin](https://maven.apache.org/plugins/maven-compiler-plugin/)
  * [maven-surefire-plugin](https://maven.apache.org/surefire/maven-surefire-plugin/)
  * [maven-failsafe-plugin](https://maven.apache.org/surefire/maven-failsafe-plugin/)

### Maven compiler plugin

```java
&lt;plugin&gt;
        &lt;artifactId&gt;maven-compiler-plugin&lt;/artifactId&gt;
        &lt;version&gt;3.8.1&lt;/version&gt;
        &lt;configuration&gt;
          &lt;release&gt;11&lt;/release&gt;
          &lt;encoding&gt;UTF-8&lt;/encoding&gt;
        &lt;/configuration&gt;
      &lt;/plugin&gt;
```


## maven surefire / failsafe plugin

Pour ces deux plugins, ajouter la configuration suivante:

```java
&lt;plugin&gt;
        &lt;artifactId&gt;maven-surefire-plugin&lt;/artifactId&gt;
        &lt;version&gt;2.22.2&lt;/version&gt;
        &lt;configuration&gt;
        [...]
          &lt;argLine&gt;--illegal-access=permit&lt;/argLine&gt;
          [...]
        &lt;/configuration&gt;
      &lt;/plugin&gt;
```


## Mise à jour des librairies

Bon,la il n&rsquo;y a pas de magie. Vous devez mettre à jour toutes vos librairies. Mis à part si vous utilisez des librairies exotiques, la plupart supportent JAVA 11 maintenant.

C&rsquo;est une bonne opportunité de faire le ménage dans vos fichiers `pom.xml` 🙂

## APIS supprimées du JDK

Si vous faites du XML, SOAP ou que vous utilisiez l&rsquo;API activation, vous devez désormais embarquer ces librairies. Le JDK ne les inclut plus par défaut.

Par exemple:

```java
&lt;dependency&gt;
            &lt;groupId&gt;com.sun.xml.bind&lt;/groupId&gt;
            &lt;artifactId&gt;jaxb-core&lt;/artifactId&gt;
            &lt;version&gt;2.3.0.1&lt;/version&gt;
            &lt;scope&gt;test&lt;/scope&gt;
        &lt;/dependency&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;com.sun.xml.bind&lt;/groupId&gt;
            &lt;artifactId&gt;jaxb-impl&lt;/artifactId&gt;
            &lt;version&gt;2.3.0.1&lt;/version&gt;
            &lt;scope&gt;test&lt;/scope&gt;
        &lt;/dependency&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;javax.xml.bind&lt;/groupId&gt;
            &lt;artifactId&gt;jaxb-api&lt;/artifactId&gt;
            &lt;version&gt;2.3.1&lt;/version&gt;
        &lt;/dependency&gt;

```


## Modularisation avec JIGSAW

Bon là &#8230; je vous déconseille de partir directement sur la modularisation, surtout si vous migrez une application existante. Bien que la modularité puisse aider à réduire vos images docker en construisant vos propres JRE et d&rsquo;améliorer la sécurité, elle apporte son lot de complexité.  
Bref pour la majorité des applications, je vous déconseille de l&rsquo;intégrer.

## Conclusion

Avec toutes ces manipulations, vous devriez pouvoir porter vos applications sur JAVA11. Il y aura sans doute quelques bugs. Personnellement, j&rsquo;en ai eu avec CGLIB vs Spring AOP sur une classe instrumentée avec un constructeur privé. Sur ce coup j&rsquo;ai contourné ce problème ( je vous laisse deviner comment 🙂 ).