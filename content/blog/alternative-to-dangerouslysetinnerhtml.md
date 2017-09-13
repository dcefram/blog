+++
author = ""
categories = ["Nerd Diary", "Programming", "React"]
date = 2017-09-13T00:34:15+08:00
description = "dangerouslySetInnerHTML in React is generally discouraged. I found a sort of better way to tackle usecases that need to 'parse' html tags."
draft = false
featured = ""
featuredalt = ""
featuredpath = "date"
linktitle = ""
title = "Alternative to dangerouslySetInnerHTML in React"
type = "post"

+++

Scenarios wherein you need to render a string with html tags in it would still require you to use
`dangerouslySetInnerHTML`... so if your problem is as such, then I guess there's still no better
way to parse strings with html tags.

As for scenarios wherein we would need to pass a content to a reusable component through attributes,
then this would work. A simple example might help right?

### The scenario
In this example, we'll be using
{{< url-link "ReactTooltip" "https://github.com/wwayne/react-tooltip" "blank" >}} as our reusable
component. In order to have a "standardized" look and behavior, we wrapped `ReactTooltip` in another
component named `Tooltip`.

```javascript
export class Tooltip extends PureComponent {
  // default props, state, etc. here...

  handleContent = () => {
    const className = cx({
      // ...
    });

    return <div className={className}>{this.props.content}</div>
  }

  render() {
    const className = cx({
      // ...
    });

    // lodash pick, just pass valid props based on what ReactTooltip expects
    const props = pick(this.props, [...]);

    return (
      <ReactTooltip
        {...props}
        class={className}
        getContent={this.handleContent}
      />
    );
  }
}
```

We could pass a string to the `Tooltip` component to display the text we want to see.

```javascript
<Tooltip content="This is a content" />
```

But how about if we want some formatting?

```javascript
<Tooltip content="this is <strong>A</strong> content" />
```

This would display the string as is, and would not parse the HTML tags since it is treated as a string.

### The solution
One might think that the simplest solution is to add a `dangerousContent` to the Tooltip component.
That is to modify the component as such:

```javascript
// Same code as above, let's just modify the handleContent method
handleContent = () => {
  const className = cx({
    // ...
  });

  if (this.props.dangerousContent === undefined) {
    return <div className={className}>{this.props.content}</div>
  }

  return (
    <div
      className={className}
      dangerouslySetInnerHTML={{ __html: this.props.dangerousContent }}
    />
  );
};
```

Usage:

```javascript
<Tooltip dangerousContent="this is <strong>A</strong> content" />
```

That should work right? Yup, that should work, but with that, we added another property to the
supposedly reusable `Tooltip` component, and we ended up having the need to parse a string and
render it as HTML.

### The 'better' solution

If we are pretty sure that we won't be retrieving the tooltip contents from an
external source, ie. we won't receive it as a string, then we could eliminate the need to modify our
common component (`Tooltip`), and just pass in a React component to the `content` attribute:

```javascript
<Tooltip content={(<span>this is <strong>A</strong> content</span>)} />
```

The above code would mean that we could revert our `Tooltip` component to remove the `dangerousContent`
property, and stop parsing strings as HTML.

Another advantage is that we could use CSS Modules and pass it to the HTML nodes if needed.

### Final thoughts
With all that said and done, the only caveat is that we could not do this if we're getting the
tooltip content from a external source, in a sense that we are limited to actual strings all the time.

P.S. In the start of this blog post, I said:

> I found a sort of better way to tackle usecases that need to 'parse' html tags.

The more accurate sentence would be that in one of my merge requests, the code reviewer hated the idea
of using `dangerouslySetInnerHTML` and suggested to me to just pass a React Component to the `content`
attribute, which I really liked and thought that I should post it in my blog in case someone might
have the same scenario.
