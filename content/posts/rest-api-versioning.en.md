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

Once upon a time, the [ACME Corporation](https://en.wikipedia.org/wiki/Acme_Corporation) was building a brand new IT product. 
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

After shipping it into production, they drew up a roadmap for their existing customers to both improve the existing features and bring new ones.

As of now, we could think everything is _hunky-dory_ isn't it?

While engineers worked on improving the existing API, the sales representative have contracted with new customers.
They enjoyed this product and its functionalities.
However, they also ask for new requirements and concerns.

Some of them are easy to apply, some not.
For instance, a new customer asked the [ACME engineers](https://en.wikipedia.org/wiki/Acme_Corporation)  for getting a `summary` for every book and additional REST operations. 

_Easy!_

However, last but not least, this customer would also get a list of authors for every book whereas the existing application only provides ONE author per book. 

{{< style "text-align:center" >}}
![Breaking change](/assets/images/2023/03/breaking_change.webp )

**This is a breaking change!**

{{</ style >}}


{{< admonition info "What is a breaking change?" true >}}
A breaking change occurs when the backward compatibility is broken between two following versions.

For instance, when you completely change the service contract on your API, a client which uses the old API definition is unable to use your new one.
{{< /admonition >}}

A common _theoretical_ approach could be to apply versions on our APIs and adapt it according to the customer. 

Unfortunately, the devil is in the details.

I will describe in this article attention points I struggled with in my last projects.

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

Throughout my different experiences struggling with API versioning, the most acceptable trade-off for both the API provider and customer/client was to only handle two versions: the current and the deprecated one.

### Where?
Now, you have to answer to this question: Where should I handle the version?

* On the Gateway?
* On Every Backend?
* On every service or on every set of services?
* Directly in the code managed by different packages.

Usually, I prefer manage it on the gateway side and don't bother with URL management on every backend.
It could avoid maintenance on both code and tests for every release. 
However, you can't have this approach on monolithic applications (see below).

### How to define it?

Here are three ways to define API versions:

* In the URL (e.g., ``/v1/api/books``)
* In a HTTP header (e.g., ``X-API-VERSION: v1``)
* In the content type (e.g., ``Accept: application/vnd.myname.v1+json``)

I strongly prefer the first one. It is the most straightforward.

For instance, if you provide your books API first version, you can declare this URL in your OpenAPI specification:

``/v1/api/books``.

The version declared here is pretty clear and difficult to miss.
If you specify the version in a HTTP header, it's less clear. 
If you have this URL ``/api/books`` and the version specified in this header: ``X-API-VERSION: v1``, what would be the version called (or not) if you didn't specify the header? Is there any default version?

Yes, you can read the documentation, but who (really) does? 

The first solution (i.e., version in the URL) mandatory conveys the associated version. 
It is so visble for all the stakeholders and could potentially avoir any mistakes or headaches while debugging.

## What about the main software/cloud providers?
Before reinventing the wheel, let's see how the main actors of our industry deal with this topic.
I looked around and found three examples:

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

In my opinion, technologies based on the [monolith pattern](https://microservices.io/patterns/monolithic.html) don't fit handling _properly_ API Versioning.
If you are not eager to execute two versions of your [monolith](https://microservices.io/patterns/monolithic.html), you would have to provide both of the two versions within the same app and runtime.

You see the point?

You would therefore struggle with:
* packaging
* testing both of two releases for every deployment even if a new feature doesn't impact the deprecated version
* removing, add new releases in the same source code,... and loosing your mind.

In my opinion, best associated technologies are more modular whether during the development or deployment phases.

For instance, if you built your app with Container based (Docker, Podman, K8S,..) stack, you would easily switch from one version to another, and sometimes you would be able to ship new features without impacting the oldest version.

However, we need to set up our development and integration workflow to do that.

## Configuration management & delivery automation

When I dug into API versioning, I realized it impacts projects organisation and, by this way, the following items:

* The source code management: _one version per branch or not?_
* The release process: _How to create releases properly?_
* Fixes, merges,...: _How to apply fixes among branches and versions?_
* The delivery process: _How to ship you versions?_

Yes **it IS a big deal**

Here is _the least bad_ approach I think it works while addressing all of these concerns:

### Source code configuration

When you want to have two different versions in production, you must decouple your work in several GIT (what else) branches.

For that, I usually put in place [GitFlow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).


{{< figure src="/assets/images/2023/03/gitflow.svg" title="source: Atlassian" >}}

Usually, using this workflow, we consider the ``develop``  branch serves as an integration branch. 
But, now we have two separate versions? 
Yes, but don't forget we have a **current** version and a **deprecated one**.

{{< admonition info "SemVer" true >}}
I base my versioning naming and numbers on [SemVer](https://semver.org/)

{{< /admonition >}}

To handle API versions, we can use [``release`` branches](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).

You can easily declare versions regarding your API versions.

For instance:

* ``release/book-api-1.0.1``
* ``release/book-api-2.0.1``

We can so have the following workflow:

1. Develop features in feature branches and merge them into the ``develop`` branch.
2. Release and use major release numbers (or whatever) to identify breaking changes and your API version number
3. Create binaries (see below) regarding the tags and release branches created
4. Fix existing branches when you want to backport features brought by new features (e.g., when there is an impact on the database mapping), and release them using minor version numbers
5. Apply fixes and create releases

### Delivery process

As of now, we saw how to design, create and handle versions.

But, how to ship them?

I you based your source code management on top of GitFlow, you would be able now to deliver releases available from git tags and release branches. 
The good point is you can indeed build your binaries on top of these ones. 
The bad one, is you must design and automatise this whole process in a CI/CD pipeline.

{{< admonition tip "Share it" true >}}
Don't forget to share it to all the stakeholders, whether developers, integrators or project leaders who are often involved in version definition.
{{< /admonition >}}

_Hold on, these programs must be executed against a configuration, aren't they?_


Nowadays, if we respect the [12 factors](https://12factor.net/) during our design and implementation, the configuration is provided through environment variables. 

Yes, your API versioning will also impact your configuration.
It's so mandatory to externalise and versionize it.

You can do it in different ways.

You can, for example, deploy a configuration server.
It will provide configuration key/values regarding the version.

If you want a live example, you can [get an example in a workshop I held this year at SnowcampIO](https://github.com/alexandre-touret/rest-apis-versioning-solution).
The configuration is managed by [Spring Cloud Config](https://docs.spring.io/spring-cloud-config/docs/current/reference/html/#_quick_start).

You can also handle your configuration in your Helm Charts if you deploy your app on top of Kubernetes. 
Your configuration values will be injected directly during the deployment. 

Obviously if it's a monolith, it will be strongly difficult.
Why?
Because you will loose flexibility on version management and the capacity on deploying several versions of your service.

## Authorisation management

Here is another point to potentially address when we implement API versioning. 
When you apply an authorisation mechanism on your APIs using [OAuthv2](https://oauth.net/2/) or [OpenID Connect](https://openid.net/), you would potentially have strong differences in your authorisation policies between two major releases.

You would then restrict the usage of a version to specific [clients or end users](https://openid.net/specs/openid-connect-core-1_0.html#Terminology).
One way to handle this is to use [scopes](https://openid.net/specs/openid-connect-core-1_0.html#ScopeClaims) stored in claims.

In the use case we have been digging into, we can declare scopes such as: ``book:v1:write`` or ``number:v2:read`` to specify both the authorised action and the corresponding version.

For example, here is a request to get an [access_token](https://oauth.net/2/access-tokens):

```bash
http --form post :8009/oauth2/token grant_type="client_credentials" client_id="customer1" client_secret="secret1" scope="openid book:v1:write book:v1:write number:v1:read"
```

And the response could be:

```bash
{
    "access_token": "eyJraWQiOiIxNTk4NjZlMC0zNWRjLTQ5MDMtYmQ5MC1hMTM5ZDdjMmYyZjciLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJjdXN0b21lcjIiLCJhdWQiOiJjdXN0b21lcjIiLCJuYmYiOjE2NzI1MDQ0MTQsInNjb3BlIjpbImJvb2t2Mjp3cml0ZSIsIm51bWJlcnYyOnJlYWQiLCJvcGVuaWQiLCJib29rdjI6cmVhZCJdLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwMDkiLCJleHAiOjE2Nz
I1MDQ3MTQsImlhdCI6MTY3MjUwNDQxNH0.gAaDcOaORse0NPIauMVK_rhFATqdKCTvLl41HSr2y80JEj_EHN9bSO5kg2pgkz6KIiauFQ6CT1NJPUlqWO8jc8-e5rMjwWuscRb8flBeQNs4-AkJjbevJeCoQoCi_bewuJy7Y7jqOXiGxglgMBk-0pr5Lt85dkepRaBSSg9vgVnF_X6fyRjXVSXNIDJh7DQcQQ-Li0z5EkeHUIUcXByh19IfiFuw-HmMYXu9EzeewofYj9Gsb_7qI0Ubo2x7y6W2tvzmr2PxkyWbmoioZdY9K0
nP6btskFz2hLjkL_aS9fHJnhS6DS8Sz1J_t95SRUtUrBN8VjA6M-ofbYUi5Pb97Q",
    "expires_in": 299,
    "scope": "book:v2:write number:v2:read openid book:v2:read",
    "token_type": "Bearer"
}
```

Next, you must validate every API call with the version exposed by your API gateway and the requested scope.
When a client tries to reach an API version with inappropriate scopes (e.g., using ``book:v1:read`` scope for a client which only uses the v2).

You will throw this error:

```json
{
    "error": "invalid_scope"
}
```

## And now something completely different: How to avoid versioning while evolving your API?

You probably understood it's totally cumbersome.

Before putting in place all of these practices, there's another way to add functionalities on a NON-versioned API without impacting your existing customers. 

**You can add new resources, operations and data without impacting your existing users.**
With the help of serialization rules, your users would only use the data and operations they know and are confident with. 
You will therefore bring backward compatibility of your API.

Just in case, you can anticipate API versioning by declaring a ``V1`` prefix on your API URL and stick to it while it's not mandatory to upgrade it.
That's how and why Spotify and Apple (see above) still stick to the ``V1``.

## Wrap-up

You probably understood when getting into this topic it's a project management issue consequences that requires tackling difficult technical consequences
To sum up, you need to ask to yourself these questions:
* Do I need it?
* Can I postpone API versioning by dealing with serialization rules and just adding new data or operations?
* Is my architecture design compatible?
* Are my source code management and delivery practices compatible?

After coping with all these points, if you must implement API versioning, you would need onboarding all the different stakeholders, not just developers, to be sure your whole development and delivery process is well aligned with practice.

And I forgot: _Good luck!_