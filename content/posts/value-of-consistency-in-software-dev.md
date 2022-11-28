+++
author = "Daniel Cefram Ramirez"
tags = ["dev"]
date = 2022-06-12T00:08:40+08:00
description = "Why consistency is important "
draft = false
linktitle = ""
title = "The Value of Consistency in Software Development"
type = "post"
+++

Recently, I read the book [A Philosophy of Software Design](https://www.amazon.com/Philosophy-Software-Design-John-Ousterhout/dp/1732102201), and one of the key points that stuck with me is _Consistency_. I read the book at the right time as the company I'm working for was recently acquired. And one of the usual ceremonies during such transitions is the merging of teams, either merging whole teams or moving people around to different teams.

It means that we must discuss whatever process, conventions, and approaches would the team abide by, and set those in paper again. I'm pretty much open to suggestions that made sense, but since I was recently exposed to the book written by John Ousterhout, I made it a point that the codebase must be consistent.

We do understand that we must find a balance on this, wherein we do not want our project to end up as another legacy project, failing to adapt to changing trends, just for the sake of enforcing consistency within the project. This is the tricky part as one of the usual approaches is to _gradually modernize_ the codebase based on the files that new tickets would force the developers to touch.

Although this might work in the first glance, we cannot deny the possibility of some parts of the code that would not be touched for quite some time. Does that mean that we shouldn't update those to align with the new approach? Doesn't that mean that we're introducing inconsistencies?

Before we dig on this further, let's answer the question _"Is consistency really that important?"_

## Importance of consistency

In John's book, he tackles the issue of system complexity, and one of the points he made is how consistency aids the reduction of complexity.

> Consistency is a powerful tool for reducing the complexity of a system and making its behavior more obvious. If a system is consistent, it means that similar things are done in similar ways, and dissimilar things are done in different ways.
>
> Consistency creates cognitive leverage: once you have learned how something is done in one place, you can use that knowledge to immediately understand other places that use the same approach. If a system is not implemented in a consistent fashion, developers must learn about each situation separately. This will take more time.
>
> \- John Ousterhout, A Philosophy of Software Design

This makes a lot of sense if you ever experienced joining a project midway. Projects that have inconsistent approaches makes you think twice when implementing a new feature. You'd think: "Should I copy this convention, or this file's convention instead?". It adds up cognitive load for something that might be trivial.

When you've been in this field for quite some time already, you would usually try to figure out patterns in the code and use those patterns as basis when trying to understand the rest of the code base. With an inconsistent codebase, this makes it hard, even impossible, to do. Debugging parts of the code that you did not implement would be harder than it should be.

Imagine reading up a recipe that has a mixture of imperial and metric system for measurements. You're bound to make a mistake following that recipe.

![grams-or-ounces](https://firebasestorage.googleapis.com/v0/b/rmrz-blog.appspot.com/o/grams-or-ounces.png?alt=media&token=0a26084f-5dc3-4ef3-a90a-7011e86ca0bf)

So how could we introduce improvements and at the same time, enforce consistency?

## Avoid "improvements" for the sake of _improvement._

Before we tackle some strategies to avoid ending up with an inconsistent codebase, let's first discuss why improvements is not always an _improvement_. I'm currently in web development, so that's what I'll mainly use to convey my point.

There are scenarios that a brand-new approach, tech, or framework seems to be very convincing that we tend to try to shove it to all our projects. But before we do that, we should step back and ask ourselves if it is worth pursuing.

As an example, if your project is currently using one of the popular CSS preprocessors out there, and suddenly CSS-in-JS made a splash that you have an itch to apply that in your project, I implore you to resist. Ask yourself what value would that bring to the table, and if the benefits would outweigh the tech debt that it would introduce.

> Don't change existing conventions. Resist the urge to "improve" on existing conventions. Having a "better idea" is not a sufficient excuse to introduce inconsistencies.
>
> \- John Ousterhout, A Philosophy of Software Design

![improvements](https://firebasestorage.googleapis.com/v0/b/rmrz-blog.appspot.com/o/Snippet%202022-06-15%20at%2000.09.38.png?alt=media&token=e36911d2-4e3c-46f5-af81-86e95ba25b00)

On the other hand, introducing absolute import paths support in webpack and implementing that to the codebase is mostly fine, as doing a grep or a "find-and-replace" for the whole codebase would work with minimal worry for regression issues.

## How to improve your project while avoiding inconsistencies

**Gradual migration.** Although we hit on this approach earlier as it is very susceptive to introducing inconsistencies in the codebase, we could still use this approach if, and only if, the team documents the proper agreed upon approach that would supersede whatever approach is currently implemented in the project. The team should then make sure to gradually modify whatever code they modify to align with the agreed approach, while at the same time, ensuring that in "chore" or "maintenance" sprints would be used to migrate the codebase to the new approach in bulk.

It is also important that efforts related to the realignment of the code to the new agreed approach should be done in a separate commit even if in the same branch. Upon merging, it's best that it does not get included in the squash, as it might be valuable to preserve such a commit just in case a regression issue was introduced due to the realignment.

**Parallel migration.** Create new classes, components, or interfaces that align with the new convention. Once they're done and ready for use, commit a sprint to migrate the code to the new approach. This usually makes sense if we're migrating away from an underlying library to an alternative.

My experience with this is when we decided to move away from JSS to Emotion JS and Emotion's styled components. Since we already had a design system to follow, it wasn't hard to create a "next" version of the components while the project is still using the older components based on JSS. When the new components had feature parity with the JSS-based components, we simply modified our import statements. This worked well because we made it a point to retain the API signature of each component as much as possible.

## Conclusion

At the end of the day, striking a balance between enforcing consistency while not _blocking_ innovation is key. We should avoid our biases and see the issue on hand in a more pragmatic way. Remember, having a "better idea" is not a sufficient excuse to introduce inconsistencies.
