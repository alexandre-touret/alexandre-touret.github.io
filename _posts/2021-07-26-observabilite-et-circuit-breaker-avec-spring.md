---
id: 563
title: Observabilité et Circuit Breaker avec Spring
date: 2021-07-26T11:53:49+02:00
author: admin
layout: post


spay_email:
  - ""
jetpack_anchor_podcast:
  - ""
jetpack_anchor_episode:
  - ""
jetpack_anchor_spotify_show:
  - ""
timeline_notification:
  - "1627293232"
publicize_twitter_user:
  - touret_alex
categories:
  - logiciels libres
tags:
  - github
  - java
  - observability
  - Planet-Libre
  - spring
---
Il y a quelques mois déjà, je discutais avec [un collègue](https://jefrajames.fr/) d&rsquo; observabilité, [opentracing](https://github.com/opentracing-contrib/java-spring-cloud), &#8230; avec [Quarkus](http://quarkus.io/). On est tombé sur [un super exemple réalisé par Antonio Concalves](https://github.com/agoncal/agoncal-fascicle-quarkus-pract). Ce projet démontre les capacités de Quarkus sur les sujets suivants:

  * Circuit Breaker
  * Observabilité 
  * OpenTracing
  * Tests
  * &#8230; 

Et la on peut se demander quid de [Spring](http://spring.io/)? Je me doutais que ces fonctionnalités étaient soient disponibles par défaut soient facilement intégrables vu la richesse de l&rsquo;écosystème.

J&rsquo;ai donc réalisé un clone de [ce projet basé sur Spring Boot/Cloud](https://github.com/alexandre-touret/bookstore_spring). Je ne vais pas détailler plus que ça les différentes fonctionnalités, vous pouvez vous référer au fichier [README](https://github.com/alexandre-touret/bookstore_spring#readme). Il est suffisamment détaillé pour que vous puissiez exécuter et les mettre en œuvre.

## Architecture de l&rsquo;application

Vous trouverez ci-dessous un schéma d&rsquo;architecture de l&rsquo;application [au format C4](https://c4model.com/).

  


<div class="wp-block-image">
  <figure class="aligncenter size-large"><img loading="lazy" width="825" height="668" src="/assets/img/posts/2021/07/rest-book-architecture.png?w=825" alt="" class="wp-image-580" srcset="/assets/img/posts/2021/07/rest-book-architecture.png 825w, /assets/img/posts/2021/07/rest-book-architecture-300x243.png 300w, /assets/img/posts/2021/07/rest-book-architecture-768x622.png 768w" sizes="(max-width: 825px) 100vw, 825px" /></figure>
</div>

## Circuit Breaker

Lors des appels entre le [bookstore](https://github.com/alexandre-touret/bookstore_spring/blob/main/rest-book/src/main/java/info/touret/bookstore/spring/book/service/BookService.java) et le [booknumberservice](https://github.com/alexandre-touret/bookstore_spring/blob/main/rest-number/src/main/java/info/touret/bookstore/spring/number/controller/BookNumbersController.java), il peut être intéressant d&rsquo; implémenter un [circuit breaker](https://martinfowler.com/bliki/CircuitBreaker.html) pour pallier aux indisponibilités de ce dernier.  
Avec Spring, on peut utiliser [Resilience4J](https://github.com/resilience4j/resilience4j) au travers de [Spring Cloud](https://spring.io/projects/spring-cloud). Tout ceci se fait de manière programmatique

Il faut tout d&rsquo;abord [configurer les circuit breakers au travers d&rsquo;une classe Configuration](https://github.com/alexandre-touret/bookstore_spring/blob/main/rest-book/src/main/java/info/touret/bookstore/spring/book/BookConfiguration.java).

```java
@Bean
    public Customizer&lt;Resilience4JCircuitBreakerFactory&gt; createDefaultCustomizer() {
        return factory -&gt; factory.configureDefault(id -&gt; new Resilience4JConfigBuilder(id)
                .timeLimiterConfig(TimeLimiterConfig.custom().timeoutDuration(Duration.ofSeconds(timeoutInSec)).build())
                .circuitBreakerConfig(CircuitBreakerConfig.ofDefaults())
                .build());
    }

    /**
     * Creates a circuit breaker customizer applying a timeout specified by the &lt;code&gt;booknumbers.api.timeout_sec&lt;/code&gt; property.
     * This customizer could be reached using this id: &lt;code&gt;slowNumbers&lt;/code&gt;
     * @return the circuit breaker customizer to apply when calling to numbers api
     */
    @Bean
    public Customizer&lt;Resilience4JCircuitBreakerFactory&gt; createSlowNumbersAPICallCustomizer() {
        return factory -&gt; factory.configure(builder -&gt; builder.circuitBreakerConfig(CircuitBreakerConfig.ofDefaults())
                .timeLimiterConfig(TimeLimiterConfig.custom().timeoutDuration(Duration.ofSeconds(timeoutInSec)).build()), "slowNumbers");
    }
```

Grâce à ces instanciations, on référence les différents [circuit breakers](https://martinfowler.com/bliki/CircuitBreaker.html).

Maintenant, on peut les utiliser dans le code de la manière suivante:

```java
public Book registerBook(@Valid Book book) {
        circuitBreakerFactory.create("slowNumbers").run(
                () -&gt; persistBook(book),
                throwable -&gt; fallbackPersistBook(book)
        );

        return bookRepository.save(book);
    }
```


Maintenant, il ne reste plus qu&rsquo;à créer [une méthode de « fallback » utilisée si un service est indisponible](https://github.com/alexandre-touret/bookstore_spring/blob/main/rest-book/src/main/java/info/touret/bookstore/spring/book/service/BookService.java). Cette dernière nous permettra, par exemple, de mettre le payload dans un fichier pour futur traitement batch.

## Observabilité

L&rsquo;observabilité est sans contexte la pierre angulaire (oui, rien que ça&#8230;) de toute application cloud native. Sans ça, pas de scalabilité, de redémarrage automatique,etc.  
Les architectures de ce type d&rsquo;applications sont [idempotentes](https://en.wikipedia.org/wiki/Idempotence). On a donc besoin d&rsquo;avoir toutes les informations à notre disposition. Heureusement, [Spring fournit par le biais d&rsquo; Actuator](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#actuator) toutes les informations nécessaires. Ces dernières pourront soit être utilisées par [Kubernetes](https://kubernetes.io/) (ex. le [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)) ou agrégées dans une base de données [Prometheus](https://prometheus.io/docs/prometheus/latest/storage/).

Pour activer certaines métriques d&rsquo;[actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html), il suffit de :

Ajouter la/les dépendance(s)

```java
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

Sur les applications distribuées, il peut s&rsquo;avérer compliqué de concentrer les logs et de les corréler. Certes, avec un ID de corrélation, on peut avoir certaines informations. Cependant, il faut que les logs soient bien positionnées dans le code. On peut également passer à travers de certaines informations (ex. connexion aux bases de données, temps d&rsquo;exécution des APIS,&#8230;). Je ne vous parle pas des soucis de volumétrie engendrées par des index Elasticsearch/Splunk sur des applications à forte volumétrie.

Depuis quelques temps, le [CNCF](https://www.cncf.io/) propose un projet (encore en incubation) : [OpenTracing](https://opentracing.io/). Ce dernier fait désormais partie d&rsquo;[OpenTelemetry](https://opentelemetry.io/).  
Grâce à cet librairie, nous allons pouvoir tracer toutes les transactions de notre application microservices et pouvoir réaliser une corrélation « out of the box » grâce à l&rsquo;intégration avec [Jaeger](https://www.jaegertracing.io/).

Pour activer la fonctionnalité il suffit d&rsquo;ajouter la dépendance au classpath:

```java
implementation 'io.opentracing.contrib:opentracing-spring-jaeger-cloud-starter:3.3.1'
```


et de configurer l&rsquo;URL de Jaeger dans l&rsquo;application

```java
# Default values
opentracing:
  jaeger:
    udp-sender:
      host: localhost
      port: 6831
    enabled: true
```


Une fois l&rsquo;application reconstruite et redémarrée, vous pourrez visualiser les transactions dans JAEGER:<figure class="wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><img loading="lazy" width="2074" height="704" src="/assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-31-jaeger-ui.png?w=1024" alt="" data-id="586" data-link="https://blog.touret.info/screenshot-2021-07-26-at-11-38-31-jaeger-ui/" class="wp-image-586" srcset="/assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-31-jaeger-ui.png 2074w, /assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-31-jaeger-ui-300x102.png 300w, /assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-31-jaeger-ui-1024x348.png 1024w, /assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-31-jaeger-ui-768x261.png 768w, /assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-31-jaeger-ui-1536x521.png 1536w, /assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-31-jaeger-ui-2048x695.png 2048w, /assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-31-jaeger-ui-1568x532.png 1568w" sizes="(max-width: 2074px) 100vw, 2074px" /></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><img loading="lazy" width="2336" height="1131" src="/assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-15-jaeger-ui.png?w=1024" alt="" data-id="587" data-link="https://blog.touret.info/screenshot-2021-07-26-at-11-38-15-jaeger-ui/" class="wp-image-587" srcset="/assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-15-jaeger-ui.png 2336w, /assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-15-jaeger-ui-300x145.png 300w, /assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-15-jaeger-ui-1024x496.png 1024w, /assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-15-jaeger-ui-768x372.png 768w, /assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-15-jaeger-ui-1536x744.png 1536w, /assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-15-jaeger-ui-2048x992.png 2048w, /assets/img/posts/2021/07/screenshot-2021-07-26-at-11-38-15-jaeger-ui-1568x759.png 1568w" sizes="(max-width: 2336px) 100vw, 2336px" /></figure>
  </li>
</ul></figure> 

## Conclusion

Je ne vais pas exposer l&rsquo;implémentation des tests unitaires et d&rsquo;intégration. Si vous voulez voir comment j&rsquo;ai réussi à mocker simplement les appels REST à une API distante, vous pouvez regarder [cette classe](https://github.com/alexandre-touret/bookstore_spring/blob/main/rest-book/src/test/java/info/touret/bookstore/spring/book/controller/BookControllerIT.java) pour voir une utilisation du [MockServer](https://www.baeldung.com/mockserver).  
Aussi, n&rsquo;hésitez pas à cloner, tester ce projet et me donner votre retour. J&rsquo;essaierai de le mettre à jour au fur et à mesure de mes découvertes (par ex. OpenTelemetry).