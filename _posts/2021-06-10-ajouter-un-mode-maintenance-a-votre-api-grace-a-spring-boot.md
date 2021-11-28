---
id: 527
title: Ajouter un mode « maintenance » à votre API grâce à Spring boot
date: 2021-06-10T17:01:20+02:00
author: admin
layout: post
thumbnail-img: /assets/img/posts/2021/06/pexels-photo-257736.jpeg

timeline_notification:
  - "1623337284"
publicize_twitter_user:
  - touret_alex
publicize_linkedin_url:
  - ""
  - logiciels libres
tags:
  - actuator
  - observability
  - Planet-Libre
  - spring
  - springboot
---
<div class="wp-block-image">
  <figure class="aligncenter size-large is-resized"><img loading="lazy" src="/assets/img/posts/2021/06/pexels-photo-257736.jpeg" alt="" class="wp-image-543" width="697" height="463" srcset="/assets/img/posts/2021/06/pexels-photo-257736.jpeg 1880w, /assets/img/posts/2021/06/pexels-photo-257736-300x200.jpeg 300w, /assets/img/posts/2021/06/pexels-photo-257736-1024x681.jpeg 1024w, /assets/img/posts/2021/06/pexels-photo-257736-768x511.jpeg 768w, /assets/img/posts/2021/06/pexels-photo-257736-1536x1022.jpeg 1536w, /assets/img/posts/2021/06/pexels-photo-257736-1568x1043.jpeg 1568w" sizes="(max-width: 697px) 100vw, 697px" /><figcaption>Photo by Pixabay on <a href="https://www.pexels.com/photo/close-up-of-telephone-booth-257736/" rel="nofollow">Pexels.com</a></figcaption></figure>
</div>

<p class="has-drop-cap">
  Quand vous avez une API, et a fortiori une application, il peut être parfois nécessaire de passer l&rsquo;application en mode « maintenance ».<br />Pour certaines applications il est parfois inutile de le traiter au niveau applicatif, car ça peut être pris géré par certaines couches de sécurité ou frontaux web par ex. (<a href="https://httpd.apache.org/">Apache HTTPD</a>, <a href="https://fr.wikipedia.org/wiki/Web_application_firewall">WAF</a>,&#8230;)
</p>

[Kubernetes a introduit ( ou popularisé ) les notions de « probes »](https://kubernetes.io/fr/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) et plus particulièrement les [livenessProbes](https://kubernetes.io/fr/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) et [readinessProbes](https://kubernetes.io/fr/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/).  
Le premier nous indique si l&rsquo;application est en état de fonctionnement, le second nous permet de savoir si cette dernière est apte à recevoir des requêtes (ex. lors d&rsquo;un démarrage).



Je vais exposer dans cet article comment utiliser au mieux ces probes et [les APIs SPRING](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/) pour intégrer dans une API un mode « maintenance »

## Stack utilisée

Dans l&rsquo;exemple que j&rsquo;ai développé, j&rsquo;ai pu utiliser les briques suivantes:  


  * OpenJDK 11.0.10
  * Spring Boot 2.5.0 (web, actuator)
  * Maven 3.8.1

Bref, rien de neuf à l&rsquo;horizon 🙂

## Configuration de Spring Actuator

Pour activer les différents probes, vous devez activer [Actuator](https://docs.spring.io/spring-boot/docs/2.4.0/actuator-api/).

Dans le fichier pom.xml, vous devez ajouter le starter correspondant:

```java
&lt;dependency&gt;
    &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
	&lt;artifactId&gt;spring-boot-starter-actuator&lt;/artifactId&gt;
&lt;/dependency&gt;
```


Puis vous devez déclarer ces differentes [propriétés](https://github.com/alexandre-touret/maintenance-mode/blob/main/src/main/resources/application.properties):

```java
management.endpoints.enabled-by-default=true
management.health.livenessstate.enabled=true
management.health.readinessstate.enabled=true
management.endpoint.health.show-details=always
management.endpoint.health.probes.enabled=true
management.endpoint.health.enabled=true
```


Après avoir redémarré votre application, vous pourrez connaître son statut grâce à un appel HTTP

```java
curl -s http://localhost:8080/actuator/health/readiness 
```


## Comment récupérer le statut des probes?

Avec Spring, vous pouvez modifier les différents statuts avec les classes [ApplicationEventPublisher](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/ApplicationEventPublisher.html) et [ApplicationAvailability](https://docs.spring.io/spring-boot/docs/2.4.4/api/org/springframework/boot/availability/ApplicationAvailability.html).

Par exemple, pour connaître le statut `<a href="https://docs.spring.io/spring-boot/docs/2.5.0-SNAPSHOT/api/org/springframework/boot/availability/ReadinessState.html">"Readiness"</a>` vous pouvez exécuter le code suivant:

```java
@ApiResponses(value = {
 @ApiResponse(responseCode = "200", description = "Checks if the application in under maitenance")})
 @GetMapping
 public ResponseEntity&lt;MaintenanceDTO&gt; retreiveInMaintenance() {
        var lastChangeEvent = availability.getLastChangeEvent(ReadinessState.class);
        return ResponseEntity.ok(new MaintenanceDTO(lastChangeEvent.getState().equals(ReadinessState.REFUSING_TRAFFIC), new Date(lastChangeEvent.getTimestamp())));
    }
```


Et la modification ?

Grâce à la même API, on peut également modifier ce statut dans via du code:

```java
@ApiResponses(value = {
@ApiResponse(responseCode = "204", description = "Put the app under maitenance")})
@PutMapping
public ResponseEntity&lt;Void&gt; initInMaintenance(@NotNull @RequestBody String inMaintenance) {
        AvailabilityChangeEvent.publish(eventPublisher, this, Boolean.valueOf(inMaintenance) ? ReadinessState.REFUSING_TRAFFIC : ReadinessState.ACCEPTING_TRAFFIC);
        return ResponseEntity.noContent().build();
}
```


## Filtre les appels et indiquer que l&rsquo;application est en maintenance

Maintenant qu&rsquo;on a codé les mécanismes de récupération du statut de l&rsquo;application et de la mise en maintenance, on peut ajouter le mécanisme permettant de traiter ou non les appels entrants.  
Pour ça on va utiliser un [bon vieux filtre servlet](http://blog.paumard.org/cours/servlet/chap04-filtre-mise-en-place.html).  


Ce dernier aura la tâche de laisser passer les requêtes entrantes si l&rsquo;application n&rsquo;est pas en maintenance et de déclencher une [MaintenanceException](https://github.com/alexandre-touret/maintenance-mode/blob/main/src/main/java/info/touret/spring/maintenancemode/exception/MaintenanceException.java) le cas échéant qui sera traité par [la gestion d&rsquo;erreur globale de l&rsquo;application](https://github.com/alexandre-touret/maintenance-mode/blob/main/src/main/java/info/touret/spring/maintenancemode/GlobalExceptionHandler.java) ( traité via un [@RestControllerAdvice](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/RestControllerAdvice.html)).  


Pour que l&rsquo;exception soit bien traitée par ce mécanisme, il faut le déclencher via le [HandlerExceptionResolver](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/servlet/HandlerExceptionResolver.html).

```java
@Component
public class CheckMaintenanceFilter implements Filter {
    private final static Logger LOGGER = LoggerFactory.getLogger(CheckMaintenanceFilter.class);
    @Autowired
    private ApplicationAvailability availability;

    @Autowired
    @Qualifier("handlerExceptionResolver")
    private HandlerExceptionResolver exceptionHandler;

    /**
     * Checks if the application is under maintenance. If it is and if the requested URI is not '/api/maintenance', it throws a &lt;code&gt;MaintenanceException&lt;/code&gt;
     *
     * @param request
     * @param response
     * @param chain
     * @throws IOException
     * @throws ServletException
     * @throws info.touret.spring.maintenancemode.exception.MaintenanceException the application is under maintenance
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        if (availability.getReadinessState().equals(ReadinessState.REFUSING_TRAFFIC) &&
                !((HttpServletRequest) request).getRequestURI().equals(API_MAINTENANCE_URI)) {
            LOGGER.warn("Message handled during maintenance [{}]", ((HttpServletRequest) request).getRequestURI());
            exceptionHandler.resolveException((HttpServletRequest) request, (HttpServletResponse) response, null, new MaintenanceException("Service currently in maintenance"));
        } else {
            chain.doFilter(request, response);
        }
    }

}
```


Enfin, voici la gestion des erreurs de l&rsquo;API:

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * Indicates that the application is on maintenance
     */
    @ResponseStatus(HttpStatus.I_AM_A_TEAPOT)
    @ExceptionHandler(MaintenanceException.class)
    public APIError maintenance() {
        return new APIError(HttpStatus.I_AM_A_TEAPOT.value(),"Service currently in maintenance");
    }

    /**
     * Any other exception
     */
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler({RuntimeException.class, Exception.class})
    public APIError anyException() {
        return new APIError(HttpStatus.INTERNAL_SERVER_ERROR.value(),"An unexpected server error occured");
    }
}
```


## Conclusion

On a pu voir comment intéragir simplement avec les APIS SPRING pour gérer le statut de l&rsquo;application pour répondre à cette question :Est-elle disponible ou non?  
Bien évidemment, selon le contexte, il conviendra d&rsquo;ajouter un peu de sécurité pour que cette API ne soit pas disponible à tout le monde 🙂  
  
Le code exposé ici est disponible sur [Github](https://github.com/alexandre-touret/maintenance-mode/). Le [Readme](https://github.com/alexandre-touret/maintenance-mode/blob/main/README.md) est suffisamment détaillé pour que vous puissiez tester et réutiliser le code.