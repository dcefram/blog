+++
author = "Daniel Cefram Ramirez"
tags = ["dev"]
date = 2023-11-04T10:37:19+08:00
title = "Making CI Pipelines Fast"
description = "We had pipelines that ran for almost an hour."
type = "post"
draft = true
+++

# Background

The project I am involved in at [Inspectorio](https://inspectorio.com) had a pretty standard process, where we had pipelines that ran unit tests before the Docker image was built, which would then allow the developer to manually trigger the deployment to an isolated test environment. This process is done on each feature branch that the team is working on.

> Aside: There's another topic that I'd like to explore a little more, which is extensively using Feature Flags instead of deploying separate feature branch test environments. This is an approach that we used extensively at the [company I previously worked at](https://www.vian.ai/), however, I did experience firsthand some of the *risks* it does carry. So properly evaluating if it's the right approach for the current project with the team is a must. Oh, we used [ConfigCat](https://configcat.com/) there, and it's a tool that I can always recommend when looking for off-the-shelf Feature Flag service.

The flow is pretty straightforward:

```mermaid
flowchart LR
    A(Push changes to feature branch) --> B(Run CI pipeline)
    B --> C(Deploy to feature branch test environment)
```
For any issues or change requests made after testing out the feature branch, we would need to go through this same flow.

# The Problem

Our issue is that our pipelines take almost **an hour**, and the main culprit is our unit tests.

On the positive side, this meant that we do have a lot of unit tests which is directly related to the size of our project. 

On the other hand, this would also mean that the time our pipeline would run would increase as the codebase size increases.

What this meant is that for every change made in our feature branch, we had to wait for almost an hour before the relevant people would be able to verify if the change made satisfied their requirements.

This also meant that even for minor changes (example: syntax changes based on code review comments) that do not need additional verification would still need to go through the hour-long pipeline before we could even trigger the merge.

With that, we embarked on an effort to figure out how to speed up our pipelines without sacrificing the value we get from our unit tests.

# Make pipelines fast again

Without sacrificing tests, we tried to look for ways to get our pipelines faster.

