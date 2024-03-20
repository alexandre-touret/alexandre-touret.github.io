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

{{< admonition note "Acknowledgement" true >}}
I would like to thank my colleagues [Max Beckers](https://www.linkedin.com/in/maximilianbeckers/), [David Pequegnot](https://www.linkedin.com/in/davidpequegnot/) & [Peter Steiner](https://www.linkedin.com/in/petersteiner/) for reviewing my article and giving their advices, useful links & tips.
{{< /admonition >}}

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
We often forget that database platforms provides valuable tools to analyse your queries. 
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

In this example, we will look into a ``1-N`` relation:

```java
@Entity
public class Store{
[...]
    @OneToMany(fetch = FetchType.EAGER,mappedBy = "store")
    private List<Book> books;
[...]
```

```java
@Entity
public class Book {
[...]
    @ManyToOne(targetEntity = Store.class)
    private Store store;
[...]    
```

If you remember well, this relation is fetched in a EAGER way.
So, when I try to get all the stores using a ``findAll()`` method

```java
public List<Store> findAllStores() {
    return StreamSupport.stream(storeRepository.findAll().spliterator(), false).toList();
}
```

Hibernate will query the database in this way:
* 1 query to select the main entity
* N queries for the entities linked by  the jointure

In our case we can see the following queries in the logs:

```shell
Hibernate: select s1_0.id,s1_0.name from store s1_0
Hibernate: select b1_0.store_id,b1_0.id,b1_0.description,b1_0.isbn_10,b1_0.isbn_13,b1_0.medium_image_url,b1_0.nb_of_pages,b1_0.price,b1_0.rank,b1_0.small_image_url,b1_0.title,b1_0.year_of_publication from book b1_0 where b1_0.store_id=?
Hibernate: select a1_0.books_id,a1_1.id,a1_1.firstname,a1_1.lastname,a1_1.public_id from book_authors a1_0 join author a1_1 on a1_1.id=a1_0.authors_id where a1_0.books_id=?
Hibernate: select a1_0.books_id,a1_1.id,a1_1.firstname,a1_1.lastname,a1_1.public_id from book_authors a1_0 join author a1_1 on a1_1.id=a1_0.authors_id where a1_0.books_id=?
Hibernate: select a1_0.books_id,a1_1.id,a1_1.firstname,a1_1.lastname,a1_1.public_id from book_authors a1_0 join author a1_1 on a1_1.id=a1_0.authors_id where a1_0.books_id=?
Hibernate: select a1_0.books_id,a1_1.id,a1_1.firstname,a1_1.lastname,a1_1.public_id from book_authors a1_0 join author a1_1 on a1_1.id=a1_0.authors_id where a1_0.books_id=?
[...]
```

It's unfortunately not finished, 

Imagine now, your book entity is related to another one in a EAGER way.

```java
@ManyToMany(fetch = FetchType.EAGER)
private List<Author> authors;
```

You will execute then another SQL queries.

For instance, in this case:

```jshelllanguage
Hibernate: select b1_0.authors_id,b1_1.id,b1_1.description,b1_1.isbn_10,b1_1.isbn_13,b1_1.medium_image_url,b1_1.nb_of_pages,b1_1.price,b1_1.rank,b1_1.small_image_url,s1_0.id,s1_0.name,b1_1.title,b1_1.year_of_publication from book_authors b1_0 join book b1_1 on b1_1.id=b1_0.books_id left join store s1_0 on s1_0.id=b1_1.store_id where b1_0.authors_id=?
```

{{< admonition tip "To sum up" true >}}
At the same way SQL jointures are really time-consuming, the way you can link entities may strongly impact the performance of your queries in either memory or while running SQL queries.   
{{< /admonition >}}

## Control the number of EAGER/SELECT relations underlying queries using ``@BatchSize``
We can easily reduce the number of SELECT queries while fetching another entities with the ``@BatchSize`` annotation

```java
@Entity
public class Store{
[...]
    @OneToMany(fetch = FetchType.EAGER,mappedBy = "store")
    @BatchSize(size = 5)
    private List<Book> books;
[...]
```

TODO LOGS

### Use a dedicated entity graph
If you are still struggling with the way Hibernate loads your Entity graph, you can also try to specify the graph of entities to load by yourself.
It could be really useful if you want to avoid to retrieve specific useless attributes which make your queries really slow.

[JPA 2.1 has introduced this feature](https://jakarta.ee/learn/docs/jakartaee-tutorial/current/persist/persistence-entitygraphs/persistence-entitygraphs.html).

Let's go back to our application.
Imagine that in one use case, when we fetch a list of books, we don't need the list of authors.
Using this API we can avoid fetching it in this way

TODO CODE

### Create a dedicated entity to reduce the number of attributes

We often forget that we don't need to map all the columns in an entity!
For instance, if your table has 30 columns and you only need 10 in your use case, why querying, fetching and storing in memory all of these data?

That's why I usually recommend to have, when it's relevant, a dedicated entity for specific use cases. 
It could be lighter than the _regular_ one and enhance the performances of your application.

For instance

TODO CODE

{{< admonition warning "Think about data consistency" true >}}
Think about the whole data consistency or your data stored in the database!
Be aware about it when you omit specific jointures or columns.
{{< /admonition >}}

### Use JOIN FETCH in your queries

Now one another strategy is to _manually_ control the jointures and how different entities will be fetched by your queries.
To do that, you can use the ``JOIN FETCH`` instruction:

For instance:

In this way you can shrink the number of queries done from N+1 to only one.
However, you **MUST** check and measure if it's worth it. 
Sometimes, this kind of query can be more time-consuming in either database or in the JVM than several small ones. 

### Use a DTO or a tuple {#dto}

Imagine we have a screen with of list of data coming from several entities. 
Instead of fetching all of these, and struggling with fetching strategies, we can also run [DTO (or tuple) projections](https://thorben-janssen.com/dto-projections/).

In this way, you can select all (and only) the data you need with only ONE query.
To get your code even clearer, you can also use [records](https://docs.oracle.com/javase/specs/jls/se21/html/jls-8.html#jls-8.10) to make your data immutable. 

TODO CODE

### Avoid transactions while reading our database with the annotation @Transactional(readonly=true) 

One thing we often (again) remember: read-only database operations don't need transactions!
In the good old days, it was also a good practice to set up two different datasources for the persistence context: one read-only avoiding database transactions and one which allowed it.
Anyway, you can now declare your service only read data and doesn't need to open a database transaction using the ``@Transactional(readonly=true) `` annotation.

For instance:

TODO CODE

By the way, this feature goes well with using dedicated entities as mentioned above.
For a specific search/query use case, you can use both of them to make your code even more straightforward.

### Pagination w/ Spring Data
When you browse a large amount of data, it's usually a good practice to paginate results.
The good news when you use Spring Data, is you have all the features included by default.
The bad news is you may have time/cpu-consuming queries run for calculating the number of elements, pages and the position of the current result's page.

If getting the number of pages is useless for you, you can switch to [Slices](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/domain/Slice.html) instead of [Pages](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/domain/Page.html).

When using this feature, you will only know if there is another slice available onwards or backwards through the methods [``hasNext()``](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/domain/Slice.html#hasNext()) and [``hasPrevious()``](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/domain/Slice.html#hasNext()).

You will find below good links talking about it on StackOverflow:

* https://stackoverflow.com/questions/49918979/page-vs-slice-when-to-use-which
* https://stackoverflow.com/questions/12644749/way-to-disable-count-query-from-pagerequest-for-getting-total-pages


Now, let's go back to our example and see how it could be implemented:

TODO CODE

### Caching specific data
You may use and query specific which is not daily (or monthly) updated. For instance, the department, country tables.
In this case, you may want to cache them in the memory of your application (i.e., [Second-Level cache](https://jakarta.ee/learn/docs/jakartaee-tutorial/current/persist/persistence-cache/persistence-cache.html).

With [JPA you can easily cache specific entities](https://jakarta.ee/learn/docs/jakartaee-tutorial/current/persist/persistence-cache/persistence-cache.html) using the [``@Cacheable`` annotation](https://jakartaee.github.io/persistence/latest/api/jakarta.persistence/jakarta/persistence/Cacheable.html).

For instance:

TODO CODE

### In case of emergency: break the glass! {#native}
OK, none of all the tips exposed in this article worked?
Now, remember that, under the hood you use a database.
It contains many tools which may run your queries at lightning speed.

You can use [SQL views](https://www.postgresql.org/docs/current/rules-views.html) or [SQL materialized views](https://www.postgresql.org/docs/current/rules-materializedviews.html) to specify the data you want to fetch.
In addition, feel free to use [Native queries](https://jakartaee.github.io/persistence/latest/api/jakarta.persistence/jakarta/persistence/EntityManager.html#createNativeQuery(java.lang.String)) , [Named Native Queries](https://jakartaee.github.io/persistence/latest/api/jakarta.persistence/jakarta/persistence/NamedNativeQuery.html) or [Stored Procedure Queries](https://jakartaee.github.io/persistence/latest/api/jakarta.persistence/jakarta/persistence/StoredProcedureQuery.html)  (**ONLY FOR**) for the 10-20%  of your most time-consuming queries.

At the end of the day, you won't be faster using an [ORM](https://en.wikipedia.org/wiki/Object%E2%80%93relational_mapping)!

For instance, when you use a SQL view, you can easily run either a native query or fetch a DTO or a tuple (see [above](#dto)):

Here is an example to illustrate it:

TODO CODE

## Links
To write this article, I dug in many documentations and blog posts, here is a bunch of useful resources I stumbled upon:

* https://blog.ippon.tech/boost-the-performance-of-your-spring-data-jpa-application
* https://thorben-janssen.com
* https://vladmihalcea.com

## Conclusion

If you reached this last chapter, you would see there are plenty of solutions to fix ORM/JPA performance issues.
This first thing to put in place, is the whole observability stack: through logging, traces or prometheus metrics you will get deep insights of your application. 
Check also your database to see if you have a "full table scan" when you run specific SQL queries. It will help you find where is the bottleneck.

Last but not least, don't try to apply premature optimisations (e.g., [native queries](#native)) first! 
[Premature optimisation is the root of all evil!](https://www.laws-of-software.com/laws/knuth/)
