+++
author = "Daniel Cefram Ramirez"
tags = ["dev"]
date = 2023-08-04T23:54:51+08:00
title = "Array concat in Javascript - a performance perspective"
description = "Sometimes, what we think is slower might be faster."
type = "post"
draft = false

+++

I recently encountered a problem where I had to optimize a function that handles an array size of more than 10k items. The goal of the function was just to determine if the items in the multidimensional array are all *empty*.

Here's what the array looks like:

```js
[
  [
    { some: "", unique: "", key: "", value: "", pair: "" }
  ],
  ...rest
]
```

The original function had a logic similar to this:

```js
let allValues = [];
outerArray.forEach((innerArray) => {
  innerArray.forEach((obj) => {
    allValues = allValues.concat(Object.values(obj));
  });
});

// If we found one, then there are results
const hasNoResults = !allValues.find(Boolean); 
```

The logic is pretty easy to understand. However, it isn't efficient, and it's not because of the nested array.

We encountered a couple of cases where we had to iterate over 10k items in the first level of the multidimensional array, and this caused the UI to hang for a couple of seconds, with the maximum we saw around 30 seconds in Chrome.

## Who's the culprit?

We used Chrome's DevTools' Performance profiler to dig into which exact line was taking up the most time.

![](https://storage.googleapis.com/rmrz-blog.appspot.com/concat-perf-js.png)

In the screenshot above, you can also notice the yellow area chart at the very top. That's the CPU usage, which you can see is hovering at 100% for 33 seconds.

The specific line that is the culprit is the line where we did the `.concat`.

## The solution

There were two solutions that were floated:
- One was to use `push` and mutate the array, retaining most of the current logic in place.
- The other was to add another nested loop, processing each item rather than building a new array with the combined values before doing the checking.

We went for the latter solution as after some benchmarking, the worst-case scenario has the same benchmark for the two options, but the best-case scenario is faster when we simply short-circuit the loops without having to copy items to a temporary array.

Here's a rough code of the benchmark I made on my work laptop:
```js
// test data
const data = Array.from(new Array(10000)).map((i) => ({
  v: 'rand_' + i,
  z: 'rrrr' + i,
  l: i % 2 ? '0' : '0'
}));

function arrayConcat() {
  console.time('array.concat');
  let values = [];
  data.forEach((d) => {
    values = values.concat(Object.values(d));
  });
  const hasNoResults = values.every((a) => a === "0");
  console.log('array.concat noResults', hasNoResults);
  console.timeEnd('array.concat');
}

function nestedLoops() {
  console.time('nested loops')
  const hasNoResults = typeof data.find((d) => {
    return typeof Object.values(d).find((v) => v !== '0') !== 'undefined'
  }) === 'undefined';
  console.log('nested loops noResults', hasNoResults);
  console.timeEnd('nested loops');
}

function arrayPush() {
  console.time('array.push')
  let values = [];
  data.forEach((d) => {
    values.push(...Object.values(d));
  });
  const hasNoResults = values.every((a) => a === "0");
  console.log('array.push noResults', hasNoResults);
  console.timeEnd('array.push');
}

arrayConcat();
nestedLoops();
arrayPush();
```

The results of the benchmark are:
```
array.concat: 58.93701171875 ms
nested loops: 0.028076171875 ms
array.push: 0.910888671875 ms
```

Even on the worst case scenario, nested loops logged in very similar time as `Array.push`, so we decided to go for nested loops instead of the arguably a lot readable `Array.push` approach.

## The possible reason

Although we never dug into how V8 behaves with regard to Array `concat` and `push`, we were able to find a couple of articles to back up our decision of ditching `concat`.

We found this [comment in a Dev.to article](https://dev.to/uilicious/javascript-array-push-is-945x-faster-than-array-concat-1oki#comment-agaa) that sort of explains the possible reason:

> Using array concat copies values to a new array.
> 
> When done repeatedly, it also means increased memory access.
> 
> When dealing with large arrays, where the data may exceed the bounds of the L0 cache of the CPU, then the CPU would most likely need to access a much more distant cache.
> 
> This could explain the noticeable increase in CPU usage while the browser is hanging.

## Conclusion

Does this mean that we should always avoid using `concat`? No, not really. We should just be aware of when *not* to use it.

It was 2015 when I first caught wind of React and its push with immutability, and the succeeding years were filled with [people *evangelizing* why we *should not* mutate objects and arrays](https://alistapart.com/article/why-mutation-can-be-scary/).

The reasons are all valid, but as with almost everything in life, we should always have a balanced view of things and understand when to use an approach, and when not to. **This is a great example for us to be careful about treating everything we learn as absolutes**.

*Always, always* evaluate the scenario when choosing what solution to go for.

# References

[Javascript Array.push is 945x faster than Array.concat](https://dev.to/uilicious/javascript-array-push-is-945x-faster-than-array-concat-1oki)
