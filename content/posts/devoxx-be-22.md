---
title: Ma première participation à Devoxx Belgium
date: 2022-10-15 08:00:00

featuredImagePreview: /assets/images/2022/10/devoxx_badge.webp
featuredImage: /assets/images/2022/10/devoxx_badge.webp

tags:
- conference
- java



---

Après trois ans d'inactivité pour des raisons que l'on connait malheureusement toutes et tous, [Devoxx Belgium](https://www.devoxx.be) était de retour à Anvers. 
Je n'avais jamais participé (en vrai) à une conférence internationale.

C'était donc une première pour moi.


Pour y aller, j'ai eu trois fois de la chance:
1. J'ai eu cette opportunité grâce à [Worldline - mon employeur](https://worldline.com/)  
2. J'ai réussi à avoir un billet pendant les cinq minutes où se sont vendus les billets lors du premier batch
3. [Ma présentation au format Quickie a été retenue](https://speakerdeck.com/alexandretouret/architecture-katas-improve-your-system-architecture-design-skills-in-a-fun-way). J'ai présenté un talk à Devoxx!!!!!!!

{{< gallery >}}
![configuration](/assets/images/2022/10/devoxx-be-22-1.webp)
![configuration](/assets/images/2022/10/devoxx-be-22-2.webp)
{{< /gallery >}}

Voici mon retour d'expérience des trois jours de conférence.

## Impressions générales

Tout d'abord, j'ai pu assister à de nombreux [Devoxx France](https://www.devoxx.fr/). J'ai cru naïvement que les deux évènements se ressembleraient. 

Je me suis trompé.

Je ne dirai pas lequel est le meilleur[^1]. Je ne saurais le dire. On est sur un autre type de conférence. 

Il y a un peu moins de feedback de la communauté, même si il y a eu [une présentation de Doctolib](https://www.youtube.com/watch?v=LoF2vkYiICo) et plus de présentations réalisées par des grands acteurs du marché ou par des grands speakers internationaux (ex. Simon Ritter, Simon Brown ou James Gosling). 

Aussi, alors que la ligne éditoriale de Devoxx France s'est tournée au fil des années sur d'autres langages et plateformes telles que NodeJS, Go, Scala, ici on est dans du Java pur et dur. 

Les (très) grands speakers de l'écosystème sont présents et on fait des super talks: [James Gosling](https://en.wikipedia.org/wiki/James_Gosling), [Simon Ritter](https://uk.linkedin.com/in/siritter), [Mario Fusco](https://developers.redhat.com/authors/mario-fusco), [Gavin King](https://in.relation.to/gavin-king/) ou [José Paumard](https://blogs.oracle.com/java/post/new-java-champion-jos%C3%A9-paumard).

En résumé, le coeur de la communauté [Java](https://en.wikipedia.org/wiki/Java_(programming_language)) bat à Anvers pendant une semaine. 
Une majorité de [Java champions](https://dev.java/community/jcs/) sont +/- présents et nous font partager leur expertise.

## Les tendances

Les grandes tendances étaient:
* L'IA et les applications
* Le projet Loom
* GraalVM

## Quelques conférences
L'ensemble des conférences [est déjà publié sur Youtube](https://www.youtube.com/c/Devoxx2015/videos). N' hésitez pas à les consulter. Il y a beaucoup de talks de qualité.

### Artificial Intelligence: You Are Here by Alan D Thompson

Le [Dr Alan D. Thompson](https://lifearchitect.ai/) est un expert en intelligence artificielle. 
Il nous a donné une présentation pendant la keynote sur ce que l' IA peut réellement faire de nos jours.
C'est de plus en plus utilisé dans notre industrie au travers de Github Copilot, [Codegeex](https://github.com/THUDM/CodeGeeX),...

Après nous avoir rappellé [la timeline de l'adoption de l' IA](https://lifearchitect.ai/timeline/), il a illustré avec des peintures déssinées par une IA comment un ordinateur peut maintenant comprendre une phrase en langage naturel et la traduire en image. 

Il a également présenté [le langage de modélisation GPT3](https://en.wikipedia.org/wiki/GPT-3).

Vous pouvez trouver [la vidéo ici](https://www.youtube.com/watch?v=xjYy91BxdPo).

## Revolutionizing Java-Based Applications with GraalVM by Alina Yurenko and Thomas Wuerthinger

Dans cette présentation, les présentateurs d'Oracle ont abordé une autre grande tendance du marché: le retour au natif qui permet de limiter l'impact sur le démarrage, la mémoire et la taille des packages.

Au travers d'un exemple basé sur [Micronaut](https://micronaut.io/), ils ont expliqué comment [GraalVM](https://www.graalvm.org/) peut répondre à ces enjeux. Ils ont également démystifié plusieurs mythes liés à GraalVM. Par exemple, GraalVM supporte la réflexion (... et parfois non). On peut utiliser également [Java Flight Recorder](Java Flight Recorder) pendant la compilation. Le support à l'exécution des applications est bientôt prévu.

La developer experience était également à l'ordre du jour. Comment offrir une bonne expérience alors que la compilation prend plus de temps?

Pour répondre à cette épineuse question, ils ont conseillé de gardé le mode [JIT](https://developers.redhat.com/articles/2021/06/23/how-jit-compiler-boosts-java-performance-openjdk) avec une JVM pendant le développement et d'utiliser l' [AOT](https://devblogs.microsoft.com/java/aot-compilation-in-hotspot-introduction/) pour le déploiement final. Ceci permet de disposer d'une machine puissante et de garantir la compatibilité matérielle et OS de la machine de production.

[La vidéo est disponible ici](https://www.youtube.com/watch?v=mhmqomex1zk)

## The lost art of software design by Simon Brown

J'utilise [le modèle C4](https://www.c4model.com/) depuis plusieurs années. 
Je l'ai même présenté très brièvement dans mon talk. 

Aussi, j'ai été très impressionné quand j'ai pu assister à la présentation de [Simon Brown](https://simonbrown.je/) sur la conception logicielle.
Il a expliqué pourquoi la conception n'était pas conflictuelle avec les méthodes agiles.
Ca permet notamment d' identtifier et de gérer les risques.

Au delà du modèle C4, [il a montré comment identifier et évaluer les différents risques avec le "Risk Storming"](https://riskstorming.com/). 

Enfin, il a répondu à la question à un million d'euros: "Quand arrêter la conception?"

[Vous trouverez la réponse ici](https://www.youtube.com/watch?v=36OTe7LNd6M).

### Ahead Of Time and Native in Spring Boot 3.0 by Stéphane Nicoll & Brian Clozel

Une autre conférence qui met en avant GraalVM! 
Cette fois on abordait le support de l' AOT et du mode natif dans la future version de Spring Boot.

Les présentateurs ont expliqués comment Spring supportait le mode natif: le processus appliqué, la gestion des métadonnées et l'analyse réalisée.
En (très très bref) résumé, l' AOT génère des sources dont le chargement des Bean Definition.

Ils ont également pointé du doigt des changements que je considère bloquants:
* On ne peut pas utiliser changer les profils au runtime
* La surcharge des propriétés et variable d'environnement n'est pas possible à l'exécution
* On ne peut pas utiliser de Java Agent.

Pour ce dernier point, cela risque de poser de nombreux soucis que ça soit l'utilisation d'un [APM tel que Dynatrace](https://www.dynatrace.com/news/blog/what-is-apm-2/) ou le support de [l'AOP](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/aop.html).

A la fin de cette présentation, ils ont donné quelques recommendations. Parmi celles-ci:

* Exécuter en développement l'application en mode AOT avec une JVM
* Exécuter les tests en mode natif

[Vous trouverez la vidéo ici](https://www.youtube.com/watch?v=TS4DpYSmfXk)

### The Art of Java Language Pattern Matching by Simon Ritter

[Simon Ritter](https://uk.linkedin.com/in/siritter) a exploré toutes les possibilité du [pattern matching en Java](https://docs.oracle.com/en/java/javase/15/language/pattern-matching-instanceof-operator.html). 
Toutes les fonctionnalités ne sont pas encore disponibles. On peut néanmoins faire beaucoup de choses. 

Après un rappel sur les nouvelles fonctionnalités depuis le JDK11 ([Sealed classes](https://docs.oracle.com/en/java/javase/15/language/sealed-classes-and-interfaces.html), [Records](https://docs.oracle.com/en/java/javase/15/language/records.html)), Simon Ritter a illustré leur utilisation dans ce contexte.

Si vous voulez tout connaître sur cette fonctionnalité, je vous conseille fortement de regarder ce talk.

[Voici la vidéo](https://www.youtube.com/watch?v=OlW724WaJJQ)

## Conclusion

Voila les quelques talks qui m'ont interpellé. Il y en a beaucoup d'autres tels que ceux de [Julien TOPCU](https://devoxx.be/talk/?id=2352) ou [Marcy ERICKA CHARELLOIS](https://devoxx.be/talk/?id=19402).
Cette première participation était très enrichissante. J'ai eu à plusieurs reprises l'impression d'avoir l'information à la source (ex. pour Spring). 

Si j'ai autant de chance, je pense rééditer l'expérience l'année prochaine. 

En tant que speaker pour une conférence ou un workshop? Seul l'avenir nous le dira!

[^1]:[*Vous savez, moi je ne crois pas qu'il y aient de bonnes ou mauvaises conférences. Moi, si je devais résumer ma vie aujourd’hui avec vous, je dirais que c’est d’abord des rencontres, des gens qui m’ont tendu la main...*](https://www.imdb.com/title/tt0250223/characters/nm0046347)