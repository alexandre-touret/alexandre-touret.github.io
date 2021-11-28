---
id: 472
title: Gérer « efficacement » les fichiers de configuration dans les charts HELM
date: 2021-01-09T15:21:28+01:00
author: admin
layout: post


publicize_linkedin_url:
  - ""
timeline_notification:
  - "1610202091"
publicize_twitter_user:
  - touret_alex
---
<p class="has-drop-cap">
  Dès qu&rsquo;on veut déployer des environnements <a href="https://kubernetes.io/">Kubernetes</a>, <a href="https://helm.sh/">Helm </a>devient une des solutions à considérer.<br />Le déploiement des objets standards tels que <code>deployment</code>, <code>autoscaler </code>et autres se fait aisément car ces derniers ne changent pas d&rsquo;un environnement à l&rsquo;autre. Généralement on déploie la même infrastructure sur tous les environnements du développement à la production.
</p>

Bien évidemment on pourra limiter la taille des replicas sur l&rsquo;environnement de développement par exemple mais au fond, le contenu des charts sera identique. Une des difficultés que l&rsquo;on pourra rencontrer c&rsquo;est dans la gestion des fichiers de configuration. 

Je vais essayer d&rsquo;exposer dans cet article comment j&rsquo;ai réussi à gérer +/- efficacement (en tout cas pour moi) les fichiers de configuration dans les charts HELM.<figure class="wp-block-gallery columns-1 is-cropped">


![helm](/assets/img/posts/2021/01/loik-marras-sq0l3spwlhi-unsplash.jpg)

## Les config maps et secrets

Logiquement dans ce type d&rsquo;architecture, les [configmaps](https://kubernetes.io/docs/concepts/configuration/configmap/) et [secrets](https://kubernetes.io/docs/concepts/configuration/secret/) permettent le chargement des variables d&rsquo;environnement et autres mots de passe. Cependant si vous utilisez certains frameworks qui nécessitent des fichiers de configuration, vous devrez charger les fichiers dans des volumes. Pour ces derniers, les volumes n&rsquo;ont pas besoin d&rsquo;être persistents.

Par exemple dans la configuration de votre `deployment`, vous pourrez configurer le montage d&rsquo;un volume de la manière suivante:  


```yaml
volumeMounts:
            - mountPath: /config
              name: configuration-volume
              readOnly: true
            - mountPath: /secrets
              name: secret-volume
              readOnly: true
      [...]
      volumes:
        - configMap:
            defaultMode: 420
            name: configuration
          name: configuration-volume
        - name: secret-volume
          secret:
            defaultMode: 420
            secretName: secrets
```


Pour intégrer un fichier binaire, on pourra le faire de la manière suivante dans le template HELM:

```yaml
apiVersion: v1
# Definition of secrets
kind: Secret
[...]
type: Opaque
# Inclusion of binary configuration files
data:
  my_keystore.jks: {{ .Files.Get "secrets/my_keystore.jks" | b64enc }}
```


Vous pouvez définir les fichiers directement dans vos configmaps. Cependant, si vos fichiers sont volumineux, vous aurez du mal à les maintenir. Personnellement, j&rsquo;opte pour mettre les fichiers de configuration à coté et les charger dans le configmap.

On pourra procéder de la manière suivante:

```yaml
apiVersion: v1
kind: ConfigMap
[...]

data:
  my.conf:   {{- (.Files.Glob "conf/*").AsConfig | nindent 2 }} 

```


## Livrables agnostiques

Une bonne pratique de développement logiciel est d&rsquo;externaliser la configuration de vos environnements (ex. l&rsquo;URL JDBC de la base de données) des livrables. Les charts HELM n&rsquo;échappent à la règle.

On peut stocker la configuration de chaque environnement dans le chart, mais dans ce cas, on perdra beaucoup de souplesse lors des mises à jour des propriétés et cela nous imposera une nouvelle version.

On a plusieurs niveaux d&rsquo;externalisation. Le premier est dans le chart. Vous pouvez externaliser les différentes valeurs dans le fichier `values.yml`. Ci dessous un exemple avec un [autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/):

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  labels:
  [...]
spec:
  maxReplicas: {{ .Values.myapp.maxReplicaCount }}
  minReplicas: {{ .Values.myapp.minReplicaCount }}
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
   [...]
  targetCPUUtilizationPercentage: {{ .Values.myapp.replicationThreesold }}

```


Les valeurs sont décrites comme suit:

```yaml
myapp:
  minReplicaCount: "2"
  maxReplicaCount: "6"
  replicationThreesold: 80
```


Pour externaliser les valeurs d&rsquo;environnement, vous pourrez donc externaliser un autre fichier `values.yml` qui sera appliqué au déploiement. Les valeurs de ce dernier surchargeront les valeurs définies dans le chart.  
Il est important de noter également que les données présentes dans les fichiers de configuration (ex. fichier `application.properties`) peuvent être « variabilisées » et surchargées par le même mécanisme. Vous aurez à utiliser la commande [tpl](https://helm.sh/docs/chart_template_guide/functions_and_pipelines/).  


```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: configuration
  labels:
    [...]
data:
  application.properties: 
    |- 
    {{ tpl (.Files.Get "conf/application.properties") . | nindent 4}} 
```


## Conclusion

Vous l&rsquo;aurez compris, les charts HELM n&rsquo;échappent pas aux règles déjà connues de gestion des environnements et des livrables. Même si il y a quelques subtilités à connaître pour intégrer des fichiers de configuration par exemple, les grands principes restent les mêmes.