---
title: "Streamline Java Application Deployment: Pack, Ship, and Unlock Distributed Tracing with Elastic APM on Kubernetes"
date: 2023-11-06T08:00:00+02:00
draft: true

images: ["/assets/images/2023/10/claudio-schwarz-q8kR_ie6WnI-unsplash.webp"]
featuredImagePreview: /assets/images/2023/10/claudio-schwarz-q8kR_ie6WnI-unsplash.webp
featuredImage: /assets/images/2023/10/claudio-schwarz-q8kR_ie6WnI-unsplash.webp
og_image: /assets/images/2023/10/claudio-schwarz-q8kR_ie6WnI-unsplash.webp

tags:
  - Distributed_Tracing
  - Java
  - APM
  - Docker
  - Elastic
---

In [my last article](https://blog.touret.info/2023/09/05/distributed-tracing-opentelemetry-camel-artemis/), I dug into [Distributed Tracing](https://www.w3.org/TR/trace-context/) and exposed how to enable it in Java applications.
We didn't see yet how to deploy an application on Kubernetes and get distributed tracing insights. 
Several strategies can be considered, but the main point is how to minimize the impact of deploying APM agents on the whole delivery process.

In this article, I will expose how to ship APM agents for instrumenting Java applications deployed on top of [Kubernetes](https://kubernetes.io/) through [Docker containers](https://www.docker.com/resources/what-container/).

In addition, to make it easy, I will illustrate this setup by the following use case:

* We have an API _"My wonderful API"_ which is instrumented through an [Elastic APM agent](https://www.elastic.co/guide/en/apm/agent/index.html). 
* The data is then sent to the [Elastic APM](https://www.elastic.co/guide/en/apm).

{{< style "text-align:center" >}}
![c4 context diagram](/assets/images/2023/10/architecture_system.svg )
{{</ style >}}

Now, if we dive into the _"Wonderful System"_, we can see the _Wonderful Java application_ and the agent:

{{< style "text-align:center" >}}
![c4 context diagram](/assets/images/2023/10/architecture_container.svg )
{{</ style >}}

{{< admonition tip "Elastic APM vs Grafana/OpenTelemetry" >}}
In this article I delve into how to package an [Elastic APM agent](https://www.elastic.co/guide/en/apm/agent/java/current/configuration.html) and enable Distributed Tracing with the [Elastic APM suite](https://www.elastic.co/guide/en/apm/index.html). 

You can do that in the same way with an OpenTelemetry Agent. 
Furthermore, [Elastic APM is compatible with OpenTelemetry](https://www.elastic.co/fr/blog/native-opentelemetry-support-in-elastic-observability).
{{</ admonition >}}

We can basically implement this architecture in two different ways:

1. Deploying the agent in all of our Docker images
2. Deploying the agent asides from the Docker images and using initContainers to bring the agent at the startup of our applications

We will then see how to lose couple application docker images to the apm agent one. 

## Why not bringing APM agents in our Docker images?
It could be really tempting to put the APM agents in the application's Docker image.

We can illustrate it adding the following lines of code in our Docker images definition:

```dockerfile
RUN mkdir /opt/agent
COPY ./javaagent.jar /opt/agent/javaagent.jar
```

Nonetheless, if you want to upgrade your agent, you will have to repackage it and redeploy all your Docker images.
For regular upgrades, it will not bother you, but, if you encounter a bug or a vulnerability, it will be tricky and annoying to do that.

What is why I prefer loose coupling the _"business"_ applications Docker images to technical tools such as APM agents.

## Deploy an APM agent through initContainers
While looking around how to achieve this, I came across to the [Kubernetes initContainers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

This kind of container is run only once during the startup of every pod. 
A bunch of commands is ran then on top of it.
For our current use case, it will copy the javaagent into a volume such as an [empty directory volume](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir).

### Impacts in the "_Wonderful Java Application_ Docker image
The main impact is to declare a volume in your Docker image:

```dockerfile
VOLUME /opt/agent
```
It will be used by both the Docker container and the initContainer.
We can consider it as a "bridge" between these two containers.

We also have to declare one environment variable: ``JAVA_OPTS``.

For instance:

```dockerfile
ENV JAVA_OPTS=$JAVA_OPTS
[...]
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} org.springframework.boot.loader.JarLauncher"]
```

Il will be used during the deployment to set up our _Wonderful Java Application_.

Now, let's build our initContainer Docker image.

### InitContainer Docker Image creation
It is really straightforward. 
We can use for example, the following configuration:

```dockerfile
FROM alpine:latest
RUN mkdir -p /opt/agent_setup
RUN mkdir /opt/agent
COPY ./javaagent.jar /opt/agent_setup/javaagent.jar
VOLUME /opt/agent
```

### Kubernetes configuration
We can now set up our Kubernetes Deployment to start the corresponding container and copy the Java agent.

```yaml
kind: Deployment
spec:
  containers:
  - name: java-app
    image: repo/my-wonderful-java-app:v1
    volumeMounts:
    - mountPath: /opt/agent
      name: apm-agent-volume
  initContainers:
  - command:
    - cp
    - /opt/agent_setup/javaagent.jar
    - /opt/agent
    name: apm-agent-init
	image: repo/apm-agent:v1
    volumeMounts:
    - mountPath: /opt/agent
      name: appd-agent-volume
  volumes:
    - name: appd-agent-volume
      emptyDir: {}
```

{{< admonition tip "Why not copying the Java agent directly in the initContainer Docker image execution?" >}}
The copy must be run with a command specified in the initContainer declaration and cannot be done during the initContainer execution (i.e., specified in its Dockerfile). 
Why?
The volume is mounted just after the initContainer execution and drops the JAR file copied earlier.
{{</ admonition >}}


## Start the Java Application with the agent
Last but not least, we can now configure the [pods](https://kubernetes.io/docs/concepts/workloads/pods/) where we run our Java applications.

We will use the ``JAVA_OPTS`` environment variable to configure the location of the Java agent, and [the Elastic APM Java system properties](https://www.elastic.co/guide/en/apm/agent/java/current/configuration.html).

For instance: 

```jshelllanguage
JAVA_OPTS=-javaagent:/opt/agent/javaagent.jar -Delastic.apm.service_name=my-wonderful-application -Delastic.apm.application_packages=org.mywonderfulapp -Delastic.apm.server_url=http://apm:8200
```

You can then configure your Kubernetes deployment as:

```yaml
spec:
  containers:
  - name: java-app
    env:
    - name: JAVA_OPTS
      value: -javaagent:/opt/agent/javaagent.jar -Delastic.apm.service_name=my-wonderful-application -Delastic.apm.application_packages=org.mywonderfulapp -Delastic.apm.server_url=http://apm:8200
```

_Et voila!_

## Conclusion

We have seen how to pack and deploy Distributed Tracing java agents and Java Applications deployed on top of Docker images.
Obviously, my technical choice of using an InitContainer can be challenged regarding the technical context and how you are confortable with your delivery practices.
You probably noticed I use an emptyDir to deploy the Java agent.
_Normally_ it will not be a big deal, but I advise you to check this usage with your Kubernetes SRE/Ops/Administrator first.

Anyway, I think it is worth it and the tradeoffs are more than acceptable because this approach are, in my opinion, more flexible than the first one.

Hope this helps!
