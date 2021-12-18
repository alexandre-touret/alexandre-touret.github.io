---
id: 201
title: 'Comment coacher des jeunes développeurs &#8211; The last blood'
date: 2019-09-11T21:16:44+02:00




timeline_notification:
  - "1568233009"
publicize_twitter_user:
  - touret_alex
publicize_linkedin_url:
  - ""
---
Après avoir soumis [mon article sur le coaching des développeur](http://blog.touret.info/2019/07/17/comment-coacher-des-jeunes-developpeurs/)s, je me suis rendu compte que j'ai oublié pas mal de points qui, à bien y réfléchir, me paraissent essentiels.  
Dans mon précédent article ( the first blood pour le coup ) je me suis attardé sur le « quoi » : toutes les actions que j'ai testé dans l'encadrement des jeunes développeurs et des développeurs en général.

Maintenant, je vais essayer de m'attarder sur le « comment » : ma démarche, la posture que l'on doit adopter ( ce n'est que mon ressenti ) etc.

Je vais commencer par ce dernier point. Quand on est architecte, développeur sénior ou bien encore tech lead, on est amené à encadrer techniquement des développeurs.

Vous pouvez adopter plusieurs postures:

<ul class="wp-block-gallery columns-3 is-cropped">
  <li class="blocks-gallery-item">
    <figure><img loading="lazy" width="275" height="321" src="/assets/images/2019/09/yoda.jpg" alt="" data-id="212" data-link="http://blog.touret.info/?attachment_id=212" class="wp-image-212" srcset="/assets/images/2019/09/yoda.jpg 275w, /assets/images/2019/09/yoda-257x300.jpg 257w" sizes="(max-width: 275px) 100vw, 275px" /></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><img loading="lazy" width="300" height="168" src="/assets/images/2019/09/pascal_le_grand_frere.jpg" alt="" data-id="211" data-link="http://blog.touret.info/?attachment_id=211" class="wp-image-211" /></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><img loading="lazy" width="613" height="344" src="/assets/images/2019/09/capture-kubrick-756b3f-0401x.jpeg?w=612" alt="" data-id="210" data-link="http://blog.touret.info/?attachment_id=210" class="wp-image-210" srcset="/assets/images/2019/09/capture-kubrick-756b3f-0401x.jpeg 613w, /assets/images/2019/09/capture-kubrick-756b3f-0401x-300x168.jpeg 300w" sizes="(max-width: 613px) 100vw, 613px" /></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><img loading="lazy" width="480" height="360" src="/assets/images/2019/09/bisounours.jpg" alt="" data-id="209" data-link="http://blog.touret.info/?attachment_id=209" class="wp-image-209" srcset="/assets/images/2019/09/bisounours.jpg 480w, /assets/images/2019/09/bisounours-300x225.jpg 300w" sizes="(max-width: 480px) 100vw, 480px" /></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><img loading="lazy" width="410" height="230" src="/assets/images/2019/09/gandalf-lord-of-the-rings-e1534255368438.jpg" alt="" data-id="217" data-link="http://blog.touret.info/?attachment_id=217" class="wp-image-217" srcset="/assets/images/2019/09/gandalf-lord-of-the-rings-e1534255368438.jpg 410w, /assets/images/2019/09/gandalf-lord-of-the-rings-e1534255368438-300x168.jpg 300w" sizes="(max-width: 410px) 100vw, 410px" /></figure>
  </li>
</ul>

A ce stade de lecture de cet article, vous vous dites, quelle est la bonne photo et donc la posture à adopter ?  
A mon avis, elles sont à proscrire individuellement. Je pense qu'il faut les panacher.

Tout d'abord, il faut se souvenir de notre début de carrière et se rappeler du code que l'on a réalisé. J'ai par exemple gardé les premiers programmes réalisés en entreprise ( Servlet, JSP, JAVA 1.2, des méthodes de 3km de long, de la duplication de code en veux tu en voila, &#8230;) . Ça me permet de relativiser, d'être assez compréhensif et d'éviter de prendre les gens de haut.  
  
Cependant, cette prise de conscience ne doit pas vous empêcher de faire progresser votre entourage et surtout de leur faire éviter les écueils que vous avez vécu. Les ateliers et documentation que vous pourrez leur transmettre sont donc primordiaux. Par exemple, faire lire [« Clean Code »](https://g.co/kgs/Xes2A3) ou [« Effective Java »](https://g.co/kgs/WL4qUH) aux développeurs &#8211; je ne l'oblige pas mais incite fortement &#8211; est un moyen de leur faire gagner du temps dans leur apprentissage du code.  
  
Ensuite, même si vos _padawans_ vous voient soit comme Pascal le grand frère ou maître Yoda (pour flatter mon égo), il ne faut pas oublier les exigences que vous avez fixé. L'industrie logicielle a gagnée en maturité en favorisant par exemple l'industrialisation via les outils de CI/CD ou bien encore en facilitant l'application de principes de qualité via des outils d'analyse des dépendances ([dependency track](https://docs.dependencytrack.org/)) et du code ([sonarqube](https://www.sonarqube.org/)). Vous devez vous adapter, favoriser l'adoption de ces pratiques et imposer quelques étapes qualité de préférence automatisée via de la CI.  


Pour favoriser l'adoption de toutes vos exigences, je conseille d'y aller progressivement. Il ne faut pas oublier que votre objectif est de faire « grandir » vos collègues. Pour cela essayez de les adapter et les faire évoluer dans le temps.  
Par exemple, pour les tests unitaires, commencez pas mettre en place les différents indicateurs qui vous permettront de mesurer la couverture de code. Ensuite, exigez un niveau de couverture de code (ex. 30%). Suivez le, via les quality gates SonarQube et enfin augmentez le progressivement : 30% , 40%,&#8230; Si vous commencez dès le début par un objectif trop haut, ce dernier paraîtra inatteignable et découragera tout le monde. Mieux vaut commencer volontairement très bas pour favoriser l'adoption.

Dans un autre domaine, pour [vos workflows GIT](https://www.atlassian.com/git/tutorials/comparing-workflows/), vous pouvez commencer dans un premier temps par [le workflow de feature branch](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow). Ce dernier posera les bases des pipelines CI, des merge requests et des bonnes pratiques liées à la gestion de configuration. Une fois tout le cérémonial lié à GIT assimilé par votre équipe, passer à [GITFLOW](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) sera beaucoup simple.  


Bref, cette démarche revient à parler [de conduite du changement](https://fr.wikipedia.org/wiki/Conduite_du_changement). Il faut **identifier vos exigences minimales**. Celles-ci doivent être acceptées par votre hiérarchie **ET** par vos collègues. Sans ça vous échouerez! 

Si ils vous soumettent quelques idées ou adaptations, n'hésitez pas à les incorporer. Ça peut faciliter l'adoption!

Ensuite, planifiez une progression sur 1 ou 2 ans. Cela donnera à vos collègues dans un premier temps des premiers objectifs atteignables puis une marge de progression leur permettant de s'améliorer.

Enfin, n'hésitez pas à faire un bilan ( par ex. au bout d'un projet ou après la première année ). Ou encore mieux, faites le faire par un de vos collègues pour avoir son ressenti. Cela mettra en exergue le chemin parcouru &#8230; et ce qu'il reste à faire 🙂

## Conclusion

A mon avis le management et l'encadrement de personnes n'est pas à prendre à la légère. Votre attitude ainsi que la démarche que vous voulez mettre en œuvre feront autant voir plus que toute la documentation et formations que vous mettrez en place.