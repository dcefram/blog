+++
author = "Daniel Cefram Ramirez"
tags = ["JavaScript"]
date = 2017-02-25T05:50:12Z
description = ""
draft = false
slug = "object-assign-vs-json-parse"
title = "Using JSON parse and stringify to clone objects"
type = "post"

+++

[Immutability is important](http://stackoverflow.com/a/34385684). The stackoverflow article that I just linked would explain why immutability is important.

I am accustomed to using Immutable.js at work, but when I came across an ancient project that didn't make sense to add a new library just for using immutable objects, I had to resort to `Object.assign`.

But the problem with `Object.assign` though is that you cannot use it to modify deep properties.

Take this for example:
```javascript
const obj = {
  node: {
    id: 1,
    title: 'The quick brown fox',
    image: {
      original: '//some.url/to/original/image',
      cached: '//some.url/to/cached/image'
    }
  }
};

const updatedObj = Object.assign(
  {},
  obj,
  {
    node: { title: 'The quickest brown fox' }
  }
);
```

What we wanted was to update the title property of the node, but what we got was an object that only has `{ node : { title: 'The quickest brown fox' } }`. We failed to get all other properties of `obj`.

A workaround is to not pass `{ node : { title: 'The quickest brown fox' } }` in `Object.assign`'s last parameter, but rather do that only after the `Object.assign`:

```javascript
const obj = {
  node: {
    id: 1,
    title: 'The quick brown fox',
    image: {
      original: '//some.url/to/original/image',
      cached: '//some.url/to/cached/image'
    }
  }
};

const updatedObj = Object.assign({}, obj);
updateObj.node.title = 'The quickest brown fox';
```

Another workaround is to use JSON.stringify and JSON.parse to clone the object, and then update the property in a mutable way:

```javascript
const obj = {
  node: {
    id: 1,
    title: 'The quick brown fox',
    image: {
      original: '\//some.url/to/original/image',
      cached: '\//some.url/to/cached/image'
    }
  }
};

const updatedObj = JSON.parse(JSON.stringify(obj));
updateObj.node.title = 'The quickest brown fox';
```

With this, `updatedObj` got all the properties of `obj`, but with the updated title, while not mutating `obj`.

Now now, surely there should have some performance hit with using `JSON.parse(JSON.stringify(var))` compared to using `Object.assign()` right?

That's what I thought, and was surprised when I tried testing it out in [jsperf](https://jsperf.com/json-parse-perf/1).

In chrome, `JSON.parse` with `JSON.stringify` does get slower the larger the object, but it is interesting to see that cloning a 256 wide array is faster when using `JSON.parse` and `JSON.stringify` compared to `Object.assign`.

Run that test in firefox, and you'll see that `Object.assign` is slower regardless of the size of the array.

That was interesting to see, which is why I wrote it in my blog.