---
id: 222
title: Partager des variables entre scénarios gatling
date: 2019-11-21T22:12:53+01:00

featuredImagePreview: /assets/images/2019/11/gatling-new-design.png
featuredImage: /assets/images/2019/11/gatling-new-design.png
og_image: /assets/images/2019/11/gatling-new-design.png

timeline_notification:
  - "1574370773"
publicize_twitter_user:
  - touret_alex
tags:
  - gatling
  - planetlibre
  - scala
---
Je suis en train de mettre en œuvre des tests de performance avec [Gatling](https://gatling.io/). Un des principaux outils libres de tests de performance.

J'ai eu récemment à résoudre un « petit » soucis : je souhaitai partager des variables entre plusieurs [scénarios](https://gatling.io/docs/2.2/general/scenario). Il existe pas mal de solutions sur stackoverflow. J'ai condensé certaines d'entre elles pour les adapter à mon besoin.  
Ces variables sont issues de exécution d'une seule requête et sont automatiquement injectées dans les scénarios suivants. Ce mécanisme permet par exemple de récupérer un jeton d'un serveur d'identification et de l'injecter pour le scénario que l'on souhaite tester.

Pour ce faire, il faut ajouter une variable de type `LinkedBlockingDeque` et injecter le contenu choisi via la session

```java
val holder = new LinkedBlockingDeque[String]() 
...
val firstScenario = scenario("First Simulation")
		.exec(http("first scenario")
			.post("/base/url1")
			.check(jsonPath("$.my_variable").find.saveAs("variable")))
		.exec(session => {
            holder.offerLast(session("variable").as[String])
            session}       
        );

```


Maintenant on peut l'utiliser dans un autre scénario comme [feeder](https://gatling.io/docs/2.2/session/feeder/):

```java
val secondScenario = scenario("Second Simulation")
		.feed(sharedDataFeeder)
```


Voici l'exemple complet



{{< gist alexandre-touret bdba509353c7b42de85d9a90c0352aa7 >}}

En espérant que cela puisse aider à certain.e.s d'entre vous 🙂