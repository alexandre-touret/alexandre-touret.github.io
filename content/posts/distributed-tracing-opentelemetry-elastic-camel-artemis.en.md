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

_Distributed Tracing is the new black._ 

Among other things, it helps diving into distributed transactions getting into what are the different requests, their contexts and how long they are.

Since [Google published Dapper](https://research.google/pubs/pub36356/), many solutions came out. 
Now, OpenTelemetry is the most popular, but there are other solutions available such as Elastic APM or Dynatrace. 

This tooling fits well with synchronous transactions through API. 
However, what about asynchronous transactions?
The need of clarity is even more important in this case. 
When your architecture is based on a messaging / event streaming broker, it is quite hard to get an outlook of the whole transaction: from the producer to the consumer.

Hopefully you can do using OpenTelemetry.

{{< admonition info "What about the main concepts?" true >}}
I will not dig into the concepts of Distributed tracing in this article.
[If you are interested in it, you can read my article on the Worldline Tech Blog](https://blog.worldline.tech/2021/09/22/enabling_distributed_tracing_in_spring_apps.html).

{{< /admonition >}}


## OpenTelemetry

Pré requis
Architecture
Code
Configuration maven

...


## Elastic APM


