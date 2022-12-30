+++
author = "Daniel Cefram Ramirez"
tags = ["css"]
date = 2017-03-04T08:13:23Z
description = "Applying styles based on other elements."
draft = false
slug = "responsive-web-designs-through-eqcss"
title = "Responsive web designs through EQCSS"
type = "post"

+++

[EQCSS](https://github.com/eqcss/eqcss) allows us to style elements based on the element's state. It is similar to CSS' media queries, but with the added feature to style elements based on the element's dimension and contents, and not just based on the browser's width and height.

This got me interested since my previous project's longstanding issue was with how the app should look like based on a combination of two factors: _The window's size and the number of elements inside the container_. The current maintainer had to resort to using JavaScript, adding event listeners to add a class based on the two conditions above.

EQCSS could've solved the issue in a much, let's say, cleaner way.

_\* Since it hasn't yet found its way to the standard CSS (specifications is still a work-in-progress), in order to get EQCSS to work, we will still have to resort to JavaScript_

## Element Queries

If ever you used media queries before, you might find the syntax very similar:

```css
@element '.selector' and (min-width: 500px) {
  $this { display: none; }
}
```

EQCSS starts with the `@element` keyword, and then is succeeded with a selector, and lastly the condition. The actual CSS code is placed inside that block, and will only apply once the condition is met. This also means that the CSS code that you place within the block are scoped to that condition block.

_\* The `$this` is a meta-selector. Here's a list of [meta-selectors.](https://github.com/eqcss/eqcss#meta-selectors)_

The interesting part is that you can style elements outside of the selector, ie:

```css
@element '.sidebar' and (min-height: 500px) {
  body { display: flex; }
  .other-non-child-elements { flex: 1; }
  $this li { color: brown; }
}
```

You'll notice on the code above that you can style other elements outside of the selector; in the example's case, we styled the `body`, another non-child element, and a child element `li` if ever `.sidebar`'s height is at least 500px.

Aside from the usual conditions that media queries already has, EQCSS has additional conditions:

#### Width-based Conditions

- `min-width`
- `max-width`

#### Height-based Conditions

- `min-height`
- `max-height`

#### Count-based Conditions

- `min-characters`
- `max-characters`
- `min-lines`
- `max-lines`
- `min-children`
- `max-children`

#### Scroll-based Conditions

- `min-scroll-y`
- `max-scroll-y`
- `min-scroll-x`
- `max-scroll-x`

#### Aspect-based Conditions

- `orientation`
- `min-aspect-ratio`
- `max-aspect-ratio`

You can find the demos on [EQCSS's README](https://github.com/eqcss/eqcss#element-query-demos). I found this useful and am grateful that we can use this now. Hopefully the draft gets finalized and this gets added to standard CSS in the future.
