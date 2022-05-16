---
title: Faire des batchs "Cloud Native" dans Kubernetes
date: 2022-05-01 08:00:00

header:
  teaser: /assets/images/2022/02/architecture.jpg

tags:
  - cloud
  - kubernetes
  - batch
---

![pat-whelen-xSsWBa4rb6E-unsplash.jpg ](/assets/images/2022/05/pat-whelen-xSsWBa4rb6E-unsplash.jpg)

Quand on parle du Cloud et de Kubernetes, généralement on pense aux APIs.
Mais qu'en est-il des batchs?
Oui, depuis plusieurs années, on pensait les éradiquer, mais ils sont encore là et on en a encore besoin pour quelques années encore. 
Ils ont même eu une deuxième jeunesse avec le Big Data et l'explosion des volumétries dans l'IT.

Je vais essayer de faire un tour d'horizon dans cet article des batchs dans un environnement Cloud et plus particulièrement dans Kubernetes.

Les exemples présentés dans cet article seront (sans doute) approfondis dans un second article et d'ores et déjà disponibles dans [mon GitHub](https://github.com/alexandre-touret/k8s-batch). 

## Pourquoi des batchs dans le Cloud?

A ce titre un peu provocateur, j'ajouterais aussi *"Pourquoi des batchs dans Kubernetes ?"*.

Oui, aujourd'hui encore,comme j'ai pu l'indiquer précédemment, on doit créer des traitements batchs. A coté des APIs qui représentent le cas d'utilisation "standard" du Cloud, on peut également avoir à traiter des fichiers volumineux allant de plusieurs centaines de Mo à quelques Go.

Parmi les cas d'utilisation qui nécessitent ce genre de traitement, on pourra avoir:
* Les reprises de données (suite à des erreurs ou lors d'une initialisation)
* Traitement suite à une réception de fichiers (par ex. traitement de fichiers OPENDATA)

Si vous êtes déjà passé sur le Cloud pour vos applications transactionnelles, vous vous poserez cette question: *Puis-je également déployer des batchs?*

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
Cette fois, on aura à concilier performances, fichiers volumineux et reprises sur erreur. 

### Quelques technologies

On pourra retrouver dans notre future architecture les briques suivantes:

* Une passerelle de fichiers (File Gateway) pour permettre l'envoi des fichiers de manière sécurisée
* Un stockage objet pour la distribution de fichiers, ou l'archivage.
* Les éléments nécessaires à l'API : bases de données, HSMs, Cluster Kubernetes,...

## Modes de déclenchement

Si on regarde de plus près les exigences techniques liées aux cas d'utilisation, on pourrait résumer les différents modes de déclenchement de la manière suivante:

* Traitement sur réception de fichiers
* Traitement déclenché par un ordonnanceur de manière régulière ou non.
* Traitement déclenché par CRONTab

J'ai volontairement exclu les traitements sur présence de messages (ex. Kafka). Je les considère plus liés au monde transactionnel.

Dans les paragraphes suivants, je vais décrire des solutions d'architecture qui permettent de déployer ces traitements dans Kubernetes. J'aborderai sans doute un exemple dans un autre article

## Contraintes 

Dès qu'on s'aventure dans ce type de conception, nous aurons, au delà des [12 factors](https://12factor.net/), les contraintes suivantes à traiter:
  
### Gestion des erreurs et indisponibilités
Dans un cluster Kubernetes, le crash d'un POD n'est pas rédhibitoire.
Le cluster permet de redémarrer immédiatement une autre instance.

Pour les APIs, ce n'est pas un problème.
Pour les batchs, c'est une autre paire de manches. 
Quid du crash en plein milieu du traitement d'un fichier?

Il faut donc penser à ce cas ( et à d'autres) et archiver les fichiers pour un éventuel rejeu.

### Données et idempotence des traitements

Idéalement, les fichiers doivent avoir des lignes indépendantes qui peuvent être insérées individuellement et dans n'importe quel ordre.
Aussi, chaque modification et traitement de données doivent être idempotentes.

Pourquoi? Pas seulement par ce que c'est sympa et l'état de l'art, mais dans ce nouvel environnement, vous ne pourrez pas forcément garantir l'ordre des traitements.
L'une des solutions potentielles de traitement est de découpler la lecture et l'insertion par du queueing (Artemis, Kafka *- oui ce n'est pas du queuing, mais vous avez compris...*). 
Dans ce cas, si votre traitement n'est pas idempotent, vous devrez lutter avec des doublons en base. 

### Gestion des ressources 

Imaginez, vous recevez un fichier de 1Go. 
Vos ressources systèmes sont des PODs avec un 1 Go de RAM.

Vous voyez le soucis? 

Cet exemple, qui n'est pas trop éloigné de la réalité, mets en évidence l'une des contraintes techniques que vous devrez prendre dès le début de votre conception. 

L'une des solutions serait, par exemple, le traitement quasi systématique du streaming de fichiers et l'obligation d'avoir des fichiers avec des lignes de données indépendantes (c.-à-d. sans avoir à faire de liens inter lignes pendant le traitement).

## Traitement sur réception de fichiers

Dans ce cas, nous avons un processus qui est déclenché lors de la réception d'un fichier. Nous pourrons par exemple avec ce genre d'architecture un fichier qui est envoyé dans espace de stockage objet. Ce dernier est ensuite traité par un programme.
J'ai fait le choix ici de mettre en oeuvre un couplage lâche (on ne se refait pas) entre l'espace de réception de fichiers et le traitement. 

Je traite ici le risque de crash d'un POD en gardant systématiquement les fichiers dans un stockage objet. De cette manière, si le traitement a échoué, un autre POD pourra le télécharger et rejouer le processus batch.  

Ce découplage permet de gérer facilement la scalabilité et les arrêts/relances de PODs.

![batch_evenement-Batch_sur_presence_fichier](/assets/images/2022/05/batch_evenement-Batch_sur_presence_fichier.svg)

Dans ce cas, le batch pourra être déployé sous la forme d'un [déploiement Kubernetes](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/).

## Traitement déclenché par un ordonnanceur 

Maintenant, on va aborder les traitements qui sont lancés par un ordonnanceur tiers. 
Généralement, dans le monde de l'entreprise, la planification des traitements est centralisée au lieu de laisser de le faire sur chaque machine avec des [CRON Jobs](https://en.wikipedia.org/wiki/Cron).

Dans ce cas, on a deux manières de procéder:
* Avoir un traitement qui fournit une API permettant de démarrer des traitements et d'avoir leurs statuts.
* Lancer des jobs.

### Avec une API

Ici, on conçoit les batchs comme des WEBAPPS qui fournissent des traitements batchs sur demande via des APIs. La contrainte est qu'à l'instar de la solution précédente, le programme tourne toujours et n' est vraiment utile que lorsqu'il est appelé via un endpoint REST.

Ce modèle de conception peut être utilisé à mon avis si la fréquence est forte et si l'intégration d'un  Job Kubenertes est problématique pour vous (voir ci-dessous). 

L'un des avantages que l'on pourra trouver est que le [mode de déploiement est assez simple et similaire aux APIs](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/).

![traitement_api](/assets/images/2022/05/traitement_api.svg)

### Avec des jobs

Si votre ordonnanceur peut exécuter le client kubectl, vous pourrez considérer les [jobs  kubernetes](https://kubernetes.io/docs/concepts/workloads/controllers/job/). 

En résumé, ils permettent de créer un POD et exécute une action en gérant les erreurs potentielles jusqu'à complétion du traitement.

Par exemple, voici un job permettant de faire un "Hello World!":

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: hello-world
spec:
  template:
    spec:
      containers:
      - name: helloworld
        image: busybox
        command: ["echo",  "Hello World!"]
      restartPolicy: Never
  backoffLimit: 4
```

Une fois déployé avec Helm, vous pouvez les voir avec la commande ``kubectl get jobs``

```jshelllanguage
minikube kubectl -- get jobs
NAME          COMPLETIONS   DURATION   AGE
hello-world   0/1           25s        25s
```

Pour les logs et voir le résultat de la commande lancé, cela se passe d'une manière assez habituelle:

```jshelllanguage
minikube kubectl -- logs hello-world-zx4wh
Hello World!
```

## Traitement déclenché par CRONTab

## Paysages des solutions logicielles possibles

## Faiblesses

## Conclusion
