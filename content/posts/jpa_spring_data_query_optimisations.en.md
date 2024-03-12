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

Most of the Java developers I know don't really know what is under the hood of Spring Data and JPA.
In my opinion, it's mainly due to all the features provided by these specifications and frameworks. 
They bring a lot of simplicity which help you forget SQL queries syntax.

Unfortunately, when your stored data is coming to grow, querying against your database could be difficult. 
The different queries you can make in your Java application tend to take a lot of time and eventually break your SLOs.

In this article, I tried to write down a bunch of tips & tricks to tackle this issue.
Even if some are related to Spring Data, I think you can use most of them if you use a JPA in a standard way.
You will see that even if we can consider using JPA easy at first glance, it can bring a lot of complexity.

Database index,...


Eager/lazy relations
@BatchSize

N+1 issue
https://www.baeldung.com/cs/orm-n-plus-one-select-problem

Use a sql view

Use a dedicated entity graph

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


