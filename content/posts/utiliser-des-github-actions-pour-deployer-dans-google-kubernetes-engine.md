---
id: 373
title: Utiliser des GITHUB Actions pour déployer dans Google Kubernetes Engine
date: 2020-05-10T08:22:00+02:00

featuredImagePreview: /assets/images/2020/05/article_github_actions_k8s-1.png
featuredImage: /assets/images/2020/05/article_github_actions_k8s-1.png
images: ["/assets/images/2020/05/article_github_actions_k8s-1.png"]

lightgallery: true

tags:
  - github
  - gradle
  - kubernetes
---
A mes heures perdues, je travaille sur un « POC/side project qui n'aboutira pas et je m'en fiche » basé sur Quarkus. J' ai choisi d'utiliser les langages et composants suivants :

  * [Kotlin](https://kotlinlang.org/)
  * [Quarkus](http://quarkus.io/)
  * [Gradle](https://gradle.org/)
  * [Kubernetes](http://kubernetes.io/) pour le déploiement

Oui, tant qu'à faire, autant aller dans la hype &#8230;

[Mon projet est sur GITHUB](https://github.com/alexandre-touret/music-quote). Pour automatiser certaines actions et, disons-le, par fierté personnelle, j'ai choisi d'automatiser certaines actions par la mise en œuvre de pipelines CI/CD.  
Depuis peu, GITHUB a intégré un mécanisme de pipeline : [GITHUB Actions](https://github.com/features/actions).

Ça permet, entre autres, de lancer des processus automatisé sur un push ou sur une action pour un commit GIT.

La force de l'outil est, selon moi, de facilement s'intégrer avec beaucoup de services du cloud ( sonarcloud, google cloud, heroku,…). On aime ou on n'aime pas, mais chez Microsoft, l'intégration ils savent faire.

Par exemple, si on veut lancer une compilation lors d'un push, on peut placer un fichier ``.github/workflows/build.xml`` avec le contenu :

```yaml
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


Coté GITHUB, vous verrez l'exécution sur un écran dédié

{{< style "text-align:center" >}}
![Music Quote](/assets/images/2020/05/screenshot_2020-05-08-alexandre-touret-music-quote.png)
{{</ style >}}

Vous pouvez créer autant de workflows que vous souhaitez (si votre projet est en libre accès).  
Pour chaque workflow, on peut définir et utiliser des jobs. Les logs d'exécution sont disponibles dans ce même écran:

{{< style "text-align:center" >}}
![Music Quote](/assets/images/2020/05/screenshot_2020-05-09-alexandre-touret-music-quote.png)
{{</ style >}}

## Worflows implémentés

J'ai choisi d'implémenter les workflows suivants:

  * **CI**: Build sur la feature branch
  * **CD**: Build sur master branch et déploiement

On obtient donc dans mon cas:

{{< style "text-align:center" >}}
![workflow](/assets/images/2020/05/workflow.png)
{{</ style >}}

Ce n'est pas parfait. Loin de là. Dans la « vraie vie », pour une équipe de dev, je l'améliorerai sans doute par un build docker dans les features branches, une validation formelle et bloquante de l'analyse sonar, etc.  
Pour un dev perso ça suffit largement. Le contenu de la branche master est compilé et une image docker est crée pour être déployée automatiquement dans GKE.

## Analyse SONAR

J'ai choisi d'utiliser [sonarcloud](http://sonarcloud.io/) pour analyser mon code. C'est gratuit pour les projets opensource. L'analyse se fait simplement:

```yaml
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


Dans ce job j'utilise deux [secrets](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets). Ce sont des tokens qui permettent de ne pas stocker en dur les données dans les repos GITHUB.

## Création d'une image Docker et déploiement dans le registry GITHUB

Ici aussi, ça se fait simplement. La preuve :

```yaml
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
  2. Création de l'image docker en utilisant la commande docker et le Dockerfile fourni par Quarkus
  3. Identification sur la registry Docker de GITHUB
  4. Déploiement de l'image

Pour plus de détails sur la variable GITHUB_TOKEN, vous pouvez lire [cet article de la documentation](https://help.github.com/en/actions/configuring-and-managing-workflows/authenticating-with-the-github_token).

## Déploiement dans Google Kubernetes Engine

Mon application est pour l'instant architecturée comme suit (_attention c'est compliqué_):

{{< style "text-align:center" >}}
![workflow](/assets/images/2020/05/application-1.png)
{{< /style >}}

Pour la déployer dans Google Kubernetes Engine, j'ai besoin d' implémenter cette « architecture » par les objets Kubernetes suivants:

{{< style "text-align:center" >}}
![workflow](/assets/images/2020/05/application_gke.png)
{{< /style >}}

J'utilise les objets suivants:

  * Des services pour exposer la base de données ainsi que l'application
  * Un deployment pour l'application
  * Des pods car à un moment, il en faut&#8230;
  * Un statefulset pour la base de données

Vous pourrez trouver la définition de tous ces objets au format yaml via [ce lien](https://github.com/alexandre-touret/music-quote/tree/master/k8s). J'ai fait très simple. Logiquement j'aurai du créer un volume pour les bases de données ou utiliser une base de données en mode PAAS.

Pour lancer le déploiement, il faut au préalable créer un secret ( fait manuellement pour ne pas stocker d'objet yaml dans le repository GITHUB) pour se connecter au repo GITHUB via la commande suivante:

```bash
kubectl create secret docker-registry github-registry --docker-server=docker.pkg.github.com --docker-username=USER--docker-password=PASSWORD --docker-email=EMAIL
```
On peut faire pareil pour les connexions base de données. J'ai mis dans un configmap pour ne pas trop me prendre la tête&#8230;

Après le déploiement via le pipeline se fait assez simplement:

```yaml
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


J'utilise [les « actions » fournies par Google](https://github.com/GoogleCloudPlatform/github-actions). 

## Conclusion

Pour que ça marche il y a pas mal d'étapes préalables ( des tokens à générer, un utilisateur technique, &#8230;).  
J'ai essayé de les référencer dans [le README du projet](https://github.com/alexandre-touret/music-quote).  
Si vous voulez tester l'intégration Kubernetes dans le cloud google, sachez que vous pouvez disposer d'un crédit de 300€ valable un an. Attention, avec ce genre d'architecture, ça part vite&#8230;