# Migrer son application Spring Boot vers la version 3

Pour ce dernier article de l'année 2022, voici un rapide retour d'expérience.

Je suis actuellement en cours de préparation d'un workshop pour [l'édition 2023 de SnowcampIO](https://snowcamp.io/fr/).
J'aborderai dans [ce dernier le versioning des APIs REST](https://sessionize.com/s/alexandre-touret/rest-apis-versioning-hands-on/60048).
Pour illustrer ce sujet ô combien épineux, j'ai réalisé une plateforme "microservices" en utilisant différents composants de la [stack Spring](https://spring.io/).


| Container | Tools                                                        | Comments |
|---|--------------------------------------------------------------|---|
| API Gateway | Spring Cloud Gateway 2022.0.0-RC2                                |  |
| Bookstore API | JAVA 17,Spring Boot 3.0.X                                    |  |
| ISBN API | JAVA 17,Spring Boot 3.0.X                                    |  |
| Configuration Server | Spring Cloud Config 2022.0.0-RC2                                |  |
| Database | PostgreSQL                                                   |  |
| Authorization Server | JAVA 17,Spring Boot 3.0.X, Spring Authorization Server 1.0.0 |  |


En résumé, j'utilise [Spring Boot](https://spring.io/projects/spring-boot), [Cloud](https://spring.io/cloud), [Security](https://spring.io/projects/spring-security), [Authorization Server](https://spring.io/projects/spring-authorization-server), [Circuit Breaker](https://spring.io/projects/spring-cloud-circuitbreaker), [Spring Data](https://spring.io/projects/spring-data),...

J'ai démarré le développement avant [l'annonce officielle de la version 3.0 de Spring Boot](https://spring.io/blog/2022/11/24/spring-boot-3-0-goes-ga).
Ce n'était pas réellement obligatoire pour cet atelier, mais j'ai souhaité quand même migrer cette application dans la dernière version de Spring Boot/Framework.

Je vais décrire dans cet article comment j'ai réussi à migrer toute cette stack et les choix que j'ai fait pour que ça fonctionne.

Bien évidemment, cette application n'est pas une _"vraie"_ application en production.
Par exemple, je n'ai qu'une seule entité JPA...
Cependant, je la trouve représentative et espère (très modestement) que mon retour d'expérience pourra servir.

[La Pull Request correspondante est disponible sur GitHub](https://github.com/alexandre-touret/rest-apis-versioning-workshop/pull/11/files).

## Pré-requis

Une documentation existe.
Vous pouvez la consulter [ici](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.0-Migration-Guide).
Il existe aussi plusieurs articles sur le blog du projet Spring. Voici [un exemple](https://spring.io/blog/2022/05/24/preparing-for-spring-boot-3-0).

## Dépendances et configuration des plugins

### JDK

Pour Spring Boot 3, il faut impérativement utiliser un [JDK >=17](https://openjdk.org/projects/jdk/17/).

### Mises à jour

L'une des premières actions à réaliser est de migrer votre application vers [la version 2.7](https://spring.io/blog/2022/06/23/spring-boot-2-7-1-available-now).

À l'heure où j'écris cet article, la version de Spring Cloud est encore en version RC. 
J'ai donc dû ajouter le repository _"milestone"_ de Spring:

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

## Migration namespace javax vers jakartaee

Selon votre code, les dépendances que vous pouvez avoir, cette étape pourra aller du renommage des import javax vers jakarta à d'innombrables maux de tête.

Si vous utilisez Spring Boot au-dessus d'un Tomcat (c.-à-d. en mode _old school_), il  vous faudra mettre à jour le conteneur de servlet à une version compatible.

Dans mon application, je n'ai eu qu'à modifier les imports dans les entités,  filtres et méthodes annotées par l'annotation ``@PostConstruct()``.

```java
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
...
```

Sur ce sujet, Jetbrains a [publié un tutoriel sur la migration vers Jakarta](https://www.jetbrains.com/idea/guide/tutorials/migrating-javax-jakarta/).

## Distributed Tracing et observabilité

Spring embarque désormais plusieurs fonctionnalités liées à l'observabilité sous forme de starters. 
Dans mon cas, [j'avais embarqué opentracing (qui était déprécié depuis quelques temps) et me connectait sur Jaeger](https://blog.worldline.tech/2021/09/22/enabling_distributed_tracing_in_spring_apps.html).

J'ai suivi [cet article](https://spring.io/blog/2022/10/12/observability-with-spring-boot-3) paru sur le blog de Spring.
J'ai par conséquent basculé sur [Zipkin](https://zipkin.io/) (pour mon Workshop, l'utilisation du distributed tracing est un peu la cerise sur le gâteau).

Voici les starters que j'ai intégrés :

```groovy
implementation 'io.micrometer:micrometer-tracing-bridge-brave'
implementation 'io.zipkin.reporter2:zipkin-reporter-brave'
implementation 'io.opentelemetry:opentelemetry-exporter-zipkin'
implementation 'org.springframework.boot:spring-boot-starter-aop'
```

J'ai par la suite intégré les propriétés suivantes dans la configuration:

```yaml
spring:
 zipkin:
    base-url: http://localhost:9411
    sender:
      type: web


management:
  tracing:
    sampling:
      probability: 1.0
  metrics:
    distribution:
      percentiles-histogram:
        http:
          server:
            requests: true
```
 
Je pense que j'aurai pu faire fonctionner [Jaeger](https://www.jaegertracing.io/). 
Je n'ai pas voulu perdre de temps (SnowcampIO arrive bientôt...).

## Securité
J'ai eu quelques soucis après avoir mis à jour Spring Authorization Server et Spring Security.
Je pense que la version précédente de Spring était plus permissive sur l'injection et le nom des beans chargés dans les classes Configuration.

J'ai donc revu [la validation côté gateway et plus particulièrement la validation du jeton JWT](https://github.com/alexandre-touret/rest-apis-versioning-solution/pull/3/files#diff-8e3d0d23edcf12597216d4469b5a3576c0b4d3d24a4cee740cb2ae67481fe006).

J'ai dû notamment ajouter le paramètre ``jwk-set-uri`` qui est obligatoire maintenant :

```yaml
    resourceserver:
        jwt:
          jwk-set-uri: http://localhost:8009
```

Je n'ai pas eu de [réels problèmes coté Authorization Server car j'avais déjà migré vers la version 0.4.0](https://github.com/spring-projects/spring-authorization-server/).

## Conclusion

Vous l'aurez compris, si vous faites l'effort de suivre régulièrement les versions de Spring, vous devriez venir à bout facilement de la migration vers la dernière version de Spring.

Néanmoins, sur des projets conséquents (et je ne parle pas de ceux où il n'y a de tests automatisés...) ça peut s'avérer coûteux.
Certaines actions et contournements peuvent prendre du temps (ex. javax --> jakarta).

Enfin, je vous conseille d'attendre la première version mineure et la version définitive de Spring Cloud avant de vous lancer pour _"de vrai"_. 
Bien que Spring ait fait un effort de documentation pour la migration, il est plus sage d'attendre que les premiers correctifs soient publiés avant de vous lancer.

