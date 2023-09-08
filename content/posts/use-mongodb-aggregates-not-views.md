+++
author = "Daniel Cefram Ramirez"
tags = ["dev"]
date = 2023-08-24T23:23:11+08:00
title = "Use MongoDB Aggregates, Not Views"
description = "Views are just aggregates, but for APIs, it's often better to build aggregates from scratch"
type = "post"
draft = false

+++

This post was a long time coming, I just stumbled upon this one in one of my Zettels. On one of the olden projects that I used to be part of, we had an issue that an API endpoint that joined multiple collections together was taking seconds to respond.

## The Problem

We had an API endpoint that would list down a *folder*'s contents. The folder can contain items from three different collections, we'll name them as *images*, *texts*, and *videos* just so that I don't reveal a lot about what the project was about.

In a relational database, the joins would've been easy and efficient. In MongoDB, you have to be careful about where you place the *filters*.

We initially created a `view` in MongoDB to see the big picture, where we could see all the items per folder. The issue though is that when we started building the API, we queried against this `view`. Why is it an issue?

Well, remember that I mentioned that the view was made so that we can see the big picture, which means that there were no filters at all. So it's just a bunch of lookups, which looked something like this:

```js
db.folders.aggregate([
  {
    $lookup: {
      from: "images",
      localField: "_id",
      foreignField: "folderId",
      as: "images",
    }
  },
  {
    $lookup: {
      from: "texts",
      localField: "_id",
      foreignField: "folderId",
      as: "texts",
    }
  },
  {
    $lookup: {
      from: "videos",
      localField: "_id",
      foreignField: "folderId",
      as: "videos",
    }
  },

  // combine the three collectionsinto one array
  {
    $addFields: {
      items: {
        $concatArrays: ["$images", "$texts", "$videos"],
      },
    }
  }
  // The succeeding is to move the items array contents upwards
  {
    $project: { items: 1 },
  },
  {
    $unwind: "$items",
  },
  {
    $replaceRoot: {
      newRoot: "$items",
    },
  },
])
```

In our new API endpoint, we simply added the filters on the view:
```js
// Using mongodb
const items = await FolderView.find({
  folderId: someFolderId,
  owner: someOwnerId,
});
```

Seems simple enough, right?

The issue is that `views` are computed on-demand, and is built first before we can query against it. This means that we are processing all of the available data even though we already knew beforehand that we only care for the items that belong to a specific folder, and a specific owner.

![MongoDB Views Diagram](https://storage.googleapis.com/rmrz-blog.appspot.com/mongodb-views-filter-diagram.png)

### How did we pinpoint the bottleneck?

As with all optimization efforts, we had to benchmark where the bottleneck was. One way is to add timers all over, and the other, which we did was to use existing tools that we had in production to analyze the API request.

One of the best tool that I used to do this was [Datadog](https://www.datadoghq.com/), as it accurately pinpointed us to the culprit:

![Before](https://storage.googleapis.com/rmrz-blog.appspot.com/mongodb-aggregates-before.png)

This is how we figured out that our use of the `view` is a big contributor, 85% in fact, to the latency of the API endpoint.
## The Solution

To test out our theory that doing the filters as the first step of the aggregate would help, we decided to recreate the whole aggregate from the view into our API endpoint. So instead of using `folders_view`, we used the exact same aggregates that we used to build the view, but added an extra step as the first step of the aggregate:

```js
db.folders.aggregate([
  {
    $match: {
      _id: mongoose.Types.ObjectId(someFolderId),
      owner: mongoose.Types.ObjectId(someOwnerId),
    },
  }
  // the rest is the same as the aggregate above
])
```

The idea here is that we only get the specific folder first, and then the rest of the step would only lookup against 1 folder, rather than looking up all items from all folders and bucketing them according to their `folderId`.

![MongoDB Aggregates Diagram](https://storage.googleapis.com/rmrz-blog.appspot.com/mongodb-aggregates-filter-diagram.png)

Did this work? Of course! It was a significant performance boost:

![After](https://storage.googleapis.com/rmrz-blog.appspot.com/mongodb-aggregates-after.png)

From **283ms**, we went down to **2.28ms! That's a 100x performance improvement!** But obviously, the delta would depend on how much data we already have in the database. If we just had a few items, the difference would be insignificant.

## Conclusion

Although this resulted in a definite performance boost, the caveat is that we now have a duplicate aggregate where we need to remember to update both the view and the API's aggregate whenever we decide to change the steps of the aggregate, in case we want to still maintain the view for backroom activities.

But this is a small price to pay for the 100x performance improvement, which can easily change into a larger delta once more users add more data to the database.

However, if you did anticipate doing a lot of joins beforehand, I suggest just going with a relational database, something that was designed with that in mind from the start.