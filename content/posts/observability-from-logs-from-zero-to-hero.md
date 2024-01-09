---
title: "Observability From Logs From Zero to Hero"
date: 2024-01-08T15:05:43+01:00
draft: true
  
featuredImagePreview: "/assets/images/2024/01/felipe-correia-ScQngs6oO1E-unsplash.webp"
featuredImage: "/assets/images/2024/01/felipe-correia-ScQngs6oO1E-unsplash.webp"
images: ["/assets/images/2024/01/felipe-correia-ScQngs6oO1E-unsplash.webp"]

tags:
  - Observability
---

## The sad reality

Picture this: it's Friday afternoon, and you're eagerly looking forward to unwinding for the weekend. 
Suddenly, an Ops engineer alerts you about a critical issue—a stubborn HTTP 500 error that's causing a major roadblock.

Despite their efforts, the Ops engineer couldn't pinpoint the root cause due to a lack of contextual information.

Hours pass by, but you take it upon yourself to delve into the problem. 
Eventually, after reproducing and debugging the issue on your computer, you uncover the issue.

Do you think it is science fiction?
Are you used with such a scenario? 

If yes, you probably didn't identify one of your end users and their main usage: Your Ops and the observability!

In this article, I aim to share a collection of best practices gleaned from years of experience.
I will then outline how to merge logs and traces to gain clearer insights into your platform's workings. 
By doing so, you can transform your relationship with Ops teams, making them your best friends.

// TODO GITHUB

## A definition of Observability
Observability is the ability to understand the internal state of a complex system. 
When a system is observable, a user can identify the root cause of a performance problem by examining the data it produces, without additional testing or coding.

This is one of the ways in which quality of service issues can be addressed.

## Logs, Traces & Monitoring

To make a system fully observable, the following abilities must be implemented:
* Logs
* Metrics
* Traces

They can be defined as follows:

![monitoring](/assets/images/2024/01/image-2023-8-1_9-44-11.webp)

## Logs

When a program fails, OPS usually try to identify the underlying error analyzing log files.
It could be either reading the application log files or using a log aggregator such as Elastic Kibana or Splunk.

In my opinion, most of the time developers don't really take care about this matter.
It is mainly due to they did not experience such a trouble.

For two years I had to administrate a proprietary customer relationship management solution. 
The only way to analyze errors was navigating through the logs, using the most appropriate error levels to get the root cause.
We didn't have access to the source code (Long live to open source programs).
Hopefully the log management system was really efficient. 
It helped us get into this product and administrate it efficiently.

I strongly think we should systematise such experiences for developers. 
It could help them (us) know what is behind the curtain and make more observable and better programs.

### Key principles

You must first dissociate the logs you make while you code (e.g., for debugging) from the production logs.
The first should normally remove the first.
For the latter, you should apply some of these principles:

* Identify and use the most appropriate level (``DEBUG``, ``INFO``, ``WARN``, ``ERROR``,...)
* Provide a clear and useful message for OPS (yes you make this log for him/her)
* Provide business context (e.g., the creation of the contract ``123456`` failed )
* Logs must be read by an external tool (e.g., using a log aggregator)
* Logs must not expose sensitive data: You must think about GDPR, PCI DSS standards

### What about log levels?

### Some examples

## Traces

## Combine both with monitoring

## Conclusion
