+++
author = "Daniel Cefram Ramirez"
tags = ["golang"]
date = 2017-11-04T21:31:38+08:00
description = ""
draft = false
linktitle = ""
title = "What I dislike in Go"
type = "post"

+++

# Error handling

I should admit that I used to like Go's idea of error handling, wherein errors are treated as values.
I also thought that forcing developers to handle each possible error points immediately
was a good thing, rather than moving all of the code into a `try` `catch` block.

But recently, while working on one of our project's internal tools, I came to grow tired of Go's
error handling. Here's why.

### Repetition

While the idea of forcing developers to handle each possible error points immediately was good,
forcing our code style to be littered with `if err != nil` isn't "pretty" or good. On my case, I had
a function that had to use multiple functions that could return an error... And since I would
want to throw an error (or return an error) once one of those functions fails, I was forced to
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
    return err
  }

  contents := string(file)
  contents = strings.Replace(contents, "some-string", someString, -1)

  err = ioutil.WriteFile("./some-file-" + fmt.Sprintf("%04d", version),[]byte(contents), os.ModePerm)

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
  // ... Some other code

  try {
    version := strconv.Atoi(ver)

    if version >= someCondition {
      version = version + 1
    }

    file = ioutit.ReadFile("./some-file-" + fmt.Sprintf("%04d", version))

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

# Import paths

Go's `import` looks really cool and straightforward. It's easy to know where to look in case you are
debugging a 3rd party library that you used in your project. There are plenty of articles though that
point out the pitfalls of Go's dependency model, but with [dep](https://github.com/golang/dep), the
version issue which is Go's weakness is well addressed.

However, what is not addressed is how sub packages are handled. Go does not have any way to `import`
a package using relative paths, and this makes it a pain to fork and contribute to 3rd party Go packages.

The reason being is that when you fork a project, and use `go get`, you would end up having a path
that uses your repo's path (ex: `$GOPATH/src/github.com/<YourUser>/<ForkedLibary>`). Now, if that
library imports some of its own sub packages between different source files, you would need to manually
update them in order for it to work... and before pushing, you'll have to remember to revert all
your updated `import`s so that it could be pulled back to the original repository.

If Go supports relative `import` paths, contributing to 3rd party libraries could have been less tedious.
