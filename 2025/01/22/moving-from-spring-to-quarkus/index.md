# Moving from Spring Boot to Quarkus

{{< style "text-align:center;" >}}
_Photo by [Dino Reichmuth](https://unsplash.com/@dinoreichmuth?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash) on [Unsplash](https://unsplash.com/photos/yellow-volkswagen-van-on-road-A5rCN8626Ck?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)_
      
{{< /style >}}

After nearly a decade of coding with Spring Boot, I decided to switch to [Quarkus](https://quarkus.io/) (_and was quite late to the party_) for a workshop about how to embrace the API-First approach in Java.

A few years ago, I had already given it a spin. I was not entirely convinced of the value of switching. By the way, I presented in 2022 a talk about that topic with a former colleague of mine [Jean-François James](https://jefrajames.fr/). 
We compared both of the two solutions and concluded the functionalities provided by Spring Boot & Quarkus were sightly similar.

With 2-3 years having passed. I then decided to revisit Quarkus and see how it has evolved.
Although there are some still missing features, I was really impressed.
I will then try to sum up in this article my journey so far from a developer's point of view.

## The context

Instead of reusing one of my existing workshops, I chose to start a new platform from the ground up. 

Here is the context diagram:

{{< style "text-align:center;" >}}
![context diagram](/assets/images/2025/01/guitar_heaven_context.png)
{{< /style >}}

And the container diagram:

{{< style "text-align:center;" >}}
![context diagram](/assets/images/2025/01/guitar_heaven_container.png)
{{< /style >}}

Basically, it is a simple monolithic application with a database which reaches external services:
* [EBay](https://developer.ebay.com/).
* A back office called through Kafka.

The [code repository is available on my GitHub account](https://github.com/alexandre-touret/api-first-workshop).

{{< admonition type=warning title="This app is not production ready (yet)" >}}
I drafted and created this application as part of [a workshop on API-First](https://blog.touret.info/api-first-workshop/).
It is not a production-ready. It misses many aspects such as Observability or security.
{{< /admonition >}}

## Developer experience

My first surprise, was when I started the Quarkus Dev. [After generating the project and selecting the different requirements](https://code.quarkus.io/), I ran into two main components which, in my view, significantly improve the Developer Experience (DX) and go far beyond I used to with Spring:

* The [Dev UI](https://quarkus.io/guides/dev-ui)
* The [Dev Services](https://quarkus.io/guides/dev-services)


{{< style "text-align:center;" >}}
![Dev UI Extensions](/assets/images/2025/01/dev_ui_extensions.png)
_The DevUI extensions page_
{{< /style >}}

Usually many developers look down on Java because it is hard to setup and the integration with external services could be painful. 
Through these two tools, I think Quarkus found a smart answer to these worries.

Once you defined your extensions such as PostgreSQL, you have automatically the corresponding dev services enabled and you can use them either in your integration tests or directly through [the dev mode](https://quarkus.io/guides/dev-mode-differences).

Last but not least, you can browse all of these through the dev-ui. As mentioned [in the Quarkus Guide](https://quarkus.io/guides/dev-ui).

{{< admonition type=quote title="It allows you to" >}}
 - quickly visualize all the extensions currently loaded
 - view extension statuses and go directly to extension documentation
 - view and change Configuration
 - manage and visualize Continuous Testing
 - view Dev Services information
 - view the Build information
 - view and stream various logs

{{< /admonition >}}

Concretely, what it means for me? 
I do not have to bother me again on setting up a local Docker compose environment for testing the plateform locally!

Usually I had to setup and provide to developers such a tooling to enable local testing. 

[Although Spring also provides Dev Services](https://docs.spring.io/spring-boot/reference/features/dev-services.html), I think (_it is only my opinion_), Quarkus brings it as a end to end solution to developers.

### What about the documentation ?

I usually said the documentation belongs to the deliverables. I was well surprised by [the Quarkus guides](https://quarkus.io/guides/). They are straightforward and help you adopt Quarkus easily.
I guess the authors made a special effort on this field. For me the consequence was obvious: I really liked coding with Quarkus, it was easy to move from Spring and find the corresponding features.

## Tools & Framework integration

As I mentioned earlier, one of the Quarkus's strengths I pinpointed is to strongly streamline the integration of differents tools and provide a cohesive setup through its extensions.

For instance, in my workshop, I sat up the application in this way:

```xml
<dependency>
   <groupId>io.github.microcks.quarkus</groupId>
   <artifactId>quarkus-microcks</artifactId>
   <version>0.2.7</version>
</dependency>
<dependency>
   <groupId>io.quarkus</groupId>
   <artifactId>quarkus-hibernate-orm-panache</artifactId>
</dependency>
<dependency>
   <groupId>io.quarkus</groupId>
   <artifactId>quarkus-jdbc-postgresql</artifactId>
</dependency>
<dependency>
   <groupId>io.quarkus</groupId>
   <artifactId>quarkus-hibernate-orm</artifactId>
</dependency>
<dependency>
   <groupId>io.quarkus</groupId>
   <artifactId>quarkus-messaging-kafka</artifactId>
</dependency>
```

With this bunch of dependencies, Quarkus automatically sets up the corresponding dev services and the API to reach these external services (databases, kafka broker,...).

## API-First Quarkus development

The purpose of my workshop was to delve into [API-First](https://www.postman.com/api-first/). 
I therefore created an application built using a Code-First approach and put in practice some tools and patterns to make API-First compatible.

I then used these tools:

### OpenAPIGenerator
Instead of using the [Quarkus OpenAPI Server generator](https://docs.quarkiverse.io/quarkus-openapi-generator/dev/server.html), I prefered using the goold old [OpenAPIGenerator](https://openapi-generator.tech/) Maven plugin. Why? Because it offers more customisation possibilities than the Quarkus extension. 

Here is how I configured it:

```xml
<plugin>
    <groupId>org.openapitools</groupId>
    <artifactId>openapi-generator-maven-plugin</artifactId>
    <version>7.10.0</version>
    <executions>
        <execution>
            <id>generate-server</id>
            <goals>
                <goal>generate</goal>
            </goals>
            <configuration>
                <inputSpec>${project.basedir}/src/main/resources/openapi/guitarheaven-openapi.yaml
                </inputSpec>
                <generatorName>jaxrs-spec</generatorName>
                <configOptions>
                    <apiPackage>info.touret.guitarheaven.application.generated.resource</apiPackage>
                    <modelPackage>info.touret.guitarheaven.application.generated.model</modelPackage>
                    <library>quarkus</library>
                    <dateLibrary>java8</dateLibrary>
                    <generateBuilders>true</generateBuilders>
                    <openApiNullable>false</openApiNullable>
                    <useBeanValidation>true</useBeanValidation>
                    <generatePom>false</generatePom>
                    <interfaceOnly>true</interfaceOnly>
                    <legacyDiscriminatorBehavior>false</legacyDiscriminatorBehavior>
                    <openApiSpecFileLocation>openapi/openapi.yaml</openApiSpecFileLocation>
                    <returnResponse>true</returnResponse>
                    <sourceFolder>.</sourceFolder>
                    <useJakartaEe>true</useJakartaEe>
                    <useMicroProfileOpenAPIAnnotations>true</useMicroProfileOpenAPIAnnotations>
                    <useSwaggerAnnotations>false</useSwaggerAnnotations>
                    <withXml>false</withXml>
                </configOptions>
                <output>${project.build.directory}/generated-sources/open-api-yaml</output>
                <ignoreFileOverride>${project.basedir}/.openapi-generator-ignore</ignoreFileOverride>
                <modelNameSuffix>Dto</modelNameSuffix>
            </configuration>
        </execution>
    </executions>
</plugin>
```

This setup generates at the build time both the model classes and the Server API interfaces.

{{< admonition type=tip title="Want to know more about Quarkus API-First development?" >}}
 If you want to dig into API-First development with Quarkus, you can check out [my workshop](https://blog.touret.info/api-first-workshop/). 
{{< /admonition >}}


### Quarkus OpenAPIGenerator
To generate the REST API client, I then chose to use [the Quarkus OpenAPI Generator extension](https://docs.quarkiverse.io/quarkus-openapi-generator/dev/index.html).

It is really easy to implement. Add just this extension:

```xml
<dependency>
   <groupId>io.quarkiverse.openapi.generator</groupId>
   <artifactId>quarkus-openapi-generator</artifactId>
   <version>2.7.1-lts</version>
</dependency>
```

Define then the following properties in the [src/main/resources/application.properties]:

```ini
quarkus.openapi-generator.codegen.input-base-dir=src/main/resources/openapi-client
quarkus.openapi-generator.codegen.spec.ebay_buy_openapi_yaml.base-package=info.touret.guitarheaven.infrastructure.ebay
quarkus.openapi-generator.codegen.spec.ebay_buy_openapi_yaml.model-name-suffix=Dto
quarkus.openapi-generator.codegen.spec.ebay_buy_openapi_yaml.use-bean-validation=true
```

There is plenty of configuration parameters you can use. If you want to know more, you [can browse the documentation](https://docs.quarkiverse.io/quarkus-openapi-generator/dev/client.html).

### Small Rye
Like other services accessible through the DevUI, the [Small Rye Swagger UI](https://quarkus.io/guides/openapi-swaggerui) is really interesting. Once you add the Rest-Jackson extension enabled, the Swagger UI is automatically plugged to your API when you run the dev mode.

Although I would prefer using [Redocly](https://redocly.com/) instead, the way the SwaggerUI is automatically brought in this setup is enough for me to use it.

### Microcks
[Microcks](https://microcks.io/) offers a facility for mocking external services. With the [Quarkus Microcks extension](https://github.com/microcks/microcks-quarkus), you can use it similarly to other dev services. I won't delve deeply into this topic because, aside from integrating it as part of the dev services, the functionalities are similar to those in Spring Boot. 

## Persistence

I must admit. I do like [Spring Data](https://docs.spring.io/spring-data/commons/reference/index.html) and the way it [abstracts and generates the JPQL queries through the interface methods naming](https://docs.spring.io/spring-data/commons/reference/repositories/definition.html).
At the beginning of my migration journey, I thought moving to [Panache](https://quarkus.io/guides/hibernate-orm-panache) would be challenging.

I was wrong.

Although I missed some functionalities of the [Spring Data CRUD Repository](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/CrudRepository.html), I found my footing easily.
Panache offers two modes of usage: the Active Record pattern and the repository pattern.
I chose the latter for two reasons:

* Mocking a repository is easier than mocking static methods with Mockito
* I prefer to keep data separate from the persistence methods.

Anyway, using Panache let you using more JPQL Queries than with Spring Data. Whether is it good or bad, I am not sure.
What can I say that shifting from Spring Data to Quarkus is quite straightforward for a Java Developer. 

{{< admonition type=info title="What about the Quarkus Spring Data extension?" >}}
There is a [Quarkus Spring Data extension available](https://quarkus.io/guides/spring-data-jpa). 
I prefered not to use it to work in a Quarkus _"standard"_ way for persistence avoiding dependency on a external framework or compatibility layer. 
{{< /admonition >}}

## Rest client

Whether you use the [Spring Rest Client](https://spring.io/blog/2023/07/13/new-in-spring-6-1-restclient/) or [Spring OpenFeign Client](https://spring.io/projects/spring-cloud-openfeign), you can switch to [Quarkus Rest Client easily](https://quarkus.io/guides/rest-client).

I found the usage straightforward.

You can inject it as a field in your code:

```java
@RestClient
private EbayClient ebayClient;
```

define the client:

```java
@RegisterRestClient
@Path("/item_summary/search")
public interface EbayClient {

    // (1)
    @GET
    SearchPagedCollection searchByName(@RestQuery("q") String query);

    //(2)
    @ClientExceptionMapper
    static RuntimeException toException(Response response) {
        if (response.getStatus() == 400) {
            return new RuntimeException("The remote service responded with HTTP 400");
        }
        // Disabling some issues with the EBAY Mock
        return null;
    }
}
```

1. The client is automatically generated and plugged to the remote endpoint through the URL specified in the ``application.properties``:


```ini
quarkus.rest-client."info.touret.guitarheaven.infrastructure.ebay.EbayClient".url=${quarkus.microcks.default.http}/rest/Browse+API/v1.19.9
quarkus.rest-client.extensions-api.verify-host=false
```
2. We can also customise the error management with the [ClientExceptionHandler](https://javadoc.io/doc/io.quarkus/quarkus-rest-client-reactive/3.0.0.CR1/io/quarkus/rest/client/reactive/ClientExceptionMapper.html).


_Et voilà_

Most of the boiler plate code is therefore removed and you can focus on what it worths. 

By the way, in [my workshop on API-First, I then generated the ``RestClient`` class from the OpenAPI file](https://blog.touret.info/api-first-workshop/#9).

## Kafka Integration

The [Kafka integration is also pretty straightforward](https://quarkus.io/guides/kafka-getting-started). 

Whether you broadcast messages or fetch them, the connection layer is automatically handled by Quarkus:

```java
@Inject
@Channel("guitar-requests-out")
Emitter<Record<UUID, GuitarRequest>> guitarRequestEmitter;/**
 * Sends message to Kafka
 *
 * @param guitarRequest : The Guitar to send to Kafka
 */
public void requestForNewGuitars(GuitarRequest guitarRequest) {
    LOGGER.info("Sending Guitar Request to supplier : {}", guitarRequest.requestId().toString());
    guitarRequestEmitter.send(Record.of(guitarRequest.requestId(), guitarRequest));
}/**
 * Fetches the kafka topic
 * <b>This method is only for testing purpose during the workshop</b>
 *
 * @param guitarRequestRecord: The Kafka record of the Guitar to send
 */
@Incoming("guitar-requests-in")
public void traceRequestsForNewGuitars(Record<UUID, GuitarRequest> guitarRequestRecord) {
    LOGGER.info("Received new Guitar Request: ID: {} - NAME: {} - QTY: {}", guitarRequestRecord.key(), guitarRequestRecord.value().guitarName(), guitarRequestRecord.value().quantity());
}
```

The configuration of the Kafka Client is then configured in the ``application.properties`` file:

```ini
# --------------------------
## KAFKA Client configuration
# --------------------------
quarkus.kafka.devservices.topic-partitions.guitar-requests=1
mp.messaging.outgoing.guitar-requests-out.connector=smallrye-kafka
mp.messaging.outgoing.guitar-requests-out.topic=guitar-requests
mp.messaging.outgoing.guitar-requests-out.key.serializer=org.apache.kafka.common.serialization.UUIDSerializer
mp.messaging.outgoing.guitar-requests-out.value.serializer=info.touret.guitarheaven.infrastructure.kafka.GuitarRequestSerializer
mp.messaging.outgoing.guitar-requests-out.auto.offset.reset=earliest
mp.messaging.incoming.guitar-requests-in.connector=smallrye-kafka
mp.messaging.incoming.guitar-requests-in.topic=guitar-requests
mp.messaging.incoming.guitar-requests-in.key.deserializer=org.apache.kafka.common.serialization.UUIDDeserializer
mp.messaging.incoming.guitar-requests-in.value.deserializer=info.touret.guitarheaven.infrastructure.kafka.GuitarRequestDeserializer
mp.messaging.incoming.guitar-requests-in.auto.offset.reset=earliest
```

It was just a simple integration. For more information, you can check out [the guide](hhttps://quarkus.io/guides/kafka) and the examples.
Nevertheless, thanks to the Dev Services, we can use [RedPanda in development to pop a Kafka Stack](https://quarkus.io/guides/kafka-dev-services) and avoid configuring a Docker compose stack to enable it during integration tests.

## Difficulties and some functionalities still missing (from my point of view)

### Testing

The main difficulty I faced was writing and running my integration tests.

Quarkus offers [the `@QuarkusTest` facility](https://quarkus.io/guides/getting-started-testing) for creating and running integration tests, and it works well. It is automatically connected to the dev services (e.g., the database), and data is automatically imported at the test startup using the JPA standard method (i.e., using the `import.sql` file located in the `src/test/resources` folder).

My main concern was that this dataset and the JPA context were shared across all the integration tests. Once I deleted an item during one of my integration tests, I was unable to access it in subsequent tests.

While working on my project, this issue slightly annoyed me. I had to troubleshoot why my integration tests failed, even though they had passed before (a common development challenge).

I really missed [the Spring Test `@Sql` annotation](https://docs.spring.io/spring-framework/reference/testing/testcontext-framework/executing-sql.html). Among other benefits, it helps me run SQL scripts whenever needed and reload my data at the beginning of my integration tests. Although it might be considered heavier, it provides more flexibility and ensures data integrity.

### Moving from Spring Data

As I exposed earlier, Spring Data offers many functionalities which make the development easier. It was a bit weird recoding JPQL queries for fetching data I used to do without coding with Spring Data. 

Anyway, I strongly believe it is just _a detail_. The scope of functionalities is, in my opinion, equivalent.

To sum up, Spring Data mostly abstracts the persistence layer, while coding the persistence layer with Quarkus involves more direct use of JPA and Hibernate (even though Panache strongly simplifies the process).

## Conclusion

I will stop this comparison here. I haven't explored much so far, but after spending some hours coding, I'm really pleased with the effort the Quarkus community has made to enhance the developer experience. With full support of [the Microprofile specifications](https://microprofile.io/) and its various API or facilities, Quarkus allows you to streamline your development, and write code that is straightforward and more stable over time.

One interesting point still missing is about Security. Although there is a [Quarkus OpenId Connect integration](https://quarkus.io/guides/security-openid-connect-client-reference), I don't know yet what is the gap between Spring Security and it.

Anyway, I may have missed some points in my review. If so, feel free to reach out to me.

2-3 years ago, when people asked about moving to Quarkus, I didn't see much interest. However, if I had to start a greenfield project today, it would be now my first choice.
