---
marp: true
---

<!-- _class: invert -->

# Kubernetes

* Kubernetes, also known as K8s, is an open-source system for automating
  deployment, scaling, and management of containerized applications.

* It groups containers that make up an application into logical units for easy
  management and discovery. Kubernetes builds upon 15 years of experience of
  running production workloads at Google, combined with best-of-breed ideas and
  practices from the community.

---

## Kubernetes Events

* Kubernetes events are a resource type in Kubernetes.

* They are automatically generated when other resources have state changes,
  errors, or other messages that should be broadcast to the system.

* They are an valuable resource for debugging issues in your cluster.
  
---

## Kubernetes Events (II)

* For the most part, events are easy to see when you are trying to debug issues
  for a specific resource. Using kubectl describe pod «<podname>» for example
  will show events at the end of the output for the pod. Only events that have
  occurred relatively recently (within a few hours) will appear.

* Another way to view events is to grab the events from the resources API
  directly. This can be done using kubectl get events, which displays recent
  events for all resources in the system.

---

## Kubernetes Events (III)

* Some useful examples might be: 0 Warnings only kubectl get events
  --field—selector type=Warning

* No pod events

```
kubectl get events --field—selector involvedObject.kind!=Pod 
```

* Events for a single node named "minikube"

```
kubectl get events --field—selector \
  involvedObj ect. kind=Node, \
  involvedObject.name= 
```

---

## Kubernetes Enhancements Process

* The Kubernetes Enhancements Process (KEP) is one of the most important engines
  driving the project's continued evolution and growth.

* During the 1.21 release cycle, Kubernetes Special Interest Groups (SIGs)
  submitted 51 Kubernetes Enhancements Proposals (KEPs) for inclusion an
  increase compared to the last few release cycles.

* KEPs are the primary artefacts of the Enhancements process. They're design
  documents, inspired by the Python Enhancements Proposal and Rust RFCs, that
  enable SIGs to "propose, communicate, and coordinate" nontrivial changes, such
  as new features, deprecations, or policies with broad impact to the project.

---

## The Receipts process

* Until recently, the Enhancements team has shepherded KEPs through the release
  cycle by relying on a process that requires several manual updates to
  spreadsheets and repetitive outreach to SIGs.

* This method has worked, but it has involved friction and toil.

* The receipts process, a Git-based artefact and tooling that supports automated
  Enhancement collection, validation, and tracking processes for Kubernetes
  releases.

* Through this method, SIGs will now opt in to a release using a specified file
  format—the receipt—that contains metadata about the KEP being enrolled.

* After a SIG opts into the release, all tracking will occur via Git commits
  rather than via issue comments, PR references, and other non-auditable
  mechanisms.

---

## Streamlining The Enhancements Process

* Introduced in 2020, the Production Readiness Review (PRR) is an approval
  process for KEPs aimed at ensuring that features for Kubernetes can be safely
  operated in production environments.

* During the 1.21 release cycle, PRRs became a requirement for KEPs.

* During the 1.21 release cycle, the Enhancements subproject received feedback
  that the KEPs process was getting too complex.

* In addition to diagramming the current process, subproject members members
  started discussions on how to resolve notorious pain points and suggested a
  glossary to clarify ambiguous terminology and started establishing a lighter
  review process for enhancements that do not impact releases. This work is
  ongoing.

---

## Kubectl Get Events

* *kubectl get events* has some limitations end exposes several pain points; so,
  it a KEP was initiated to resolve some or most of them.

* This KEP proposed a new command kubectl events which will help address the
  existing issues and enhance the events functionality to accommodate more
  features.

* For example: Any modification to --watch functionality for events will also
  change the --watch for kubectl get since the events is dependent of kubectl
  get.

---

## KEP Motivation

* A separate sub-command for events under kubectl which can help with long
  standing issues: Some of these issues that be addressed with the above change
  are:

* Users would like to

  * ... filter events types

  * ... see all changes to the an object

  * ... watch an object until its deletion

  * ... change sorting order

  * ... see a timeline/stream of events
  
---

## Limitations of the Existing Design

* Most of the issues discussed require extending the functionality of kubectl
  get events.

* This would result in kubectl get command having a different set of
  functionality based on the resource it is working with.

* To avoid per-resource functionality, it's best to introduce a new command
  which will be similar to kubectl get in functionality, but additionally will
  provide all of the extra functionality.

---

## KEP Design Details (I)

* The design calls for the addition of several flags that would act as filtering
  mechanisms for events and would work in tandem with the existing --watch flag:
  
  * Add a new --watch-event=[] flag that allows users to subscribe to particular
    events, filtering out any other event kind.

  * Add a new --watch-until=EventType flag that would cause the --watch flag to
    behave as normal, but would exit the command as soon as the specified event
    type is received.

---

## KEP Design Details (II)

* The design calls for the addition of several flags ...

  * Add a new - watch-for=pod/bar flag that would filter events to only display
    those pertaining to the specified resource. A non-existent resource would
    cause an error. This flag could further be used with the
    --watch-until=EventType flag to watch events for the resource specified, and
    then exit as soon as the specified EventType is seen for that particular
    resource.

  * Add a new --watch-until-exists=pod/bar flag that outputs events as usual,
    but exits as soon as the specified resource exists. This flag would employ
    the functionality introduced in the wait command.

---

<!-- _class: invert -->

## kubectl alpha events DEMO

* Instead of kubectl events we call for now kubectl alpha events.

* Special preparations in or for the cluster are not needed for it.

* As it is in alpha gate, we only look at sorting before and after ...
