---
date: "2021-07-26T11:53:49Z"
featuredImagePreview: "/assets/images/2021/07/rest-book-architecture.png"
featuredImage: "/assets/images/2021/07/rest-book-architecture.png"
images: ["/assets/images/2021/07/rest-book-architecture.png"]

tags:
- github
- java
- observability
- planetlibre
- spring
timeline_notification:
- "1627293232"
title: Observabilité et Circuit Breaker avec Spring
---
Il y a quelques mois déjà, je discutais avec [un collègue](https://jefrajames.fr/) d' observabilité, [opentracing](https://github.com/opentracing-contrib/java-spring-cloud), &#8230; avec [Quarkus](http://quarkus.io/). On est tombé sur [un super exemple réalisé par Antonio Concalves](https://github.com/agoncal/agoncal-fascicle-quarkus-pract). Ce projet démontre les capacités de Quarkus sur les sujets suivants:

  * Circuit Breaker
  * Observabilité 
  * OpenTracing
  * Tests
  * &#8230; 

Et la on peut se demander quid de [Spring](http://spring.io/)? Je me doutais que ces fonctionnalités étaient soient disponibles par défaut soient facilement intégrables vu la richesse de l'écosystème.

J'ai donc réalisé un clone de [ce projet basé sur Spring Boot/Cloud](https://github.com/alexandre-touret/bookstore_spring). Je ne vais pas détailler plus que ça les différentes fonctionnalités, vous pouvez vous référer au fichier [README](https://github.com/alexandre-touret/bookstore_spring#readme). Il est suffisamment détaillé pour que vous puissiez exécuter et les mettre en œuvre.

## Architecture de l'application

Vous trouverez ci-dessous un schéma d'architecture de l'application [au format C4](https://c4model.com/).

## Circuit Breaker

Lors des appels entre le [bookstore](https://github.com/alexandre-touret/bookstore_spring/blob/main/rest-book/src/main/java/info/touret/bookstore/spring/book/service/BookService.java) et le [booknumberservice](https://github.com/alexandre-touret/bookstore_spring/blob/main/rest-number/src/main/java/info/touret/bookstore/spring/number/controller/BookNumbersController.java), il peut être intéressant d' implémenter un [circuit breaker](https://martinfowler.com/bliki/CircuitBreaker.html) pour pallier aux indisponibilités de ce dernier.  
Avec Spring, on peut utiliser [Resilience4J](https://github.com/resilience4j/resilience4j) au travers de [Spring Cloud](https://spring.io/projects/spring-cloud). Tout ceci se fait de manière programmatique

Il faut tout d'abord [configurer les circuit breakers au travers d'une classe Configuration](https://github.com/alexandre-touret/bookstore_spring/blob/main/rest-book/src/main/java/info/touret/bookstore/spring/book/BookConfiguration.java).



```java
@Bean
    public Customizer<Resilience4JCircuitBreakerFactory> createDefaultCustomizer() {
        return factory -> factory.configureDefault(id -> new Resilience4JConfigBuilder(id)
                .timeLimiterConfig(TimeLimiterConfig.custom().timeoutDuration(Duration.ofSeconds(timeoutInSec)).build())
                .circuitBreakerConfig(CircuitBreakerConfig.ofDefaults())
                .build());
    }

    /**
     * Creates a circuit breaker customizer applying a timeout specified by the <code>booknumbers.api.timeout_sec</code> property.
     * This customizer could be reached using this id: <code>slowNumbers</code>
     * @return the circuit breaker customizer to apply when calling to numbers api
     */
    @Bean
    public Customizer<Resilience4JCircuitBreakerFactory> createSlowNumbersAPICallCustomizer() {
        return factory -> factory.configure(builder -> builder.circuitBreakerConfig(CircuitBreakerConfig.ofDefaults())
                .timeLimiterConfig(TimeLimiterConfig.custom().timeoutDuration(Duration.ofSeconds(timeoutInSec)).build()), "slowNumbers");
    }
```


Grâce à ces instanciations, on référence les différents [circuit breakers](https://martinfowler.com/bliki/CircuitBreaker.html).

Maintenant, on peut les utiliser dans le code de la manière suivante:

```java
public Book registerBook(@Valid Book book) {
        circuitBreakerFactory.create("slowNumbers").run(
                () -> persistBook(book),
                throwable -> fallbackPersistBook(book)
        );

        return bookRepository.save(book);
    }
```


Maintenant, il ne reste plus qu'à créer [une méthode de « fallback » utilisée si un service est indisponible](https://github.com/alexandre-touret/bookstore_spring/blob/main/rest-book/src/main/java/info/touret/bookstore/spring/book/service/BookService.java). Cette dernière nous permettra, par exemple, de mettre le payload dans un fichier pour futur traitement batch.

## Observabilité

L'observabilité est sans contexte la pierre angulaire (oui, rien que ça&#8230;) de toute application cloud native. Sans ça, pas de scalabilité, de redémarrage automatique,etc.  
Les architectures de ce type d'applications sont [idempotentes](https://en.wikipedia.org/wiki/Idempotence). On a donc besoin d'avoir toutes les informations à notre disposition. Heureusement, [Spring fournit par le biais d' Actuator](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#actuator) toutes les informations nécessaires. Ces dernières pourront soit être utilisées par [Kubernetes](https://kubernetes.io/) (ex. le [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)) ou agrégées dans une base de données [Prometheus](https://prometheus.io/docs/prometheus/latest/storage/).

Pour activer certaines métriques d'[actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html), il suffit de :

Ajouter la/les dépendance(s)

```groovy
dependencies {
[...]
        implementation 'org.springframework.boot:spring-boot-starter-actuator'
        implementation 'io.micrometer:micrometer-registry-prometheus'
     [...]
    }
```


Spécifier la configuration adéquate:

```java
management:
  endpoints:
    enabled-by-default: true
    web:
      exposure:
        include: '*'
    jmx:
      exposure:
        include: '*'
  endpoint:
    health:
      show-details: always
      enabled: true
      probes:
        enabled: true
    shutdown:
      enabled: true
    prometheus:
      enabled: true
    metrics:
      enabled: true
  health:
    livenessstate:
      enabled: true
    readinessstate:
      enabled: true
    datasource:
      enabled: true
  metrics:
    web:
      client:
        request:
          autotime:
            enabled: true
```


## OpenTracing

Sur les applications distribuées, il peut s'avérer compliqué de concentrer les logs et de les corréler. Certes, avec un ID de corrélation, on peut avoir certaines informations. Cependant, il faut que les logs soient bien positionnées dans le code. On peut également passer à travers de certaines informations (ex. connexion aux bases de données, temps d'exécution des APIS,&#8230;). Je ne vous parle pas des soucis de volumétrie engendrées par des index Elasticsearch/Splunk sur des applications à forte volumétrie.

Depuis quelques temps, le [CNCF](https://www.cncf.io/) propose un projet (encore en incubation) : [OpenTracing](https://opentracing.io/). Ce dernier fait désormais partie d'[OpenTelemetry](https://opentelemetry.io/).  
Grâce à cet librairie, nous allons pouvoir tracer toutes les transactions de notre application microservices et pouvoir réaliser une corrélation « out of the box » grâce à l'intégration avec [Jaeger](https://www.jaegertracing.io/).

Pour activer la fonctionnalité il suffit d'ajouter la dépendance au classpath:

```groovy
implementation 'io.opentracing.contrib:opentracing-spring-jaeger-cloud-starter:3.3.1'
```


et de configurer l'URL de Jaeger dans l'application

```yaml
# Default values
opentracing:
  jaeger:
    udp-sender:
      host: localhost
      port: 6831
    enabled: true
```


Une fois l'application reconstruite et redémarrée, vous pourrez visualiser les transactions dans JAEGER:

![jaeger1](/assets/images/2021/07/screenshot-2021-07-26-at-11-38-31-jaeger-ui.png)
![jaeger2](/assets/images/2021/07/screenshot-2021-07-26-at-11-38-15-jaeger-ui.png)


## Conclusion

Je ne vais pas exposer l'implémentation des tests unitaires et d'intégration. Si vous voulez voir comment j'ai réussi à mocker simplement les appels REST à une API distante, vous pouvez regarder [cette classe](https://github.com/alexandre-touret/bookstore_spring/blob/main/rest-book/src/test/java/info/touret/bookstore/spring/book/controller/BookControllerIT.java) pour voir une utilisation du [MockServer](https://www.baeldung.com/mockserver).  
Aussi, n'hésitez pas à cloner, tester ce projet et me donner votre retour. J'essaierai de le mettre à jour au fur et à mesure de mes découvertes (par ex. OpenTelemetry).