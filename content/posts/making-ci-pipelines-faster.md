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

The project I am involved in at [Inspectorio](https://inspectorio.com) had a pretty standard process, where each merge request would run unit tests before the MR could be merged. Merging would be blocked until the pipeline passes.

```mermaid
flowchart LR
    A(Push changes to feature branch) --> B(Run CI pipeline)
    B --> C(Merge changes)
```

# The Problem

Our issue is that our pipelines take almost **an hour**, and the main culprit is our unit tests.

On the positive side, this meant that we do have a lot of unit tests which is directly related to the size of our project.

On the other hand, this would also mean that the time our pipeline would run would increase as the codebase size increases.

What this meant is that for every change made in our feature branch, even if the change is minor (for example: syntax changes based on code review comments), we would need to wait for almost an hour before we can merge the changes.

This is especially painful as there were "old" flakey unit tests that for some reason, are quite hard to clean up. When those tests failed, it meant that we needed to retry the pipeline and wait for another hour before we could merge.

With that, we embarked on an effort to figure out how to speed up our pipelines without sacrificing the value we get from our unit tests.
# Make pipelines fast again

Without sacrificing tests, we tried to look for ways to get our pipelines faster.

