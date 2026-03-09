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
When I started designing such platforms, I was a little bit scared. 
The theory was slightly attractive: I could cherry-pick the best services from each cloud provider to build the ultimate architecture. 
Nevertheless, I had expressed some reservations about operational concerns: complexity, costs, observability, alerting, and the like.

Why? The sad reality is that, beyond the marketing hype, cloud platform capabilities are not equal and they are not interchangeable. Furthermore, the operational burden of managing multiple clouds is not linear. It may lead you into a labyrinth of technical complexities where network latency, fragmented data, and incompatible APIs threaten both your SLA and your peace of mind.

This article is the first part of a series that aims to share my experience and lessons learned from the trenches of multi-cloud. It will cover the "Why" and "What" of multi-cloud, exploring the motivations behind adopting such a strategy and defining what multi-cloud truly entails. Subsequent parts will delve into the "How," providing practical insights and strategies for successful multi-cloud implementations.

## The Why

There are many reasons why you might adopt a multi-cloud strategy. Whether you are drafting a global hosting strategy for your company or designing a new platform, multi-cloud can be a compelling option. Let's explore some of the most common drivers. For each, I will provide my **personal** insights:

### Risk mitigation and business continuity

This is often cited as a primary driver for multi-cloud adoption. The idea is to avoid a single point of failure by distributing your workloads across multiple cloud providers. In the event of an outage or disaster with one provider, your services can theoretically failover to another, ensuring business continuity.

That was the easy part.
In practice, achieving true business continuity across multiple clouds is far more complex than simply replicating workloads. This is because it requires a deep understanding of each cloud provider's infrastructure, services, and APIs, as well as the ability to manage and orchestrate workloads across disparate environments. 

Beyond maintaining different tools and setups (e.g., two Terraform setups), you will also need to consider data replication strategies, network connectivity, and security implications across multiple environments.

Consequently, in my view, this use case is primarily reserved for highly sensitive workloads. For financial institutions or public services subject to military or governmental regulations (such as the [OIV in France](https://www.sgdsn.gouv.fr/files/files/Nos_missions/plaquette-saiv.pdf)), a multi-region setup may be "enough" to comply with these requirements and prevent outages.

Nevertheless, at a corporate level, multi-cloud hosting for different platforms can be beneficial. It may offer the ability to choose the right hosting provider for every platform. In addition, it may help you to _easily_ switch from one provider to another if needed.

### Cost "optimization"

For this topic, there are basically two situations to consider: 
- Building a multi-cloud landing zone from scratch 
- Integrating two existing solutions without rebuilding one of them in another cloud provider's landing zone

For the first topic, we will definitely lose money. 
Building a multi-cloud setup from the ground up is a technical solution to mitigate and prevent high-impact risks when there's no other possible way.
Furthermore, it brings additional costs which may inflate the bill: staying current with two different technologies, maintaining and operating two different setups, networking...

For the latter, it's a whole new ball game.
Building or migrating an existing service already available on another cloud provider could be tricky and highly expensive, even if you built it on top of standards such as Kubernetes. Nevertheless, would you really save money in this case? Depending on the interactions between the different parts of the platform (from one cloud provider to another), you may, at the end of the day, face prohibitive additional costs. The only way to determine if it is acceptable is to analyze the different workflows, pinpoint the implied transactions, and estimate the corresponding costs. 
I usually start by evaluating network costs. While it's not the only cost center impacted by a multi-cloud topology, it's a good indicator for forecasting cost increases.

For instance, imagine we have this workflow for one use case involving two different cloud providers: 

{{< mermaid >}}sequenceDiagram
    participant Client
    participant API_Cloud_Provider_#1
    participant API_Cloud_Provider_#2
    Client->>API_Cloud_Provider_#1: Call API /my_feature
    API_Cloud_Provider_#1->>API_Cloud_Provider_#2: Call API /my_sub_feature
    Note right of API_Cloud_Provider_#2: Inter cloud provider transaction through Internet or VPN
{{< /mermaid >}}

Obviously, internet transactions are cheaper than VPN or [InterConnect solutions](https://docs.cloud.google.com/network-connectivity/docs/interconnect/concepts/overview). However, even though they go through the Internet, they still incur additional costs.

Imagine you have the following requirements:

- Number of transactions for ``/my_feature`` per second: 100 TPS
- Estimated payload size: 5KB

This results in a monthly bandwidth of roughly 43 GB.
On GCP, it would cost approximately $6 if your transactions go through the Internet. In this case, it is definitely worth it. However, if your transactions require a VPN, it will cost around $6,800!

To sum up, it is crucial to regularly review the main workflows and NFRs (Non-Functional Requirements) to estimate the implied additional costs of your technical choices. Why? Because, initially, you will likely work with significant uncertainty that will only decrease over time (e.g., after setting up your platform in the development environment).

### 3. Vendor Lock-in avoidance

From an organizational perspective, this makes sense as it prevents dependency on a single provider. That is the theory. In practice, if you only stick to standards and avoid provider-specific features, you miss out on many valuable functionalities. 

I believe that instead of self-restricting, one should take a pragmatic approach and evaluate the impact of a potential migration: Is it impossible? If not, what is the cost?

For instance, let's look at an e-commerce microservices platform:

```plantuml {format="svg" title="vendor lock-in"}
@startuml monolith
!include <C4/C4_Container>
!include <C4/C4_Context>
!include <C4/C4_Component>

LAYOUT_LANDSCAPE()
HIDE_STEREOTYPE()
AddBoundaryTag("newboundary", $bgColor="e1f3f8",$borderColor="447870", $fontColor="447870", $shadowing="true", $shape = RoundedBoxShape())
AddBoundaryTag("eventBoundary", $bgColor="46beaa",$borderColor="green", $fontColor="white", $shadowing="true", $shape = EightSidedShape())
AddRelTag("eventRel", $textColor="green", $lineColor="green", $lineStyle="boldStyle", $sprite="eventRel,scale=2,color=green", $legendText="firewall")
Person(user, "Truffade At Home Admins")
Person(customer, "Customer")

System_Boundary(donutssystem, "Truffade At Home") {
    System_Boundary("GUI","Presentation Layer"){
        Container(fogui,"GUI")
        Container(bogui,"backoffice GUI")
        Container(foapi,"Back for Front GUI")
        Container(boapi,"Back for Backoffice GUI")
    }

    System_Boundary(api,"Service Layer") {
        System_Boundary(shoppingAPI,"Shopping Service",$tags="newboundary"){
            Container(shoppingService,"Shopping API",)
            ContainerDb(shoppingDb,"Shopping DB")
        }
        System_Boundary(customerAPI,"Customer Service",$tags="newboundary"){
            Container(customerService,"Customer API")
            ContainerDb(customerDb,"Customer DB")
        }
        System_Boundary(billingAPI,"Billing Service",$tags="newboundary"){
            Container(billingService,"Billing API")
            Container(hsm,"HSM")
            ContainerDb(billingDb,"Billing DB")
            ContainerDb(billingS3,"Billing Object Storage")
        }
    }
}


Rel(customer,fogui,"HTTPS")
Rel(fogui, foapi,"HTTPS")

Rel(foapi,shoppingService,"HTTPS")
Rel(shoppingService,shoppingDb,"JDBC")

Rel(customerService,customerDb,"JDBC")
'Rel(shoppingService,billingService,"HTTPS")
'Rel(shoppingService,SIPS,"HTTPS")
'Rel(shoppingService,delivery,"HTTPS")
Rel(billingService,billingDb,"JDBC")
Rel(billingService,billingS3,"HTTPS")

Rel(user,bogui,"HTTPS")
Rel(bogui,boapi,"HTTPS")
Rel(boapi,customerService,"HTTPS")
Rel(boapi,billingService,"HTTPS")
Rel(boapi,shoppingService,"HTTPS")

Rel(billingService,hsm,"TCPS",$tags="security")
Lay_D(billingAPI,customerAPI)
@enduml

```

Even though we deploy managed services for databases or API gateways, we can assume we won't be totally locked into these components. They rely on either standards or open-source solutions. It won't be free, but the migration costs will be acceptable.
However, there's one component in this architecture worth taking the time to look into: the [HSM](https://en.wikipedia.org/wiki/Hardware_security_module). Usually, it's fully proprietary, and you would be definitively locked in once you start rolling out your service in production.

In this use case, we can imagine two solutions:
1. Assume we will be fully locked in 
2. Providing a different HSM module (on-premise or from another provider) or using cryptographic mechanisms (e.g., DEK/KEK) to mitigate the risks.

That's just a sneak peek into why, in the long term, architecting a multi-cloud setup might secure your technical architectural choices. As discussed in the Risk Mitigation chapter, it might help avoid being locked in with a vendor.

### 4. Best-of-Breed services

When you design a platform you are often tempted to choose the best product or solution for every use case. It might also help you avoid reinventing the wheel if you already have existing off-the-shelf solutions.

We can imagine a platform split into two parts:
1. The first part for the transactional processes : [AWS EC2 VMs](https://aws.amazon.com/ec2/) and or [EKS Kubernetes cluster](https://aws.amazon.com/eks/)
2. The second part for the Business Intelligence workloads run on top of [GCP BigQuery](https://cloud.google.com/bigquery?hl=en). 

For the latter, we can imagine we already have scripts, dashboards which could be reused.

Usually it's one of the most important key factor to switch to this kind of architecture. It may help streamline your delivery by promoting reusability. 

Nevertheless, it's crucial to check if it's relevant regarding the platform requirements and expectations. 

### 6. Regulatory compliance and data residency

Last, but not the least, what about all regulation and compliance?

Isolating some of your worloads into one cloud provider and host the least critical workloads to another one may be a strategy to assess. 
In my opinion, it's a strategy that would be studied at a global level because the scope of this implementation will affect the entire company's IT landscape. It may help streamline the setup and the compliancy assessment of sensitive workloads (e.g., [PCI DSS](https://www.pcisecuritystandards.org/)).


For instance, if we stick to the same e-commerce use case, we may consider splitting our workload into two different ones hosted on different cloud providers.

```plantuml {format="svg" title="compliancy"}
@startuml
!include <C4/C4_Container>
!include <C4/C4_Context>
!include <C4/C4_Component>

LAYOUT_LANDSCAPE()
HIDE_STEREOTYPE()
AddBoundaryTag("newboundary", $bgColor="e1f3f8",$borderColor="447870", $fontColor="447870", $shadowing="true", $shape = RoundedBoxShape())
AddBoundaryTag("eventBoundary", $bgColor="46beaa",$borderColor="green", $fontColor="white", $shadowing="true", $shape = EightSidedShape())
AddRelTag("eventRel", $textColor="green", $lineColor="green", $lineStyle="boldStyle", $sprite="eventRel,scale=2,color=green", $legendText="firewall")

Person(user, "Truffade At Home Admins")
Person(customer, "Customer")

System_Boundary(donutssystem, "Truffade At Home") {
    System_Boundary("GUI","Presentation Layer"){
        Container(fogui,"GUI")
        Container(bogui,"backoffice GUI")
        Container(foapi,"Back for Front GUI")
        Container(boapi,"Back for Backoffice GUI")
    }

    System_Boundary(api,"Service Layer") {
        System_Boundary(shoppingAPI,"Shopping Service",$tags="newboundary"){
            Container(shoppingService,"Shopping API",)
            ContainerDb(shoppingDb,"Shopping DB")
        }
        System_Boundary(customerAPI,"Customer Service",$tags="newboundary"){
            Container(customerService,"Customer API")
            ContainerDb(customerDb,"Customer DB")
        }
        System_Boundary(billingAPI,"Billing Service",$tags="newboundary"){
            Container(billingService,"Billing API")
            Container(hsm,"HSM")
            ContainerDb(billingDb,"Billing DB")
            ContainerDb(billingS3,"Billing Object Storage")
        }
        
    
    }
}

System_Boundary(paymentSystem,"PCI DSS Payment"){
    System_Boundary(payment,"PCI DSS Payment Service", $tags="eventBoundary"){
            Container(paymentgui,"Payment GUI")
            Container(paymentService,"Payment Service")
            ContainerDb(paymentDb,"Payment DB")
        }
}


Rel(customer,fogui,"HTTPS")
Rel(fogui, foapi,"HTTPS")

Rel(foapi,shoppingService,"HTTPS")
Rel(shoppingService,shoppingDb,"JDBC")

Rel(customerService,customerDb,"JDBC")
'Rel(shoppingService,billingService,"HTTPS")
'Rel(shoppingService,SIPS,"HTTPS")
'Rel(shoppingService,delivery,"HTTPS")
Rel(billingService,billingDb,"JDBC")
Rel(billingService,billingS3,"HTTPS")

Rel(user,bogui,"HTTPS")
Rel(bogui,boapi,"HTTPS")
Rel(boapi,customerService,"HTTPS")
Rel(boapi,billingService,"HTTPS")
Rel(boapi,shoppingService,"HTTPS")

Rel(billingService,hsm,"TCPS",$tags="security")

Rel(customer,paymentgui,"HTTPS")
Rel(paymentgui,paymentService, "HTTPS")
Rel(paymentService,paymentDb, "JDBC")

Lay_D(billingAPI,customerAPI)
@enduml

```

In this way, we would be able to streamline the setup, reviewal and by extension, the entire SDLC for specific sensitive workloads.

## What

configuration multi cloud dans le cadre d'une plateforme 

plusieurs acteurs et solutions sont envisagées et on va évaluer la pertinence du multi cloud

L'utilisateur veut un service et non plusieurs plateformes !

## Conclusion





