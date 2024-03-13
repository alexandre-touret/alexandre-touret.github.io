---
title: "Tips & tricks for optimizing JPA queries"
date: 2024-03-24T06:00:43+01:00
draft: true
  
featuredImagePreview: "/assets/images/2024/03/tobias-fischer-PkbZahEG2Ng-unsplash.webp"
featuredImage: "/assets/images/2024/03/tobias-fischer-PkbZahEG2Ng-unsplash.webp"
images: ["/assets/images/2024/03/tobias-fischer-PkbZahEG2Ng-unsplash.webp"]
tags:
  - Java
  - JPA
  - Spring_Data

---

{{< style "text-align:center;" >}}
_Picture of [Tobias Fischer](https://unsplash.com/fr/@tofi?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)_

{{< /style >}}

Most of the Java developers I know don't really know what is under the hood of [Spring Data](https://spring.io/projects/spring-data) and [Java Persistence API (JPA)](https://docs.oracle.com/javaee/7/tutorial/persistence-intro.htm).
In my opinion, it's mainly due to all the features provided by these specifications and frameworks. 
They bring a lot of simplicity which make you forget SQL queries syntax.

Unfortunately, when your stored data is coming to grow, querying against your database could be difficult. 
The different queries you can indeed make your Java applications being slow and potentially break your SLOs.

In this article, I tried to write down a bunch of tips & tricks to tackle this issue.
Even if some are related to [Spring Data](https://spring.io/projects/spring-data), I think you can use most of them if you use a JPA in a standard way.

You will see that even if we can consider using JPA easy at first glance, it can bring a lot of complexity.

## Observe your application
### Observe your persistence layer

First and foremost, you **MUST** trace and monitor your persistence layer.

If you use Hibernate (without Spring, Quarkus,...), you can get insights configuring the logger:

```xml
<logger name="org.hibernate.SQL">
     <level value="debug"/>
</logger>
```
If you use Spring (and JPA, Hibernate), you can also get them adding these configuration properties:

```ini
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
```
After getting all the queries and operations done by your persistence layer, you will be able to pinpoint which component is responsible for slowing down your queries: the database or your ORM. 

In the case of huge SQL queries, I usually execute them directly in SQL using the database tools to check if I have the same behaviour.

### Observe your database
We often forget that the database provides valuable tools to analyse your queries. 
Once you have pointed out the time/resource consuming queries, you must check if your database query is time-consuming because, for instance, does a full scan of your table.

To do that, you can check the SQL queries execution plan.

If you use [PostgreSQL (what else)](https://www.postgresql.org/), you can get these insights using the [``EXPLAIN``](https://www.postgresql.org/docs/current/sql-explain.html) command. 

## Checks your relations
Let's go back to our Java application.
One of the main points of interest of any JPA (and SQL) queries is how your entity is joined with others. 
Every jointure brings costs and complexity.

For JPA queries, you must check first if your relation between two objects should be either [``EAGER`` or ``LAZY``](https://docs.oracle.com/javaee/7/api/javax/persistence/FetchType.html).

You probably understood: there is no free lunch. 
You must measure first the JPA queries and mapping time-consumption and check which solution is the best.

By default, EAGER relations are set up for ``@ManyToOne`` and ``@OneToOne``. LAZY are for ``@OneToMany``. 
Most of the time, I keep using the default configuration. 

However, you must take care of the whole [entity graph](https://docs.oracle.com/javaee/7/tutorial/persistence-entitygraphs001.htm) loaded by your query.
Does your entity loaded by a ``@OneToOne`` relation loads also a ``@OneToMany`` relation in a ``EAGER`` way? 
It's the kind of question you will have to answer.

### The famous N+1 issue


### Use a dedicated entity graph
https://docs.oracle.com/javaee/7/tutorial/persistence-entitygraphs001.htm
### @BatchSize

### Using JOIN FETCH in your queries

Eager/lazy relations
@BatchSize


Use a sql view

Create a dedicated entity to reduce the number of attributes

Use a DTO or a tuple

use @Transactional(readonly=true) 

Pagination w/ Spring Data
Slice vs Page
https://stackoverflow.com/questions/49918979/page-vs-slice-when-to-use-which
https://stackoverflow.com/questions/12644749/way-to-disable-count-query-from-pagerequest-for-getting-total-pages

@Cacheable

Last but not least use a good old SQL query

## Conclusion
https://blog.ippon.tech/boost-the-performance-of-your-spring-data-jpa-application


