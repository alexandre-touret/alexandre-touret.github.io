---
id: 235
title: Premiers pas avec Gradle
date: 2019-12-30T15:03:36+01:00
author: admin
layout: post


timeline_notification:
  - "1577714616"
publicize_twitter_user:
  - touret_alex
tags:
  - gradle
  - java
---
<div class="wp-block-image">
  <figure class="aligncenter size-large is-resized"><img loading="lazy" src="/assets/img/posts/2019/12/gradle_logo.png?w=535" alt="" class="wp-image-243" width="581" height="202" srcset="/assets/img/posts/2019/12/gradle_logo.png 535w, /assets/img/posts/2019/12/gradle_logo-300x104.png 300w" sizes="(max-width: 581px) 100vw, 581px" /></figure>
</div>

Depuis quelques temps je me mets à [Gradle](https://gradle.org/). Après de (trop?) nombreuses années à utiliser Maven (depuis la version 0.9&#8230;), je me risque à modifier mon environnement de build. Du moins sur des projets démo.

Quand on a fait pas mal de Maven, on est un peu dérouté au début. On a d&rsquo;un coté, la plupart des actions qui sont configurées de manière implicite et de l&rsquo;autre on peut tout coder/étendre ou presque.

Je ne vais pas me risquer à faire un comparatif des deux outils. Gradle ( donc fortement orienté ) en [a fait un.](https://gradle.org/maven-vs-gradle/)

Je vais plutôt décrire avec cet article comment on peut démarrer rapidement en configurant son environnement pour être utilisé en entreprise.

## Installation

Le plus simple est d&rsquo;utiliser [SDKMAN](https://sdkman.io).

Voici la manipulation pour l&rsquo;installer:

```java
$ curl -s "https://get.sdkman.io" | bash
$ source "$HOME/.sdkman/bin/sdkman-init.sh"
$ sdk install gradle 6.0.1
```


## Configuration d&rsquo;un proxy

Et oui comment souvent, passer le proxy d&rsquo;entreprise est la moitié du boulot :).  
Pour le configurer de manière globale (c.-à-d. pour tous vos projets) sur votre poste de travail, vous devez créer un fichier `gradle.properties` dans le répertoire `$HOME/.gradle` :

```java
systemProp.http.proxyHost=proxy
systemProp.http.proxyPort=8888
systemProp.http.nonProxyHosts=localhost|127.0.0.1
systemProp.https.proxyHost=proxy
systemProp.https.proxyPort=8888
systemProp.https.nonProxyHosts=localhost|127.0.0.1
```


## Configuration d&rsquo;un miroir Nexus ou Artifactory

A l&rsquo;instar du proxy, on va essayer de mettre en place une configuration globale. Pour ce faire, on va utiliser [les init scripts](https://docs.gradle.org/current/userguide/init_scripts.html). Cette fonctionnalité est très intéressante. Elle permet de centraliser des actions et configurations.  
Pour créer un script, il faut tout d&rsquo;abord créer un fichier `.gradle` dans le répertoire `$HOME/.gradle/init.d`.  
  
Voici un exemple pour [Nexus](https://fr.sonatype.com/nexus-repository-sonatype):

```java
allprojects { 
  buildscript { 
    repositories {
      mavenLocal() 
      maven {url "https://url-nexus"} 
    }
  }
  repositories { 
    mavenLocal()
    maven { url "https://url-nexus"}
  }
}
```


## Configuration du déploiement dans Nexus / Artifactory

Le déploiement dans Nexus est possible via [le plugin maven publish](https://docs.gradle.org/current/userguide/publishing_maven.html). La configuration fournie dans la documentation est tellement bien faite ( comme le reste d&rsquo;ailleurs ) que je ne vais que mettre un lien vers celle-là:  
Voici [le lien](https://docs.gradle.org/current/userguide/publishing_maven.html#publishing_maven:complete_example).

## Conclusion

Après ces quelques actions vous pourrez démarrer des builds avec gradle tout en étant compatible avec un environnement « Maven ».  
Enjoy 🙂