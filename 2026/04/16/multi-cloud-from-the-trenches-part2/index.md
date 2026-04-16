# Multi-Cloud from the Trenches: Part 2 - The How


{{< style "text-align:center;" >}}
_Photo by <a href="https://unsplash.com/@rpianarosa?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Ramiro Pianarosa</a> on <a href="https://unsplash.com/photos/white-clouds-on-black-background-xUpbQ9GX7SQ?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>_      
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
| --- | --- | --- |
| Real-time tracking of vehicles |  AWS IoT Core | **GCP IoT Core** |
| Data analytics and reporting |  AWS Redshift | **GCP BigQuery** |
| AI and machine learning for predictive maintenance and route optimization |  AWS SageMaker | **GCP Vertex AI Platform** |
| Customer-facing applications | **AWS Elastic Beanstalk** | GCP App Engine |

I emphasised the most suitable services (for my organisation) for each use case, but in practice, you may have to make trade-offs between the different providers and services. For instance, if you are already using AWS for other use cases, it may be easier to use AWS SageMaker for AI and machine learning, even if GCP Vertex AI Platform offers better features.

For the payment processing services, we may choose to use a third-party service that is compatible with all cloud providers, such as Worldline or Stripe.

Starting with this study doesn't mean you need to avoid a functional analysis. On the contrary, it will help you to determine which use cases and workloads are best suited for each cloud provider during our functional analysis.
Furthermore, this assessment must be reviewed and updated regularly. As you will progress in your design you will probably get into a better understanding of the user's needs and the technical requirements. It will potentially lead you to change your initial cloud-provider strategy, and to choose different providers and services for each use case.

If usually, you start designing in the other way around, starting with the use cases and the workloads.
Don't worry, it's not a problem. 
This approach is not too far from that you are used to. 
I just recommend you to keep in mind that you will have to check the different cloud providers and their products at some point, and that it may impact your design. 
Therefore, it's better to start with a quick check of the different cloud providers and their products, to have a better understanding of the different options available to you, and to be able to make informed decisions during your design process.
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

In practice, it's not that simple. For instance, I had in the past to connect to a database on Azure. It wasn't possible to interact with API. We had to use a secure connection to connect to the database instead, which added complexity and latency.
We chose this solution to avoid unworthy costs increases. Hopefully, it was only for a specific use case not on the critical path, and we were able to isolate it from the rest of the system. 

It's just an illustration of what you would face when designing a multi-cloud platform.  

Finally, as with any other design (but even more so for this kind of architecture), one of the keys to success will be to design your system as a set of [loosely coupled](https://en.wikipedia.org/wiki/Loose_coupling) sub-systems or workloads. It will help you tackle some of the challenges of such a design. 
In other words, shaping your platform with loosely coupled systems will enable you to deploy your workloads into different cloud providers, preventing any failures (_mostly_) and tackling the challenge of creating a fully distributed application. 

## The fallacies of ~~Multi-cloud~~ Network Computing

When you design your application with cross-service (or cross-cloud-provider) transactions, it's quite easy to draw an arrow with PlantUML or any other design tool.
In practice, it comes with some difficulties. For instance, you may have some trouble with the internet connection or face skyrocketing cost increases.

Basically, you would come across the [Fallacies of Distributed Computing](https://en.wikipedia.org/wiki/Fallacies_of_distributed_computing): 

- The network is reliable;
- Latency is zero;
- Bandwidth is infinite;
- The network is secure;
- Topology doesn't change;
- There is one administrator;
- Transport cost is zero;
- The network is homogeneous;

Assessing your design choices against these fallacies is key. It will help you challenge the boxes and arrows in your diagrams with real-life challenges. 
Beyond the joke, I think it's a good reminder while designing. It might guide the different design iterations to check and validate the different assumptions that will be stated through the study of the NFRs.

## NFR

Pointing out Non-Functional Requirements and checking how use cases and designed workloads are compatible with them is one of the most critical steps of the design.

For a multi-cloud platform, we will need to assess these points in particular:

- Performance: Do all your transactions, and especially the cross-provider ones, fit with the [Service Level Objectives](https://en.wikipedia.org/wiki/Service-level_objective) (e.g., _95% of your API calls must be rendered within 30ms_)?
- Availability: What is the availability of the entire platform? 

For the latter, it will strongly rely on the way you segregate the different workloads between the different cloud providers. You can have different figures depending on the workloads. For instance, you can provide 99.95% of availability for your API and less for your Analytics platform. 

This segregation makes sense.
If one of your workloads involves two different platforms, the availability will be limited to the [GCD](https://en.wikipedia.org/wiki/Greatest_common_divisor) of the different cloud providers' [SLAs](https://en.wikipedia.org/wiki/Service-level_agreement).

## Compliance

Another topic to address while reviewing the NFRs is compliance. Usually, this requirement comes first and will be the cornerstone of your platform's design: Do you need to handle payments and be [PCI DSS compliant](https://www.pcisecuritystandards.org/standards/)? Do your customers aim to provide an [OIV](https://fr.wikipedia.org/wiki/Op%C3%A9rateur_d%27importance_vitale)?

You will then need to ask these questions and share these requirements with all the stakeholders. Throughout these discussions, you will get insights and will be able to validate whether you can deploy your workloads and store data in specific countries.

For instance, you may need to answer these questions:
- Could you deploy a fully French sovereign platform onto AWS us-east-1?
- Is this region/cloud provider fully compliant with PCI DSS (or any regulation)?

Furthermore, while designing our multi-cloud platform, it's worth gathering the components based on their required compliance onto the same cloud provider. 

One good practice would be to isolate them from the rest of the platform.
In this way, you would avoid mixing different requirements in the same cloud provider. By specialising the usage of your different cloud providers, you will prevent assessing and auditing two different cloud providers against compliance rules. 
This segregation will come with some beneficial side effects for your organisation: you will be able to get a dedicated CI/CD pipeline for each cloud provider.

## Performance & Reliability

Checking and ensuring the performance of a single-cloud platform might be challenging; imagine when you deploy across several cloud providers!
As mentioned earlier, if you clearly pinpointed the bounded contexts, avoiding cross-cloud-provider transactions within the same workload as much as possible will help you guarantee the performance of your platform (_remember the fallacies of distributed programming_). It will also strengthen the reliability of the entire system.

If you can't avoid it, it will be mandatory to keep an eye on this workload and measure the impact in terms of performance. 
Nevertheless, you can prevent some latency issues. You may colocate the different datacenters in the same region (i.e., deploy all your workloads in Paris). Some of the main actors recently published news about how to seamlessly connect different clouds with each other (e.g. [AWS / GCP](https://aws.amazon.com/blogs/networking-and-content-delivery/aws-and-google-cloud-collaborate-to-simplify-multicloud-networking/)). 

Unfortunately, there's no free lunch. When you dive into the highlighted solutions, they are usually based [on interconnect (for GCP)](https://docs.cloud.google.com/network-connectivity/docs/interconnect/concepts/overview) which could strongly impact the costs of your platform.

Before over-complicating your architecture, consider using only the Internet when possible. It will be cheaper. To prevent network latency issues, we can also deploy the different cloud platforms in the same location. For instance, we can opt for ``europe-west9`` for GCP and ``eu-west-3`` for AWS.

## FinOps 

Let's be honest, during operations, a platform deployed on several cloud providers will always be significantly more expensive than on a single cloud provider.
Nevertheless, it's important to balance these costs against additional costs, such as rebuilding a service from the ground up for colocation, or data transfer costs.

To limit the impacts, it's crucial to embrace a FinOps approach from the outset. My recommendation is not to be a rocket scientist, but to enable the simplest solutions—or at least those in which you have a strong background—and increase the complexity step by step.

Then, enable observability too. It will enhance your accurate understanding of the platform and ease your decision-making.

Beyond setting up end-to-end observability in your projects, another best practice is to regularly review your platform and check out the different costs. One exercise I've been leading for a while is arranging FinOps reviews with lead developers and Ops (_et que s'appelerio DevOps_). We check and explain the different cost variations, whether they are increases or decreases.

Throughout this review, we can evaluate the different implemented solutions in terms of costs. For instance, we can check if a component's setup is overkill.

It's not really different from "traditional cloud projects". But, for multi-cloud projects, it will be crucial to keep an eye on data transfer costs and the underlying infrastructure (e.g., Cloud Interconnect). Although you are unlikely to have much room to evolve this part after the initial deployment, it's worth keeping track of it and balancing it against the benefits of the service exposed to your customers.

## Data portability & personal data protection

What about synchronisation or portability?
It might be a big deal. For many reasons such as costs (_it's always about cost savings_), simplicity, security, or just preventing conflicts, I tend to avoid data replication between the different cloud providers as much as possible. 

Why? Because at the end of the day you could get either a split-brain issue or simply data inconsistency. 

In one of my previous professional experiences, we used to intensively synchronise data across different systems (within the same datacenter), and we struggled a lot to ensure data consistency.

To be completely honest, we cannot completely avoid data synchronisation. However, by loosely coupling your different components and segregating your different workloads, you can significantly avoid massive data synchronisation.

Nevertheless, even though you will keep your different use cases and components as loosely coupled as possible, you will need to tackle these challenges:

### Data correlation 

Let's go back to our previous example: we may manipulate some repository data such as vehicle names, product names, or user names. How to correlate them?
For the users, I will address this point just after, but for the other ones, it's essential to go back to the basics, and pinpoint what are the master data and what will be their corresponding repositories.

Depending on the context, technologies, and performance, you can either provide these data through an API or simply through synchronisation (e.g., with files). Usually, these data won't change a lot. This synchronisation is, in my view, acceptable.

Then, imagine we want to correlate the vehicle IDs across the IoT cloud to the customer-facing applications. How to do that? In this case, we can imagine different solutions: 
- Create a key/value cache which would be accessible from both platforms. The IoT part would write data, and the customer-facing side would only read it (and cache it locally if needed). 
- Copy it from one cloud provider to another on a regular basis. The copy would only be unidirectional.

Regarding the solution, we can implement it in different ways (from the easiest to the most complicated):
- A simple Key/Value cache service such as [Redis](https://redis.io/nosql/key-value-databases/)
- A file copy 
- [Event Sourcing](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing)
- [Change Data Capture](https://cloud.google.com/discover/what-is-change-data-capture)

### Security & Personally Identifiable Information (PII) 

If you need to synchronise and control the data lifecycle, it's mandatory to think about security at different levels:
- At rest
- In motion

At the bare minimum, the data synchronised must be encrypted from end to end. But what about [Personally Identifiable Information (PII)](https://www.dol.gov/general/ppii)?

Unfortunately, there's no magic. You will have to track and manage the whole personal data lifecycle at the different levels of your architecture across the different components of the cloud providers.

Another challenge arises in the different environments, such as the development or staging platforms. What if we need to create a pseudonymised set of data which would be consistent across the different software systems?
It's not a new topic, but it becomes more difficult to handle in this case.

Unfortunately, I haven't found any magical recipe yet for this concern.

## Identity & access management

Let's go back to the real-time tracking of vehicles example. What if we needed to link the vehicles that users track through our IoT platform to the customer-facing applications?

Actually, when it comes to define how to identify users and how to correlate customer data across the different sub-systems, it can quickly become cumbersome. 

There are many strategies depending on the context and the targeted platforms.

Here is one strategy I have successfully applied:

### Customer data and user rights
- We used **only** one Single Sign-On (SSO) solution (e.g., Keycloak) with OpenID Connect. Ideally, it is best to rely on a single Identity Provider (IdP).
- We leveraged custom fields (e.g., token claims) or used standard fields such as the email to correlate users seamlessly across the different subsystems.
- The user rights policy was strictly based on Role-Based Access Control (RBAC).

### "Technical" security data
- Each cloud platform brought its own IAM policies and technical accounts. We deliberately avoided spanning them from one cloud provider to another to keep the technical security context isolated.

The purpose of this segregation is to keep the setup of the different cloud providers as loosely coupled as possible.
Using an open standard for authentication and authorisation such as OpenID Connect helps broadcast all the required info to correlate the identity of the users across the entire system.

## A Unified View for End Users

Last but not least, remember the [first part of this series: Users don't give a heck!](https://blog.touret.info/2026/03/12/multi-cloud-from-the-trenches-part1/#the-sad-reality-end-users-dont-care).

From an architecture perspective, it means the challenge is to span our services across many cloud providers and provide a unified view to our customers.
For that purpose, we may have different strategies depending on whether we consider the front-office or the back-office.

### Front-Office
When we need to expose APIs or web interfaces to our APIs, it's important to think from a customer's perspective. 
Even though exposing different URLs for IoT or specific equipment may be acceptable, providing two (or more) sets of APIs which will be completely different in terms of conventions, error management, or anything else is, to some extent, unacceptable. 
Your customers will lose time and engagement during onboarding.
That is why it matters to think about streamlining public APIs through, for instance, a global API Gateway. It will help provide a cohesive set of functionalities and give a unique way to interact with your platform.

If you aim to provide web interfaces or mobile applications, specializing [Backends-for-Frontends (BFF)](https://learn.microsoft.com/en-us/azure/architecture/patterns/backends-for-frontends) could also help in that field.

### Back-Office
Providing a unified view is also important for the back office. How do you get unified KPIs or SLOs from end-to-end? I will answer these questions in the next part of this series :).

## Conclusion

Implementing a multi-cloud strategy is far more complex than just drawing lines between cloud providers on a whiteboard. As we've seen, it requires a rigorous methodology: from defining clear bounded contexts and keeping an eye on FinOps, to handling data portability and identity seamlessly. 

To avoid any surprises after delivery, it's key to develop a holistic approach from design to production and to continuously challenge your assumptions against the reality of distributed systems.

Of course, the multi-cloud journey doesn't stop here. Several essential domains remain to be explored in your projects, such as managing different skill sets, achieving [Operational Excellence](https://en.wikipedia.org/wiki/Operational_excellence), automation, and sustainability.

FInally, your goal is to shield your users from this underlying complexity. In the next part of this series, we will tackle one of the most critical challenges of these distributed systems: end-to-end observability and how to provide a unified, cohesive view of your platform's health.
