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

gcloud container clusters update gke-cluster --region MY_REGION --project MY_GCP_PROJECT --update-addons=StatefulHA=ENABLED

https://cloud.google.com/kubernetes-engine/docs/how-to/stateful-ha


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


```
kubectl get pods -o wide | grep stateful-service-ha
stateful-service-ha-stateful-operator-0              1/1     Running             0                  12m     XXX.XXX.XXX.XXX   gke-gke-cluster-dev-node-pool   <none>           <none>
```

```bash
1s          Warning   NodeNotReady                     pod/stateful-service-ha-stateful-operator-0                                                       Node is not ready
0s          Normal    TaintManagerEviction             pod/stateful-service-ha-stateful-operator-0                                                       Marking for deletion Pod tap2use/stateful-service-ha-stateful-operator-0
0s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Triggering failover for pod stateful-service-ha-stateful-operator-0
0s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Triggering failover for pod stateful-service-ha-stateful-operator-0
0s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Triggering failover for pod stateful-service-ha-stateful-operator-0
0s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Triggering failover for pod stateful-service-ha-stateful-operator-0
0s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Failover for pod stateful-service-ha-stateful-operator-0 successful
1s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Triggering failover for pod stateful-service-ha-stateful-operator-0
0s          Normal    Scheduled                         pod/stateful-service-ha-stateful-operator-0                                                       Successfully assigned tap2use/stateful-service-ha-stateful-operator-0 to gke-gke-cluster-dev-node-pool20250114-5e2dc459-pafo
0s          Normal    SuccessfulCreate                  statefulset/stateful-service-ha-stateful-operator                                                 create Pod stateful-service-ha-stateful-operator-0 in StatefulSet stateful-service-ha-stateful-operator successful
0s          Normal    PodFailoverAfterNodeUnreachable   highavailabilityapplication/stateful-service-ha-stateful-operator                                 Triggering failover for pod stateful-service-ha-stateful-operator-0
0s          Normal    SuccessfulAttachVolume            pod/stateful-service-ha-stateful-operator-0                                                       AttachVolume.Attach succeeded for volume "pvc-8839935b-6637-4f70-b5b8-17e2bbf31b04"
0s          Normal    Pulling                           pod/stateful-service-ha-stateful-operator-0                                                       Pulling image "europe-docker.pkg.dev/fra-t2u-gcp-sbx-dev/t2u-docker-registry-dev-testing/awl-u9-stateful-service:2.39.0"
0s          Normal    Pulled                            pod/stateful-service-ha-stateful-operator-0                                                       Successfully pulled image "europe-docker.pkg.dev/fra-t2u-gcp-sbx-dev/t2u-docker-registry-dev-testing/awl-u9-stateful-service:2.39.0" in 694ms (694ms including waiting). Image size: 303313012 bytes.
0s          Normal    Created                           pod/stateful-service-ha-stateful-operator-0                                                       Created container stateful-service-ha-stateful-operator
0s          Normal    Started                           pod/stateful-service-ha-stateful-operator-0                                                       Started container stateful-service-ha-stateful-operator
0s          Normal    SyncLoadBalancerSuccessful        service/stateful-service-ha-stateful-operator                                                     Successfully ensured IPv4 External LoadBalancer resources

```