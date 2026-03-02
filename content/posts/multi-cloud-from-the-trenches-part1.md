---
title: "Multi-Cloud from the Trenches: Part 1 - The Why and The What"
date: 2026-03-16 08:00:00
images: ["/assets/images/2026/03/joel-filipe-VuwAfoHpxgs-unsplash.webp"]
featuredImagePreview: /assets/images/2026/03/joel-filipe-VuwAfoHpxgs-unsplash.webp
featuredImage: /assets/images/2026/03/joel-filipe-VuwAfoHpxgs-unsplash.webp
lightgallery: true
og_image: /assets/images/2026/03/joel-filipe-VuwAfoHpxgs-unsplash.webp
tags:
  - Cloud
---


{{< style "text-align:center;" >}}
_Photo by <a href="https://unsplash.com/@joelfilip?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Joel Filipe</a> on <a href="https://unsplash.com/photos/low-angle-photo-of-30-st-mary-axe-VuwAfoHpxgs?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>_
      
{{< /style >}}      

For a couple of years, I have been regularly working on designing and implementing cloud-native landing zones on multiple cloud providers at once. 
When I started desigining such a platforms, I was a little bit scared. 
The theory was slighlty attractive: I could cherry pick the best services from each cloud provider to build the ultimate architecture. 
Nevertheless, I had expressed some reservations about operational worries : complexity, costs, observability, alerting and such like.

Why? The sad reality is actually that, beyond the commercial speeches, cloud platforms capabilities are not equals and they are not interchangeable. Then, the operational burden of managing multiple clouds is not linear. It may take you into a labyrinth of technical complexities where network latency, fragmented data and incompatible API threnten both your SLA and your peace of mind.

This article is the first part of a series that aims to share my experience and lessons learned from the trenches of multi-cloud. It will cover the "Why" and "What" of multi-cloud, exploring the motivations behind adopting such a strategy and defining what multi-cloud truly entails. Subsequent parts will delve into the "How," providing practical insights and strategies for successful multi-cloud implementations.

## Why


organization / partnersship / compliance

different products
