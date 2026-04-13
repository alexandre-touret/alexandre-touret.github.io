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
It is essentially to keep the same approach as any other architectural strategy: start with the business goals and requirements, then design the technical solution that best meets those needs.
However, in the case of multi-cloud, there are some specific considerations to take into account throughout the process.
It requires an iterative approach (i.e., more than deploying on a single cloud).
Once you have made the decision to adopt a multi-cloud strategy, you should start by identifying the use cases and workloads that are best suited to each cloud provider.
This will allow you to leverage the strengths of each provider and optimize your costs and performance.
This step will help you determine whether building a multi-cloud platform is relevant.

{{< admonition tip "Part 1" true >}}
By the way, I strongly recommend reading the first part of this series before addressing the next steps. I will then assume that you have already identified the reasons why you want to adopt a multi-cloud strategy and that you have a clear understanding of the benefits and challenges associated with it.
{{< /admonition >}}

Personally, I started working on multi-cloud architectures when I was involved in a project that required us to use existing products from both Azure and GCP operated by different teams.
Each of these products had specific features and capabilities that were essential for our use case.
Instead of reinventing the wheel by moving an existing product to another cloud platform and causing a skyrocketing cost increase, we opted to integrate them, and we designed a solution that could leverage the strengths of both providers, combining off-the-shelf products and custom solutions while also ensuring that we could manage the complexity of using multiple cloud platforms.

What I learned from this experience is that the key to successfully implementing a multi-cloud strategy is to start with a clear understanding of your business goals and requirements. It may seem obvious when you read it, but throughout the different iterations of the design, it's easy to lose sight of the original goals and requirements, and to get caught up in the technical details.

When your technical strategy is based on off-the-shelf products, your process is "less" complex. You usually start by pinpointing the different use cases and workloads, and how compatible they are with the available products. Then you check how to connect them together and how to interact with different cloud providers through APIs.

By contrast, if you start from the ground up, you will have to design the whole system and make a lot of trade-offs between complexity, cost, performance, compliance, and maintainability.
Generally speaking, you will have the same trade-offs to make, and you will need more design and project iterations than if you were to use existing products.

Finally, to sum up, we may summarise this process into three main steps:

1. Check-out the business strategy and goals
2. Check-out the different use cases and workloads
 - If you have a product-based strategy, check-out the compatibility of the use cases with the available products
 - If you have a custom solution strategy, check-out the different design options and trade-offs
3. Check-out the different cloud providers and their products

## Back to basics

It's time to get back to basics!

As any other design, we should start designing the system by identifying the different use cases and workloads, and how they interact with each other. We can use for that many different techniques, such as [user stories](https://en.wikipedia.org/wiki/User_story), [use case diagrams](https://martinfowler.com/bliki/BoundedContext.html), [High-level UML Sequence diagrams](https://en.wikipedia.org/wiki/Sequence_diagram), or [BPMN](https://en.wikipedia.org/wiki/Business_Process_Model_and_Notation) diagrams. The important thing is to have a clear understanding of the different use cases and workloads, and how they interact with each other. In my view, the [Domain Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html) and particularly dividing your platform into different [Bounded Contexts](https://martinfowler.com/bliki/BoundedContext.html) are quite useful to identify all of them.

To clear this point up, let's take the example of a company that wants to build a mobility platform. The main use cases are:
- Real-time tracking of vehicles
- Data analytics and reporting
- AI and machine learning for predictive maintenance and route optimization
- Customer-facing applications
- Payment processing services

We may start by checking which cloud providers offer the best services for each use case. For instance, we may have this feature's coverage if we used to use AWS and GCP:

| Use case |  AWS | GCP |
| --- | --- | --- | --- |
| Real-time tracking of vehicles |  AWS IoT Core | **GCP IoT Core** |
| Data analytics and reporting |  AWS Redshift | **GCP BigQuery** |
| AI and machine learning for predictive maintenance and route optimization |  | AWS SageMaker | **GCP Vertex AI Platform** |
| Customer-facing applications | **AWS Elastic Beanstalk** | GCP App Engine |

I emphasised the most suitable services (for my organisation) for each use case, but in practice, you may have to make trade-offs between the different providers and services. For instance, if you are already using AWS for other use cases, it may be easier to use AWS SageMaker for AI and machine learning, even if GCP Vertex AI Platform offers better features.

For the payment processing services, we may choose to use a third-party service that is compatible with all cloud providers, such as Worldline or Stripe.

Starting with this study doesn't mean you need to avoid a functional analysis. On the contrary, it will help you to determine which use cases and workloads are best suited for each cloud provider during our functional analysis.
Furthermore, this assessment must be reviewed and updated regularly. As you will progress in your design you will probably get into a better understanding of the user's needs and the technical requirements. It will potentially lead you to change your initial cloud-provider strategy, and to choose different providers and services for each use case.

If usually, you start designing in the other way around, starting with the use cases and the workloads:  Don't worry, it's not a problem. This approach is not too far from that you are used to. I just recommend you to keep in mind that you will have to check the different cloud providers and their products at some point, and that it may impact your design. So, it's better to start with a quick check of the different cloud providers and their products, to have a better understanding of the different options available to you, and to be able to make informed decisions during your design process.
However, if you rely on a product-based strategy, starting from the use cases might be biased because you will eventually deploy most of your use cases on the same cloud provider to avoid complexity (_which is a good thing!_). 

During this phase, we will be able to pinpoint what are the different use cases and workloads, and how they interact with each other.
For that purpose, I used to work with BPMN diagrams. It's understandable for everyone, and it allows us to easily pinpoint the different interactions between the different cloud providers.

We can decline the different use cases into processes and sub-processes, and then model the interactions between the different cloud providers and services. This will help us identify the different components of the system, and how they interact with each other.

For instance, we may model the real-time tracking of vehicles use case as follows:

![Real-time Monitoring](/assets/images/2026/04/real-time-monitoring.svg)

{{< admonition info "About this diagram" true >}}
Normally you would have one diagram per use case, but I just wanted to give you an example of how to model the interactions between the different cloud providers and services. 
{{< /admonition >}}

While making such a design, we can easily pinpoint the different interactions between the different cloud providers and services. The most important recommendation I can give you is to keep it as simple as possible keeping every use case only on one cloud provider, to avoid complexity. 
Nevertheless, if you need to use multiple providers, make sure to clearly define the boundaries and interactions between them.

Then, try **to promote API interaction** between the different cloud providers. It could be easy to reach a remote database or a remote service, but it may add complexity and latency. Further, if we consider the different cloud providers as different systems, we must validate incoming data and outputs, and check the interactions between them.

OK. Now you got the theory. Let's see how it ~~fails~~ works in practice.

You will get some use cases that require you to interact with multiple cloud providers. Your job as an architect is to weight the pros and cons of each approach: reusing as is this workload and have a cross-providers workload or re-implementing it on one provider. You will have to make trade-offs (everything in architecture is about trade-offs) between complexity, cost, performance, compliance and maintainability.

In practice, it's not that simple. For instance, I had in the past to deal with a database on Azure. It wasn't possible to interact with API. We had to use a secure connection to connect to the database instead, which added complexity and latency.
We chose this solution to avoid unworthy costs increases. Hopefully, it was only for a specific use case not on the critical path, and we were able to isolate it from the rest of the system. 

It's just an illustration of what you would face when designing a multi-cloud platform.  
Finally, as with any other design (but even more so for this kind of architecture), one of the keys to success will be to design your system as a set of [loosely coupled](https://en.wikipedia.org/wiki/Loose_coupling) sub-systems or workloads. It will help you tackle some of the challenges of such a design. 
In other words, shaping your platform with loosely coupled systems will enable you to deploy your workloads into different cloud providers, preventing any failures (_mostly_) and tackling the challenge of creating a fully distributed application. 

## The fallacies of ~~Multi-cloud~~ Network Computing

When you design your application with cross-service (or cross-cloud-provider) transactions, it's quite easy to draw an arrow with PlantUML or any other design tool.
In practice, it comes with some difficulties. You may have some trouble with the internet connection or face skyrocketing cost increases.

Basically, you come across the [Fallacies of Distributed Computing](https://en.wikipedia.org/wiki/Fallacies_of_distributed_computing): 

- The network is reliable;
- Latency is zero;
- Bandwidth is infinite;
- The network is secure;
- Topology doesn't change;
- There is one administrator;
- Transport cost is zero;
- The network is homogeneous;

Assessing your design choices against these fallacies is key. It will help you challenge the boxes and arrows in your diagrams with real-life challenges.

## NFR

Pointing out Non-Functional Requirements and checking how use cases and designed workloads are compatible with them is one of the most critical steps of the design.

For a multi-cloud platform, we will need to assess these points in particular:

- Performance: Do all your transactions, and especially the cross-provider ones, fit with the [Service Level Objectives](https://en.wikipedia.org/wiki/Service-level_objective) (e.g., _95% of your API calls must be rendered within 30ms_)?
- Availability: What is the availability of the entire platform? 

For the latter, it will strongly rely on the way you segregate the different workloads between the different cloud providers. You can have different figures depending on the workloads. For instance, you can provide 99.95% of availability for your API and less for your Analytics platform. 
This segregation makes sense.
If one of your workloads involves two different platforms, the availability will be limited to the [GCD](https://en.wikipedia.org/wiki/Greatest_common_divisor) of the different cloud providers' [SLAs](https://en.wikipedia.org/wiki/Service-level_agreement).

## DRS & Reliability
You mention trade-offs, but not explicit advice on DR/multi-cloud failover, backup, or high-availability design patterns.

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
