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
a function that had to use multiple functions that could return an error... And since I would
wan't to throw an error (or return an error) once one of those functions fails, I was forced to
litter my code with if statements:

```go
func someFunc() error {
  // ... Some other code

  version, err := strconv.Atoi(ver)

  if err != nil {
    return err
  }

  if version >= someCondition {
    version = version + 1
  }

  file, err := ioutit.ReadFile("./some-file-" + fmt.Sprintf("%04d", version))

  if err != nil {
    return error
  }

  contents := string(file)
  contents = strings.Replace(contents, "some-string", someString, -1)

  err = ioutil.WriteFile("./some-file-" + fmt.Sprintf("%04d", version),[]byte(contents), os.ModePerm)

  if err != nil {
    return error
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
  // ... Some other code

  try {
    version := strconv.Atoi(ver)

    if version >= someCondition {
      version = version + 1
    }

    file= ioutit.ReadFile("./some-file-" + fmt.Sprintf("%04d", version))

    contents := string(file)
    contents = strings.Replace(contents, "some-string", someString, -1)

    ioutil.WriteFile("./some-file-" + fmt.Sprintf("%04d", version),[]byte(contents), os.ModePerm)
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