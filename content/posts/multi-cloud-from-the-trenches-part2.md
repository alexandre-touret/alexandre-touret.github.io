---
title: "Multi-Cloud from the Trenches: Part 2 - The How"
date: 2026-04-24 08:00:00
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



## Introduction

This article is the second part of a series on multi-cloud strategies. In the first part, we explored the reasons why organizations are adopting multi-cloud approaches and the benefits they can reap from it. Now, in this second part, we will dive into the practical aspects of implementing a multi-cloud strategy. We will discuss the key considerations, challenges, and best practices for successfully managing multiple cloud environments. I will also share some real-world examples and insights from my experience. 

Whether you are just starting to explore multi-cloud or are already in the midst of your journey, I hope this article will provide you with valuable guidance on how to navigate the complexities of multi-cloud and achieve your business goals. 

So, let's get started!

{{< admonition tip "The series" true >}}
- Part 1 : [Multi-Cloud from the Trenches: Part 1 - The Why](https://blog.touret.info/2026/03/12/multi-cloud-from-the-trenches-part1/)
{{< /admonition >}}

## How to start?

Check if multi-cloud is relevant

different partners with existing platforms --> it makes sense

Apply this iterative approach to your multi-cloud strategy. Start with a small use case, and then expand it gradually. This will allow you to learn and adapt as you go, and to avoid getting overwhelmed by the complexity of managing multiple cloud providers from the start.

// schema d'itération

## Back to basics

Pinpoint the different use cases and workloads.

// Exemple de decoupage fonctionnel

Check how to connect them together, 

Using BPMN to model the different processes and interactions between the various cloud providers and services.

// Exemple de BPMN

Try to keep every use case only on one cloud provider, to avoid complexity. But if you need to use multiple providers, make sure to clearly define the boundaries and interactions between them.

Interact between the different cloud providers with API. I consider them as different systems. It's important to check inputs and outputs, and how they interact with each other.

OK... this is the theory. 
You will get some use cases that require you to interact with multiple cloud providers. Your job as an architect is to weight the pros and cons of each approach: reusing as is this workload and have a cross-providers workload or re-implementing it on one provider. You will have to make trade-offs (everything in architecture is about trade-offs) between complexity, cost, performance, compliance and maintainability.

In practice, it's not that simple. For instance, I had in the past to deal with a database on Azure. It wasn't possible to interact with API. We had to use a secure connection to connect to the database, which added complexity and latency.
However, we had to make it work. Hopefully, it was only for a specific use case not on the critical path, and we were able to isolate it from the rest of the system. 

## The NFR
Check if we met the non-functional requirements, such as security, compliance, and performance, across all cloud providers.

## The fallacies of ~~Multi-cloud~~ Network Computing

https://en.wikipedia.org/wiki/Fallacies_of_distributed_computing

The originally listed fallacies are:

    The network is reliable;
    Latency is zero;
    Bandwidth is infinite;
    The network is secure;
    Topology doesn't change;
    There is one administrator;
    Transport cost is zero;
    The network is homogeneous;

## Compliance

Ne pas oublier les aspects de compliance, notamment en ce qui concerne les données. Il est important de vérifier les réglementations en vigueur dans les différents pays où les données sont stockées et traitées, et de s'assurer que les fournisseurs de cloud respectent ces réglementations.

Si vous devez vous conformer à des aspects reglementaires spécifiques, il est important de vérifier que les fournisseurs de cloud que vous utilisez sont conformes à ces réglementations.

Si possible, essayez de centraliser la gestion de la compliance pour éviter les erreurs et les incohérences entre les différents fournisseurs de cloud. Aussi un audit est assez lourd à traiter, si vous pouvez concentrer les données dans un seul fournisseur de cloud, cela peut faciliter la gestion de la compliance.

## Performance

Si on a bien séparé les uses cases, c'est gagné
sinon, il faut challenger les performances de chaque interaction entre les différents cloud providers. Il est important de vérifier que les performances sont acceptables pour chaque use case, et de faire des compromis si nécessaire.

## FinOps 
data transer costs, data egress costs, and the importance of monitoring and optimizing cloud spending across multiple providers.


## Conclusion

What about agnostic ?