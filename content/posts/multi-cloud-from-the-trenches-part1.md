---
title: "Multi-Cloud from the Trenches: Part 1 - The Why and The What"
date: 2026-03-16 08:00:00
images: ["/assets/images/2026/03/joel-filipe-VuwAfoHpxgs-unsplash.webp"]
featuredImagePreview: /assets/images/2026/03/joel-filipe-VuwAfoHpxgs-unsplash.webp
featuredImage: /assets/images/2026/03/joel-filipe-VuwAfoHpxgs-unsplash.webp
lightgallery: true
og_image: /assets/images/2026/03/joel-filipe-VuwAfoHpxgs-unsplash.webp
tags:
  - Cloud
---


{{< style "text-align:center;" >}}
_Photo by <a href="https://unsplash.com/@joelfilip?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Joel Filipe</a> on <a href="https://unsplash.com/photos/low-angle-photo-of-30-st-mary-axe-VuwAfoHpxgs?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>_
      
{{< /style >}}      

For a couple of years, I have been regularly working on designing and implementing cloud-native landing zones on multiple cloud providers at once. 
When I started desigining such a platforms, I was a little bit scared. 
The theory was slighlty attractive: I could cherry pick the best services from each cloud provider to build the ultimate architecture. 
Nevertheless, I had expressed some reservations about operational worries : complexity, costs, observability, alerting and such like.

Why? The sad reality is actually that, beyond the commercial speeches, cloud platforms capabilities are not equals and they are not interchangeable. Then, the operational burden of managing multiple clouds is not linear. It may take you into a labyrinth of technical complexities where network latency, fragmented data and incompatible API threnten both your SLA and your peace of mind.

This article is the first part of a series that aims to share my experience and lessons learned from the trenches of multi-cloud. It will cover the "Why" and "What" of multi-cloud, exploring the motivations behind adopting such a strategy and defining what multi-cloud truly entails. Subsequent parts will delve into the "How," providing practical insights and strategies for successful multi-cloud implementations.

## Why

There are many reasons you may adopt a multi-cloud strategy. Whether you are drafting a hosting strategy at a global level of your company or when you are designing a new platform, multi-cloud can be a compelling option. Let's explore some of the most common drivers. For each of them, I will provide my **personal**  insights:

### Risk mitigation and business continuity

This is often cited as a primary driver for multi-cloud adoption. The idea is to avoid a single point of failure by distributing your workloads across multiple cloud providers. In the event of an outage or disaster with one provider, your services can theoretically failover to another, ensuring business continuity.

That was the easy part.
Behind the curtain, you will find that achieving true business continuity across multiple clouds is far more complex than simply replicating workloads. This is because it requires a deep understanding of each cloud provider's infrastructure, services, and APIs, as well as the ability to manage and orchestrate workloads across disparate environments. 

Beyond maintaining different tools and setups (e.g., 2 Terraform setups), you will also need to consider data replication strategies, network connectivity, and security implications across multiple environments.

Then, in my view, this use case is strictly reserved to highly sensitive workloads. Usually for financial institutions or public services which are providing services which are subject to military or governmental regulations such as the [OIV in France](https://www.sgdsn.gouv.fr/files/files/Nos_missions/plaquette-saiv.pdf), providing a multiple-region setup may be "enough" and might comply with these requirements and prevent any outage.

Nevertheless, at a company level, having a multi-cloud hosting for different platforms may be a good thing. It may offer the ability to choose the right hosting provider for every platform. In addition, it may help you to _easily_ switch from one provider to another if needed.

### Cost optimization

I will start this chapter by two jokes:
- Cloud hosting is cheaper than on-premise hosting
- Multi-Cloud hosting could save money by optimising costs


It's a joke, outillage, compétences, coûts supplémentaires

negociation


### 3. Vendor Lock-in avoidance

D'un point de vue organisation, ça a du sens, car ca permet de se garantir de la dépendance à un seul fournisseur.
en théorie
en pratique, si on ne garde que les standards et aucune fonctionnalité d'un fournisseur cloud, on se prive de beaucoup de fonctionnalités intéressantes

je pense qu'au lieu de se restreindre, il faut avoir une approche plus pragmatique et évaluer l'impact d'une migration : est-ce impossible ? sinon à quel coût ?

### 4. Best-of-Breed services

### 6. Regulatory compliance and data residency

organization / partnersship / compliance

different products


## What

configuration multi cloud dans le cadre d'une plateforme 

plusieurs acteurs et solutions sont envisagées et on va évaluer la pertinence du multi cloud

L'utilisateur veut un service et non plusieurs plateformes !

## Conclusion





