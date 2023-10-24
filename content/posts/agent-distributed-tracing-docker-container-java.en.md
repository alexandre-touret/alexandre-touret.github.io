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

In [my last article](https://blog.touret.info/2023/09/05/distributed-tracing-opentelemetry-camel-artemis/), I dug into enabling distributed tracing and exposed how to enable it on Java applications.
Now, we must deploy it on Kubernetes and get distributed tracing insights. 
The main point is how to minimize the impact of deploying APM agents on the delivery of our applications.

In this article, I will expose how to ship APM agents for instrumenting Java applications deployed on top of Kubernetes through Docker containers.

In addition, to make it easy, I will illustrate this setup by this use case:
We have an API _"My wonderful API"_ which is instrumented through an Elastic APM agent. 
The data is then sent to the Elastic APM.


{{< style "text-align:center" >}}
![c4 context diagram](/assets/images/2023/10/architecture_system.svg )
{{</ style >}}

Now, if we dive into the "Wonderful System", we can see the Java application and the agent:

{{< style "text-align:center" >}}
![c4 context diagram](/assets/images/2023/10/architecture_container.svg )
{{</ style >}}

We can basically implement this architecture in two ways:

1. Deploy the agent in all Docker images
2. Deploy the agent asides from the Docker images and use initContainers to bring the agent at the startup of our applications  
## Why not bringing APM agents in all of our Docker images?

It could be really easy to put the APM agents in the application's Docker images.
Nonetheless, if you want to upgrade your agent, you will have to repackage and redeploy all your Docker images.
For regular upgrades, it won't bother you, but, if you encounter a bug, it could be tricky and annoying to do that.

What's why I prefer loose coupling the _"business"_ applications Docker images to technical tools such as APM agents.

## Deploy an APM agent through initContainers

While looking around how to achieve this, I came across to the [Kubernetes initContainers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

The only constraint is to declare a volume in your function

