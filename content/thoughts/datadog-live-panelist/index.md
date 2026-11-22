+++
author = "Daniel Cefram Ramirez"
tags = ["Career", "Journal"]
date = 2026-11-22T21:51:26+08:00
title = "Unexpectedly, a Panelist at Datadog Live"
description = "Five days to prepare for a panel I never expected to join."
slug = "datadog-live-panelist"
type = "post"
draft = false
toc = false
+++

{{< img-proc "images/dd2026-1.jpg" "Resize" "1000x" >}}

Five days.

That's how much notice I got before sitting on a panel at [Datadog LIVE Philippines 2026](https://events.datadoghq.com/events/datadog-live-philippines-2026) last October 20th.

It wasn't something I planned for. My former boss was supposed to be one of the panelists, but something came up and he couldn't make it. So he asked me to take his place.

To be honest, the short notice didn't bother me much. I usually just grab opportunities when they come up. You know, maybe something life changing for the better is hidden somewhere out there XD.

But a couple of things did make me pause.

# The Stand-In

The first was the timing. Over in Digital Channels at Security Bank, we've been taking a hard look at our observability setup lately, including the tools we use and what they cost us. So getting invited to talk on stage at a _Datadog_ event felt... a little awkward.

I was upfront with the Datadog folks about it. They knew where we stood, and they still wanted me up there.

The second was the lineup.

A CEO. A CTO. And me.

I started wondering what I was walking into. Would it be all business strategy and boardroom decisions? Would there be room for someone whose days are spent on deployments, incidents, and figuring out why a certain API suddenly got slower?

It wasn't really about the titles. I just wasn't sure my stories would fit.

I said yes anyway.

# Homework

Thankfully, Datadog sent the discussion questions ahead of time.

I read through them expecting executive-level stuff. Instead, they were things I deal with every week. Things I could talk about from experience instead of theory. I didn't have to sound like a CEO or a CTO. I could just sound like an engineer.

Which, honestly, made me want to wing it.

I mean, these were questions about my day job. How hard could it be?

Two days before the event, I finally made some time to sit down and think through some witty answer for each question. Looking back, that was a good call. Not because I needed to memorize anything, but because _knowing_ something and _explaining_ it to a room full of strangers are two very different things.

One of the questions was about how observability helps make sure the features we ship actually work. And that got me thinking: what do we even mean when we say a feature _works_?

# Working Isn't Enough

For engineers, a feature works when it behaves according to spec. The APIs return what they should, transactions go through, and there are no errors in the logs.

Customers don't see any of that.

Picture this. You're in line to pay for parking. You open your banking app, scan the QR code, and wait.

And wait.

At this point, I would be sweating profoundly.

Especially if there are people behind you. A few extra seconds suddenly feel like forever. So you close the app and open another one.

{{< img-proc "images/parking-queue.png" "Resize" "500x" >}}

That's the reality of digital banking today. Switching apps for a single transaction costs the customer almost nothing. They don't care that our APIs returned a 200 or that our servers are healthy. They care about getting out of the queue.

**A successful transaction isn't the same as a good experience.**

That's where observability earns its keep. It tells us not just _whether_ something works, but _how well_ it works for the person holding the phone.

Writing that example down did more for me than any talking point. It gave me a bridge between the technical stuff I know and the customer and business outcomes that everyone else on the panel cared about.

# On Stage

Surprisingly, I wasn't nervous when the day came.

We had a rehearsal beforehand, and I tried out the parking example. The moderator liked it. Liked it enough to tell me to bring it up during the actual panel.

Not bad for the guy who was worried he wouldn't fit in.

{{< img-proc "images/dd2026-2.jpg" "Resize" "400x" >}}

And I did get to tell it on stage, although everything's a blur at this point. The moderator helped a lot at making things feel natural. It was just like as if we were just having a casual conversation at the sides.

# Three Ways of Looking at It

I usually think of observability as metrics, logs, traces, and dashboards. Is the app fast? Is it up?

Is the thing we just deployed behaving?

The other two panelists stretched that.

The CEO of Telly Systems, Inc. mentioned that he keeps an eye on social media to see what customers are saying. Simple, but it stuck with me. Our dashboards can say a transaction was successful while a customer is posting about how slow the app was. Sometimes the first alert doesn't come from a monitor. It comes from a frustrated post.

The CTO of Modulus Labs talked about how consolidating their tooling into Datadog helped their teams react faster. That one hit close to home. Having the data is one thing. Connecting the dots quickly, without jumping between five different tools in the middle of an incident, is another.

So there we were, three people looking at the same thing from different angles:

- For me, it was making sure features don't just work, but actually feel good to use.
- For the CTO, it was giving engineers the visibility to find and fix problems fast.
- For the CEO, it went beyond the app entirely, to what customers were saying out loud.

Different starting points. Same goal: know what's happening, figure out what needs attention, and make better decisions because of it.

# Looking Back

Five days of notice, a slightly awkward invite, and a nagging worry that an engineer wouldn't belong on a panel with a CEO and a CTO.

Turns out, the differences were the whole point. The conversation worked _because_ we weren't all talking at the same altitude. Knowing how a system works matters. So does knowing how it affects customers and the business. The good stuff happens when those two meet.
I'm glad I said yes.

Next time, though, I'll probably use more than two of the five days to prepare.

{{< img-proc "images/dd2026-3.jpg" "Resize" "1000x" >}}

