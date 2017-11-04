+++
author = "Daniel Cefram Ramirez"
tags = ["Golang"]
date = 2017-11-04T21:31:38+08:00
description = ""
draft = false
linktitle = ""
title = "Why I Dislike Golang Error Handling"
type = "post"

+++

I should admit that I used to like Go's idea of error handling, wherein errors are treated as values.
I also thought that forcing developers to handle each possible error points immediately
was a good thing, rather than moving all of the code into a `try` `catch` block.

But recently, while working on one of our project's internal tools, I came to grow tired of Go's
error handling. Here's why.

# Repetition

While the idea of forcing developers to handle each possible error points immediately was good,
forcing our code style to be littered with `if err != nil` isn't "pretty" or good. On my case, I had
a function that had to use `strconv.Atoi` multiple times... 4 strings to be exact. And since I would
wan't to throw an error (or return an error) once one of those `strconv.Atoi` fails, I was forced to
litter my code with if statements:

```go
func someFunc() error {
  // ... Some code that parses 2 strings, and splits each string to 2

  majorPrev, err := strconv.Atoi(majorPrevStr)

  if err != nil {
    return err
  }

  minorPrev, err := strconv.Atoi(minorPrevStr)

  if err != nil {
    return err
  }

  majorCur, err := strconv.Atoi(majorCurStr)

  if err != nil {
    return err
  }

  minorCur, err := strconv.Atoi(minorCurStr)

  if err != nil {
    return err
  }

  // Rest of the code
}
```

Now, imagine that you also have other functions that you would call that also returns an error if it
fails... You would want to handle those too, and in no time, your code will be littered with
`if err != nil`.

It would've been better if we could at least have a ternary operator in golang, so that it would
be a little "neater".

But what would be really neater is if Go had `try` `catch`...

```go
func someFunc() error {
  // ... Some code that parses 2 strings, and splits each string to 2

  try {
    majorPrev := strconv.Atoi(majorPrevStr)
    minorPrev := strconv.Atoi(minorPrevStr)
    majorCur := strconv.Atoi(majorCurStr)
    minorCur := strconv.Atoi(minorCurStr)
  } catch (error) {
    return error
  }

  // Rest of the code
}
```

I find it easier to debug errors caught in the `catch` block in other languages, since errors caught
there would also return the line number and column where the error was thrown.

# Error tracing

How errors are treated also makes debugging in Golang hard. There might be a better way that I am
not aware of, but if ever there is, I can say that it isn't straightforward.

With what we currently have out of the box, the sample code that I provided above would be hard to
debug if ever `someFunc()` did return an error. `error` does not contain the line number where it
was triggered, thus we would have to rely on exposing some meaningful "string" in the error message
by implementing the `Error` interface.

So yeah, it is doable, but I think this is unnecessary extra effort for something that should've
been made easy in the language itself.