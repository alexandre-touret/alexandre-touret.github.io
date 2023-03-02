---
id: 113
title: "Tracer (facilement) les entrées sorties d'une API REST"
date: 2018-12-01T15:51:50+01:00

featuredImage: /assets/images/2018/12/street_city_people_blackandwhite_bw_man_detail_project-248333-jpgd.jpeg
featuredImagePreview: /assets/images/2018/12/street_city_people_blackandwhite_bw_man_detail_project-248333-jpgd.jpeg
images: ["/assets/images/2018/12/street_city_people_blackandwhite_bw_man_detail_project-248333-jpgd.jpeg"]

tags:
  - logbook
  - planetlibre
  - spring
  - springboot
---

Il y a quelques jours, je cherchais comment tracer rapidement et simplement les entrées sorties d'une [API REST](https://fr.wikipedia.org/wiki/Representational_state_transfer) en appliquant quelques formatages, des filtres, et des insertions en base si besoin.

Travaillant sur une stack [SpringBoot](https://spring.io/projects/spring-boot), vous allez me dire : oui tu peux faire des filtres. Pour être franc, j'ai essayé d' appliquer des [interceptor](https://www.baeldung.com/spring-mvc-handlerinterceptor) et [filtres](https://www.baeldung.com/spring-boot-add-filter) mais dans mon contexte, ça ne collait pas.

Me voilà donc à la recherche d'une solution faisant le taff et qui soit peu intrusive dans mon contexte. 

J'ai trouvé par hasard au fil de mes lectures sur Stackoverflow le framework [logbook](https://github.com/zalando/logbook) réalisé par &#8230; Zalando ( et oui, ils ne font pas que des chaussures) en licence MIT.   
Ce composant ne fait qu'une seule chose, mais il le fait bien ! 

Il permet entre autres de s'intégrer dans une stack JAVA ( JAX-RS ou SpringMVC), de filtrer, récupérer les différentes informations des requêtes et réponses et enfin de formatter selon l'envie (ex. JSON).  
  
Voici un exemple de mise en œuvre dans un projet SpringBoot:

Dans le  fichier pom.xml, ajouter cette dépendance:


```xml
<dependency>
 <groupId>org.zalando</groupId>
 <artifactId>logbook-spring-boot-starter</artifactId>
 <version>1.11.2</version>
</dependency>
```


Dans une de vos classes [Configuration](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Configuration.html), définir la factory de Logbook

```java
@Bean
public Logbook createLogBook() {
  // too easy : return Logbook.create();
  return Logbook.builder()
                  .condition(Conditions.requestTo("/helloworld"))
                  .formatter(new JsonHttpLogFormatter()).build();
}
```


Dans mon cas j'ai fait un filtre en n'incluant que l' API /helloworld et j'ai formatté en JSON.  
On peut également modifier le processus d'écriture pour ne pas écrire dans un fichier mais en base par ex.  


Ensuite, j'ai ajouté la configuration du logger dans le fichier application.properties

```ini
logging.level.org.zalando.logbook:TRACE
```


Et voila ! 

Dans la console, lors d'un appel ou d'une réponse à mon API, j'ai le message suivant :


```bash
018-12-01 15:14:18.373 TRACE 3605 --- [nio-8080-exec-1] org.zalando.logbook.Logbook              : {"origin":"remote","type":"request","correlation":"c6b345013835273f","protocol":"HTTP/1.1","remote":"127.0.0.1","method":"GET","uri":"http://127.0.0.1:8080/helloworld","headers":{"accept":["/"],"host":["127.0.0.1:8080"],"user-agent":["curl/7.52.1"]}}
2018-12-01 15:14:18.418 TRACE 3605 --- [nio-8080-exec-1] org.zalando.logbook.Logbook              : {"origin":"local","type":"response","correlation":"c6b345013835273f","duration":48,"protocol":"HTTP/1.1","status":200,"headers":{"Content-Length":["11"],"Content-Type":["text/plain;charset=UTF-8"],"Date":["Sat, 01 Dec 2018 14:14:18 GMT"]},"body":"Hello world"}
```


Vous remarquerez que les requêtes / réponses peuvent désormais être associés grâce à un identifiant de corrélation. On peut facilement déterminer le temps de traitement d'une requête ou encore faciliter les recherches.  


Vous trouverez tout le code dans [ce repo github](https://github.com/littlewing/demo-logbook).