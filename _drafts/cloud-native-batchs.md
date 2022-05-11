---
title: Faire des batchs "Cloud Native" dans Kubernetes
date: 2022-06-01 08:00:00

header:
  teaser: /assets/images/2022/02/architecture.jpg

tags:
  - cloud
  - kubernetes
  - batch
---

Quand on parle du Cloud et de Kubernetes, généralement on pense au développement et au déploiement d'APIs.
Mais qu'en est-il des batchs?
Oui, depuis plusieurs années, on pensait les éradiquer, mais ils sont encore là et on en a encore besoin. 
Ils ont même eu une deuxième jeunesse avec le Big Data et l'explosion des volumétries dans l'IT.

Je vais essayer de faire un tour d'horizon dans cet article des batchs dans un environnement Cloud et plus particulièrement dans Kubernetes.


## Pourquoi des batchs dans le Cloud?

A ce titre un peu provocateur, j'ajouterais aussi "Pourquoi des batchs dans Kubernetes ?".

Oui, aujourd'hui encore, on doit créer des traitements batchs. A coté des APIs qui représentent le cas d'utilisation "standard" du Cloud, on peut également avoir à traiter des fichiers volumineux allant de plusieurs centaines de Mo à quelques Go.

Parmi les cas d'utilisation qui nécessitent ce genre de traitement, on pourra avoir:
* Les reprises de données (suite à des erreurs ou lors d'une initialisation)
* Traitement suite à une réception de fichiers (par ex. traitement de fichiers OPENDATA)

Si vous déjà franchi le pas du Cloud pour vos applications transactionnelles, vous vous poserez cette question: *Puis-je déployer également des batchs?*

### Pourquoi se poser cette question?

Les réponses sont multiples. 
Elles sont tout d'abord liées à une rationalisation des environnements.
Vous avez votre application dans le cloud, votre base de données y est également gérée pour éviter la latence réseau.
Vous devez donc déployer des traitements tiers au plus proche de celle-ci pour vous soustraire des mêmes soucis.

De plus, l'écosystème lié au cloud offre des technologies et pratiques qui rendent la vie plus simple (si, si je vous assure) aux développeurs et ops. 
Le déploiement via l'Infra As Code est un bon exemple : Avoir toute l'infrastructure liée aux traitements batchs et transactionnels versionnées et instantiables à la demande est quelque chose dont on a du mal à se passer!

## Difficulté(s) par rapport aux APIs

Quand on déploie une API dans le cloud, généralement tout va bien. 
On peut voir rapidement que cet environnement convient bien à ce genre de traitements.

Pour les batchs, c'est une autre affaire!
Selon les sociétés, il peut y avoir un fort historique et beaucoup d' exigences à propos des batchs. 
Que cela soit sur les performances, la qualité de service ou plus simplement l' utilisation.

Il faut donc, à l'instar de toute architecture, déterminer quel sera l'environnement technique de ce type de traitement. 
Cette fois, on aura à concilier performances et fichiers volumineux. 

### Quelques technologies

On pourra retrouver dans notre future architecture les briques suivantes:

* Une passerelle de fichiers (File Gateway) pour permettre l'envoi des fichiers de manière sécurisée
* Un stockage objet pour la distribution de fichiers, ou l'archivage.
* Les éléments nécessaires à l'API : bases de données, HSMs, Cluster Kubernetes,...

## Modes de déclenchement

Si on regarde de plus près les exigences techniques liées aux cas d'utilisation, on pourrait résumer les différents modes de déclenchement de la manière suivante:

* Traitement sur présence de fichiers
* Traitement déclenché par un ordonnanceur de manière régulière ou non.

J'ai volontairement exclu les traitements sur présence de messages (ex. Kafka). Je les considère plus liés au monde transactionnel.

### Traitement sur présence de fichiers

### gpsupTraitement déclenché par un ordonnanceur 




Cloud native batchs
    How
        How to trigger them?
            Cron
            APIs
            Messaging ?
        Ecosystem ?
            Identify it with all the implied systems
                database
                File gateway
                object storage
                HSMs
        Landscape ?
            In Java
            Docker
            K8S
        Loose coupling
            For instance how to reach the gateway
    Lacks
        High pressure file management
    Benefits
        Scalability
        Infra as code
    Demonstration ???



