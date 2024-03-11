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

Photo de <a href="https://unsplash.com/fr/@tofi?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Tobias Fischer</a> sur <a href="https://unsplash.com/fr/photos/photo-dun-batiment-de-5-etages-pour-la-bibliotheque-PkbZahEG2Ng?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>

{{< /style >}}

Start logging all the SQL queries & monitoring your SQL queries on your database 
Try to know if the issue is due to a database performance issue or a java/memory issue (it could be)

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

@Cacheable

Last but not least use a good old SQL query

## Conclusion
https://blog.ippon.tech/boost-the-performance-of-your-spring-data-jpa-application


