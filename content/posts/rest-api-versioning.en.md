---
title: Real life Rest API Versioning for dummies
date: 2023-03-30 08:00:00
draft: true
images: ["/assets/images/2023/03/vardan-papikyan-DnXqvmS0eXM-unsplash.webp"]
featuredImagePreview: /assets/images/2023/03/vardan-papikyan-DnXqvmS0eXM-unsplash.webp
featuredImage: /assets/images/2023/03/vardan-papikyan-DnXqvmS0eXM-unsplash.webp

og_image: /assets/images/2023/03/vardan-papikyan-DnXqvmS0eXM-unsplash.webp

tags:
- REST
- API
- Versioning

---

## Once upon a time an API ...

{{< admonition quote "Second Law of Consulting" true >}}
“No matter how it looks at first, it’s always a people problem” - Gerald M. Weinberg
{{< /admonition >}}

Once upon a time, the [ACME Corporation](https://en.wikipedia.org/wiki/Acme_Corporation) was building a brand new IT product. 
It aimed at a new way managing bookstores through a new software which provides a web interface and an API.

At the early steps, the developers drew up a first roadmap of their API based on the expectations of their first customers.
They therefore built and shipped a microservices platform and released their first service contract for their early adopters.

Here is the design of this platform:

**The High level design**

{{< style "text-align:center" >}}
![c4 context diagram](/assets/images/2023/03/Bookstore-System_Context_diagram_for_Bookstore_System.svg )
{{</ style >}}

**More in depth**

{{< style "text-align:center" >}}
![c4 container diagram](/assets/images/2023/03/Bookstore-Container_Context_diagram_for_Bookstore_System.svg )
{{</ style >}}

To cut long story short, we have a microservices platform based on the [Spring Boot](https://docs.spring.io/spring-boot/docs/)/[Cloud](https://docs.spring.io/spring-boot/docs/) Stack exposed through an [API Gateway](https://spring.io/projects/spring-cloud-gateway) and [securised](https://github.com/spring-projects/spring-authorization-server/) using [OpenID Connect](https://openid.net/).

## The platform and its roadmap

After shipping this platform into production, they drew up a roadmap for their existing customers to both improve the existing features and bring new ones.

At as of now, we could think everything is _hunky dory_ isn't it?

While engineers strived to improve the existing API, the sales representative have contracted with new customers.
They enjoy this product and its functionalities.
However, they also bring new requirements and concerns.

Some of them are easy to apply. 
A new customer asked the [ACME engineers](https://en.wikipedia.org/wiki/Acme_Corporation)  for getting a ``summary`` for every book and additional REST operations. 

_Easy!_

However, last but not least, this customer would also get a list of authors for every book whereas the existing application only provides ONE author per book. 

{{< style "text-align:center" >}}
![c4 context diagram](/assets/images/2023/03/breaking_change.webp )
{{</ style >}}

**That point could be considered as a breaking change!**

{{< admonition info "What is a breaking change?" true >}}
A breaking change occurs when the backward compatibility is broken between two following versions.

For instance, when you completely change the service contract on your API, a client which uses the old API definition is unable to use your API.
{{< /admonition >}}

A common _theorical_ approach could be to versionise our APIs and adapt it according to the customer. 
Unfortunately, the devil is in the details.

I will describe in this article attention points I strived/struggled with in my last projects.

## What do we versionise? How and where to apply it?

After answering to the first question: _Do I really need API versioning?_ you then have to answer to this new one: what should we consider versioning?

You only have to version the service contract. 
In the case of a simple web application based on a GUI and an API

{{< style "text-align:center" >}}
![c4 context diagram](/assets/images/2023/03/monolith-Donuts___Home_Monolith.svg )
{{</ style >}}

Versioning is handled in the service contract of your API.
If you change your database without impacting the APIs, why should you waste your time creating and managing a version of your API.

On the other way around, when you evolve your service contract, you usually impact your database (e.g., see the first example of breaking change above).

Moreover, the version is usually specified on the _"middleware"_ side, where your expose your API. 


What about the GAFAM?


Few questions to ask to yourself ... and answer

If you want to avoir or postone it

Impacts

## Configuration management & automation

## Authorisation management

## Conclusion





