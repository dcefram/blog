+++
author = "Daniel Cefram Ramirez"
categories = ["Programming", "Nerd Diary"]
date = 2017-07-20T11:57:16Z
description = ""
draft = false
slug = "learning-go-first-excersise"
tags = ["Programming", "Nerd Diary"]
title = "Learning Go: First Exercise"
type = "post"

+++

I decided to blog my self study adventures in learning Go. I'll start with *A Tour of Go*'s exercises and then follow through my own personal small project, probably a blogging platform that reads markdown files.

I already did this, and have my [go-learn self study codes in github](https://github.com/dcefram/go-learn/), but I decided to do all of the exercises again after a couple of months not using Go since I was studying Rust. P.S. Rust is really good, albeit harder to master, but I wanted to study a compiled language that I would use for backend services. `Iron` and `Rocket.rs` is good, but still has a lot of boilerplate. Don't get me wrong though, Golang has a lot of boilerplate too, but not so much more than Node.js...

**Here's the link for today's exercise:** https://tour.golang.org/flowcontrol/8

This one is pretty basic, as the formula is already given in the exercise's description. Let's try to do the first part, wherein we'll loop through the formula 10 times, and then return the value. We'll also print out Go's `math.Sqrt` function just to compare how close we are.

```go
package main

import (
	"fmt"
	"math"
)

func Sqrt(x float64) float64 {
	z := x

	for i := 0; i < 10; i++ {
		z = z - (z*z - x) / (float64(2)*z)
	}

	return z
}

func main() {
	fmt.Println(Sqrt(2))
	fmt.Println(math.Sqrt(2))
}
```

This would print out `1.414213562373095` for our function, while Go's `math.Sqrt` would spit out `1.4142135623730951`.

Let's try doing the second part of the exercise... We'll only stop looping once the value stopped changing.

I first did this:
```go
package main

import (
	"fmt"
	"math"
)

func Sqrt(x float64) float64 {
	z, cache := x, 0.0

	for z != cache {
		cache = z
		z = z - (z*z - x) / (float64(2)*z)
	}

	return z
}

func main() {
	fmt.Println(Sqrt(2))
	fmt.Println(math.Sqrt(2))
}
```

One problem though, this loop will never end because `z` would alternate between `1.414213562373095` and `1.4142135623730951` for each iteration, which would mean that `z` will never be equal to `cache`.

We would want to stop looping if we have at at least 15 numbers that are the same.

```go
package main

import (
	"fmt"
	"math"
)

const DELTA = 0.0000001

func Sqrt(x float64) float64 {
	z, cache := x, 0.0

	for math.Abs(z - cache) > DELTA {
		cache = z
		z = z - (z*z - x) / (float64(2)*z)
	}

	return z
}

func main() {
	fmt.Println(Sqrt(2))
	fmt.Println(math.Sqrt(2))
}
```

You'll notice my DELTA is actually only 7 decimals... this is what I got after trial and error on trying to get the smallest number of iterations with similar results as `math.Sqrt`.
