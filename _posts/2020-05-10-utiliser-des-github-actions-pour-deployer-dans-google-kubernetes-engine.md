---
id: 373
title: Utiliser des GITHUB Actions pour déployer dans Google Kubernetes Engine
date: 2020-05-10T08:22:00+02:00
author: admin
layout: post


publicize_twitter_user:
  - touret_alex
timeline_notification:
  - "1624118296"
publicize_linkedin_url:
  - ""
  - logiciels libres
tags:
  - github
  - gradle
  - kubernetes
---
<p class="has-drop-cap">
  A mes heures perdues, je travaille sur un « <em>POC/side project qui n&rsquo;aboutira pas et je m&rsquo;en fiche</em> » basé sur Quarkus. J&rsquo; ai choisi d&rsquo;utiliser les langages et composants suivants :
</p>

  * [Kotlin](https://kotlinlang.org/)
  * [Quarkus](http://quarkus.io/)
  * [Gradle](https://gradle.org/)
  * [Kubernetes](http://kubernetes.io/) pour le déploiement

Oui, tant qu&rsquo;à faire, autant aller dans la hype &#8230;

<div class="wp-block-group">
  <div class="wp-block-group__inner-container">
    <div class="wp-block-image">
      <figure class="aligncenter size-medium"><img loading="lazy" width="696" height="549" src="/assets/img/posts/2020/05/article_github_actions_k8s-1.png?w=300" alt="" class="wp-image-412" srcset="/assets/img/posts/2020/05/article_github_actions_k8s-1.png 696w, /assets/img/posts/2020/05/article_github_actions_k8s-1-300x237.png 300w" sizes="(max-width: 696px) 100vw, 696px" /></figure>
    </div>
  </div>
</div>

[Mon projet est sur GITHUB](https://github.com/alexandre-touret/music-quote). Pour automatiser certaines actions et, disons-le, par fierté personnelle, j&rsquo;ai choisi d&rsquo;automatiser certaines actions par la mise en œuvre de pipelines CI/CD.  
Depuis peu, GITHUB a intégré un mécanisme de pipeline : [GITHUB Actions](https://github.com/features/actions).

Ça permet, entre autres, de lancer des processus automatisé sur un push ou sur une action pour un commit GIT.

La force de l&rsquo;outil est, selon moi, de facilement s&rsquo;intégrer avec beaucoup de services du cloud ( sonarcloud, google cloud, heroku,…). On aime ou on n&rsquo;aime pas, mais chez Microsoft, l&rsquo;intégration ils savent faire.

Par exemple, si on veut lancer une compilation lors d&rsquo;un push, on peut placer un fichier `.github/workflows/build.xml` avec le contenu :

```java
name: CI

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: Set up JDK 11
        uses: actions/setup-java@v1
        with:
          java-version: 11
      - name: Build with Gradle without testing
        run: ./gradlew build -x test
```


Coté GITHUB, vous verrez l&rsquo;exécution sur un écran dédié<figure class="wp-block-image size-large is-resized">

<img loading="lazy" src="/assets/img/posts/2020/05/screenshot_2020-05-08-alexandre-touret-music-quote.png?w=1024" alt="" class="wp-image-376" width="768" height="305" srcset="/assets/img/posts/2020/05/screenshot_2020-05-08-alexandre-touret-music-quote.png 1025w, /assets/img/posts/2020/05/screenshot_2020-05-08-alexandre-touret-music-quote-300x119.png 300w, /assets/img/posts/2020/05/screenshot_2020-05-08-alexandre-touret-music-quote-768x306.png 768w" sizes="(max-width: 768px) 100vw, 768px" /> </figure> 

Vous pouvez créer autant de workflows que vous souhaitez (si votre projet est en libre accès).  
Pour chaque workflow, on peut définir et utiliser des jobs. Les logs d&rsquo;exécution sont disponibles dans ce même écran:

<div class="wp-block-image">
  <figure class="aligncenter size-large is-resized"><img loading="lazy" src="/assets/img/posts/2020/05/screenshot_2020-05-09-alexandre-touret-music-quote.png?w=936" alt="" class="wp-image-399" width="702" height="275" srcset="/assets/img/posts/2020/05/screenshot_2020-05-09-alexandre-touret-music-quote.png 936w, /assets/img/posts/2020/05/screenshot_2020-05-09-alexandre-touret-music-quote-300x117.png 300w, /assets/img/posts/2020/05/screenshot_2020-05-09-alexandre-touret-music-quote-768x300.png 768w" sizes="(max-width: 702px) 100vw, 702px" /></figure>
</div>

## Worflows implémentés

J&rsquo;ai choisi d&rsquo;implémenter les workflows suivants:

  * **CI**: Build sur la feature branch
  * **CD**: Build sur master branch et déploiement

On obtient donc dans mon cas:

<div class="wp-block-image">
  <figure class="aligncenter size-large is-resized"><img loading="lazy" src="/assets/img/posts/2020/05/workflow.png?w=1024" alt="" class="wp-image-378" width="512" height="396" srcset="/assets/img/posts/2020/05/workflow.png 1056w, /assets/img/posts/2020/05/workflow-300x232.png 300w, /assets/img/posts/2020/05/workflow-1024x791.png 1024w, /assets/img/posts/2020/05/workflow-768x593.png 768w" sizes="(max-width: 512px) 100vw, 512px" /></figure>
</div>

Ce n&rsquo;est pas parfait. Loin de là. Dans la « vraie vie », pour une équipe de dev, je l&rsquo;améliorerai sans doute par un build docker dans les features branches, une validation formelle et bloquante de l&rsquo;analyse sonar, etc.  
Pour un dev perso ça suffit largement. Le contenu de la branche master est compilé et une image docker est crée pour être déployée automatiquement dans GKE.

## Analyse SONAR

J&rsquo;ai choisi d&rsquo;utiliser [sonarcloud](http://sonarcloud.io/) pour analyser mon code. C&rsquo;est gratuit pour les projets opensource. L&rsquo;analyse se fait simplement:

```java
sonarCloudTrigger:
    name: SonarCloud Trigger
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: Set up JDK 11
        uses: actions/setup-java@v1
        with:
          java-version: 11
      - name: SonarCloud Scan
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        run: ./gradlew jacocoTestReport sonarqube

```


Dans ce job j&rsquo;utilise deux [secrets](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets). Ce sont des tokens qui permettent de ne pas stocker en dur les données dans les repos GITHUB.

## Création d&rsquo;une image Docker et déploiement dans le registry GITHUB

Ici aussi, ça se fait simplement. La preuve :

```java
jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: Set up JDK 11
        uses: actions/setup-java@v1
        with:
          java-version: 11
      - name: Build in JVM Mode with Gradle without testing
        run: ./gradlew quarkusBuild  [1]
      - name: Branch name
        run: echo running on branch ${GITHUB_REF##*/}
      - name: Build the Docker image Quarkus JVM
        run: docker build -f src/main/docker/Dockerfile.jvm -t docker.pkg.github.com/${GITHUB_REPOSITORY}/music-quote-jvm:latest .  [2]
      - name: Login against github docker repository
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: docker login -u ${GITHUB_ACTOR} -p ${GITHUB_TOKEN}  docker.pkg.github.com   [3]
      - name: Publish the Docker image Quarkus JVM
        run: docker push docker.pkg.github.com/${GITHUB_REPOSITORY}/music-quote-jvm:latest  [4]
```


  1. Création du binaire
  2. Création de l&rsquo;image docker en utilisant la commande docker et le Dockerfile fourni par Quarkus
  3. Identification sur la registry Docker de GITHUB
  4. Déploiement de l&rsquo;image

Pour plus de détails sur la variable GITHUB_TOKEN, vous pouvez lire [cet article de la documentation](https://help.github.com/en/actions/configuring-and-managing-workflows/authenticating-with-the-github_token).

## Déploiement dans Google Kubernetes Engine

Mon application est pour l&rsquo;instant architecturée comme suit (_attention c&rsquo;est compliqué_):

<div class="wp-block-columns">
  <div class="wp-block-column" style="flex-basis:100%;">
    <div class="wp-block-image is-style-default">
      <figure class="aligncenter size-medium"><img loading="lazy" width="359" height="483" src="/assets/img/posts/2020/05/application-1.png?w=223" alt="" class="wp-image-391" srcset="/assets/img/posts/2020/05/application-1.png 359w, /assets/img/posts/2020/05/application-1-223x300.png 223w" sizes="(max-width: 359px) 100vw, 359px" /></figure>
    </div>
  </div>
</div>

Pour la déployer dans Google Kubernetes Engine, j&rsquo;ai besoin d&rsquo; implémenter cette « architecture » par les objets Kubernetes suivants:

<div class="wp-block-image">
  <figure class="aligncenter size-large is-resized"><img loading="lazy" src="/assets/img/posts/2020/05/application_gke.png?w=561" alt="" class="wp-image-392" width="421" height="443" srcset="/assets/img/posts/2020/05/application_gke.png 561w, /assets/img/posts/2020/05/application_gke-285x300.png 285w" sizes="(max-width: 421px) 100vw, 421px" /></figure>
</div>

J&rsquo;utilise les objets suivants:

  * Des services pour exposer la base de données ainsi que l&rsquo;application
  * Un deployment pour l&rsquo;application
  * Des pods car à un moment, il en faut&#8230;
  * Un statefulset pour la base de données

Vous pourrez trouver la définition de tous ces objets au format yaml via [ce lien](https://github.com/alexandre-touret/music-quote/tree/master/k8s). J&rsquo;ai fait très simple. Logiquement j&rsquo;aurai du créer un volume pour les bases de données ou utiliser une base de données en mode PAAS.

Pour lancer le déploiement, il faut au préalable créer un secret ( fait manuellement pour ne pas stocker d&rsquo;objet yaml dans le repository GITHUB) pour se connecter au repo GITHUB via la commande suivante:

```java
kubectl create secret docker-registry github-registry --docker-server=docker.pkg.github.com --docker-username=USER--docker-password=PASSWORD --docker-email=EMAIL
```


On peut faire pareil pour les connexions base de données. J&rsquo;ai mis dans un configmap pour ne pas trop me prendre la tête&#8230;

Après le déploiement via le pipeline se fait assez simplement:

```java
[...]
      - uses: GoogleCloudPlatform/github-actions/setup-gcloud@master
        with:
          version: '286.0.0'
          service_account_email: ${{ secrets.GKE_SA_EMAIL }}
          service_account_key: ${{ secrets.GKE_SA_KEY }}
          project_id: ${{ secrets.GKE_PROJECT }}
      # Get the GKE credentials so we can deploy to the cluster
      - run: |-
          gcloud container clusters get-credentials "${{ secrets.GKE_CLUSTER }}" --zone "${{ secrets.GKE_ZONE }}"
      # Deploy the Docker image to the GKE cluster
      - name: Deploy
        run: |-
          kubectl apply -f ./k8s     
```


J&rsquo;utilise [les « actions » fournies par Google](https://github.com/GoogleCloudPlatform/github-actions). 

## Conclusion

Pour que ça marche il y a pas mal d&rsquo;étapes préalables ( des tokens à générer, un utilisateur technique, &#8230;).  
J&rsquo;ai essayé de les référencer dans [le README du projet](https://github.com/alexandre-touret/music-quote).  
Si vous voulez tester l&rsquo;intégration Kubernetes dans le cloud google, sachez que vous pouvez disposer d&rsquo;un crédit de 300€ valable un an. Attention, avec ce genre d&rsquo;architecture, ça part vite&#8230;