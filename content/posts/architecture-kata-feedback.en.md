---
title: Architecture Kata Insights
date: 2025-07-15 08:00:00
images: ["/assets/images/2025/07/8766b1ec-22e1-44a7-af3f-006a27d2bf3e.webp"]
featuredImagePreview: /assets/images/2025/07/8766b1ec-22e1-44a7-af3f-006a27d2bf3e.webp
featuredImage: /assets/images/2025/07/8766b1ec-22e1-44a7-af3f-006a27d2bf3e.webp
lightgallery: true
og_image: /assets/images/2025/07/8766b1ec-22e1-44a7-af3f-006a27d2bf3e.webp
tags:
  - conference
---

## Introduction

Last week, I had the opportunity to lead a workshop at [Riviera Dev](rivieradev.fr/) on Software Architecture.

Through a three-hour Architecture Kata, more than sixty participants have learned and improved their design/architecture skills through a (not so)real-life use case.

If you are not familiar with the Architecture Katas, I suggest you have a sneak peek on the following links:

* [A video captured during a conference](https://youtu.be/xLhb3mvweDI) and [the slides](https://speakerdeck.com/alexandretouret/architecture-katas-improve-your-system-architecture-design-skills-in-a-fun-way) where I introduce the concept.
* [An article from the Worldline Tech Blog](https://blog.worldline.tech/2019/12/12/architecture-katas.html).


In this article, as a follow up, I will expose some of the solutions proposed by the participants and give then my proposition.

## The Kata

Before getting into the different propositions, [here is the Kata (in French)](/assets/images/2025/07/kata_rivieradev.pdf)

To sum up, the main purpose was to design an innovative digital platform to promote sustainable and solidarity-based tourism. The platform targeted eco-conscious travelers, local ecological associations, and responsible tourism service providers.

Key features included user profiles with eco-friendly booking options, carbon footprint dashboards, gamification, and activity tracking. Associations could publish volunteer initiatives and gather support, while service providers can manage eco-labelled offers and reservations. IoT sensors monitored environmental quality, and integration with connected mobility enhances eco-actions.

## First proposition

Most of the attendees worked at Amadeus. They definitively used to with this kind of use case.
Among of them, [Christian Ceelen](https://www.linkedin.com/in/christian-ceelen-5891a33) and his team proposed this solution.


Here are some the diagrams made by Christian, and to be honest I was totally impressed!

{{< gallery >}}
![1](/assets/images/2025/07/michael_kata/17-14-15.png)
![2](/assets/images/2025/07/michael_kata/17-14-26.png)
![2](/assets/images/2025/07/michael_kata/17-14-38.png)
![2](/assets/images/2025/07/michael_kata/17-14-50.png)
![2](/assets/images/2025/07/michael_kata/17-14-57.png)
![2](/assets/images/2025/07/michael_kata/17-15-03.png)
![2](/assets/images/2025/07/michael_kata/17-15-09.png)
![2](/assets/images/2025/07/michael_kata/17-15-14.png)
![2](/assets/images/2025/07/michael_kata/17-15-15.png)
![2](/assets/images/2025/07/michael_kata/17-15-25.png)
{{< /gallery >}}


{{< admonition type=tip title="How to browse this documentation" >}}
I suggest you download [this file](/assets/images/2025/07/michael_kata/travel.dsl) and go to [Structurizr](https://structurizr.com/dsl?src=https://docs.structurizr.com/dsl/tutorial/5.dsl) to try it out.
{{< /admonition >}}


## Second proposition

This proposition was submitted by Nikita Rousseau and his teammates:

You could find below his feedback and take-aways in French:

> Les challenges :
> - très peu de temps avec beaucoup de personnes 6P
> - Faire un tour de table pour identifier les contributeurs et adapter le niveau de langage entre les acteurs
> - Clarifier les termes et objets métiers qui vont être impliqués lors du design (parler d > experience pour coupler les notions du transport + hébergement + activité écolo + score)
> -  Faire des workflows pour expliciter l'aspect fonctionnel de haut de niveau et vérifier que l'on répond au besoin
> - Construire une maquette HLD qui implèmente les workflows (on parcours les fleches pour vérifier que l'on construit un système cohérent)
> - Grouper par aspect fonctionnel pour ensuite proposer une implémentaiton technique

They started working on a whiteboard but switched on DrawIO.

Below their design:

### High level design

![hld](/assets/images/2025/07/nikita_rousseau/hld.webp)

### Low level design

![lld](/assets/images/2025/07/nikita_rousseau/lld.webp)

## My proposition

### My approach (in nutshell)

Here are some of the guidelines I gave to the attendees: 

1. Start asking "Why a new app?
2. Pinpoint the Business & Non-Functional Requirements  and the key figures
3. Dig into the design step by step

Furthermore, when some of them were completely stuck, I gave this pice of advice: start identify the main business flows and design your platform upon these ones.

Finally, throughout the design, it's really important to focus on the core business and give the opportunity to re-use external services.

#### Business Flows

1. Searching, booking, traveller profile & dashboard
2. Local & sustainable activities publishing, enrollment & management
3. Communication
4. Payment, donations
5. IoT metrics gathering & dashboards
6. Mobile & Web interactions

#### NFRs
The NFRs (RTO, RPO) are very well described in the document. Both the RTO & RPO definition are prioritized according to the business functionalities.

For instance, we can check that the financial transactions are highly criticals. 
Therefore, it makes sense to reuse and buy an external service which could handle such a requirements.

#### High level design (System View)

##### Assumptions

As said above, I chose not to implement the payment/donations functionality and use/buy an external service. It helps me avoid dealing with the strong RTO & RPO and the related compliancy (PCI-DSS). 

##### Actors & external systems

I identified the different actors :

* Traveller
* Sustainable Travel Service Provider

And the external services:

* IOT Devices
* PSP (Payment Service Provider)

##### Design

![hld](/assets/images/2025/07/att-hld.png)

#### Low Level Design (Container View)


## Conclusion

You probably noticed slight differences between the three propositions. 
This is normal. Depending on background, experience, and time, we may choose different approaches.

To cut a long story short: put 3 architects in a room and one platform to design, you will probably get 4 solutions...

Joking aside, if you face such a dilemma, you should choose the simplest and most evolutive solution.
