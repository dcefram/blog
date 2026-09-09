+++
author = "Daniel Cefram Ramirez"
tags = ["Dev Tools", "journal"]
date = 2025-12-24T22:34:50+08:00
title = "Switched to Mise"
description = "After months using Proto, I decided to switch to Mise"
slug = "switched-to-mise"
type = "journal"
aliases = ['/journal/switched-to-mise/']
draft = false 
toc = false
+++

I used moonrepo's [proto](https://moonrepo.dev/proto) for 3 months. It's a solid tool—fast, written in Rust,
supports multiple languages through a pluggable WASM architecture. On paper, it
checks all the boxes for a modern version manager.

But I switched to [mise](https://mise.jdx.dev) this month.

The reason? Something stupidly simple: _I could never remember how to activate a
specific Node.js version in proto._

Every single time, I'd have to look it up. Google it. Check the docs. It wasn't
intuitive. The command structure just didn't stick in my brain, no matter how
many times I used it.

With mise, it felt natural from day one. `mise use node@<version>`. Done. It's
the same pattern as nvm (`nvm use <version>`), fnm (`fnm use <version>`),
and basically every other Node version switcher I've used. The muscle memory was
already there.

## The "Use" Keyword Matters

This might sound trivial-"just memorize one command, bro"-but here's the thing:
when you're context-switching between projects, debugging issues, or just trying
to get work done, you don't want to think about your tooling. You want it to be invisible.

Proto's approach is different. It's more... Deliberate? Contextual? I'm sure there's
a good reason for it, and maybe it's more powerful in ways I didn't explore.
But power means nothing if I can't remember how to use it without opening a
browser tab.

Mise just clicked. The `use` keyword is a convention that's been around forever
in the Node ecosystem. It's what people expect. It's what I expect.

## Mise's Simplicity

Just like proto, mise supports the languages that I use (minus xcode I guess,
which is not a language, but proto has a plugin for xcode version switching available
that can be installed easily). Oh, mise does have a plugin system too, haven't tried
it yet though. All that with a simple, familiar feeling, CLI. Less novel, maybe,
but that's exactly what I wanted.

It's like the difference between a fancy new IDE with all the bells and whistles
versus just using Vim with a few plugins. Sometimes you just want the thing that
works the way you expect it to work.

## Takeaway

I'm not saying proto is bad. It's not. It's a well-designed tool with a clear vision.
But for my workflow, mise just fits better.

The lesson here isn't "mise is better than proto." It's just that the best tool
is the one you don't have to think about. The one that matches your mental model.
The one where the commands just flow from your fingers without a second thought.

