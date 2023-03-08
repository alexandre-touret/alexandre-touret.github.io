# Gérer « efficacement » les fichiers de configuration dans les charts HELM

  Dès qu'on veut déployer des environnements Kubernetes, <a href="https://helm.sh/">Helm </a>devient une des solutions à considérer.<br />Le déploiement des objets standards tels que <code>deployment</code>, <code>autoscaler </code>et autres se fait aisément car ces derniers ne changent pas d'un environnement à l'autre. Généralement on déploie la même infrastructure sur tous les environnements du développement à la production.

Bien évidemment on pourra limiter la taille des replicas sur l'environnement de développement par exemple mais au fond, le contenu des charts sera identique. Une des difficultés que l'on pourra rencontrer c'est dans la gestion des fichiers de configuration. 

Je vais essayer d'exposer dans cet article comment j'ai réussi à gérer +/- efficacement (en tout cas pour moi) les fichiers de configuration dans les charts HELM.

## Les config maps et secrets

Logiquement dans ce type d'architecture, les [configmaps](https://kubernetes.io/docs/concepts/configuration/configmap/) et [secrets](https://kubernetes.io/docs/concepts/configuration/secret/) permettent le chargement des variables d'environnement et autres mots de passe. Cependant si vous utilisez certains frameworks qui nécessitent des fichiers de configuration, vous devrez charger les fichiers dans des volumes. Pour ces derniers, les volumes n'ont pas besoin d'être persistents.

Par exemple dans la configuration de votre `deployment`, vous pourrez configurer le montage d'un volume de la manière suivante:  


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
  my_keystore_jks {% raw %} .Files.Get "secrets/my_keystore.jks" | b64enc }} {% endraw %}
```


Vous pouvez définir les fichiers directement dans vos configmaps. Cependant, si vos fichiers sont volumineux, vous aurez du mal à les maintenir. Personnellement, j'opte pour mettre les fichiers de configuration à coté et les charger dans le configmap.

On pourra procéder de la manière suivante:

```yaml
apiVersion: v1
kind: ConfigMap
[...]

data:
  my_conf:   {% raw %}{{- (.Files.Glob "conf/*").AsConfig | nindent 2 }} {% endraw %}

```


## Livrables agnostiques

Une bonne pratique de développement logiciel est d'externaliser la configuration de vos environnements (ex. l'URL JDBC de la base de données) des livrables. Les charts HELM n'échappent à la règle.

On peut stocker la configuration de chaque environnement dans le chart, mais dans ce cas, on perdra beaucoup de souplesse lors des mises à jour des propriétés et cela nous imposera une nouvelle version.

On a plusieurs niveaux d'externalisation. Le premier est dans le chart. Vous pouvez externaliser les différentes valeurs dans le fichier `values.yml`. Ci dessous un exemple avec un [autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/):

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  labels:
  [...]
spec:
  maxReplicas: {% raw %} {{.Values.myapp.maxReplicaCount }}{% endraw %}
  minReplicas: {% raw %} .Values.myapp.minReplicaCount }}{% endraw %}
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
   [...]
  targetCPUUtilizationPercentage: {% raw %} .Values.myapp.replicationThreesold }}{% endraw %}

```


Les valeurs sont décrites comme suit:

```yaml
myapp:
  minReplicaCount: "2"
  maxReplicaCount: "6"
  replicationThreesold: 80
```


Pour externaliser les valeurs d'environnement, vous pourrez donc externaliser un autre fichier `values.yml` qui sera appliqué au déploiement. Les valeurs de ce dernier surchargeront les valeurs définies dans le chart.  
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
    {% raw %}{{ tpl (.Files.Get "conf/application.properties") . | nindent 4}} {% endraw %}
```


## Conclusion

Vous l'aurez compris, les charts HELM n'échappent pas aux règles déjà connues de gestion des environnements et des livrables. Même si il y a quelques subtilités à connaître pour intégrer des fichiers de configuration par exemple, les grands principes restent les mêmes.
