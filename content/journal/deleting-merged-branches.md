+++
author = "Daniel Cefram Ramirez"
date = 2021-03-11T09:31:25+08:00
description = "I just wanted my git log graphs to have less noise"
draft = false
title = "Deleting Merged Branches"
tags = ["Fish", "Tools"]
type = "toys"
+++

There was this one project that I was involved in that never deleted merged branches. Not only was rebasing to latest branch not the norm in this project, but so was squashing, thus there are a lot of commits littered all over the repository.

I’m not that opinionated on this matter though, as it falls into one of those _“I have a preference, but I won’t force it on other’s projects”_, where “others” in this case are projects that I did not pioneer.

However, the noise is real when I open up the project in a Git GUI, as I see a lot of lines with lots of commits in the graph, thus I decided to create a tool to just purge these merged branches off of my local clone. I would then just “hide” the remote from the graph in the Git GUI.

My initial thought was that this was the perfect opportunity to play with some obscure, but pretty, languages ([Nim Programming Language](https://nim-lang.org/) and [The Crystal Programming Language](https://crystal-lang.org/)), and after some research with their libgit2 bindings, and admittedly, also checking out [NodeGit](https://www.nodegit.org/) and [go-git](https://github.com/go-git/go-git) for a much more mature project, I just felt that the effort required for these were simply a lot. Heck, I couldn’t even figure out how to list the branches merged to another target branch.

So I ended up just using the CLI, and wrapping it on a simple fish function.

## The simple solution
```mermaid
flowchart LR
    A(List merged branches) --> B(Filter known protected branches)
    B --> C(Delete branches)
```

I first need to list all branches merged to a target branch. This was the simple part.
```fish
git branch --merged main
```

With the list, I would just need to ignore a couple of /protected/ branches. I used simple `grep` for this (`-v to inverse the behavior, and -e for the usual expression matching`).

```fish
grep -v -e 'qa' -e 'staging' -e 'main'
```

And for deleting, it’s a simple `git branch -d […branches names]`.

The final command should look like this:
```fish
git branch --merged main | grep -v -e 'qa' -e 'staging' -e 'main' | xargs git branch -d
```

Now, I wrapped it in a fish function just in case I need to change the target branch, and so that the command I type would be way smaller than this long one.

```fish
function delmerged
  argparse t/to -- $argv

  if set -ql _flag_to
    git branch --merged $argv | grep -v -e 'qa' -e 'staging' -e 'main' | xargs git branch -d
  else
    git branch --merged main | grep -v -e 'qa' -e 'staging' -e 'main' | xargs git branch -d
  end
end
```

The usage for this is simply executing `delmerged` inside a repository. If you want to delete all branches merged to, let’s say  `staging`, it would be as simple as `delmerged —to staging`.

Source code: [fish/delmerged.fish at main · dcefram/fish · GitHub](https://github.com/dcefram/fish/blob/main/functions/delmerged.fish)