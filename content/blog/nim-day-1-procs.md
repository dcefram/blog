+++
author = "Daniel Cefram Ramirez"
tags = ["nim"]
date = 2019-04-22T15:50:22+08:00
description = ""
draft = true
linktitle = ""
title = "Nim Day 1 Procs"
type = "post"

+++

I decided to learn Nim again, as I'm growing tired with the language I'm 
currently using at work. I'll post my notes on what I've learned here in my blog 
just as I would have back then when I studied at school.

I'm skipping datatypes section, since it's pretty straightforward similar to 
other imperative compiled languages out there (Read more about [Basic Datatypes](https://nim-lang.org/docs/tut1.html#basic-types))

Also, this language syntax is 
similar to python.

Oh, some basic stuff that needs to be thrown out first are:

- variable declarations: `var, let, const`. `var` for mutable variables, `let` for immutable, `const` for constants that would be checked in compile time.
- Nim is a compiled language, and as such, to run your code, you'll have to compile it and then run the compiled binary. Thankfully, the CLI has a flag to auto run the compiled binary: `nim -r c <filename>.nim`. Your common sense is correct, the `-r` is the flag for running the binary that you just compiled, and the command `c` is for... compile.

### So let's talk about procs

- `proc`s are the "functions" or "methods" in Nim.
- they have implicit returns, with `result` as the value that would automagically be returned if no `return` statement was found.

#### Examples:

```nim
proc helloWorld(name: string): string = "Hello there " & name

# usage
echo(helloWorld("Dan")) # output: Hello there Dan
```

And some multi-line procs

```nim
proc helloWorld(name: string): string =
  result = "Hello World from " & name
  result.add(" and whoever is in this world")

# usage
echo(helloWorld("Dan")) # output: Hello World from Dan and whoever is in this world
```

If you noticed, in order to "append" to the whatever value is going to be returned, you'll have to use the proc `add`..

Oh, how about if we would want to capture a variable amount of arguments? Yeah, Nim got that too

```nim
proc genNames(names: varargs[string]): string =
  result = ""
  for name in names:
    result.add(name & " ")

# usage
echo(genNames("Dan", "AC", "Janine")) # output: Dan AC Janine
```

Notice that we sneaked in some loops there too. `names` by this time is an iterable variable. We could also add control flows in there (if statements and case statements)

Uhmmm, functional overloading is also possible!

```nim
proc getUserCity(firstName: string): string =
  case firstName
  of "Dan": return "Taytay"
  of "AC": return "QC"
  of "Janine": return "QC"
  else: return "Unknown"

proc getUserCity(userId: int): string =
  case userId
  of 1: return "Taytay"
  of 2: return "QC"
  else: return "Unknown"
```

Ah yes, the `case` statement. Similar to the traditional `switch` statement
on other languages, just that we do not have `break` statements.

Hey, how about passing functions as a parameter? Yeap, we can force Functional Programming through our throat in this procedural programming language.

```nim
proc isValid(x: int, validator: proc (x: int): bool) =
  if validator(x): echo(x, " is valid")
  else: echo(x, " is NOT VALID")

isValid(1, proc (num: int): bool = num == 1)
```

We can also sugarize the above to remove the `proc` keyword

```nim
proc isValid(x: int, validator: (x: int) -> bool) =
  if validator(x): echo(x, " is valid")
  else: echo(x, " is not valid")

isValid(1, (num: int) -> bool => num == 1)
```

I guess the next post would be about collections? You know, arrays.