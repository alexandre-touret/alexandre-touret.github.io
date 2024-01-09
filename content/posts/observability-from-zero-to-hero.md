---
title: "Observability From Zero to Hero with the Grafana stack"
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

I already talked about observability. 
Here are a bunch of articles I wrote on this blog or on the Worldline Tech Blog:

* [Enhancing Asynchronous Transaction Monitoring: Implementing Distributed Tracing in Apache Camel Applications with OpenTelemetry](https://blog.touret.info/2023/09/05/distributed-tracing-opentelemetry-camel-artemis/)
* [Observabilité et Circuit Breaker avec Spring](https://blog.touret.info/2021/07/26/observabilite-et-circuit-breaker-avec-spring/)
* [Enabling distributed tracing on your microservices Spring app using Jaeger and OpenTracing](https://blog.worldline.tech/2021/09/22/enabling_distributed_tracing_in_spring_apps.html)

In this article, I aim to share a collection of best practices gleaned from years of experience.
I will then outline how to merge logs and traces on the Grafana Stack to gain clearer insights into your platform's workings. 
By doing so, you can transform your relationship with Ops teams, making them your best friends.

The examples provided in this article come from [this project hosted on Github](https://github.com/alexandre-touret/observability-from-zero-to-hero).

## A definition of Observability
Observability is the ability to understand the internal state of a complex system. 
When a system is observable, a user can identify the root cause of a performance problem by examining the data it produces, without additional testing or coding.

This is one of the ways in which quality of service issues can be addressed.

## A short presentation of the Grafana stack

This stack aims at a cockpit dashboard of your platforms.
Through different tools, the [Grafana stack](https://grafana.com/oss/) provides all you need to collect logs, metrics and traces (and beyond) to monitor and understand the behaviour of your platforms.   

In this article, I will particularly focus on:
* [Grafana](https://grafana.com/oss/grafana/): The dashboard engine
* [Loki](https://grafana.com/oss/loki/): The log storage engine
* [Mimir](https://grafana.com/oss/mimir/): The TSDB metrics storage engine
* [Tempo](https://grafana.com/oss/tempo/): The trace storage engine

I create a [Docker Compose stack to run it on your desktop](https://github.com/alexandre-touret/observability-from-zero-to-hero/tree/main/docker).

You can run it as following:

```bash
cd docker
docker compose up
```


## Logs, Traces & Monitoring

Let's go back to the basics: To make a system fully observable, the following abilities must be implemented:
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

If you want to dig into log levels and the importance to indicate contextual information into your logs, I suggest you reading [this article from my colleague Nicolas Carlier](https://blog.worldline.tech/2020/01/22/back-to-basics-logging.html).

## What about Grafana Loki

For this test, I chose to use [loki-logback-appender](https://github.com/loki4j/loki-logback-appender) to send the logs to Loki.

The configuration for a Spring Boot application is pretty straightforward:

You must add first the appender to your classpath:
```groovy
implementation 'com.github.loki4j:loki-logback-appender:1.4.2'
```

and create a [``logback-spring.xml``](https://github.com/alexandre-touret/observability-from-zero-to-hero-/blob/main/src/main/resources/logback-spring.xml) to configure it:

```xml
 <appender name="LOKI" class="com.github.loki4j.logback.Loki4jAppender">
        <http>
            <url>http://localhost:3100/loki/api/v1/push</url>
        </http>
        <format>
            <label>
                <pattern>app=${name},host=${HOSTNAME},level=%level</pattern>
                <readMarkers>true</readMarkers>
            </label>
            <message>
                <pattern>
                    {
                    "level":"%level",
                    "class":"%logger{36}",
                    "thread":"%thread",
                    "message": "%message",
                    "requestId": "%X{X-Request-ID}"
                    }
                </pattern>
            </message>
        </format>
    </appender>
```

_Et voilà!_

Now if you

## Traces

## Combine both with monitoring

## Conclusion
