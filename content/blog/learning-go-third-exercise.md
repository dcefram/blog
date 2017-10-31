+++
author = "Daniel Cefram Ramirez"
tags = ["Golang"]
date = 2017-07-22T06:20:00Z
description = ""
draft = false
slug = "learning-go-third-exercise"
title = "Learning Go: Third Exercise"
type = "post"

+++

The third exercise is all about maps. We'll need to count the number of times a word has occurred in a sentence.

**Here's the link:** https://tour.golang.org/moretypes/23

```go
package main

import (
	"golang.org/x/tour/wc"
	"strings"
)

func WordCount(s string) map[string]int {
	words := strings.Fields(s)
	result := make(map[string]int)

	for _, word := range words {
		result[word]++
	}
	return result
}

func main() {
	wc.Test(WordCount)
}
```

Since if the `key` is not present in the `map`, its value is always `0` instead of `undefined`. So we can safely increment it by 1.