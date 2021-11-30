---
id: 179
title: Comment coacher des jeunes développeurs ?
date: 2019-07-17T21:03:59+02:00




timeline_notification:
  - "1563393924"
publicize_twitter_user:
  - touret_alex
---
En changeant de société l&rsquo;année dernière j&rsquo;ai eu l&rsquo;impression de monter d&rsquo;un cran dans la pyramide des ages.  
Pour faire plus simple, je me suis senti un peu plus vieux.

<img loading="lazy" class="size-medium wp-image-189 aligncenter" src="/assets/images/2019/07/mari-lezhava-q65bne9fw-w-unsplash.jpg?w=300" alt="" width="300" height="186" /> 

Si vous avez quelques années d&rsquo;expérience dans le développement ou tout simplement dans la technique, vous avez déjà eu l&rsquo;occasion de coacher ou d&rsquo;encadrer techniquement des jeunes diplômés.

Et oui, c&rsquo;est un signe !

Maintenant vous avez assez de recul ( pour ne pas dire que vous êtes vieux/vieille) pour encadrer techniquement des jeunes ingénieur.e.s  
Certes vous n&rsquo;avez pas fait le choix de partir vers la gestion de projet ou le management.  
Cependant l&rsquo;encadrement technique ( vous pouvez l&rsquo;appeler mentorat, tutorat, apprentissage,&#8230; ) est nécessaire pour faire monter en compétence les nouveaux arrivants et les rendre autonomes.

Je vais essayer de mettre en lumière quelques pratiques que je mets en œuvre et que j&rsquo;ai pu remettre au goût du jour depuis un an.  
Si vous avez des idées, avis, n&rsquo;hésitez pas à les mettre en commentaire.

## Documentation

Il y a plusieurs types de documentation que je partage.  
Tout d&rsquo;abord, j&rsquo;ai partagé quelques sites et ouvrages qui me paraissent indispensables.  
[Clean  Code](https://www.amazon.fr/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882) arrive en premier. [Effective Java](https://www.amazon.fr/Effective-Java-Joshua-Bloch/dp/0134685997) en second.  
A mon avis, ça ne sert pas à grand chose d&rsquo;aller plus loin dans le développement si on n&rsquo;a pas acquis les notions décrites dans ces livres!  
Puis vient le [refactoring](https://www.refactoring.com/) puis les [design patterns.](https://fr.wikipedia.org/wiki/Patron_de_conception)

Ensuite, j&rsquo;essaye de partager via notre chat interne les quelques solutions trouvées dans les projets.

Enfin, j&rsquo; essaye de m&rsquo; astreindre à mettre à jour la documentation.  
Oui c&rsquo;est un combat de tous les jours 😀  
Ça commence par les exemples de code.

J&rsquo;essaye d&rsquo; avoir des repos git assez lisibles (c.-à-d. avec un README intelligible) et un code à jour correspondant aux normes en vigueur.  
Un exemple, j&rsquo;ai crée un projet permettant d&rsquo; illustrer la mise en œuvre des tests unitaires et d&rsquo;intégration dans un projet standard (spring, tomcat, docker,&#8230;).

Ces éléments nécessitent un travail important, que ça soit à la création ou pour tenir à jour la documentation. Cependant, ça me permet de ne pas me répéter, et d&rsquo; illustrer via un cas pratique ce que j&rsquo;attends dans les Merge Requests. En effet, chaque développement est assujetti à une [Definition of Done](https://www.scruminc.com/definition-of-done/) ( tests, qualité, &#8230;) . Il faut donc que la qualité de la documentation soit en rendez vous !

## Veille

Au delà de la documentation, je « pousse » aux différents dev, les articles que je trouve pertinent pendant ma veille technologique.  
J&rsquo;invite également tout le monde à en faire.  
Je ne peux pas les obliger.  
Maintenant comme je peux le dire régulièrement.  
Si on souhaite rester dans la technique, il faut se tenir à jour. La veille (sites web, confs, livres,&#8230;) en est le meilleur moyen.

## Ateliers / Workshops

Organiser un workshop ou atelier d&rsquo;une heure ou deux max est un bon moyen de fédérer les troupes.  
J&rsquo;essaye d&rsquo;organiser deux types d&rsquo;atelier.  
Le premier est uni directionnel : Une personne présente un sujet technique et les autres en profitent.  
Ça permet tout d&rsquo;abord de diffuser plus simplement certains messages.  
Par exemple, j&rsquo;ai organisé une présentation de 30 mn sur l&rsquo;utilisation de NULL dans le code et l&rsquo;utilisation des Optional.

Le deuxième est plus long à préparer.  
C&rsquo;est un atelier organisé à la manière d&rsquo;un hands on sur un sujet très précis.  
Pendant 1H ou 2H, l&rsquo;équipe planche sur un sujet. La session est organisé et animé idéalement par un ou plusieurs membres de l&rsquo;équipe ( ça ne vous empêche pas d&rsquo;avoir votre mot à dire lors de la préparation 😀 ).  
Récemment j&rsquo;ai co-organisé un hands on « Clean Code » en illustrant quelques notions qui nous paraissaient essentielles.

Ces évènements sont évidemment chronophages mais offrent un certains retour sur investissement.  
Outre la présentation technique des différents sujets, les membres de l&rsquo;équipe se forment et apprennent.  
Ils peuvent voir en situation les différentes notions que vous évoquez (en fait je les rabâche) lors des MR ou pendant les revues de code.  
Aussi, je pense que ça contribue à une certaine émulation technologique.  
Ça prend du (beaucoup de) temps, mais ça en vaut la peine!  
L&rsquo;idéal dans ce genre d&rsquo;exercice est quand tout le monde propose des sujets.  
Pas seulement l&rsquo;architecte ou le lead dev.  
Les développeurs peuvent prendre le lead dans cet exercice. Ca permet d&rsquo;une part de les valoriser, de les faire monter en compétence. Quoi de mieux pour approfondir un sujet que de monter un talk et/ou hands on dessus ?

## Revues de code

Je ne vais pas aborder dans ce chapitre les revues de code que l&rsquo;on peut faire dans le cadre des projets, lors des MR par exemple.  
Pour certaines personnes, surtout les juniors, je fais régulièrement une revue de code alternative.  
Je passe une 1/2 heure, une heure max sur un bout de code que le dev m&rsquo;aura sélectionné. Je lis le code avec le développeur et je donne quelques axes d&rsquo;amélioration: design patterns, tests unitaires, refactoring,&#8230; Tout y va.  
Ça permet de se poser et d&rsquo;aborder quelques sujets: la programmation fonctionnelle, les IO en java,&#8230;

## Pour aller plus loin

Bien évidemment, beaucoup d&rsquo;autres actions peuvent être mises en place. La plupart de l&rsquo;accompagnement que je peux réaliser se fait quotidiennement, dans les projets.

Pour aller un peu plus loin, un [collègue](https://twitter.com/v_pradeilles?lang=fr) a mis en place un système de mentorat pour accompagner les jeunes développeurs et accélérer leur montée en compétence.  
Cette idée est très intéressante et peut être appliquée dans beaucoup de contextes.

Si vous avez des idées, questions, remarques, pratiques que vous développez chez vous, n&rsquo;hésitez pas à les partager!