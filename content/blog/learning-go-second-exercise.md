+++
author = "Daniel Cefram Ramirez"
tags = ["Golang"]
date = 2017-07-21T06:00:06Z
description = ""
draft = false
slug = "learning-go-second-exercise"
title = "Learning Go: Second Exercise"
type = "post"

+++

Today's exercise is all about slices. We'll need to generate an image by passing a slice of slices to `pic.Show`.

**Here's the link:** https://tour.golang.org/moretypes/18

```go
package main

import "golang.org/x/tour/pic"

func Pic(dx, dy int) [][]uint8 {
	slice := make([][]uint8, dy)

	for fIndex := range slice {
		slice[fIndex] = make([]uint8, dx)
		for sIndex := range slice[fIndex] {
			slice[fIndex][sIndex] = uint8(fIndex ^ sIndex)
		}
	}

	return slice
}

func main() {
	pic.Show(Pic)
}
```

Quite simple... I did learn something new too. I just figured out that the second value returned by `range` is **NOT** a reference to the value, which means that you cannot use that to manipulate the slice.