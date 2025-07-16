# Lessons learned from an architecture kata: Workshop insights and design approaches


## Introduction

Last week, I had the opportunity to lead a workshop on Software Architecture at [Riviera Dev](rivieradev.fr/).

With the help of [my colleague Yassine Benabbas](https://dev.to/yostane), more than sixty participants learned and improved their design and architecture skills through a three-hour Architecture Kata based on a (not so) real-life use case.

If you are not familiar with Architecture Katas, I suggest you take a look at the following links:

* [A video captured during a conference](https://youtu.be/xLhb3mvweDI) and [the slides](https://speakerdeck.com/alexandretouret/architecture-katas-improve-your-system-architecture-design-skills-in-a-fun-way) where I introduce the concept.
* [An article from the Worldline Tech Blog](https://blog.worldline.tech/2019/12/12/architecture-katas.html).

In this article, as a follow-up, I will present some of the solutions proposed by the participants and then share my own proposition.

## The Kata

Before diving into the different solutions, [here is the Kata (in French)](/assets/images/2025/07/kata_rivieradev.pdf).

In short, the main objective was to design an innovative digital platform to promote sustainable and solidarity-based tourism. The platform targeted eco-conscious travelers, local ecological associations, and responsible tourism service providers.

Key features included user profiles with eco-friendly booking options, carbon footprint dashboards, gamification, and activity tracking. Associations could publish volunteer initiatives and gather support, while service providers could manage eco-labeled offers and reservations. IoT sensors monitored environmental quality, and integration with connected mobility enhanced eco-actions.

During this workshop, my colleague and I did our best to help more than ten teams design this platform. We assisted them in making assumptions, overcoming the blank page challenge, and validating their designs.

I present here three solutions. The first two drafts were created by two different teams and are published with their agreement.

## First proposition

Most of the attendees worked at Amadeus. They definitively used to with this kind of use case.
Among of them, [Christian Ceelen](https://www.linkedin.com/in/christian-ceelen-5891a33) and his team proposed this solution.

Here are some the diagrams made by Christian, and to be honest I was totally impressed!

{{< image-gallery dir="/assets/images/2025/07/michael_kata" >}}

{{< style "text-align:center" >}}
_Right Click on the picture then Open on a new tab to get the original one._
{{</ style >}}


{{< admonition type=tip title="How to browse this documentation" >}}
I suggest you download [this file](/assets/images/2025/07/michael_kata/travel.dsl) and go to [Structurizr](https://structurizr.com/dsl?src=https://docs.structurizr.com/dsl/tutorial/5.dsl) to try it out.
{{< /admonition >}}

## Second proposition

This proposition was submitted by [Nikita Rousseau](https://fr.linkedin.com/in/nikita-rousseau) and his teammates:

You could find below his feedback and take-aways in French:

{{< admonition type=quote title="Feedback" >}}
Les challenges :
- très peu de temps avec beaucoup de personnes 6P
- Faire un tour de table pour identifier les contributeurs et adapter le niveau de langage entre les acteurs
- Clarifier les termes et objets métiers qui vont être impliqués lors du design (parler d > experience pour coupler les notions du transport + hébergement + activité écolo + score)
-  Faire des workflows pour expliciter l'aspect fonctionnel de haut de niveau et vérifier que l'on répond au besoin
- Construire une maquette HLD qui implèmente les workflows (on parcours les fleches pour vérifier que l'on construit un système cohérent)
- Grouper par aspect fonctionnel pour ensuite proposer une implémentaiton technique

{{< /admonition >}}

They started working on a whiteboard but switched on DrawIO.

Below their design:

### High level design

![hld](/assets/images/2025/07/nikita_rousseau/hld.webp)

### Low level design

![lld](/assets/images/2025/07/nikita_rousseau/lld.webp)

## My proposition

{{< admonition warning "It's not complete (yet)" true >}}
Although I tried to create this design under similar conditions as the participants (within about 2 hours), it doesn't fully represent what can be achieved during a real Kata. In an actual session, you spend time debating and understanding the perspectives of different stakeholders. **Among other things, it needs to be challenged by peers**.

In summary, this is just an example of what could be designed based on the Kata topic. Feel free to reach out if I missed something (and I probably did!).

{{< /admonition >}}

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
The NFRs ([RTO, RPO](https://en.wikipedia.org/wiki/IT_disaster_recovery)) are very well described in the document. Both the [RTO & RPO](https://en.wikipedia.org/wiki/IT_disaster_recovery) definition are prioritized according to the business functionalities.

For instance, we can check that the financial transactions are highly criticals. 
Therefore, it makes sense to reuse and buy an external service which could handle such a requirements.

#### High level design (System View)

##### Assumptions

As said above, I chose not to implement the payment/donations functionality and use/buy an external service. It helps me avoid dealing with the strong RTO & RPO and the related compliancy (i.e., [PCI-DSS](https://www.pcisecuritystandards.org/)). 

Then, I chose not to include the IoT sensors in my design. Instead, I decided to require all sensors to comply with a mandatory service contract.

##### Actors & external systems

I identified the different actors :

* Traveller
* Sustainable Travel Service Provider

And the external services:

* IOT Devices
* PSP (Payment Service Provider)

##### Design

![hld](/assets/images/2025/07/att-hld.svg)

#### Low Level Design (Container View)

##### Traveller Portal view

![lld1](/assets/images/2025/07/att_lld/structurizr-1-TravellerPortal.svg)

##### Local Organisation Portal view

![lld1](/assets/images/2025/07/att_lld/structurizr-1-LocalOrganizationPortal.svg)

##### Service Provider Portal view

![lld1](/assets/images/2025/07/att_lld/structurizr-1-ServiceProvider.svg )

##### IOT Carbon Efficiency Monitoring

![lld1](/assets/images/2025/07/att_lld/structurizr-1-CarbonEfficiencyMonitoring.svg)

If you want to browse the documentation with the help of Structurizr, you can check out the model [here](https://gist.github.com/alexandre-touret/e0b7dfea74ff6d3483e439865e08b4eb).

## Conclusion
You probably noticed some differences between the three propositions. This is perfectly normal—depending on background, experience, and available time, people may choose different approaches.

As the saying goes: put three architects in a room with one platform to design, and you'll probably end up with four solutions.

Jokes aside, when faced with such dilemmas, it's best to choose the simplest and most adaptable solution.

Furthermore, I explained the whole approach in [these slides](https://speakerdeck.com/alexandretouret/rvd25-katas-darchitecture-workshop).

Finally, the final design diagrams are only a part of the take aways. 

Practising Architecture katas on a regular basis also enable:
* Learning from the experience of his/her peers
* Deep diving into a new subject in a short time
* Taking decisions, assumptions
* Communicating and explain the design decisions (perhaps the most important part)
