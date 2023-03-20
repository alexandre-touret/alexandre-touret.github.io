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
_“No matter how it looks at first, it’s always a people problem” - Gerald M. Weinberg_
{{< /admonition >}}

Once upon a time, the [ACME Corporation](https://en.wikipedia.org/wiki/Acme_Corporation) was building a brand ne1w IT product. 
It aimed at a new software to manage bookstores through a web interface and an API.

In the first steps, the developers drew up a first roadmap of their API based on the expectations of their first customers.
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

{{< admonition info "To sum up" true >}}
To cut long story short, we have a microservices platform based on the [Spring Boot](https://docs.spring.io/spring-boot/docs/)/[Cloud](https://docs.spring.io/spring-boot/docs/) Stack exposed through an [API Gateway](https://spring.io/projects/spring-cloud-gateway) and [secured](https://github.com/spring-projects/spring-authorization-server/) using [OpenID Connect](https://openid.net/).
{{< /admonition >}}

## The platform and its roadmap

After shipping this platform into production, they drew up a roadmap for their existing customers to both improve the existing features and bring new ones.

At as of now, we could think everything is _hunky dory_ isn't it?

While engineers worked on improving the existing API, the sales representative have contracted with new customers.
They enjoy this product and its functionalities.
However, they also ask for new requirements and concerns.

Some of them are easy to apply, some not.
For instance, a new customer asked the [ACME engineers](https://en.wikipedia.org/wiki/Acme_Corporation)  for getting a ``summary`` for every book and additional REST operations. 

_Easy!_

However, last but not least, this customer would also get a list of authors for every book whereas the existing application only provides ONE author per book. 

{{< style "text-align:center" >}}
![Breaking change](/assets/images/2023/03/breaking_change.webp )
{{</ style >}}

**This is a breaking change!**

{{< admonition info "What is a breaking change?" true >}}
A breaking change occurs when the backward compatibility is broken between two following versions.

For instance, when you completely change the service contract on your API, a client which uses the old API definition is unable to use your current one.
{{< /admonition >}}

A common _theoretical_ approach could be to apply versions on our APIs and adapt it according to the customer. 
Unfortunately, the devil is in the details.

I will describe in this article attention points I strived/struggled with in my last projects.

## What do we versionize? How and where to apply it?

After answering to the first question: _Do I really need API versioning?_ you then have to answer to this new one: what should we consider versioning?

**You only have to version the service contract.**

In the case of a simple web application based on a GUI and an API

{{< style "text-align:center" >}}
![c4 monolith](/assets/images/2023/03/monolith-Donuts___Home_Monolith.svg )
{{</ style >}}

Versioning is applied in the service contract of your API.
If you change your database without impacting the APIs, why should you waste your time creating and managing a version of your API?
It doesn't make sense.

On the other way around, when you evolve your service contract, you usually impact your database (e.g., see the first example of breaking change above).

Moreover, the version **is usually specified on the _"middleware"_ side, where your expose your API.**

### How many versions must I handle?
Tough question!

Throughout my different experiences struggling with API versioning, I have noticed the least worst solution was to only handle two versions: the current and the deprecated one. It's the most convenient trade-off for the API provider and customer/client. 

### Where?
Now, you have to answer to this question: Where should I handle the version?

* On the Gateway?
* On Every Backend?
* On every service or on every set of services?
* Directly in the code managed by different packages.

Usually, I prefer manage it on the gateway side and don't bother with URL management on every backend? 
It could avoid maintenance on both code and tests for every release.

### How to define it?

Here are three ways to define API versions:

* In the URL (e.g., ``/v1/api/books``)
* In a HTTP header (e.g., ``X-API-VERSION: v1``)
* In the content type (e.g., ``Accept: application/vnd.myname.v1+json``)

I strongly prefer the first one. It is the most straightforward.

## What about the main software/cloud providers?
Before reinventing the wheel, let's see how the main actors of our industry deal with this topic.
I looked around this topic and I found three examples:

### Google
* The version is specified in the URL 
* It only represents the major versions which handle breaking changes

### Spotify
* The version is specified in the URL 
* The API version is still ``V1`` ...

### Apple
* The version is specified in the URL 
* The API version is still ``V1`` ...

## Appropriate (or not) technologies

In my opinion, technologies based on a monolith don't fit to handle _properly_ API Versioning.
If you are not eager to execute two versions of your monolith, you would have to provide both of the two versions with the same app and runtime.

You see the point?

You would therefore struggle with 
* packaging
* testing both of two releases for every deployment even if a new feature doesn't impact the deprecated version
* removing, add new releases in the same source code,... and loosing your mind.

In my opinion, best associated technologies are more modular whether during the development or deployment phases.

For instance, if you built your app with Container based (Docker, Podman, K8S,..) stack, you would easily switch from one version to another, and sometimes you would be able to ship new features without impacting the oldest version.

However, we need to organize our development and integration workflow to do that.

## Configuration management & delivery automation

When I dug into API versioning, I realized it impacts projects organisation and, by this way, the following items:

* The source code management: _one version per branch or not?_
* The release process: _How to create releases properly?_
* Fixes, merges,...: _How to apply fixes among branches and versions?_
* The delivery process: _How to ship you versions?_

Yes **it IS a big deal**

Here is _the least worst_ approach I think it works while addressing all of these concerns:

### Source code configuration

When you want to have two different versions in production, you must decouple your work in several GIT (what else) branches.

For that, I usually put in place [GitFlow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).

{{< style "text-align:center" >}}
![gitflow](/assets/images/2023/03/gitflow.svg)
{{</ style >}}

Usually, using this workflow, we consider the ``develop``  branch serves as an integration branch. 
But, now we have two separate versions? 
Yes, but don't forget we have a **current** version and a **deprecated one**.

{{< admonition info "Semver" true >}}
I base my versioning naming and numbers on on [SemVer](https://semver.org/)

{{< /admonition >}}

To handle API versions, we can use [``release`` branches](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).

You can easily declare versions regarding your API versions.

For instance:

* ``release/api-1.0.1``
* ``release/api-2.0.1``

We can so have the following workflow:

1. Develop features in feature branches and merge them into the ``develop`` branch.
2. Release and use major releases numbers (or whatever) to identify breaking changes and your API version number
3. Create binaries (see below) regarding the tags and release branches created
4. Fix existing branches when you want to backport features brought by new features (e.g., when there is an impact on the database mapping), and release them using minor version numbers
5. Apply fixes and create releases

### Delivery process



## Authorisation management

## Conclusion

You probably understood when getting into this topic it's a project management cause which have many technical consequences!



Few questions to ask to yourself ... and answer

If you want to avoir or postone it

You have then to be careful with your kind of architecture. 
If it is a monolith, it will be really difficult to implement versioning. Why? Because you will loose flexibility on version management and the capacity on deploying several versions of your service.

Impacts