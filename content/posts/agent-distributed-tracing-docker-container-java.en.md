---
title: "Deploy your Elastic APM Agent to Kubernetes and instrument your Java applications in a smart way"
date: 2023-10-24T10:28:11+02:00
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

In [my last article](https://blog.touret.info/2023/09/05/distributed-tracing-opentelemetry-camel-artemis/), I dug into enabling distributed tracing and exposed how to enable it in Java applications.
We didn't see how to deploy an application on Kubernetes and get distributed tracing insights. 
The are several strategies to achieve that, but the main point is how to minimize the impact of deploying APM agents on the whole delivery process.

In this article, I will expose how to ship APM agents for instrumenting Java applications deployed on top of Kubernetes through Docker containers.

In addition, to make it easy, I will illustrate this setup by the following use case:
We have an API _"My wonderful API"_ which is instrumented through an [Elastic APM agent](https://www.elastic.co/guide/en/apm/agent/index.html). 
The data is then sent to the [Elastic APM](https://www.elastic.co/guide/en/apm).

{{< style "text-align:center" >}}
![c4 context diagram](/assets/images/2023/10/architecture_system.svg )
{{</ style >}}

Now, if we dive into the _"Wonderful System"_, we can see the _Wonderful Java application_ and the agent:

{{< style "text-align:center" >}}
![c4 context diagram](/assets/images/2023/10/architecture_container.svg )
{{</ style >}}

We can basically implement this architecture in two different ways:

1. Deploying the agent in all of our Docker images
2. Deploying the agent asides from the Docker images and using initContainers to bring the agent at the startup of our applications

## Why not bringing APM agents in all of our Docker images?
It could be really easy to put the APM agents in the application's Docker images.
Nonetheless, if you want to upgrade your agent, you will have to repackage it and redeploy all your Docker images.
For regular upgrades, it won't bother you, but, if you encounter a bug, it could be tricky and annoying to do that.

What's why I prefer loose coupling the _"business"_ applications Docker images to technical tools such as APM agents.

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

```dockerfile
ENV JAVA_OPTS=$JAVA_OPTS
[...]
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} org.springframework.boot.loader.JarLauncher"]
```

Il will be used during the deployment to set up our _Wonderful Java Application_.

Now, let's build our initContainer Docker image.

### InitContainer Docker Image creation
It's really straightforward. 
We can use such a configuration:

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

{{< admonition tip "Why not copying the java agent directly in the initContainer Docker image execution?" >}}
The copy must be run with a command specified in the initContainer declaration and cannot be done during the initContainer execution (i.e., specified in its Docker file). 
Why?
The volume is mounted just after the initContainer execution and drops the JAR file copied earlier.
{{</ admonition >}}


## Start the Java Application with the agent
Last but not least, we can now configure our pods which run our Java applications.
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

## Conclusion
