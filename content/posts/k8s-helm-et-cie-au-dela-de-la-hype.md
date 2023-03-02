---
id: 440
title: 'K8S, HELM et Cie: au delà de la hype'
date: 2020-10-08T10:09:59+02:00


featuredImagePreview: /assets/images/2020/10/gartner_hype_cycle.svg_.png

publicize_linkedin_url:
  - ""
amp_status:
  - ""
spay_email:
  - ""
publicize_twitter_user:
  - touret_alex
timeline_notification:
  - "1602148200"
tags:
  - helm
  - hype
  - k8s
  - kubernetes
---
Depuis quelques années, [Kubernetes](https://kubernetes.io/) (K8S) et [son écosystème](https://www.cncf.io/) deviennent l'environnement d' exécution à la mode. Certaines personnes veulent déployer sur cet environnement en mettant en avant ses capacités de scalabilité. D'autres font du bashing (souvent) justifié sur la complexité et le coût de mise en œuvre d'une telle plateforme.  
Vous l'aurez compris, cette technologie n'échappe pas [au cycle du hype](https://fr.wikipedia.org/wiki/Cycle_du_hype) et à la fameuse courbe du Gartner.

{{< style "text-align:center" >}}
![cycle hype](/assets/images/2020/10/gartner_hype_cycle.svg_.png)
{{</ style >}}

Après quelques expériences sur cette plateforme ( et beaucoup sur d'autres 😀 ) je vais essayer de peser le pour et le contre qui m'apparaissent importants.  
Bien évidemment, ce n'est que mon avis, j'ai sans doute omis certaines informations qui pourraient être indispensables pour d' autres.

## Pourquoi et dans quelles conditions il ne faut pas utiliser K8S ?

Avant de présenter les avantages des applications cloud, je vais essayer de réaliser l'anti thèse de mon propos.

### En avez vous (vraiment) besoin ?

Vaste sujet et question délicate pour la population informaticienne qui a tendance à suivre les tendances du marché. 

{{< figure src="/assets/images/2020/10/aaron-blanco-tejedor-vbe9zj-jhbs-unsplash.png" title="Cycle Hype" width="50%" >}}


Avant de foncer tête baissée dans cette technologie qui est très intéressante au demeurant, il est important de se poser ces quelques questions:

  * Est-ce que mes [SLO](https://fr.wikipedia.org/wiki/Service-level_objectives) sont contraignantes?
  * Quel le cycle de déploiement de mes applications?
  * Qui gère les environnements ?

Bref, il faut savoir si le jeu en vaut la chandelle. Si vous avez une application qui doit scaler dynamiquement, encaisser les pics, et avoir du [zero downtime durant les mises à jour](https://dzone.com/articles/zero-downtime-deployment), Kubernetes est fait pour vous. Si vous avez une application de gestion qui n'a pas d'exigences fortes si ce n'est de répondre aux besoins fonctionnels, l'utilisation de Kubernetes est discutable.

### Êtes vous taillé pour ?

Kubernetes et son écosystème peuvent s'avérer complexes à appréhender. Si votre entreprise opte pour une utilisation « [on premise](https://en.wikipedia.org/wiki/On-premises_software)« , c'est pire. Vous devrez avoir une équipe dédiée qui gérera cette plateforme et offrir une expertise aux équipes de développement.  
Ne vous trompez pas. Si votre rôle est de développer des applications métier, il vous sera très difficile d'avoir également une expertise sur l'administration de cette plateforme. Vous pourrez l'utiliser et être à l'aise, mais l'administration d'une telle technologie est très compliquée.

Le seul conseil que je pourrais vous donner, c'est de ne partir sur Kubernetes que si vous avez une **équipe support à disposition**. C'est vrai si vous utilisez des services du Cloud tels que Google Cloud ou AWS. Ça l'est encore plus si vous utilisez des services « on premise » tels qu' Openshift.

### Est-ce que vos développements sont [« cloud native »](https://www.redhat.com/fr/topics/cloud-native-apps) ?

Au delà de la plateforme, vous devrez monter en compétence sur le développement et la conception de vos applications.

Il vous faudra prendre en considération [les 12 facteurs clés](https://en.wikipedia.org/wiki/Twelve-Factor_App_methodology) dans vos applications. Il n'est pas forcément la peine de passer sur des microservices. Il est également possible de faire des monolithes modulaires qui peuvent être légers et stateless. Beaucoup de ces facteurs sont communément admis comme des bonnes pratiques de développement logiciel (ex. Il faut une intégration continue).  
  
Aussi, cela va sans dire, il faut également monter (réellement) en compétence sur les conteneurs et leurs contraintes. Si vous n'avez pas l'habitude de travailler avec des conteneurs ( construction, déploiement, disponibilité d'une [registry](https://docs.docker.com/registry/)). Il est préférable de définir une trajectoire avec des étapes intermédiaires.  
  
Bref, tous ces sujets doivent être adressés et compris pour toutes les parties prenantes de vos équipes que ça soit les développeurs, les chefs de projet et les équipes métiers à une moindre mesure. Cette technologie représente réellement un grand pas à franchir. Si vous ne vous sentez pas de le faire, ou si vous devez gagner en maturité sur ces sujets, attendez avant de vous lancer sur Kubernetes. 

On ne pourra jamais vous reprocher de ne pas opter sur Kubernetes si vous ne remplissez pas tous les pré-requis. Pour ce qui est du contraire&#8230;

### Avez vous des interactions avec des services tiers qui sont compatible avec Kubernetes ?

Quand vous restez dans votre cluster Kubernetes, généralement, tout va bien. Dès que vous avez des interactions avec des services tiers, ça peut se compliquer.  
En effet, généralement vous devrez vous connecter à des services tiers qui ne sont pas orienté cloud : [des boitiers crypto](https://en.wikipedia.org/wiki/Hardware_security_module), des passerelles de transfert, &#8230;  
Il se peut que certains protocoles soient également incompatibles avec Kubernetes. Il vous faudra vous assurer que tout la galaxie de logiciels et systèmes gravitant autour de votre application sera compatible avec une telle architecture. Ceci n'est pas une mince affaire. L'aide d'une équipe support (voir ci-dessus) vous sera d'une grande utilité.

## Pourquoi sauter le pas ?

### La scalabilité et la résistance à la panne

Personnellement, la première fonctionnalité qui m'a intéressé c'est la gestion de la scalabilité. Si vous avez des objectifs de 99.9% de disponibilité. Kubernetes sera une plus value indéniable dans votre architecture. Après quelques <s>jours</s> heures à batailler avec les fichiers YAML, vous pourrez gérer automatiquement la scalabilité en fonction de plusieurs indicateurs qu'ils soient techniques (ce sont les plus faciles à gérer) ou un peu plus métier [en utilisant Prometheus](https://www.metricfire.com/blog/prometheus-metrics-based-autoscaling-in-kubernetes/) &#8211; et oui encore une technologie supplémentaire à connaître.

En effet, au lieu de vous en soucier une fois arrivé en production, vous aurez lors du développement l'obligation de prendre en considération l'observabilité de votre application. Par exemple, vous aurez à renseigner [si votre application est prête et/ou disponible pour traiter les requêtes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/). Ces indicateurs vous permettront de scaler **automatiquement** et de re-créer si nécessaire un [POD](https://kubernetes.io/docs/concepts/workloads/pods/) en cas de panne.

J'ai trouvé que cette pratique était vertueuse. Bien évidemment, pas besoin d'être sur Kubernetes pour avoir de l'observabilité dans des applications. Par contre, ici, c'est obligatoire et implémenté dès le développement.

La scalabilité automatique est aussi très intéressante. On a souvent vu des serveurs en production qui n'étaient pas suffisamment utilisés. Ici vous n'aurez que les instances nécessaires pour votre cas d'utilisation.  
La contrainte que l'on peut voir à cette fonctionnalité et qu'on ne maitrise pas complètement le nombre d'instances disponibles. C'est Kubernetes qui s'en charge en prenant en compte le paramétrage que vous aurez renseigné dans vos [templates HELM](https://helm.sh/docs/chart_best_practices/templates/).

### Le déploiement

Avant de déployer (dans la vraie vie), vous aurez à mettre en place un pipeline CI/CD qui orchestre les différents déploiements sur tous vos environnements. Attention, ce n'est pas une mince affaire 🙂 !

Une fois réalisé, vous verrez automatiquement le gain. Vos déploiements seront réellement fluides. Bon OK, on peut le faire sur des [VMS](https://en.wikipedia.org/wiki/Virtual_machine) standards. Mais on peut améliorer la procédure de déploiement pour mettre en place du [zero downtime](https://dzone.com/articles/zero-downtime-deployment) pour ne pas interrompre le service lors d'un déploiement. 

```yaml
strategy:
type: RollingUpdate
rollingUpdate:
maxSurge: 1
maxUnavailable: 0
```


### L'Infrastructure As Code

{{< style "text-align:center" >}}
![infrastructure as code](/assets/images/2020/10/jacek-dylag-nhcpop4a2xo-unsplash.png)
{{</ style >}}


Quand on pense à Kubernetes, et au cloud, on ne pense pas trop à l'[Infrastructure As Code](https://en.wikipedia.org/wiki/Infrastructure_as_code) au début. Cependant, cette pratique est pour moi l'une des plus utiles. 

En effet, avoir votre système décrit dans des fichiers, versionnés vous permet de le tester dès le développement. Ça évite ( dans la majorité des cas ) les erreurs lors des installations d'environnement. La mise à jour des logiciels est largement accélérée. 

Bien évidemment, il existe [Terraform](https://www.terraform.io/) et [Ansible](https://www.ansible.com/) pour le provisionning des environnements. Ici je trouve qu'on pousse le concept encore plus loin. L'automatisation est à mon avis poussé à paroxysme.  
Prenons par exemple la gestion des systèmes d'exploitation. La mise à jour sur des serveurs physiques ou virtuels peut prendre énormément de temps et générer des erreurs. Avec de l'infra as code, ceci est testé et validé automatiquement via des tests unitaires dès l'environnement de développement.  
On peut suivre la gestion des environnements via un gestionnaire de sources et la promotion vers les autres environnements (recette[1-n], pré-production, production) est grandement accélérée.

## Conclusion

Bon, vous l'aurez peut être compris, cette galaxie de technologies est intéressante et peut vous aider dans vos projets. Avant d'arriver à l'utiliser sereinement, il vous faudra sans doute définir une trajectoire et appréhender plusieurs sujets avant d'arriver à déployer vos applications sur un cloud interne ou externe.  
J'espère que cet article vous aura permis de mettre en évidence les pour et contre d'une telle technologie et le cas échéant vous donnera envie de franchir le pas.