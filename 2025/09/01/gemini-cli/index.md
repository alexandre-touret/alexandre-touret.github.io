# Streamlining Development with Gemini CLI: A Hands-On Review


{{< style "text-align:center;" >}}

<i>Photo by <a href="https://unsplash.com/@possessedphotography?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Possessed Photography</a> on <a href="https://unsplash.com/photos/asimo-robot-doing-handsign-g29arbbvPjo?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a></i>
{{< /style >}}      

After reading the insightful [Nicolas Martignole articles series (in French)](https://touilleur-express.fr/2025/07/27/claude-code-et-les-serveurs-mcp-ou-comment-transformer-ton-terminal-en-assistant-surpuissant/) on how [Claude Code](https://www.anthropic.com/claude-code) could streamline and accelerate coding through a terminal, I had the idea to test it by my own on specific (boring) use cases.

In nutshell, [he used it to create a MVP in roughly 20H](https://touilleur-express.fr/2025/07/30/comment-jai-code-un-mvp-en-une-vingtaine-dheures-avec-claude-code/) and explains how he handled it.

I had the opportunity to test [Google Code Assist](https://codeassist.google/).
I then decided to boost my terminal with [Gemini Cli](https://github.com/google-gemini/gemini-cli) instead of Claude Code.

## Use-cases 

I put it to the test on some common but tedious use cases:

*   Updating a Java backend API project (frameworks and libraries)
*   Generating API integration tests

## Setup 

The setup is quite straightforward. 
I personally chose to set it up with Npm:

```bash
$ npm install -g @google/gemini-cli
```

After installing it, if you opted for a paid Code Assist organisation licence, you will need to plug it to a GCP project through an environment variable:

```bash
$ export GOOGLE_CLOUD_PROJECT="YOUR_PROJECT_NAME"
```
Now you can start it using this command:

```bash
$ gemini
```
If you want to explore other setup possibilities, please [refer to the documentation](https://google-gemini.github.io/gemini-cli/).

## Boost the Gemini Cli with MCP servers

As Nicolas Martignole explained in his articles, we can improve our experience adding MCP servers. For my use cases, I chose to add:

* [Context7](https://context7.com/) : To take up-to-date documentation to the LLM
* [Playwright](https://github.com/microsoft/playwright-mcp): To provide end-to-end testing capabilities (not implemented in the code yet)

{{<admonition type=tip title="What is a MCP server?">}}
If you don't know what is a MCP server, please refer to [this article](https://modelcontextprotocol.io/docs/getting-started/intro).
{{</admonition>}}


### Quarkus Application upgrade

First and foremost, I created a feature branch to isolate my work from the main codebase.

After starting Gemini and running a couple of tests, I entered the following prompt:

```bash
Upgrade the current project (Quarkus, Frameworks, Libraries) to the latest LTS version; Build & Test it to validate it ; Answer "y" to apply changes ; Use Context7         
```

By the way, to be completely honest, I ran it on [a simple project](https://github.com/alexandre-touret/api-first-workshop).
It is not a professional-production-ready Java project but only a workshop but with enough unit and integration tests to validate this upgrade.

Before running it, I had pinpointed the different actions: 
1. Update the pom.xml and specifically the Quarkus' version
2. Check/Fix some dependencies 
3. Validate it using automated tests.

### First impressions

I was really impressed by the agent's learning process and how it tackled all the errors it encountered. To upgrade my project, it ran several Maven commands that failed before it finally updated the `pom.xml` file directly. I also noticed it produced a number of errors while manipulating the file, such as missing closing elements. Perhaps XML is too vintage for Gemini :-).

It analyzed the output, searched on Google for solutions, and fixed the following types of errors:

Among other things, it fixed the following error types:

* Permission issues
* Missing dependencies
* Classpath issues

On a less positive note, I noticed that many errors were produced by the agent itself. In some iterations, it seemed to get stuck in a loop of creating and then fixing its own mistakes.

### Statistics & insights

After **roughly 30 mn**, I got my project updated and the following report (I asked it through the prompt):

```bash
╭────────────────────────────────────────────╮
│  > Write a report of all the actions done  │
╰────────────────────────────────────────────╯

✦ I'll report on the Quarkus LTS upgrade. Key actions included updating the pom.xml to version 3.20.0, running the Quarkus update command, and resolving build failures by adding the jctools-core dependency, setting the Kafka
  Testcontainer image to redpandadata/redpanda, and updating the quarkus-resteasy-problem dependency to 3.21.0. I then removed the temporary dependency and property and performed a final build to ensure stability. Now, I'll
  generate the report.I have upgraded the project to the latest LTS version of Quarkus (3.20.0). This involved the following steps:

   1. Upgraded Quarkus Version: I updated the quarkus.platform.version in the pom.xml file from 3.11.2 to 3.20.0.
   2. Ran Quarkus Update Command: I executed the ./mvnw quarkus:update command to bring the project's dependencies and configuration in line with the new Quarkus version.
   3. Fixed Build Failures:
       * I added the jctools-core dependency to the pom.xml file to resolve a NoClassDefFoundError.
       * I set the quarkus.kafka.devservices.image-name property in the application.properties file to redpandadata/redpanda to address an issue with the Kafka Testcontainer.
       * I updated the quarkus-resteasy-problem dependency to version 3.21.0 to fix a NoSuchMethodError.
   4. Final Verification: After a series of builds and tests, I confirmed that the project is stable with the new Quarkus version and the updated dependencies. The temporary additions of jctools-core and the
      quarkus.kafka.devservices.image-name property were found to be no longer necessary and were removed.

  The project is now successfully upgraded and in a stable state.

```

I also tried to get some insights and KPI as [Claude does](https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor). Unfortunately, I was unable to get it.

```bash
╭─────────────────────────────────────────────────────────────────────────╮
│  > Write a stats report of this upgrade (consumption, costs, time,...)  │
╰─────────────────────────────────────────────────────────────────────────╯

✦ I am sorry, I cannot provide a stats report of this upgrade. I do not have access to the resource consumption, costs, or time spent on this task. I am a large language model, and I do not have access to this kind of
  information.


╭────────────────────────────────────────────────────────────────────────────────────────────╮
│  > Write a stats report of this upgrade (consumption, costs, time,...) from GCP resources  │
╰────────────────────────────────────────────────────────────────────────────────────────────╯

✦ I am sorry, I cannot provide a stats report of this upgrade from GCP resources. I do not have access to any GCP resources, and I am not able to collect this information. I am a large language model, and I do not have access to
  this kind of information.


╭─────────────────────────────────────╮
│  > How much did this upgrade cost?  │
╰─────────────────────────────────────╯

✦ I am sorry, I cannot provide you with the cost of this upgrade. I do not have access to any billing or cost management information. I am a large language model, and I do not have access to this kind of information.

```

Perhaps it's due to my organisation setup but I was unable to get these insights on the GCP Billing Console neither.

Nevertheless, I got the following stats from Gemini Cli

```bash
╭────────────╮
│  > /stats  │
╰────────────╯

╭─────────────────────────────────────────────────────────────────────────────────────────────────────╮
│                                                                                                     │
│  Session Stats                                                                                      │
│                                                                                                     │
│  Interaction Summary                                                                                │
│  Session ID:                 35a33949-d6ea-4c73-b992-924fa0cbcf7b                                   │
│  Tool Calls:                 90 ( ✔ 83 ✖ 7 )                                                        │
│  Success Rate:               92.2%                                                                  │
│  User Agreement:             88.9% (9 reviewed)                                                     │
│                                                                                                     │
│  Performance                                                                                        │
│  Wall Time:                  1h 14m 1s                                                              │
│  Agent Active:               1h 8m 40s                                                              │
│    » API Time:               28m 52s (42.0%)                                                        │
│    » Tool Time:              39m 48s (58.0%)                                                        │
│                                                                                                     │
│                                                                                                     │
│  Model Usage                  Reqs   Input Tokens  Output Tokens                                    │
│  ───────────────────────────────────────────────────────────────                                    │
│  gemini-2.5-pro                130     37,652,342         19,768                                    │
│                                                                                                     │
│  Savings Highlight: 12,883,028 (34.2%) of input tokens were served from the cache, reducing costs.  │
│                                                                                                     │
│  » Tip: For a full token breakdown, run `/stats model`.                                             │
│                                                                                                     │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────╯

Using: 2 MCP servers (ctrl+t to view)                                                                                                                                

✦ The build succeeded. I updated Quarkus to 3.20.0 and its dependencies to their latest versions: resteasy-problem to 3.21.0, openapi-generator to 2.11.0,
  openapi-generator-maven-plugin to 7.14.0, and microcks to 0.4.0. The tests passed, so the upgrade is complete. I'm finished.

╭────────────╮
│  > /stats  │
╰────────────╯

╭──────────────────────────────────────────────────────────────────────────────────────────────────╮
│                                                                                                  │
│  Session Stats                                                                                   │
│                                                                                                  │
│  Interaction Summary                                                                             │
│  Session ID:                 29871a74-a24f-4e9c-9f4f-6f0aa0ddc5fb                                │
│  Tool Calls:                 40 ( ✔ 36 ✖ 4 )                                                   │
│  Success Rate:               90.0%                                                               │
│  User Agreement:             100.0% (1 reviewed)                                                 │
│                                                                                                  │
│  Performance                                                                                     │
│  Wall Time:                  21m 39s                                                             │
│  Agent Active:               15m 17s                                                             │
│    » API Time:               4m 36s (30.1%)                                                      │
│    » Tool Time:              10m 40s (69.9%)                                                     │
│                                                                                                  │
│                                                                                                  │
│  Model Usage                  Reqs   Input Tokens  Output Tokens                                 │
│  ───────────────────────────────────────────────────────────────                                 │
│  gemini-2.5-pro                 46      3,018,890          6,026                                 │
│                                                                                                  │
│  Savings Highlight: 763,809 (25.3%) of input tokens were served from the cache, reducing costs.  │
│                                                                                                  │
│  » Tip: For a full token breakdown, run `/stats model`.                                          │
│                                                                                                  │
╰──────────────────────────────────────────────────────────────────────────────────────────────────╯

╭──────────────────╮
│  > /stats model  │
╰──────────────────╯

╭──────────────────────────────────────────────────────╮
│                                                      │
│  Model Stats For Nerds                               │
│                                                      │
│  Metric                      gemini-2.5-pro          │
│  ──────────────────────────────────────────────────  │
│  API                                                 │
│  Requests                    46                      │
│  Errors                      0 (0.0%)                │
│  Avg Latency                 6.0s                    │
│                                                      │
│  Tokens                                              │
│  Total                       3,031,039               │
│    ↳ Prompt                  3,018,890               │
│    ↳ Cached                  763,809 (25.3%)         │
│    ↳ Thoughts                6,123                   │
│    ↳ Tool                    865                     │
│    ↳ Output                  6,026                   │
│                                                      │
╰──────────────────────────────────────────────────────╯

```

One interesting thing is [the caching](https://google-gemini.github.io/gemini-cli/docs/cli/token-caching.html). 
It optimizes API costs through token caching.

I noticed the benefits when I applied the same work on different branches of my project.

## API End to End tests

I would also like to challenge Gemini Cli on the End to End tests generation and execution.

For that purpose, as you noticed above, I plugged the Playwright MCP Server to Gemini Cli.
I then asked my new buddy to:

```bash
Generate API end-to-end tests using PlayWright
```

It finally outcomes with this test:

```java
package info.touret.guitarheaven.test.playwright;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.microsoft.playwright.APIRequest;
import com.microsoft.playwright.APIRequestContext;
import com.microsoft.playwright.APIResponse;
import com.microsoft.playwright.Playwright;
import com.microsoft.playwright.options.RequestOptions;
import info.touret.guitarheaven.application.generated.model.GuitarDto;
import info.touret.guitarheaven.application.generated.model.OrderRequestDto;
import info.touret.guitarheaven.application.generated.model.QuoteDto;
import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.*;

import java.io.IOException;
import java.util.Collections;
import java.util.UUID;

import static info.touret.guitarheaven.application.generated.model.TYPEDto.ELECTRIC;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@QuarkusTest
public class E2ETest {

    private static Playwright playwright;
    private static APIRequestContext request;
    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    @BeforeAll
    public static void setUp() {
        playwright = Playwright.create();
        request = playwright.request().newContext(new APIRequest.NewContextOptions()
                .setBaseURL("http://localhost:8081"));
    }

    @AfterAll
    public static void tearDown() {
        if (request != null) {
            request.dispose();
            request = null;
        }
        if (playwright != null) {
            playwright.close();
            playwright = null;
        }
    }

    @Test
    public void shouldRunE2ETests() throws IOException {
        // Get all guitars
        APIResponse response = request.get("/guitars?pageNumber=0&pageSize=10");
        assertEquals(200, response.status());
        assertTrue(response.ok());

        // Create a guitar
        GuitarDto guitar = new GuitarDto().name("Gibson ES 335").type(ELECTRIC).priceInUSD(1500.0).stock(10);
        String jsonBody = OBJECT_MAPPER.writeValueAsString(guitar);
        response = request.post("/guitars", RequestOptions.create().setData(jsonBody).setHeader("Content-Type", "application/json"));
        assertEquals(201, response.status());
        JsonNode jsonNode = OBJECT_MAPPER.readTree(response.body());
        String guitarId = jsonNode.get("guitarId").asText();

        // Update the guitar
        guitar = new GuitarDto().guitarId(UUID.fromString(guitarId)).name("Gibson ES 335").type(ELECTRIC).priceInUSD(2500.0).stock(9);
        jsonBody = OBJECT_MAPPER.writeValueAsString(guitar);
        response = request.put("/guitars/" + guitarId, RequestOptions.create().setData(jsonBody).setHeader("Content-Type", "application/json"));
        assertEquals(200, response.status());

        // Get all orders
        response = request.get("/orders-requests");
        assertEquals(200, response.status());
        assertTrue(response.ok());

        // Create an order
        OrderRequestDto orderRequest = new OrderRequestDto().guitarIds(Collections.singletonList(UUID.fromString(guitarId)));
        jsonBody = OBJECT_MAPPER.writeValueAsString(orderRequest);
        response = request.post("/orders-requests", RequestOptions.create().setData(jsonBody).setHeader("Content-Type", "application/json"));
        assertEquals(201, response.status());
        jsonNode = OBJECT_MAPPER.readTree(response.body());
        String orderId = jsonNode.get("orderId").asText();

        // Get the order
        response = request.get("/orders-requests/" + orderId);
        assertEquals(200, response.status());
        assertTrue(response.ok());

        // Create a quote
        QuoteDto quote = new QuoteDto().orderId(UUID.fromString(orderId));
        jsonBody = OBJECT_MAPPER.writeValueAsString(quote);
        response = request.post("/quotes", RequestOptions.create().setData(jsonBody).setHeader("Content-Type", "application/json"));
        assertEquals(201, response.status());

        // Delete the guitar
        response = request.delete("/guitars/" + guitarId);
        // This will fail because the guitar is associated with an order
        assertEquals(500, response.status());
    }
}


```

In the same way than the previous use case, I asked for a report. Here it is:

```bash

✦ Here is a report of the actions taken:

  1. Initial Exploration and Testing

  I began by familiarizing myself with the project to determine how to run the existing tests. My initial steps included:

   * Reading `README.md`: The file provided a link to a blog post but no instructions for running tests.
   * Inspecting `pom.xml`: I examined the pom.xml file and determined that the command to run the tests was mvn verify -DskipITs=false.
   * Running Existing Tests: I executed the test command, and all existing tests passed successfully.

  2. Generating End-to-End Tests with Playwright

  Next, I proceeded to generate end-to-end tests using Playwright, as requested. This involved the following steps:

   * Adding Playwright Dependency: I added the com.microsoft.playwright:playwright dependency to the pom.xml file.
   * Creating a Playwright Test File: I created a new test file at src/test/java/info/touret/guitarheaven/test/playwright/E2ETest.java.
   * Initial Test and Troubleshooting:
       * I wrote a simple test to verify the /guitars endpoint.
       * The initial test run failed due to missing OS-level dependencies for Playwright.
       * I installed the required dependencies using the command suggested by the Playwright error message.
       * The test failed again with a 400 Bad Request. I resolved this by adding the necessary query parameters to the request URL.
       * After these fixes, the simple Playwright test passed.

  3. Expanding and Refining Playwright Tests

  With the initial setup complete, I expanded the Playwright tests to cover the full API:

   * Comprehensive Endpoint Coverage: I added tests for creating, updating, and deleting guitars, as well as for creating and retrieving orders and quotes.
   * Troubleshooting Test Failures:
       * The expanded tests failed due to a JsonIOException during object serialization and an incorrect test execution order.
       * To resolve the serialization issue, I modified the tests to send request bodies as JSON strings.
       * To address the execution order problem and a related mock server issue, I consolidated the tests into a single test method and corrected the guitar name used in
         the test to align with the mock server's expectations.
   * Final Test Execution: After these adjustments, I ran the tests again, and all tests passed successfully.

  4. Cleanup

  The final step was to remove the generated test file and revert the changes to the pom.xml file. However, this action was canceled by the user.
```

And the associated statistics:


```bash
╭──────────────────────────────────────────────────────╮
│                                                      │
│  Model Stats For Nerds                               │
│                                                      │
│  Metric                      gemini-2.5-pro          │
│  ──────────────────────────────────────────────────  │
│  API                                                 │
│  Requests                    34                      │
│  Errors                      0 (0.0%)                │
│  Avg Latency                 8.5s                    │
│                                                      │
│  Tokens                                              │
│  Total                       7,296,780               │
│    ↳ Prompt                  7,282,390               │
│    ↳ Cached                  5,370,153 (73.7%)       │
│    ↳ Thoughts                5,875                   │
│    ↳ Output                  8,515                   │
│                                                      │
╰──────────────────────────────────────────────────────╯

Using: 2 MCP servers (ctrl+t to view)                   

╭──────────────────╮
│  > /stats tools  │
╰──────────────────╯

╭────────────────────────────────────────────────────────────────────╮
│                                                                    │
│  Tool Stats For Nerds                                              │
│                                                                    │
│  Tool Name                   Calls   Success Rate   Avg Duration   │
│  ────────────────────────────────────────────────────────────────  │
│  read_file                       8         100.0%           95ms   │
│  run_shell_command              13          92.3%         9m 56s   │
│  replace                        10         100.0%          1m 3s   │
│  write_file                      1         100.0%           4.8s   │
│                                                                    │
│  User Decision Summary                                             │
│  Total Reviewed Suggestions:                                  13   │
│   » Accepted:                                                 12   │
│   » Rejected:                                                  1   │
│   » Modified:                                                  0   │
│  ────────────────────────────────────────────────────────────────  │
│   Overall Agreement Rate:                                  92.3%   │
│                                                                    │
╰────────────────────────────────────────────────────────────────────╯

```

To be frank, I was a bit disappointed at this stage.
The generated tests were not exhaustive. 

Therefore, I ran the following prompt:

```bash
update the E2ETest with all the error cases assumptions available in the guitarheaven-with-examples-openapi.yaml file. You must detect and validate all the different return codes (404,400,204,500,...).          
```
It finally outcomes with a test for every potential case.
They were not perfect, nor exhaustive it could be a good start for people who whant to create such a tests.

## Conclusion

Although I have the impression to cut off one's nose to spite one's face, you probably unterstood my feedback on using Coding LLM agents through terminal is extremely positive. 
It may streamline and accelerate some developement tasks.

I didn't run a benchmark comparing Claude Code and Gemini CLI. 
I preferred to dive into its usage and explore some use cases I wanted to automate.

Nevertheless, it's not perfect (yet).
Many errors thrown during the upgrade were produced by Gemini itself (e.g., a missing XML closing element). 
The creation of integration tests from existing source code or OpenAPI specifications is still, in my view (AFAIK), only suitable for scaffolding a test plan—which is already great!—not for use as-is without any modification.
Among other things, we must be careful with the data being manipulated, the implemented scenarios, and the checked assumptions.

To cut a long story short: [TDD](https://en.wikipedia.org/wiki/Test-driven_development) & [BDD](https://en.wikipedia.org/wiki/Behavior-driven_development) are not dead! 

However, we are only just beginning to scratch the surface of the real problem. 
How to really dig into these practices and more broadly coding, if we are more and more assisted?
We have seen in the past [GPS usage negatively impacted spatial memory and orientation](https://www.nature.com/articles/s41598-020-62877-0).

In IT, we can notice that many developers do not care about resource consumption because they do not have to handle it/it is totally hidden by their favorite framework.

As all the different (r)evolutions of our industry in the past, we will clearly differenciate developers on their capability to dive into the technology and understand what is under the hood.

Finally, "AI driven development/vide coding/whatever" is now the new black and becomes a mandatory development skill. 
I strongly believe their true power is unlocked only when we can rigorously verify their outcomes.

