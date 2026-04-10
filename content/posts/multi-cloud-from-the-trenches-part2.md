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

First and foremost, it's important to start with a **clear strategy**.
It is essentially the same approach as any other architectural strategy: start with the business goals and requirements, then design the technical solution that best meets those needs.
However, in the case of multi-cloud, there are some specific considerations to take into account throughout the process.
It requires an iterative approach.
Once you have made the decision to adopt a multi-cloud strategy, you should start by identifying the use cases and workloads that are best suited to each cloud provider.
This will allow you to leverage the strengths of each provider and optimize your costs and performance.
This step will help you determine whether building a multi-cloud platform is relevant.

{{< admonition tip "Part 1" true >}}
By the way, I strongly recommend reading the first part of this series before addressing the next steps. I will then assume that you have already identified the reasons why you want to adopt a multi-cloud strategy and that you have a clear understanding of the benefits and challenges associated with it.
{{< /admonition >}}

Personally, I started working on multi-cloud architectures when I was on a project that required us to use existing products from both Azure and GCP operated by different teams.
Each of these products had specific features and capabilities that were essential for our use case.
Instead of reinventing the wheel by moving an existing product to another cloud platform and causing a skyrocketing cost increase, we chose to integrate these products, and we designed a solution that could leverage the strengths of both providers, combining off-the-shelf products and custom solutions while also ensuring that we could manage the complexity of using multiple cloud platforms.

What I learned from this experience is that the key to successfully implementing a multi-cloud strategy is to start with a clear understanding of your business goals and requirements, and then design a solution that can leverage the strengths of each cloud provider while managing the complexity of multiple platforms. When your technical strategy is based on products, your process is less complex. You start by pinpointing the different use cases and workloads, and how compatible they are with the available products. Then you check how to connect them together and how to interact with different cloud providers through APIs.

Then, if you start from the ground up, you will have to design the whole system and make a lot of trade-offs between complexity, cost, performance, compliance, and maintainability.
Generally speaking, you will have the same trade-offs to make, and you will need more design and project iterations than if you were to use existing products.

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

## DRS & Reliability
You mention trade-offs, but not explicit advice on DR/multi-cloud failover, backup, or high-availability design patterns.

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


## Automation & DevOps
 Automation for policy enforcement, configuration drift management, and audit trails across clouds.
## Identity & Access Management
Centralized IAM/federation (SSO, RBAC, minimizing privilege sprawl across clouds).
## Skillsets & Process
Team training, cross-cloud architectural patterns, runbook/playbook development.

## Conclusion

What about agnostic ?



- Operational Excellence: Automation, iterative improvement, monitoring, incident response
- Security: Identity/access management, encryption, data protection, compliance controls, zero trust principles
- Reliability: Disaster recovery planning, backup, failover, multi-region/multi-cloud redundancy, SLAs
- Performance Efficiency: Resource right-sizing, latency/bandwidth planning, network design, capacity management
- Cost Optimization: FinOps, monitoring usage, cross-cloud cost comparison and controls, spend optimization
- Sustainability: Resource utilization, energy consumption, green practices (if relevant)
- Governance: Policy management, cloud provider account management, auditability, configuration standards
- People & Process: Training, dedicated cross-cloud teams, documented runbooks/playbooks, clear escalation paths
- Vendor Lock-in Mitigation: Use of portable components, open standards, containerization, abstraction (e.g., Terraform)
- Interoperability: API gateway, messaging and eventing platforms, common data formats/schemas
- Observability: Centralized logging, monitoring, alerting spanning all cloud providers; unified dashboards
Comparing to Your "How" Section
You covered:
- Iterative/gradual approach
- Use-case/workload isolation
- Wire them with APIs, model processes, BPMN
- Acknowledge practical trade-offs
- NFRs: security, compliance, performance, cost
- Distributed systems/network fallacies
- Compliance (regulations, audits)
- Performance (especially for cross-cloud flows)
- FinOps: egress/transfer costs, optimization
Potential Gaps or Areas That Could be Strengthened
1. Disaster Recovery & Reliability:  
   - You mention trade-offs, but not explicit advice on DR/multi-cloud failover, backup, or high-availability design patterns.
2. Automation & DevOps:  
   - The importance of using automation tools (e.g., Infrastructure as Code), CI/CD pipelines that can target multiple clouds, automated policy enforcement, or cross-cloud blueprints.
3. Identity & Access Management:  
   - Centralized IAM/federation (SSO, RBAC, minimizing privilege sprawl across clouds).
4. Governance & Policy:
   - Automation for policy enforcement, configuration drift management, and audit trails across clouds.
5. Vendor Lock-in/Portability:
   - Containerization, serverless frameworks that are cloud-neutral, use of open APIs, and avoiding proprietary cloud services where portability is a priority.
6. Unified Observability:
   - Centralizing logging, monitoring, and incident response for all clouds—(you said you’ll cover observability later, but a cross-reference or note here may help).
7. Skillsets & Process:
   - Team training, cross-cloud architectural patterns, runbook/playbook development.
8. Sustainability (if relevant to audience):
   - Resource efficiency, “green cloud” strategies (less commonly covered but increasingly topical).
