---
title: Enabling Distributed Tracing in asynchronous transactions with OpenTelemetry or Elastic APM
date: 2023-09-10 08:00:00
images: ["/assets/images/2023/09/nick-fewings-4dI5OP2Ee64-unsplash.webp"]
featuredImagePreview: /assets/images/2023/09/nick-fewings-4dI5OP2Ee64-unsplash.webp
featuredImage: /assets/images/2023/09/nick-fewings-4dI5OP2Ee64-unsplash.webp
og_image: /assets/images/2023/09/nick-fewings-4dI5OP2Ee64-unsplash.webp
draft: true

tags:
- AMQP
- OpenTelemetry
- Java
- Camel
- Artemis

---


## Introduction

Nowadays _Distributed Tracing is the new black._ 
Among other things, it helps diving into distributed transactions and answering the burning questions: what are the different requests, their contexts and how long they are.

Since [Google published Dapper](https://research.google/pubs/pub36356/), many solutions came out. 
Now, OpenTelemetry is the most popular, but there are other solutions available such as Elastic APM or Dynatrace. 

This tooling fits well with APIs and more broadly synchronous transactions. 
However, what about asynchronous transactions?
However, the need for clarity is more important in this case.
When your architecture is based on a messaging / event streaming broker, it is quite hard to get an outlook of the whole transaction.

You have indeed two loose coupled sub transactions:

{{< mermaid >}}sequenceDiagram
participant Producer
participant Consumer
participant Messaging/EventStreaming/Whatever
Producer->>Messaging/EventStreaming/Whatever: Send message
Consumer->>Messaging/EventStreaming/Whatever: Fetch message
{{< /mermaid >}}

Hopefully you can rope OpenTelemetry in it to shed light.

{{< admonition info "What about the main concepts?" true >}}
I will not dig into the concepts of Distributed tracing in this article.
[If you are interested in it, you can read my article on the Worldline Tech Blog](https://blog.worldline.tech/2021/09/22/enabling_distributed_tracing_in_spring_apps.html).
{{< /admonition >}}

I will explain in this article two ways of gathering  asynchronous transaction traces using [Apache Camel](https://camel.apache.org/) and [Artemis](https://activemq.apache.org/components/artemis/) through JMS. 
The first way is using [OpenTelemetry](https://opentelemetry.io/). The second is through [Elastic APM](https://www.elastic.co/fr/observability/application-performance-monitoring). 

## OpenTelemetry

### Architecture

The SPANs are broadcasted through OpenTelemetry and gathered through OpenTelemetry Collector.
It finally sends them to Jaeger. 
In this example, we can use it to browse and query. 

We can of course, move forward and use Grafana and Tempo to store and browse traces.

Here is the architecture of such a platform:

{{< mermaid >}}C4Container
title Distributed Tracing w/ OpenTelemetry


      Person(customerA, "Customer", "A customer") 
      

      Enterprise_Boundary(b0, "Boundary") {
        Container_Boundary(b1,"System"){
            Container(gateway,"API Gateway","Spring Cloud Gateway","Exposes the APIs")
            Container(producer,"Producer","Spring Boot, Cloud","Produces a message through an API")
            ContainerQueue(messaging, "Messaging", "Artemis", "Broadcasts messages")
            Container(consumer,"Consumer","Spring Boot, Cloud","Reads messages")
            Container(collector,"OTEL Collector","OpenTelemetry Collector")
            Container(jaeger,"Jaeger","Jaeger","Gathers and <br/> provides distributed tracing")
        }
      }

      Rel(customerA,gateway, "Uses")
      Rel(gateway, producer, "exposes")
      Rel(producer, messaging, "sends messages")
      Rel(consumer,messaging, "gets messages")
      Rel(gateway,collector,"broadcasts spans")
      Rel(producer,collector,"broadcasts spans")
      Rel(consumer,collector,"broadcasts spans")
      Rel(collector,jaeger,"broadcasts spans")
      UpdateLayoutConfig($c4ShapeInRow="3")
    
{{< /mermaid >}}

### OpenTelemetry Collector
### What about the code?

Code
Configuration maven

...

## Elastic APM


