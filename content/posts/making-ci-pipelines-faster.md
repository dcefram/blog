+++
author = "Daniel Cefram Ramirez"
tags = ["dev"]
date = 2023-11-04T10:37:19+08:00
title = "Making CI Pipelines Fast"
description = "We had pipelines that ran for almost an hour."
type = "post"
draft = true
+++

Background

The project I am involved in at [Inspectorio](https://inspectorio.com) had a pretty standard process, where each merge request would run unit tests before we could merge it.

```mermaid
flowchart LR
    A(Push changes to feature branch) --> B(Run CI pipeline)
    B --> C(Merge changes)
```

# The Problem

Our issue is that our pipelines take almost **an hour**, and the main culprit is our unit tests.

On the positive side, this meant that we do have a lot of unit tests which is directly related to the size of our project.

On the other hand, this would mean that the time our pipeline would run would increase as the codebase size increases.

What this meant is that for every change made in our feature branch, even if the change is minor (for example: syntax changes based on code review comments), we would need to wait for almost an hour before we can merge the changes.

This is painful as there were "old" flakey unit tests that for some reason, are hard to clean up. When those tests failed, it meant that we needed to retry the pipeline and wait for another hour before we could merge.

With that, we embarked on an effort to figure out how to speed up our pipelines without sacrificing the value we get from our unit tests.

# Making pipelines fast again

As we use Jest as our testing framework, we first did the obvious:

- Upgrade Jest to the latest version
- Evaluate alternatives like Vitest

The first one was pretty straightforward, as it was as simple as updating and version locking it to the latest available version. There were no breaking changes, or at least, we did not use any feature that was drastically modified.

However, our unit test steps still took almost an hour to finish. It's good we updated to the latest Jest, but it did not solve the problem we were trying to solve.

The second one, evaluating Vitest, was a little harder to do. Although doing simple benchmarks wasn't hard, it was migrating our 900+ test cases to use Vitest that was the main blocker. We couldn't simply change jest to vitest and call it a day, as we made heavy use of Jest's mocks. It was simply not economically viable to pursue Vitest.

Thankfully, Minh, one of my fellow developer, found two possible paths to optimize our pipelines:

- Jest's `--findRelatedTests`
- Caching the project's dependencies

Let's go over the two in more details.

## Jest's --findRelatedTests

