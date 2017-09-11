+++
author = "Daniel Cefram Ramirez"
categories = ["Programming", "React", "Nerd Diary"]
date = 2017-02-18T08:10:44Z
description = ""
draft = false
slug = "using-datasets-to-avoid-inline-arrow-functions"
tags = ["Programming", "React", "Nerd Diary"]
title = "Using datasets to avoid inline arrow functions"
type = "post"

+++

Adding an inline anonymous/arrow function in React is not recommended due to the nature of how react behaves. The render method would always be called each time a state or property is updated, which would then create a new function if we are using inline arrow functions, and then this would force the GC (garbage collector) to clean the previous arrow function.

```javascript
render() {
  // Not good :\
  return <div onClick={e => console.log(e)} />
}
```

The correct way would be to add a method in your class as the `onClick` handler.

```javascript
class Example extends PureComponent {
  constructor(props) {
    super(props);

    this.onClickHandler = this.onClickHandler.bind(this);
  }

  onClickHandler(event) {
    console.log(event);
  }

  render() {
    // better
    return <div onClick={this.onClickHandler} />
  }
}
```

We should also avoid using `bind` inside the render function, since like arrow functions, it would also create a new function every render.

More info here: [ESLint React Plugin Doc](https://github.com/yannickcr/eslint-plugin-react/blob/master/docs/rules/jsx-no-bind.md)

But the question right now is how would you avoid using `bind` and arrow functions when rendering a list?

```javascript
render() {
  return <ul>
    {this.props.items.map(item => (
      <li onClick={this.onClickHandler}>
        {item.label}
      </li>
    ))}
  </ul>
}
```

One way to solve this is by creating a component for the list item, just like what was suggested in the [ESLint React Plugin Doc](https://github.com/yannickcr/eslint-plugin-react/blob/master/docs/rules/jsx-no-bind.md#lists-of-items).

However, I'm not that fond of creating a whole new component for something so small, and for the sole purpose of adding a event listener efficiently.

It's a good thing that we could always revert to what we used to do before React was even a thing... Using datasets.

Compare the solution given by the ESLint doc, and the solution below:

```javascript
class Example extends PureComponent {
  constructor(props) {
    super(props);
    this.onItemClick = this.onItemClick.bind(this);
  }

  onItemClick(event) {
    if (event.target.dataset.value === undefined) return false;
    // Do something here with dataset.value
    event.stopPropagation();
  }

  render() {
    return (
      <ul>
        {this.props.items.map(item =>
          <li
            key={item.id}
            data-value={item.id}
            onClick={this.onItemClick}
          >
            ...
          </li>
        )}
      </ul>
    );
  }
}
```

Or better yet, just add `onClick` to the parent, and take advantage of how JS handles capturing.

```javascript
class Example extends PureComponent {
  constructor(props) {
    super(props);
    this.onItemClick = this.onItemClick.bind(this);
  }

  onItemClick(event) {
    if (event.target.dataset.value !== undefined) {
      // Do something with event.target.dataset.value
      event.stopPropagation();
    }
  }

  render() {
    return (
      <ul onClick={this.onItemClick}>
        {this.props.items.map(item =>
          <li
            key={item.id}
            data-value={item.id}
          >
            ...
          </li>
        )}
      </ul>
    );
  }
}
```

With that said, there are many workarounds to prevent the usage of inline arrow functions and/or bind, and this is one of the many that I prefer.