---
title: Spring Data Flow pour des batchs cloud native
date: 2022-09-01 08:00:00

header:
  teaser: /assets/images/2022/08/maksym-tymchyk-vHO-yT1BDWk-unsplash.webp
og_image: /assets/images/2022/08/maksym-tymchyk-vHO-yT1BDWk-unsplash.webp

tags:
  - cloud
  - kubernetes
  - batch
  - spring
---

[Dans mon dernier article](https://blog.touret.info/2022/05/17/cloud-native-batchs/), j'ai tenté de faire un état des lieux des solutions possibles pour implémenter des batchs cloud natifs.

![flow](/assets/images/2022/08/maksym-tymchyk-vHO-yT1BDWk-unsplash.webp){: .align-center}

J'ai par la suite testé plus en détails les [jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) et [cron jobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) Kubernetes en essayant d'avoir une vue OPS sur ce sujet.
Le principal inconvénient (qui ne l'est pas dans certains cas) des jobs est qu'on ne peut pas les rejouer.
Si ces derniers sont terminés avec succès - Vous allez me dire, il faut bien les coder - mais qu'on souhaite les rejouer pour diverses raisons, on doit les supprimer et relancer.
J'ai vu plusieurs posts sur StackOverflow à ce sujet, je n'ai pas trouvé de solutions satisfaisantes à mes yeux relatifs à ce sujet.

![luke_cage](/assets/images/2022/08/luke_cage.webp){: .align-center}

Attention, je ne dis pas que les jobs et cron jobs ne doivent pas être utilisés.
Loin de là. 

Je pense que si vous avez besoin d'un traitement sans chaînage d'actions, sans rejeu, les [jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) et [cron jobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) sont des options plus que valables.
Le monitoring et reporting des actions réalisées peut se faire par l'observabilité mise en place dans votre cluster K8S.

![spring dataflow logo](/assets/images/2022/08/spring_dataflow_logo.webp){: .align-center}

Après plusieurs recherches, je suis tombé sur [Spring Data Flow](https://dataflow.spring.io/). 
L'offre de ce module de [Spring Cloud](https://spring.io/projects/spring-cloud) va au delà des batchs. 
Il permet notamment de gérer le streaming via une interface graphique ou via son [API](https://docs.spring.io/spring-cloud-dataflow/docs/current/reference/htmlsingle/#api-guide).

Dans cet article, je vais implémenter un exemple et le déployer dans Minikube.

## Installation et configuration de Minikube

L'installation de minikube est décrite sur [le site officiel](https://minikube.sigs.k8s.io/docs/start/). 

Pour l'installer, j'ai exécuté les commandes suivantes:

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
``` 

Au premier démarrage, vous finirez l'installation

```bash
minikube start
```

### Installation de Spring Cloud Data Flow

Pour installer Spring Cloud Data Flow directement dans Kubernetes, vous pouvez exécuter les commandes suivantes:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/spring-cloud-dataflow
```

Après quelques minutes de téléchargement, vous devriez avoir le retour suivante à l'exécution de la commande ``kubectl get pods``

```bash
kubectl get pods

~ » kubectl get pods                                                                           
NAME  READY   STATUS             RESTARTS      AGE
dataflow-mariadb-0  1/1     Running            1 (24h ago)   24h
dataflow-rabbitmq-0 1/1     Running            1 (24h ago)   24h
dataflow-spring-cloud-dataflow-server-75db59d6cb-lrwp8   1/1 Running            1 (24h ago)   24h
dataflow-spring-cloud-dataflow-skipper-9db568cf4-rzsqq   1/1     Running            1 (24h ago)   24h
```

### Accès au dashboard

Pour accéder au dashboard de Spring Cloud Data Flow, vous pouvez lancer les commandes suivantes:

```bash
export SERVICE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].port}" services dataflow-spring-cloud-dataflow-server)
kubectl port-forward --namespace default svc/dataflow-spring-cloud-dataflow-server ${SERVICE_PORT}:${SERVICE_PORT}
```

Ensuite, vous pourrez accéder à la console web via l'URL ``http://localhost:8080/dashboard``.

## Développement d'une Task



## Déploiement

