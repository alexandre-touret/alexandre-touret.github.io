---
title: Moving from Spring Boot to Quarkus
date: 2025-01-20 08:00:00
images: ["/assets/images/2025/01/jdino-reichmuth-A5rCN8626Ck-unsplash.webp "]
featuredImagePreview: /assets/images/2025/01/dino-reichmuth-A5rCN8626Ck-unsplash.webp 
featuredImage: /assets/images/2025/01/dino-reichmuth-A5rCN8626Ck-unsplash.webp 
og_image: /assets/images/2025/01/dino-reichmuth-A5rCN8626Ck-unsplash.webp 
tags:
  - quarkus
  - spring
  - java
draft: true
---
{{< style "text-align:center;" >}}
_Photo by [Dino Reichmuth](https://unsplash.com/@dinoreichmuth?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash) on [Unsplash](https://unsplash.com/photos/yellow-volkswagen-van-on-road-A5rCN8626Ck?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)
      
{{< /style >}}

After mostly a decade coding with Spring Boot, I chose to switch to Quarkus for a workshop about API-First ... and was quite late to the party ...

Furthermore, I already gave it a spin few years ago and I was not really convinced by the worthiness of such a move. By the way, I presented in 2022 a talk about that topic with a former colleague of mine [Jean-François James](https://jefrajames.fr/). 
We compared both of the two solutions and our conclusion was the functionalities provided by Spring Boot & Quarkus were sightly similar.

2-3 years passed. I then decided to use it and see how it has evolved.
Some points still miss, but nevertheless I was really impressed.
I will then try to sum up in this article my journey so far from a developer point of view.

## The context

Instead of reusing one of my existing workshops, I chose to start a new platform from the ground up. 

Here is the context diagram:

{{< style "text-align:center;" >}}
![context diagram](/assets/images/2025/01/guitar_heaven_context.png)
{{< /style >}}

And the container diagram:

{{< style "text-align:center;" >}}
![context diagram](/assets/images/2025/01/guitar_heaven_container.png)
{{< /style >}}

Basically, it is a simple monolithic application with a database which reaches external services:
* [EBay](https://developer.ebay.com/).
* A back office called through Kafka.

{{< admonition type=warning title="This app is not production ready (yet)" >}}
I drafted and created this application as part of [a workshop on API-First](https://blog.touret.info/api-first-workshop/).
It is not a production-ready. It misses many aspects such as Observability or security.
{{< /admonition >}}

## Developer experience

My first surprise, was when I started first Quarkus. [After generating the project and selecting the different requirements](https://code.quarkus.io/), I ran into two main components which, in my view, significantly  improve the Developer Experience (DX) and go far beyond I used to with Spring:

* The [Dev UI](https://quarkus.io/guides/dev-ui)
* The [Dev Services](https://quarkus.io/guides/dev-services)

Usually many developers look down on Java because it hard to setup, the integration with external services could be painful. 
Through these two tools, I think Quarkus found a smart answer to these worries.

Once you defined your extensions such as PostgreSQL, you have automatically the corresponding dev services enabled and you can use them either in your integration tests or directly through [the dev mode](https://quarkus.io/guides/dev-mode-differences).

Last but not least, you can browse all of these through the dev-ui. As mentioned [in the Quarkus Guide](https://quarkus.io/guides/dev-ui).

{{< admonition type=quote title="It allows you to" >}}
 - quickly visualize all the extensions currently loaded
 - view extension statuses and go directly to extension documentation
 - view and change Configuration
 - manage and visualize Continuous Testing
 - view Dev Services information
 - view the Build information
 - view and stream various logs

{{< /admonition >}}

Concretely, what it means for me? 
I do not have to bother me again on setting up a local Docker compose environment for testing the plateform locally!
Usually I had to setup and provide to developers such a tooling to enable local testing. 

[Spring also provides Dev Services](https://docs.spring.io/spring-boot/reference/features/dev-services.html). However, I think (_it is only my opinion_), Quarkus provides it as a end to end solution to developers.

## Tools & Framework integration

## API-First

Generation

Swagger/ Small Rye

## Persistence

## Difficulties and some functionalities still missing (from my point of view)

## Conclusion