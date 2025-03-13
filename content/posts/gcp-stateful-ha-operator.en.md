---
title: Improve your Statefulsets reliability on GCP with the GKE Stateful HA Operator
date: 2025-04-01 08:00:00
images: ["/assets/images/2025/04/marc-pell-QA2rCdHbfpI-unsplash.webp"]
featuredImagePreview: /assets/images/2025/04/marc-pell-QA2rCdHbfpI-unsplash.webp
featuredImage: /assets/images/2025/04/marc-pell-QA2rCdHbfpI-unsplash.webp
og_image: /assets/images/2025/04/marc-pell-QA2rCdHbfpI-unsplash.webp 
tags:
  - gcp
  - kubernetes
  - cloud
---
{{< style "text-align:center;" >}}
Photo by <a href="https://unsplash.com/@blinky264?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Marc Pell</a> on <a href="https://unsplash.com/photos/a-red-and-white-coffee-cup-sitting-on-top-of-a-wooden-table-QA2rCdHbfpI?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
{{< /style >}}      


Most of the workloads we usually deploy [on Kubernetes are deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/). 
They dynamically manage Pods & Replicaset.

However, it may be be useful to manually handle the identity of the Pods and their scalability. For instance, if we want to install a distributed database such as MongoDB on top of Kubernetes, it would be mandatory to manually set the names to set up the cluster and its discovery.

For that purpose, we may use [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/).

When comparing the two, it is important to note that Deployments are designed to manage and host stateless applications, while StatefulSets are specifically tailored for stateful applications.

Now, imagine you sat up a single-replica application which use a persistent disk as a storage. How to recover from failures and especially node crashes?

Google have brought in their Kubernetes stack a new Operator: [The Stateful HA Operator](https://cloud.google.com/kubernetes-engine/docs/how-to/stateful-ha). 

From my perspective, it prevents setting up a cluster, using a single-replica configuration and let Kubernetes manage the failover in two ways: using the statefulset restart using liveness probes, and using this operator. To some extent, it helped me simplify the setup - _Yes, I can mix Kubernetes and simplification in the same sentence_.

Unfortunately this features comes with some restrictions:
- You must use [Compute Engine persistent disk CSI Drive](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/gce-pd-csi-driver) with a [regional storage class (e.g., ``standard-rwo-regional``)](https://cloud.google.com/kubernetes-engine/docs/concepts/persistent-volumes).
- This disk will only be available in up to 2 zones. You can not use it if you want to have a 3-zone setup for your service.
- During the failover, the application would be unavailable. If your [NFR](https://en.wikipedia.org/wiki/Non-functional_requirement) brought a [RTO](https://en.wikipedia.org/wiki/RTO) 0, this setup would not be compatible with.

I will then introduce how to put it in place.

## Enabling the Addon

First, enable the addon:

```bash
gcloud container clusters update gke-cluster --region MY_REGION --project MY_GCP_PROJECT --update-addons=StatefulHA=ENABLED
``` 

For more information, you can browse [the documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/stateful-ha).

## Activation

You can now set up this Kubernetes object 

```yaml
kind: HighAvailabilityApplication
apiVersion: ha.gke.io/v1
metadata:
  name: APP_NAME
  namespace: APP_NAMESPACE
spec:
  resourceSelection:
    resourceKind: StatefulSet
  policy:
    storageSettings:
      requireRegionalStorage: true
    failoverSettings:
      forceDeleteStrategy: AfterNodeUnreachable
      afterNodeUnreachable:
        afterNodeUnreachableSeconds: 20
```

And after applying it, we can get the following events:


```bash
1s          Warning   NodeNotReady                     pod/stateful-service-ha-stateful-operator-0                                                       Node is not ready
0s          Normal    TaintManagerEviction             pod/stateful-service-ha-stateful-operator-0                                                       Marking for deletion Pod namespace/stateful-service-ha-stateful-operator-0
0s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Triggering failover for pod stateful-service-ha-stateful-operator-0
0s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Triggering failover for pod stateful-service-ha-stateful-operator-0
0s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Triggering failover for pod stateful-service-ha-stateful-operator-0
0s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Triggering failover for pod stateful-service-ha-stateful-operator-0
0s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Failover for pod stateful-service-ha-stateful-operator-0 successful
1s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Triggering failover for pod stateful-service-ha-stateful-operator-0
0s          Normal    Scheduled                         pod/stateful-service-ha-stateful-operator-0                                                       Successfully assigned namespace/stateful-service-ha-stateful-operator-0 to gke-gke-cluster-dev-node-pool20250114-5e2dc459-pafo
0s          Normal    SuccessfulCreate                  statefulset/stateful-service-ha-stateful-operator                                                 create Pod stateful-service-ha-stateful-operator-0 in StatefulSet stateful-service-ha-stateful-operator successful
0s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Triggering failover for pod stateful-service-ha-stateful-operator-0
0s          Normal    SuccessfulAttachVolume            pod/stateful-service-ha-stateful-operator-0                                                       AttachVolume.Attach succeeded for volume "pvc-8839935b-6637-4f70-b5b8-17e2bbf31b04"
0s          Normal    Pulling                           pod/stateful-service-ha-stateful-operator-0                                                       Pulling image "DOCKER_IMAGE"
0s          Normal    Pulled                            pod/stateful-service-ha-stateful-operator-0                                                       Successfully pulled image "DOCKER_IMAGE" in 694ms (694ms including waiting). Image size: XXXX bytes.
0s          Normal    Created                           pod/stateful-service-ha-stateful-operator-0                                                       Created container stateful-service-ha-stateful-operator
0s          Normal    Started                           pod/stateful-service-ha-stateful-operator-0                                                       Started container stateful-service-ha-stateful-operator
0s          Normal    SyncLoadBalancerSuccessful        service/stateful-service-ha-stateful-operator                                                     Successfully ensured IPv4 External LoadBalancer resources
```

We now have the ``HighAvailabilityApplication`` object:

```bash
$ kubectl get highavailabilityapplications
NAME           PROTECTED
stateful-service-ha-stateful-operator        True
```

The description would be:

```bash
 kubectl describe highavailabilityapplications/stateful-service-ha-stateful-operator
Name:         stateful-service-ha-stateful-operator
Namespace:    namespace
Annotations:  meta.helm.sh/release-name: release
              meta.helm.sh/release-namespace: namespace
API Version:  ha.gke.io/v1
Kind:         HighAvailabilityApplication
Metadata:
  Creation Timestamp:  XXXXX
  Generation:          1
  Resource Version:    70249501
  UID:                 UUID
Spec:
  Policy:
    Failover Settings:
      After Node Unreachable:
        After Node Unreachable Seconds:  20
      Force Delete Strategy:             AfterNodeUnreachable
    Storage Settings:
      Require Regional Storage:  true
  Resource Selection:
    Resource Kind:  StatefulSet
Status:
  Conditions:
    Last Transition Time:  2025-03-12T21:57:57Z
    Message:               Application is protected
    Observed Generation:   1
    Reason:                ApplicationProtected
    Status:                True
    Type:                  Protected
Events:                    <none>
```


## Conclusion
The Google HA Operator is a good alternative to simplify your architecture, avoiding the need to create a full cluster (e.g., a database cluster) on top of Google Kubernetes Engine. Unfortunately, as always, these technologies come with constraints: the availability of the storage and the unavailability of the service during the failover.