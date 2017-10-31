+++
author = "Daniel Cefram Ramirez"
tags = ["JavaScript"]
date = 2017-03-25T07:38:14Z
description = ""
draft = false
featured = "generic-code-1.jpg"
featuredalt = ""
featuredpath = "date"
linktitle = ""
slug = "looping-in-successive-order-with-async-calls"
title = "Looping in successive order with Async calls"
type = "post"

+++

Let's first define an example problem to better understand the issue we have with normal looping:

For example, we have an array of post IDs that we would fetch and then print it out on the console

```javascript
const ids = [1, 2, 3, 4];

for (var id of ids) {
  fetch(`${API_URL}/${id}`).then(() => {
    console.log(id, response.results);
  });
}
```

The output of the above code would be different results with the same id, wherein the id printed would be the last number

```
4  [{ id: 1 }]
4  [{ id: 3 }]
4  [{ id: 2 }]
4  [{ id: 4 }]
```

One way to solve this is by using closures, or by simply using `let` instead of `var` to make the variable available only in that particular block

```javascript
const ids = [1, 2, 3, 4];

for (let id of ids) {
  fetch(`${API_URL}/${id}`).then(() => {
    console.log(id, response.results);
  });
}
```

The output would be:

```
1  [{ id: 1 }]
3  [{ id: 3 }]
2  [{ id: 2 }]
4  [{ id: 4 }]
```

That's better. The reason why we're printing the correct id for reach result is because the variable defined using `let` only lives on the current block, essentially behaving the same way as if we were using a function closure inside the for loop.

All is good, but what if we were concerned about the order?

Let's create a helper function just for this:

```javascript
function AsyncLoop(items, func) {
    return items.reduce(
        (promise, item, index) => promise.then(previous => func(item, previous, index)),
        Promise.resolve()
    );
}

// Usage
const ids = [1, 2, 3, 4];

AsyncLoop(ids, id => {
  return fetch(`${API_URL}/${id}`).then(response => {
    console.log(id, response.results);
    return Promise.resolve();
  });
}).then(() => console.log('DONE!'));
```

With that, the output would be in the correct order :D

```
1  [{ id: 1 }]
2  [{ id: 2 }]
3  [{ id: 3 }]
4  [{ id: 4 }]
```

The logic behind AsyncLoop function above is that it would use `reduce` to combine/reduce the array into a single value based on the accumulator function, which is the function we supply as the first parameter of `reduce`. We passed a `Promise.resolve` as the second parameter so that we would have an initial accumulator value on the first iteration of reduce (ie. the first parameter of the accumulator function), whilst returning whatever the function supplied to our helper method returns. (To learn more about reducers, read it in [MDN's docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/Reduce))

In this case, the function we supply should always return a Promise for the reducer to work as expected. Basically, the function passed would only execute once the previous iteration is done. It would know that the previous iteration is done only if it returns a resolved Promise.

I honestly had different longer versions of this particular helper method, making use of currying, recursive functions, and function closures... The reduce method is by far the best version.