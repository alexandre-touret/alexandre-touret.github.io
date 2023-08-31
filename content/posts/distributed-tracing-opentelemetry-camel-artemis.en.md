---
title: Enabling Distributed Tracing in asynchronous transactions handled by Apache Camel based applications with OpenTelemetry 
date: 2023-09-10 08:00:00
images: ["/assets/images/2023/09/nick-fewings-4dI5OP2Ee64-unsplash.webp"]
featuredImagePreview: /assets/images/2023/09/nick-fewings-4dI5OP2Ee64-unsplash.webp
featuredImage: /assets/images/2023/09/nick-fewings-4dI5OP2Ee64-unsplash.webp
og_image: /assets/images/2023/09/nick-fewings-4dI5OP2Ee64-unsplash.webp
draft: true

tags:
- AMQP
- OpenTelemetry
- Java
- Camel
- Artemis
---

## Introduction
Nowadays _Distributed Tracing is the new black._ 
Among other things, it helps diving into distributed transactions and answering the burning questions: what are the different requests, their contexts and how long they are.

Since [Google published Dapper](https://research.google/pubs/pub36356/), many solutions came out. 
Now, [OpenTelemetry](https://opentelemetry.io/) is the most popular, but there are other solutions available such as [Elastic APM](https://www.elastic.co/observability/application-performance-monitoring) or [DynaTrace](https://www.dynatrace.com/support/help/observe-and-explore/purepath-distributed-traces/distributed-traces-overview). 

This tooling fits well with APIs and more broadly synchronous transactions. 

However, what about asynchronous transactions?
The need for clarity is more important in this case.
When your architecture is based on a messaging / event streaming broker, it is quite hard to get an outlook of the whole transaction.

Why? 
It is due to the split of the _functional transaction_ into two loose coupled sub transactions:

{{< mermaid >}}sequenceDiagram
participant Producer
participant Consumer
participant Messaging/EventStreaming/Whatever
Producer->>Messaging/EventStreaming/Whatever: Send message
Consumer->>Messaging/EventStreaming/Whatever: Fetch message
{{< /mermaid >}}

Hopefully you can rope OpenTelemetry in it to shed light.

{{< admonition info "What about the main concepts of Distributed Tracing?" true >}}
I will not dig into the concepts of Distributed tracing in this article.
[If you are interested in it, you can read my article on the Worldline Tech Blog](https://blog.worldline.tech/2021/09/22/enabling_distributed_tracing_in_spring_apps.html).
{{< /admonition >}}

I will explain in this article how to set up and plug OpenTelementry to gather asynchronous transaction traces using [Apache Camel](https://camel.apache.org/) and [Artemis](https://activemq.apache.org/components/artemis/). 

All the code snippets are part of [this project on GitHub](https://GitHub.com/alexandre-touret/camel-artemis-opentelemetry).
(Normally) you can use and run it locally on your desktop.

## Architecture
The [SPANs](https://www.logicmonitor.com/blog/what-are-spans-in-distributed-tracing) are broadcast through OpenTelemetry and gathered through [OpenTelemetry Collector](https://opentelemetry.io/docs/collector).
It finally sends them to [Jaeger](https://www.jaegertracing.io/). 
You can also opt for [Tempo](https://grafana.com/oss/tempo/) and [Grafana](https://grafana.com/). 

Here is the architecture of such a platform:


{{< style "text-align:center" >}}
![OpenTelemetry Collector Architecture](/assets/images/2023/09/architecture.svg )
{{</ style >}}

## OpenTelemetry Collector

The cornerstone of this architecture is the [collector](https://opentelemetry.io/docs/collector/). 
This tool can be compared to [Elastic LogStash](https://www.elastic.co/fr/logstash/) or an [ETL](https://en.wikipedia.org/wiki/Extract,_transform,_load). 
It will help us get, transform and export telemetry data.

{{< style "text-align:center" >}}
![OpenTelemetry Collector Functionalities](/assets/images/2023/09/otel-diagram.svg "Source: https://opentelemetry.io/docs/collector/" )
{{</ style >}}

For our use case, the configuration is quite simple.

First, here is the [Docker compose configuration](https://opentelemetry.io/docs/collector/):

````yaml
  otel-collector:
    image: otel/opentelemetry-collector:0.75.0
    container_name: otel-collector
    command: [ "--config=/etc/otel-collector-config.yaml" ]
    volumes:
      - ./docker/otel-collector-config.yaml:/etc/otel-collector-config.yaml
    ports:
      - "1888:1888"   # pprof extension
      - "8888:8888"   # Prometheus metrics exposed by the collector
      - "8889:8889"   # Prometheus exporter metrics
      - "13133:13133" # health_check extension
      - "4317:4317"   # OTLP gRPC receiver
      - "55670:55679" # zpages extension
````

and the [``otel-collector-config.yaml``](https://github.com/alexandre-touret/camel-artemis-opentelemetry/blob/main/containers/docker/otel-collector-config.yaml):

```yaml
# (1)
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: "0.0.0.0:4317"
      http:
        endpoint: "0.0.0.0:4318"

  prometheus:
    config:
      scrape_configs:
        - job_name: 'test'
          metrics_path: '/actuator/prometheus'
          scrape_interval: 5s
          static_configs:
            - targets: ['host.docker.internal:8080']
# (2)
exporters:
  #  prometheus:
  #    endpoint: "0.0.0.0:8889"
  #    const_labels:
  #      label1: value1

  logging:

  jaeger:
    endpoint: jaeger:14250
    tls:
      insecure: true
#  zipkin:
#    endpoint: http://zipkin:9411/api/v2/spans
#    tls:
#      insecure: true

# (3)
processors:
  batch:

extensions:
  health_check:
  pprof:
    endpoint: :1888
  zpages:
    endpoint: :55679
# (4)
service:
  extensions: [pprof, zpages, health_check]
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [logging, jaeger]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [logging]
```

**Short explanation**

If you want further information about this configuration, you [can browse the documentation](https://opentelemetry.io/docs/collector/configuration/).
For the impatient readers here are a short explanation of this configuration file:

1. Where to pull data?
2. Where to store data?
3. What to do with it?
4. What are the workloads to activate?

## What about the code?

The configuration to apply is pretty simple and straightforward. 
To cut long story short, you need to include libraries, add some configuration stuff and run your application with an agent which will be responsible for broadcasting the SPANs.

### Libraries to add

For an Apache Camel based Java application, you need to add this starter first:

```xml
<dependency>
   <groupId>org.apache.camel.springboot</groupId>
   <artifactId>camel-opentelemetry-starter</artifactId>
</dependency>
```

In case you set up a _basic_ [Spring Boot application](https://spring.io/), you only have to configure the agent (_see below_).

### In the code
This step is not mandatory.
However, if you are eager to get more details in your Jaeger dashboard, it is advised.

In the application class, you only have to put the ``@CamelOpenTelemetry`` annotation. 

```java
@CamelOpenTelemetry
@SpringBootApplication
public class DemoApplication {
[...]
```

If you want more details, you can check [the official documentation](https://camel.apache.org/components/3.20.x/others/opentelemetry.html).

### The Java Agent

The java agent is responsible for instrumenting Java 8+ code, capturing metrics and forwarding them to the collector.
...

[Its documentation is available on GitHub](https://github.com/open-telemetry/opentelemetry-java-instrumentation).
The detailed list of configuration parameters [is available here](https://opentelemetry.io/docs/instrumentation/java/automatic/agent-config/). 
You can configure it through environment, system variables or a [configuration file](https://opentelemetry.io/docs/instrumentation/java/automatic/agent-config/#configuration-file).

For instance, by default, the OpenTelemetry Collector default endpoint value is ``http://localhost:4317``. 
You can customise it by setting the ``OTEL_EXPORTER_OTLP_METRICS_ENDPOINT`` environment variable or the ``otel.exporter.otlp.metrics.endpoint`` java system variable (e.g., using ``-Dotel.exporter.otlp.metrics.endpoint`` option ).

**Example of configuration**

```xml
<profile>
    <id>opentelemetry</id>
    <activation>
        <property>
            <name>apm</name>
            <value>otel</value>
        </property>
    </activation>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-dependency-plugin</artifactId>
                <executions>
                    <execution>
                        <id>copy-javaagent</id>
                        <phase>process-resources</phase>
                        <goals>
                            <goal>copy</goal>
                        </goals>
                        <configuration>
                            <artifactItems>
                                <artifactItem>
                                    <groupId>io.opentelemetry.javaagent</groupId>
                                    <artifactId>opentelemetry-javaagent</artifactId>
                                    <version>${opentelemetry-agent.version}</version>
                                    <overWrite>true</overWrite>
                                    <outputDirectory>${project.build.directory}/javaagents</outputDirectory>
                                    <destFileName>javaagent.jar</destFileName>
                                </artifactItem>
                            </artifactItems>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <agents>
                        <agent>${project.build.directory}/javaagents/javaagent.jar</agent>
                    </agents>
                    <!--                    <systemPropertyVariables>-->
                    <!--                        <otel.traces.sampler>parentbased_traceidratio</otel.traces.sampler>-->
                    <!--                        <otel.traces.sampler.arg>0.2</otel.traces.sampler.arg>-->
                    <!--                    </systemPropertyVariables>-->
                </configuration>
            </plugin>
        </plugins>
    </build>
</profile>
```

The variables in comment (e.g., ``otel.traces.sampler``) can be activated if you want [to sample your forwarded data based on a head rate limiting](https://opentelemetry.io/docs/concepts/sampling/).

You can now run both the producer and the consumer:

```jshelllanguage
mvn clean spring-boot:run -Popentelemetry -f camel-producer/pom.xml
```

```jshelllanguage
mvn clean spring-boot:run -Popentelemetry -f camel-consumer/pom.xml
```

The gateway can also be run and instrumented in the same way. 
You can run it as:

```jshelllanguage
mvn clean spring-boot:run -Popentelemetry -f gateway/pom.xml
```

## Dashboard

To get traces, I ran this dumb command to inject traces in Jaeger:

```jshelllanguage
while true ; http :9080/camel/test; end
```

Now, you can browse Jaeger ([http://localhost:16686](http://localhost:16686)) and query it to find trace insights:

{{< style "text-align:center" >}}
![Jaeger front page](/assets/images/2023/09/jaeger-1.webp "Number of different apps")
{{</ style >}}

If you dig into one transaction, you will see the whole transaction:

{{< style "text-align:center" >}}
![Jaeger transaction page](/assets/images/2023/09/jaeger-2.webp "One transaction")
{{</ style >}}

And correlate two sub transactions:

{{< style "text-align:center" >}}
![Jaeger two sub transactions](/assets/images/2023/09/jaeger-3.webp "Two sub transactions")
{{</ style >}}

## Conclusion

We saw how to highlight asynchronous transactions and correlate them through OpenTelemetry and Jaeger. It was voluntarily simple.
One of the key features of OpenTelemetry Collector is it becomes through the years a _standard_. Most suites, such as Elastic APM are compatible with it.
