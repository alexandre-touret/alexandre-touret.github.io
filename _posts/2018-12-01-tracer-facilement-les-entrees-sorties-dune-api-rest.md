---
id: 113
title: 'Tracer (facilement) les entrées sorties d&rsquo;une API REST'
date: 2018-12-01T15:51:50+01:00




timeline_notification:
  - "1543675914"
publicize_linkedin_url:
  - www.linkedin.com/updates?topic=6474646066024321024
publicize_twitter_user:
  - touret_alex
tags:
  - logbook
  - planetlibre
  - spring
  - springboot
---
<figure class="wp-block-image"><img loading="lazy" width="1200" height="1200" src="/assets/images/2018/12/street_city_people_blackandwhite_bw_man_detail_project-248333-jpgd.jpeg" alt="" class="wp-image-115" srcset="/assets/images/2018/12/street_city_people_blackandwhite_bw_man_detail_project-248333-jpgd.jpeg 1200w, /assets/images/2018/12/street_city_people_blackandwhite_bw_man_detail_project-248333-jpgd-300x300.jpeg 300w, /assets/images/2018/12/street_city_people_blackandwhite_bw_man_detail_project-248333-jpgd-1024x1024.jpeg 1024w, /assets/images/2018/12/street_city_people_blackandwhite_bw_man_detail_project-248333-jpgd-150x150.jpeg 150w, /assets/images/2018/12/street_city_people_blackandwhite_bw_man_detail_project-248333-jpgd-768x768.jpeg 768w" sizes="(max-width: 1200px) 100vw, 1200px" /></figure> 

Il y a quelques jours, je cherchais comment tracer rapidement et simplement les entrées sorties d&rsquo;une [API REST](https://fr.wikipedia.org/wiki/Representational_state_transfer) en appliquant quelques formatages, des filtres, et des insertions en base si besoin.

Travaillant sur une stack [SpringBoot](https://spring.io/projects/spring-boot), vous allez me dire : oui tu peux faire des filtres. Pour être franc, j&rsquo;ai essayé d&rsquo; appliquer des [interceptor](https://www.baeldung.com/spring-mvc-handlerinterceptor) et [filtres](https://www.baeldung.com/spring-boot-add-filter) mais dans mon contexte, ça ne collait pas.

Me voilà donc à la recherche d&rsquo;une solution faisant le taff et qui soit peu intrusive dans mon contexte. 

J&rsquo;ai trouvé par hasard au fil de mes lectures sur Stackoverflow le framework [logbook](https://github.com/zalando/logbook) réalisé par &#8230; Zalando ( et oui, ils ne font pas que des chaussures) en licence MIT.   
Ce composant ne fait qu&rsquo;une seule chose, mais il le fait bien ! 

Il permet entre autres de s&rsquo;intégrer dans une stack JAVA ( JAX-RS ou SpringMVC), de filtrer, récupérer les différentes informations des requêtes et réponses et enfin de formatter selon l&rsquo;envie (ex. JSON).  
  
Voici un exemple de mise en œuvre dans un projet SpringBoot:

Dans le  fichier pom.xml, ajouter cette dépendance:

<pre class="wp-block-preformatted"><dependency><br />    <groupId>org.zalando</groupId><br />    <artifactId>logbook-spring-boot-starter</artifactId><br />    <version>1.11.2</version><br /></dependency><br /><br />
```


Dans une de vos classes [Configuration](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Configuration.html), définir la factory de Logbook

<pre class="wp-block-preformatted">@Bean<br />public Logbook createLogBook() {<br />    // too easy : return Logbook.create();<br />    return Logbook.<em>builder</em>()<br />            .condition(Conditions.<em>requestTo</em>("/helloworld"))<br />            .formatter(new JsonHttpLogFormatter())<br />            .build();<br />}
```


Dans mon cas j&rsquo;ai fait un filtre en n&rsquo;incluant que l&rsquo; API /helloworld et j&rsquo;ai formatté en JSON.  
On peut également modifier le processus d&rsquo;écriture pour ne pas écrire dans un fichier mais en base par ex.  


Ensuite, j&rsquo;ai ajouté la configuration du logger dans le fichier application.properties

<pre class="wp-block-preformatted">logging.level.org.zalando.logbook:TRACE<br />
```


Et voila ! 

Dans la console, lors d&rsquo;un appel ou d&rsquo;une réponse à mon API, j&rsquo;ai le message suivant :



<pre class="wp-block-preformatted">018-12-01 15:14:18.373 TRACE 3605 --- [nio-8080-exec-1] org.zalando.logbook.Logbook              : {"origin":"remote","type":"request","correlation":"c6b345013835273f","protocol":"HTTP/1.1","remote":"127.0.0.1","method":"GET","uri":"http://127.0.0.1:8080/helloworld","headers":{"accept":["<em>/</em>"],"host":["127.0.0.1:8080"],"user-agent":["curl/7.52.1"]}}<br />
2018-12-01 15:14:18.418 TRACE 3605 --- [nio-8080-exec-1] org.zalando.logbook.Logbook              : {"origin":"local","type":"response","correlation":"c6b345013835273f","duration":48,"protocol":"HTTP/1.1","status":200,"headers":{"Content-Length":["11"],"Content-Type":["text/plain;charset=UTF-8"],"Date":["Sat, 01 Dec 2018 14:14:18 GMT"]},"body":"Hello world"}
```


Vous remarquerez que les requêtes / réponses peuvent désormais être associés grâce à un identifiant de corrélation. On peut facilement déterminer le temps de traitement d&rsquo;une requête ou encore faciliter les recherches.  




Vous trouverez tout le code dans [ce repo github](https://github.com/littlewing/demo-logbook).