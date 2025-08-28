---
title: "Streamline some dev tasks with Gemini Cli: Feedbacks & insights "
date: 2025-09-15 08:00:00
images: ["/assets/images/2025/09/possessed-photography-g29arbbvPjo-unsplash.webp "]
featuredImagePreview: /assets/images/2025/09/possessed-photography-g29arbbvPjo-unsplash.webp
featuredImage: /assets/images/2025/09/possessed-photography-g29arbbvPjo-unsplash.webp
lightgallery: true
og_image: /assets/images/2025/09/possessed-photography-g29arbbvPjo-unsplash.webp
tags:
  - IA
---

{{< style "text-align:center;" >}}

<i>Photo by <a href="https://unsplash.com/@possessedphotography?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Possessed Photography</a> on <a href="https://unsplash.com/photos/asimo-robot-doing-handsign-g29arbbvPjo?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a></i>
{{< /style >}}      

Article Nicolas Martignole

Outils mis en oeuvre

Gemini

MCP : Context7


Uses cases testés

Quarkus Application upgrade



Install in Gemini CLI

See Gemini CLI Configuration for details.

    Open the Gemini CLI settings file. The location is ~/.gemini/settings.json (where ~ is your home directory).
    Add the following to the mcpServers object in your settings.json file:

❯ cat ~/.gemini/settings.json
{
  "theme": "Default",
  "selectedAuthType": "oauth-personal",
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": [
        "-y",
        "@upstash/context7-mcp"
      ]
    },
    "playwright": {
      "command": "npx",
      "args": [
        "@playwright/mcp@latest"
      ]
    }
  },
  "preferredEditor": "vim"
}¶                 

 Upgrade the current project (Quarkus, Frameworks, Libraries) to the latest LTS version; Build & Test it to validate it ; Answer "y" to apply changes ; Use Context7         


✦ The Quarkus LTS upgrade to 3.20.0 and quarkus-resteasy-problem to 3.21.0, along with temporary jctools-core and quarkus.kafka.devservices.image-name properties, fixed the build. After a pom.xml parsing error and subsequent
  fix, the build is now stable. I've removed the temporary dependency and property, and the final build was successful, indicating they are no longer needed. I am now finished with the task.

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






Play wright



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






Retour

La suite

