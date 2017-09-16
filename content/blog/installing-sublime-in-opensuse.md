+++
author = "Daniel Cefram Ramirez"
categories = ["Nerd Diary"]
date = 2017-09-16T16:21:10+08:00
description = "OpenSUSE's package manager isn't well known for having up-to-date packages, and you usually have to resort to manually installing or compiling programs that you really want to be updated. Sublime is one of those softwares."
draft = false
featured = ""
featuredalt = ""
featuredpath = "date"
linktitle = ""
title = "Installing Sublime in OpenSUSE"
type = "post"

+++

My daily driver nowadays is {{< url-link "Gogland" "https://www.jetbrains.com/go" "blank" >}},
and I sometimes use {{< url-link "VSCode" "https://code.visualstudio.com/" "blank" >}} if ever I
need to open 2 or more projects at the same time (Gogland eats up way too much RAM).

In my previous post, I stated that I switched to VSCode away from Sublime, but since Gogland got
better JS support, like configuring the root path so that it would match how my webpack config
handles import paths, and with the fact that Gogland got better tooling when it came to coding in
Go Language, I'm now using it as my primary editor.

But a day or two ago, Sublime Text announced that they just released Sublime Text 3 out of Beta.
I wanted to test it out in my OpenSUSE laptop since I paid for a Sublime Text license, and would wanted
to encourage myself that I didn't just waste 70 dollars on a product that got outdated pretty quickly after
VSCode came out. But alas, zypper does not have the latest and greated Sublime Text 3 :(

So here are my notes on how to install Sublime Text 3, the manual way... Since sublime does release
tarballs for Linux, we'll go ahead and use that.

### Steps

- Download the tarball from {{< url-link "Sublime's website" "https://www.sublimetext.com/3" "blank" >}}
- Extract it to `/opt`: `tar vxjf sublime_text_3_build_3143_x64.tar.bz2 -C /opt/`
- Link it so that it would be available through command line: `ln -s /opt/sublime_text_3/sublime_text /usr/bin/subl`

You can open sublime through the terminal using `subl` keyword.
