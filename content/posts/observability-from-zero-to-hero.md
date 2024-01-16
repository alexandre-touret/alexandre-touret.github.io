---
title: "Observability From Zero to Hero with the Grafana stack"
date: 2024-01-08T15:05:43+01:00
draft: true
  
featuredImagePreview: "/assets/images/2024/01/felipe-correia-ScQngs6oO1E-unsplash.webp"
featuredImage: "/assets/images/2024/01/felipe-correia-ScQngs6oO1E-unsplash.webp"
images: ["/assets/images/2024/01/felipe-correia-ScQngs6oO1E-unsplash.webp"]

tags:
  - Observability
  - Spring
  - Java
---

## The sad reality

Picture this: it's Friday afternoon, and you're eagerly looking forward to unwinding for the weekend. 
Suddenly, an Ops engineer alerts you about a critical issue—a stubborn HTTP 500 error that's causing a major roadblock.

Despite the dedicated efforts of the Ops engineers, the root cause remains elusive due to a lack of contextual information.

Hours pass by, but you take it upon yourself to delve into the problem. 
Eventually, after reproducing and debugging the issue on your computer, you uncover the issue.

Does this sound like science fiction? If you've experienced a similar scenario, you're likely familiar with the challenges posed by unidentified end users and their unique usage patterns—enter Ops and observability!

I've previously delved into the topic of observability. 
Here are a bunch of articles I wrote on this blog or on the [Worldline Tech Blog](https://blog.worldline.tech):

* [Enhancing Asynchronous Transaction Monitoring: Implementing Distributed Tracing in Apache Camel Applications with OpenTelemetry](https://blog.touret.info/2023/09/05/distributed-tracing-opentelemetry-camel-artemis/)
* [Observabilité et Circuit Breaker avec Spring](https://blog.touret.info/2021/07/26/observabilite-et-circuit-breaker-avec-spring/)
* [Enabling distributed tracing on your microservices Spring app using Jaeger and OpenTracing](https://blog.worldline.tech/2021/09/22/enabling_distributed_tracing_in_spring_apps.html)

In this article, I aim to highlight the importance of putting in place observability during the earliest stages of a project.
I will then outline how to merge logs and traces from a good old [Spring Boot application](https://spring.io/projects/spring-boot/) on the [Grafana Stack](https://grafana.com/) to gain clearer insights into your platform's workings. 
By doing so, you can transform your relationship with Ops teams, making them your best friends.

{{< admonition question "What about the code?" true >}}
The examples provided in this article come from [this project hosted on Github](https://github.com/alexandre-touret/observability-from-zero-to-hero).
{{< /admonition >}}

## A definition of Observability

We can shortly define it as this:

> Observability is the ability **to understand the internal state of a complex system**. 
> When a system is observable, a user can **identify the root cause** of a performance problem by examining the data it produces, without additional testing or coding.

This is one of the ways in which quality of service issues can be addressed.

## A short presentation of the Grafana stack

[The Grafana stack](https://grafana.com/oss/) aims at a tool which allows you to query, visualise, alert and explore all of your metrics.
You can aggregate them through a [wide range of data sources](https://grafana.com/docs/grafana/latest/datasources/).
With regard to the topic of this article,it will provide us all you need to collect logs, metrics and traces (and beyond) to monitor and understand the behaviour of your platforms.   

I will therefore particularly focus on:
* [Grafana](https://grafana.com/oss/grafana/): The dashboard engine
* [Loki](https://grafana.com/oss/loki/): The log storage engine
* [Tempo](https://grafana.com/oss/tempo/): The trace storage engine

To get it started easily, I just created a [Docker Compose stack to run it on your desktop](https://github.com/alexandre-touret/observability-from-zero-to-hero/tree/main/docker).

You can run it with these commands:

```bash
cd docker
docker compose up
```
## Logs, Traces & Monitoring

Let's go back to the basics: To make a system fully observable, the following abilities must be implemented:
* Logs
* Traces
* Metrics

They can be defined as follows:

![monitoring](/assets/images/2024/01/image-2023-8-1_9-44-11.webp)

## Logs

When a program fails, OPS usually tries to identify the underlying error analyzing log files.
It could be either reading the application log files or using a log aggregator such as Elastic Kibana or Splunk.

In my opinion, most of the time developers don't really care about this matter.
It is mainly due to they did not experience such a trouble.

For two years, I had to administrate a proprietary customer relationship management solution. 
The only way to analyse errors was navigating through the logs, using the most appropriate error levels to get the root cause.
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

{{< admonition tip "About this appender" true >}}
I chose to use this appender for testing purpose.
If you deploy your application on top of Kubernetes, you would probably opt for a more suitable solution such as [FluentD](https://www.fluentd.org/).
{{< /admonition >}}

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
                    {"level":"%level","class":"%logger{36}","thread":"%thread","message": "%message","requestId": "%X{X-Request-ID}"}
                </pattern>
            </message>
        </format>
    </appender>
```
_Et voilà!_

{{< admonition tip "About the format" true >}}
It is just my 2 cents: more and more I tend to produce structurised logs using JSON for instance.
It is usually easier to manipulate them all along the log ingestion tools chain (e.g, with [LogStash](https://www.elastic.co/fr/logstash/). 
{{< /admonition >}}

After restarting your application:

```bash
gradle bootRun
```

You can now get logs browsing Grafana reaching this URL: [http://localhost:3000/goto/M-VkkicSR?orgId=1](http://localhost:3000/goto/M-VkkicSR?orgId=1) and running some API calls with the following command:

```bash
http :8080/api/events
```

## Traces

Upon initial inspection, one might consider the existing setup sufficient. However, I highly recommend delving into the realm of [Distributed Tracing](https://research.google/pubs/pub36356/), a technology I have previously introduced (refer to the aforementioned discussion).
Not only it will be first really useful when you deploy distributed architectures but also for the other kind of platforms.

The true value of distributed tracing becomes evident not only in the deployment of distributed architectures but across various platforms. In the complex landscape of production issues, identifying the root cause or understanding why a specific SQL query failed or took an extended duration can be challenging. Traditionally, attempts to replicate such issues in alternative environments often fall short due to the inherent complexities of data, server configurations, and benchmarking.

This technology empowers you to gain valuable insights that were previously elusive. When grappling with production issues, you no longer need to rely solely on replication efforts; distributed tracing provides a clear and comprehensive perspective on what might be amiss.

To sum up: _Try it, you'll like it!_

### The setup

There is several ways to set it up.
Nowadays, OpenTelemetry is the _de facto_ standard.
Most of the solutions are compatible with it.

Nevertheless, after challenging some APMs, I found some missing features which are really useful in real life projects. 
For instance, you can not easily ignore URLs, for instance the actuator endpoints, from the traces you will manage.
You can do that in just [one property with the Elastic APM agent](https://www.elastic.co/guide/en/apm/agent/java/1.x/config-http.html#config-transaction-ignore-urls).
There is [an issue about this feature](https://github.com/open-telemetry/opentelemetry-java-instrumentation/issues/1060#issuecomment-1816716602).

I suggest using the agents.
It is less intrusive than other solutions.

For instance if you use the spring boot gradle plugin you can configure it as following:

```groovy
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.2.1'
    id 'io.spring.dependency-management' version '1.1.4'

}

ext {
    opentelemetryAgentVersion = '1.32.0' // Mettez la version appropriée
}

group = 'info.touret.observability'
version = '0.0.1-SNAPSHOT'

java {
    sourceCompatibility = '21'
}

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-actuator'
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'io.micrometer:micrometer-registry-prometheus'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    implementation 'com.github.loki4j:loki-logback-appender:1.4.2'
    implementation "io.opentelemetry.javaagent:opentelemetry-javaagent:${opentelemetryAgentVersion}"

}

task copyJavaAgent(type: Copy) {
    from configurations.detachedConfiguration(
            dependencies.create("io.opentelemetry.javaagent:opentelemetry-javaagent:${opentelemetryAgentVersion}")
    )
    into "${project.getLayout().getBuildDirectory()}/javaagents"
    rename { 'javaagent.jar' }
}

processResources.dependsOn copyJavaAgent

bootRun {
    doFirst {
        jvmArgs = ["-javaagent:${project.getLayout().getBuildDirectory()}/javaagents/javaagent.jar"]
    }

    // 
    // systemProperties = [
    //     'otel.traces.sampler': 'parentbased_traceidratio',
    //     'otel.traces.sampler.arg': '0.2'
    // ]
}
tasks.named('test') {
    useJUnitPlatform()
}

```

After restarting your application, you can reach the API with this command:

```bash
http :8080/api/events
```

This API is really simple.
To illustrate how to handle errors using both the Spring stack and the Grafana stack, an error is always thrown using [the Problem Detail RFC 7807](https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-ann-rest-exceptions.html) while reaching it.

Here the [service](https://github.com/alexandre-touret/observability-from-zero-to-hero/blob/main/src/main/java/info/touret/observability/observabilityfromzerotohero/ObservabilityService.java):

```java
@Service
public class ObservabilityService {
    public void breakMethod() {
        throw new IllegalStateException("Breaking method issue");
    }
}
```

And the [controller](https://github.com/alexandre-touret/observability-from-zero-to-hero/blob/main/src/main/java/info/touret/observability/observabilityfromzerotohero/ObservabilityAPIController.java) which returns the error:

```java
@GetMapping("/api/event")
public ResponseEntity<ObservabilityEventDto> getEvent() throws ErrorResponseException {
        try {
            observabilityService.breakMethod();
            var observabilityEventDto = new ObservabilityEventDto(UUID.randomUUID().toString(), "OK");
            return ResponseEntity.ok(observabilityEventDto);
        } catch (Exception e) {
            var observabilityEventDto = new ObservabilityEventDto(UUID.randomUUID().toString(), "Error");
            LOGGER.error(e.getMessage());
            throw new ErrorResponseException(HttpStatus.INTERNAL_SERVER_ERROR, ProblemDetail.forStatus(HttpStatus.INTERNAL_SERVER_ERROR), e);
        }
    }
```

After testing this service a few times, you can now see the traces on your Grafana dashboard.

### Head or Tail sampling? 

One significant drawback of implementing this technology lies in the potential performance overhead it introduces to the instrumented application. In cases where high-pressure APIs generate or broadcast SPANs for every transaction, there's a substantial risk of significantly impacting the [Service Level Objectives (SLOs)](https://sre.google/sre-book/service-level-objectives/) of your platform.

A viable solution to mitigate this challenge involves sampling the traces, such as retaining only 20% of the transactions. There are two primary approaches:

1. **Head Sampling**: In this method, SPANs are sampled and filtered directly from the producer (e.g., a backend). This is essential for heavily utilized platforms and proves to be the most efficient, as it produces only the necessary spans, thereby avoiding the dissemination of unnecessary SPANs. However, it comes with the trade-off of potentially losing critical traces involving failures. The sampling rate is purely statistical (e.g., 10 or 20% of SPANs sampled and broadcast).

2. **Tail Sampling**: Alternatively, SPANs are sampled retrospectively, often through tools like the [Open Telemetry Collector](https://opentelemetry.io/docs/collector/). While this method allows for filtering SPANs based on various criteria, such as the transaction status, it does not address the overhead issue. All SPANs are initially broadcast and then filtered, making it less suitable for heavily used scenarios.

Both approaches have their pros and cons, and the choice depends on the specific requirements of the platform. For an in-depth exploration of this issue, you can refer to [this article](https://uptrace.dev/opentelemetry/sampling.html#what-is-sampling).

## Correlating Logs & Traces

Now, you have on one side the logs of your applications, and on the other the traces.
To dig into errors and see what is behind the curtain of any error logged, it is really import to correlate both. 

For that, you must specify in your logs the traceID and spanID of the corresponding trace.
Hopefully, logback and the Loki appender can help you on this!
We therefore will modify the pattern of the logs in the [``logback-spring.xml``](https://github.com/alexandre-touret/observability-from-zero-to-hero-/blob/main/src/main/resources/logback-spring.xml) file:


```xml
<pattern>
    {"level":"%level","TraceID":"%mdc{trace_id:-none}","spanId":"%mdc{span_id:-none}","class":"%logger{36}","thread":"%thread","message": "%message","requestId": "%X{X-Request-ID}"}
</pattern>
```
As a developer point of view, the job is done :)
Now, it is time for the OPS/SRE to configure Grafana to link Loki and Tempo through the TraceID field.

For that, you can create a derived field directly in the datasource configuration:

```yaml
datasources:
  - name: Loki
    type: loki
    access: proxy
    uid: loki
    url: http://loki:3100
    jsonData:
        maxLines: 1000
        derivedFields:
          - datasourceUid: tempo
            matcherRegex: '\"TraceID\": \"(\w+).*\"'
            name: TraceID
            # url will be interpreted as query for the datasource
            url: '$${__value.raw}'
            # optional for URL Label to set a custom display label for the link.
            urlDisplayLabel: 'View Trace'

  - name: Tempo
    type: tempo
    access: proxy
    uid: tempo
    url: http://tempo:3200
    jsonData:
      nodeGraph:
        enabled: true
      serviceMap:
        datasourceUid: 'mimir'
      tracesToLogs:
        datasourceUid: loki
        filterByTraceID: true
        filterBySpanID: false
        mapTagNamesEnabled: false
```

Now you will be able to browse directly to the corresponding trace from your log event and the other way around.

## Metrics

Now, let us deep dive into the metrics of our application!
We can do that through [Prometheus](https://prometheus.io/).

We can configure now Prometheus to grab the metrics exposed by our application.

To do that, we need first to activate the Prometheus endpoint:

We need to add this dependency first:

```groovy
implementation 'io.micrometer:micrometer-registry-prometheus'
```

And enable the corresponding endpoint:

```ini
management.endpoints.web.exposure.include=health,info,prometheus
```

After enabling it, as a developer point of view, it is done :-)

The prometheus statistics can be scrapped by Prometheus itself using [this configuration](https://github.com/alexandre-touret/observability-from-zero-to-hero/blob/main/docker/prometheus/prometheus.yml) 

```yaml
scrape_configs:
- job_name: prometheus
  honor_timestamps: true
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /actuator/prometheus
  scheme: http
  static_configs:
    - targets:
        - host.docker.internal:8080
```

Finally, you can directly browse it through Grafana to integrate all of these metrics into your dashboards 🎉.

## Conclusion
I endeavored to provide you with a comprehensive overview of what an OPS professional could anticipate while investigating an issue and the corresponding topics that require attention. 
As you probably figured out, we only applied just a bunch of configuration sets.  
One of the key merits of these tools lies in their non-intrusiveness within the code itself.
To cut long story short: it is not a big deal!

Integrating these configurations can be a significant stride forward, providing invaluable assistance to the entire IT team, from development to operations, as they navigate and troubleshoot issues—whether in production or elsewhere.

I will finish this article by my opinion on such topics: regardless of the targeted tools, this set of configuration **must be considered as the first feature to implement for every cloud native application**.
