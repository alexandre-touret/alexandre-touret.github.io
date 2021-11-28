---
id: 222
title: Partager des variables entre scénarios gatling
date: 2019-11-21T22:12:53+01:00
author: admin
layout: post


timeline_notification:
  - "1574370773"
publicize_twitter_user:
  - touret_alex
tags:
  - gatling
  - Planet-Libre
  - scala
---
Je suis en train de mettre en œuvre des tests de performance avec [Gatling](https://gatling.io/). Un des principaux outils libres de tests de performance.<figure class="wp-block-image size-large">

<img loading="lazy" width="800" height="500" src="/assets/img/posts/2019/11/gatling-new-design.png?w=612" alt="" class="wp-image-236" srcset="/assets/img/posts/2019/11/gatling-new-design.png 800w, /assets/img/posts/2019/11/gatling-new-design-300x188.png 300w, /assets/img/posts/2019/11/gatling-new-design-768x480.png 768w" sizes="(max-width: 800px) 100vw, 800px" /> </figure> 

J&rsquo;ai eu récemment à résoudre un « petit » soucis : je souhaitai partager des variables entre plusieurs [scénarios](https://gatling.io/docs/2.2/general/scenario). Il existe pas mal de solutions sur stackoverflow. J&rsquo;ai condensé certaines d&rsquo;entre elles pour les adapter à mon besoin.  
Ces variables sont issues de exécution d&rsquo;une seule requête et sont automatiquement injectées dans les scénarios suivants. Ce mécanisme permet par exemple de récupérer un jeton d&rsquo;un serveur d&rsquo;identification et de l&rsquo;injecter pour le scénario que l&rsquo;on souhaite tester.

Pour ce faire, il faut ajouter une variable de type `LinkedBlockingDeque` et injecter le contenu choisi via la session

```java
val holder = new LinkedBlockingDeque[String]() 
...
val firstScenario = scenario("First Simulation")
		.exec(http("first scenario")
			.post("/base/url1")
			.check(jsonPath("$.my_variable").find.saveAs("variable")))
		.exec(session =&gt; {
            holder.offerLast(session("variable").as[String])
            session}       
        );

```


Maintenant on peut l&rsquo;utiliser dans un autre scénario comme [feeder](https://gatling.io/docs/2.2/session/feeder/):

```java
val secondScenario = scenario("Second Simulation")
		.feed(sharedDataFeeder)
```


Voici l&rsquo;exemple complet  
[gist https://gist.github.com/littlewing/bdba509353c7b42de85d9a90c0352aa7#file-gatling\_scenario\_with\_shared\_values-scala]  
  
En espérant que cela puisse aider à certain.e.s d&rsquo;entre vous 🙂