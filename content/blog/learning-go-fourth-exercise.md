+++
author = "Daniel Cefram Ramirez"
categories = ["Programming", "Nerd Diary"]
date = 2017-07-22T07:10:33Z
description = ""
draft = false
slug = "learning-go-fourth-exercise"
tags = ["Programming", "Nerd Diary"]
title = "Learning Go: Fourth Exercise"
type = "post"

+++

The fourth exercise is all about function closures. We're tasked to create a Fibonacci function using function closures.

**Here's the link:** https://tour.golang.org/moretypes/26

```go
package main

import "fmt"

// fibonacci is a function that returns
// a function that returns an int.
func fibonacci() func() int {
	cur, next := 1, 0
	return func() int {
		cur, next = next, cur+next
		return cur
	}
}

func main() {
	f := fibonacci()
	for i := 0; i < 10; i++ {
		fmt.Println(f())
	}
}
```