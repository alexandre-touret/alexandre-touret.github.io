---
title: Déployer des batchs cloud native avec Spring Cloud Data Flow
date: 2022-08-16 08:00:00

featuredImage: /assets/images/2022/08/maksym-tymchyk-vHO-yT1BDWk-unsplash.webp
featuredImagePreview: /assets/images/2022/08/maksym-tymchyk-vHO-yT1BDWk-unsplash.webp
images: ["/assets/images/2022/08/maksym-tymchyk-vHO-yT1BDWk-unsplash.webp"]

tags:
  - cloud
  - kubernetes
  - batch
  - spring

galleryExecution:
 - url: /assets/images/2022/08/dataflow_config2.webp
   image_path: /assets/images/2022/08/dataflow_config2.webp
   alt: "create"
 - url: /assets/images/2022/08/dataflow_config10.webp
   image_path: /assets/images/2022/08/dataflow_config10.webp
   alt: "init"
 - url: /assets/images/2022/08/dataflow_config8.webp
   image_path: /assets/images/2022/08/dataflow_config8.webp
   alt: "init"
 - url: /assets/images/2022/08/dataflow_config7.webp
   image_path: /assets/images/2022/08/dataflow_config7.webp
   alt: "init"
 - url: /assets/images/2022/08/dataflow_config9.webp
   image_path: /assets/images/2022/08/dataflow_config9.webp
   alt: "init"

---

[Dans mon dernier article](https://blog.touret.info/2022/05/17/cloud-native-batchs/), j'ai tenté de faire un état des lieux des solutions possibles pour implémenter des batchs cloud natifs.

{{< style "text-align:center" >}}
![dataflow](/assets/images/2022/08/maksym-tymchyk-vHO-yT1BDWk-unsplash.webp)
{{</ style >}}

J'ai par la suite testé plus en détails les [jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) et [cron jobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) Kubernetes en essayant d'avoir une vue OPS sur ce sujet.
Le principal inconvénient (qui ne l'est pas dans certains cas) des jobs est qu'on ne peut pas les rejouer.
Si ces derniers sont terminés avec succès - *Vous allez me dire, il faut bien les coder* - mais qu'on souhaite les rejouer pour diverses raisons, on doit les supprimer et relancer.
J'ai vu plusieurs posts sur StackOverflow à ce sujet, je n'ai pas trouvé de solutions satisfaisantes relatifs à ce sujet.

{{< style "text-align:center" >}}
![dataflow](/assets/images/2022/08/luke_cage.webp)
{{</ style >}}


Attention, je ne dis pas que les jobs et cron jobs ne doivent pas être utilisés.
Loin de là. 

Je pense que si vous avez besoin d'un traitement sans chaînage d'actions, sans rejeu, les [jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) et [cron jobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) sont de bonnes options.
Le monitoring et reporting des actions réalisées peut se faire par l'observabilité mise en place dans votre cluster K8S.

{{< style "text-align:center" >}}
![dataflow](/assets/images/2022/08/spring_dataflow_logo.webp)
{{</ style >}}

Après plusieurs recherches, je suis tombé sur [Spring Data Flow](https://dataflow.spring.io/). 
L'offre de ce module de [Spring Cloud](https://spring.io/projects/spring-cloud) va au delà des batchs. 
Il permet notamment de gérer le streaming via une interface graphique ou via son [API](https://docs.spring.io/spring-cloud-dataflow/docs/current/reference/htmlsingle/#api-guide).

Dans cet article, je vais implémenter un exemple et le déployer dans [Minikube](https://minikube.sigs.k8s.io/).

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

Pour accéder au [dashboard de Spring Cloud Data Flow](https://cloud.spring.io/spring-cloud-dataflow-ui/), vous pouvez lancer les commandes suivantes:

```bash
export SERVICE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].port}" services dataflow-spring-cloud-dataflow-server)
kubectl port-forward --namespace default svc/dataflow-spring-cloud-dataflow-server ${SERVICE_PORT}:${SERVICE_PORT}
```

Ensuite, vous pourrez accéder à la console web via l'URL ``http://localhost:8080/dashboard``.

## Développement d'une Task

J'ai crée une simple task qui va rechercher la nationalité d'un prénom. 
Pour ceci, j'utilise l'API [https://api.nationalize.io/](https://api.nationalize.io/).

On passe un prénom en paramètre et on obtient une liste de nationalités possibles avec leurs probabilités.

Vous trouverez les sources de cet exemple sur [mon Github](https://github.com/alexandre-touret/cloud-task).

Aussi, [la documentation est bien faite, il suffit de la lire](https://dataflow.spring.io/docs/batch-developer-guides/batch/spring-task/). 

### Initialisation

J'ai initié un projet Spring avec les dépendances suivantes:


```groovy
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.cloud:spring-cloud-starter-task'
    developmentOnly 'org.springframework.boot:spring-boot-devtools'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    implementation 'org.springframework.boot:spring-boot-starter-jdbc'
    runtimeOnly 'org.mariadb.jdbc:mariadb-java-client'
}

dependencyManagement {
    imports {
        mavenBom "org.springframework.cloud:spring-cloud-dependencies:${springCloudVersion}"
    }
}
```

Attention, les starters et dépendances JDBC/MariaDB sont indispensables pour que votre tâche puisse enregistrer le statut des exécutions.

### Construction de la tâche

Une tâche se crée facilement en annotation une classe "Configuration" par l'annotation ``@EnableTask`` 

```java
@Configuration
@EnableTask
public class TaskConfiguration {
  ...
}
```

Ensuite l'essentiel du job s'effectue dans la construction d'un bean ``CommandLineRunner`` :

```java
    @Bean
    public CommandLineRunner createCommandLineRunner(RestTemplate restTemplate) {
        return args -> {
            var commandLinePropertySource = new SimpleCommandLinePropertySource(args);
            var entity = restTemplate.getForEntity("https://api.nationalize.io/?name=" + Optional.ofNullable(commandLinePropertySource.getProperty("name")).orElse("BLANK"), NationalizeResponseDTO.class);
            LOGGER.info("RESPONSE[{}]: {}", entity.getStatusCode(), entity.getBody());
        };
    }

```

Dans mon exemple, j'affiche dans la sortie standard le payload de l'API ainsi que le code HTTP de la réponse.

Voici un exemple d'exécution :

```bash
2022-08-12 15:11:07.885  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2022-08-12 15:11:07.894  INFO 1 --- [           main] i.t.b.cloudtask.CloudTaskApplication     : Started CloudTaskApplication in 17.704 seconds (JVM running for 19.18)
2022-08-12 15:11:10.722  INFO 1 --- [           main] i.t.batch.cloudtask.TaskConfiguration    : RESPONSE[200 OK]: NationalizeResponseDTO{name='Alexandre', countries=[CountryDTO{countryId='BR', pr....
```

### Packaging

Ici rien de nouveau, il suffit de lancer la commande:

```bash
./gradlew build
```

## Déploiement

### Création et déploiement de l'image Docker
Pour déployer notre toute nouvelle tâche, nous allons d'abord créer l'image Docker avec buildpack.

Tout d'abord on va se brancher sur minikube pour que notre image soit déployée dans le repository de minikube 

```bash
eval $(minikube docker-env)
```

Ensuite, il nous reste à créer l'image Docker

```bash
./gradlew bootBuildImage --imageName=info.touret/cloud-task:latest
```

Pour vérifier que votre image est bien présente dans minikube, vous pouvez exécuter la commande suivante:

```bash
minikube image ls | grep cloud-task                                                                                                                                                                          
info.touret/cloud-task:latest
```

### Création de l'application

Avant de créer la tâche dans l'interface, il faut d'abord référencer l'image Docker en créer une [application](https://dataflow.spring.io/docs/applications/):


{{< figure src="/assets/images/2022/08/dataflow_config5.webp" title="" >}}

Il faut déclarer l'image Docker avec le formalisme présenté dans la capture d'écran.

### Création de la tâche

Voici les différentes actions que j'ai réalisé via l'interface:

{{< gallery >}}
![configuration](/assets/images/2022/08/dataflow_config3.webp)
![configuration](/assets/images/2022/08/dataflow_config4.webp)
{{< /gallery >}}
Vous trouverez plus de détails dans [la documentation officielle](https://dataflow.spring.io/docs/batch-developer-guides/batch/data-flow-simple-task/).

## Exécution

Maintenant, il nous est possible de lancer notre tâche.
Vous trouverez dans les copies d'écran ci-dessous les différentes actions que j'ai réalisé pour exécuter ma toute nouvelle tâche.

{{< gallery 2 >}}

![configuration](/assets/images/2022/08/dataflow_config2.webp)
![configuration](/assets/images/2022/08/dataflow_config10.webp)
![configuration](/assets/images/2022/08/dataflow_config8.webp)
![configuration](/assets/images/2022/08/dataflow_config7.webp)
![configuration](/assets/images/2022/08/dataflow_config9.webp)

{{< /gallery >}}

J'ai pu également accéder aux logs.

Il est également important de noter qu' après l'exécution d'une tâche, le POD est toujours au statut ``RUNNING``  afin que Kubernetes ne redémarre pas automatiquement le traitement.

```bash
kubectl get pods | grep cloud-task                                                                                                                                                                           
cloud-task-7mp72gzpwo                                    1/1     Running            0               57m
cloud-task-pymdkr182p                                    1/1     Running            0               65m
```

A chaque exécution il y aura donc un pod d'alloué.

## Aller plus loin

Parmi les fonctionnalités que j'ai découvert, on peut :
* relancer un traitement
* le programmer 
* nettoyer les exécutions
* les pistes d'audit
* le chaînage des différentes tâches

Gros inconvénient pour le nettoyage: je n'ai pas constaté un impact dans les pods alloués. 

## Conclusion

Pour résumer, je vais me risquer à comparer les deux solutions jobs/cron jobs Kubernetes et une solution basée sur Spring Cloud Dataflow.
Je vais donc utiliser la liste des caractéristiques présentée par [M. Richards et N. Ford dans leur livre: Fundamentals of Software Architecture](https://fundamentalsofsoftwarearchitecture.com/)[^1].

Bien évidemment, cette notation est purement personnelle.
Vous noterez que selon où on positionne le curseur, l'une des deux solutions peut s'avérer meilleure (ou pas).

Bref, tout dépend de vos contraintes et de ce que vous souhaitez en faire.
A mon avis, une solution telle que Spring Cloud Dataflow s'inscrit parfaitement pour des traitements mixtes (streaming, batch) et pour des traitements Big Data. 

N'hésitez pas à me donner votre avis ([sans troller svp](https://blog.touret.info/a-propos/)) en commentaire ou si ça concerne [l'exemple, directement dans Github](https://github.com/alexandre-touret/cloud-task).

|Architecture characteristic   |   K8s job rating| Spring Cloud Dataflow rating |
|---|---|---| 
|Partitioning type   | Domain & technical  | Domain & technical|
|Number of quanta [^2]  |  1 | 1 to many |
|Deployability   | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
|Elasticity   | ⭐⭐⭐ | ⭐⭐⭐⭐ |
|Evolutionary   | ⭐⭐⭐ | ⭐⭐⭐⭐ |
|Fault Tolerance   | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
|Modularity   | ⭐⭐⭐  | ⭐⭐⭐⭐⭐|
|Overall cost   | ⭐⭐⭐⭐| ⭐⭐⭐ |
|Performance   | ⭐⭐⭐⭐⭐| ⭐⭐⭐ |
|Reliability   | ⭐⭐⭐⭐| ⭐⭐⭐ |
|Scalability   | ⭐⭐⭐⭐| ⭐⭐⭐⭐ |
|Simplicity   | ⭐⭐⭐⭐⭐| ⭐⭐⭐|
|Testability   | ⭐⭐⭐  | ⭐⭐⭐⭐|

[^1]: A lire absolument!
[^2]: ~ Nombre de livrables indépendants fortement couplés
