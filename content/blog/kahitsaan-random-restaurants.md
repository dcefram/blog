+++
author = "Daniel Cefram Ramirez"
tags = ["crystal", "tools"]
date = 2018-12-19T09:12:14+08:00
description = ""
draft = false
linktitle = ""
title = "Kahitsaan Random Restaurants"
type = "post"

+++

So I made a tool and I thought of blogging about it.

### Background

I recently left [SplitmediaLabs](https://www.splitmedialabs.com), and now I'm working remotely as a Senior Software Developer/Engineer for a consultancy (aside: contract says that I'm a Senior Software Engineer, but my company ID states that I'm a Senior Software "Developer". Minor stuff, it's just that I hate inconsistencies).

Although I'm working remotely, I usually meetup with the team at a co-working space once a week...
And during those meetups, we always have a dilemma of picking a place to eat within the vicinity of the co-working space.

Here's the usual conversation that we have: (I'm paraphrasing here, adding some words here and there)

> Colleague: Gutom na ako, saan tayo kakaen? (I'm hungry, where should we eat?)
> Me: Kahit saan (Anywhere)
> Colleague: Pambihira, walang resto na Kahit Saan ang pangalan dito (OMGWTH, there's no resto named "Anywhere" around here)
> Me: Ikaw gutom, ikaw magisip (You're the one that is hungry, so you should pick where to eat)
> Colleague: Wag nalang tayo kumaen (Let's diet :P)

### The Solution and the idea

Create a tool that would retrieve a list of Restaurants around the vicinity, and pick one at random.
I was thinking of creating a web app for this, but I decided to take advantage of this to play around [Crystal](https://crystal-lang.org).

Oh, and use an existing platform's API rather than creating a new one that would then turn into a
startup that would compete with other well established platforms... In other words: Use Zomato's API.

> P.S. I'm not a Ruby developer, but I'm pretty attracted with how easy it is to dive into Crystal language compared to the
> other compiled language that I'm also self-studying ([Nim](https://nim-lang.org))... So my code might not be idiomatic
> "Ruby"/Crystal since I only learned how to write Crystal through the official docs. But I'd love to learn, please send me
> feedback and/or links to good books.

### Implementation

Here's the [source code](https://github.com/dcefram/kahitsaan).

Implementing this was quite easy, since even though Crystal language itself isn't 1.0, and is far from "polished", a lot of the tools built for Crystal had the "polished" feeling. I guess it's because most of the tools were inspired from their Ruby counterpart.

One of the libraries that has a "polished" feel is [Crest](https://github.com/mamantoha/crest), which I used to send requests to Zomato's API. Everything was a breeze tbh. I thought of caching the results so that I won't have to request the API all the time to speed up the response of the CLI tool, but alas, the terms and condition of Zomato's API specifically indicated that caching is not allowed. :sadface:

Here's a GIF of the CLI tool:

{{< img-post "date" "kahitsaan.svg" "Kahitsaan CLI tool" >}}

Oh, and you can click on the link (depending on your terminal emulator though).

### Conclusion/Takeaways

It's fun learning a new language when you have something to use it on. Although I could've used bash to create this tool (you know `curl` right?), I still had fun writing this even though I never used an indentation-based language before aside from BASIC.

As for the tool itself, I guess it's half useful since I need to open up my laptop to use it. Getting a web version done would be much more useful since most of the time, we would use this tool while walking around greenbelt... and using the phone is obviously much more convenient than using the laptop while walking :joy:
