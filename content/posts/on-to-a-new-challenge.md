+++
author = "Daniel Cefram Ramirez"
tags = ["life"]
date = 2018-09-11T12:31:38+08:00
description = "Why I left a great job at XSplit, a company that I felt as the golden standard of how employers should be."
draft = false
linktitle = ""
title = "On to a new challenge"
type = "post"

+++

I've been working for [SplitmediaLabs](https://www.splitmedialabs.com/) for the past 4 years. To be honest, I always thought that I would stick with SplitmediaLabs for longer than my previous work, possibly till I am too old to work, as this company was the best company I had ever worked for. But alas, times had changed, and my current situation made another offer look a lot more attractive that I decided to take a leap of fate and grabbed the opportunity.

Looking back, it's been a wild 4 years ride. From being a stiff corporate employee into a loose startup-_ish_ shorts wearing developer.

## Why I loved SplitmediaLabs

[I used to work for Fujitsu Ten](https://rmrz.ph/posts/when-i-used-to-work-for-fujitsu-ten/), and although they provided me great opportunities like going to multiple business trips to Japan, **Fujitsu Ten** **is in fact a Japanese corporation**. With that came the strict dress code, strict working hours, and frequent overtimes. You know, what Japanese people normally do.

So when I first joined SplitmediaLabs, it felt like freedom. There were no dress codes, as in I could wear shorts and slippers to work, the time-in/out was super flexible, and we could even play games in the office. We had free dinner, a ping-pong table, and we could bring toys to work... I mean, a girl named Ira even brought her skateboard to work when I first started working there.

Unlike in Fujitsu, where I was just one of the almost thousands of employees, I felt that I was really appreciated and that I had somewhat of an impact on the end product. Here are a few of the projects that I was involved in:

### [Player.me](https://player.me/)

I mainly worked on the desktop application and the video editor. This is where I did a deep dive on most of the &quot;native&quot; functionalities of our C++ shell.

It was an eye opening experience that I [made a talk about it](https://blog.rmrz.ph/javascript-for-desktop-my-presentation-in-feu/), mainly criticizing the fact that frontend developers really care for the aesthetics but usually disregards the _costs_ of their desired &quot;behavior&quot;. One example here is... did you know that the CSS transform scale eats up a lot of CPU juice? We had an animation that would scale an element for our loading indicator, and that made our app take 10% more CPU usage! That's a lot!

Since the desktop app would be hooked to a game, we wanted to minimize the impact of the desktop app's resource consumption so that the gameplay would go on smoothly like as if the desktop app did not exist at all.

### [XSplit Broadcaster](https://www.xsplit.com/broadcaster)

#### Plugins

I worked on multiple plugins that people actually use nowadays, like the YouTube chat, ExtraLife alerts, track.tl, Audio Visualizer, etc.

I honestly had a great time when I was tasked to create plugins, mainly due to the technical freedom I had on choosing what stack to use. I usually took the opportunity to learn a new thing or two each time a new plugin was to be developed.

#### Plugin Store

This was my first &quot;big&quot; React app. It was pretty exciting, and looking back, it somewhat prepared me to work on larger React projects.

#### Video Editor

I was the one who kickstarted the video editor project, although I did have trouble on making the app performant due to my approach on rendering the ruler. I was able to learn a lot of things during my work here, as someone senior jumped in and helped me solve multiple issues that I was having. We ended up switching over to Polymer, due to its advertised advantages. I have to note that we were one of the very early adopters of Polymer, jumping in during its 0.3 version.

#### XJS Framework

This is one of my first open source project, and the first in TypeScript. We were an early adopter of TypeScript, to the point that when I left the project, the version of TypeScript was so outdated that TypeScript projects had to use the compiled version instead of directly using the .ts files.

This is also where I made a deep dive onto Dgeni, to create a [beautiful functional API documentation](https://xjsframework.github.io/api.html) based off the actual XJS source code. But, due to my lack of doing proper documentation on my adventures in Dgeni land, I am not super sure as to how to maintain the documentation to make it work with the latest TypeScript versions, unless I actually spend time digging through the source code again. I'm thinking that we should move on to Slate instead, and manually write the .md files...

This project also gave me the opportunity to experience San Fransisco for the first time ever. It was a surreal experience, and my memories just feel like it was just a dream.

{{< img-post "date" "TwitchCon2015-219-1.jpg" "twitchcon" >}}
Me and our CEO, Henrik, giving a presentation about XJS Framework at TwitchCon

{{< img-post "date" "TwitchCon2015-353.jpg" "twitchcon" >}}

{{< img-post "date" "gatebridge.jpg" "twitchcon" >}}
I even took a long walk just to get to see this in person

### XSplit Gamecaster

This was the first project that I jumped into upon joining SplitmediaLabs, and was the first project that I had my hands on that got released to the public with multiple articles written about it.

Although I maintained XSplit Gamecaster for quite some time, I was transferred to XSplit Broadcaster's plugin team for the majority of my stay before I was again transferred to Player.me.

So aside from the projects, I also loved SplitmediaLabs due to how the company treated me.

When I was at TwitchCon presenting XJS Framework, I had a severe migraine that I thought was a stroke. I could barely move my hands, my left foot, and I talk in a very slow motion. I was also hearing a white thinning noise on my left ear. They brought me to the hospital, and all expenses were... guess who paid for my hospital admission? Henrik! Our CEO! He personally came to the hospital, paid for the initial downpayment, and booked an Uber for me so that I could rest at the hotel.

{{< img-post "date" "TwitchCon2015-221.jpg" "twitchcon" >}}
Me, with Henrik, on our presentation while my migraine is killing me

{{< img-post "date" "hospital.jpg" "twitchcon" >}}
This painful experience costs $2000 for just 4 hours right after the presentation ended.

Our COO, Andreas, then proceeded to take care of the remaining $2000 for my 4 hour stay at the emergency room.

I also loved the fact that I was one of the very few employees that consistently got double digit percent raises every year. To be honest, it wasn't about the money. It's more of the feeling that me and my work was greatly appreciated by the company. This was something that I really needed, as a person who does not have any bachelors degree to show for it.

### Why I left SplitmediaLabs

I'd rather not write any disparaging words in my blog, but yes, during my stint at the Player.me project, I encountered some teammates that are higher in position than me, that just made a negative impact on my performance, my inferiority complex issues, and just overall made working there a little too stressful and belittling to myself. No, I'm not talking about Makara Sok, who is an awesome mentor, that is if ever I could get him to mentor me. His code reviews made a lot of sense, and I learned a lot on our interactions through code review. I can just imagine how much more I would've learned if he was my mentor.

I'd like to style myself as a person who can hold my anger, and show kindness to others, but oh boy, looking back during those days, I was really on the edge. It's hard to work well when you're bottling up your negative feelings.

But that wasn't enough for me to look for another job. Another straw was the _&quot;failure&quot;_ of my project, Player.me desktop app. People might say that the project did reach the masses and people are using it... but I'm totally aware of the fact that it did not hit deadlines, and it did not hit the expectations in terms of adoption.

That reinforced my negative outlook in myself, and me being the main developer of the desktop app, I felt responsible for the lackluster adoption rate. I felt that my seat-mate, JC, was a better developer than I am, and he should take over the lead of whatever would be the next big project.

However, I had my doubts if looking for another job is the right decision to make. I mean, I always improved on every _stumble_ I encountered at SplitmediaLabs. The company is a really great place to grow professionally.

But then came a call. An offer that I would get to work remotely, which just fits with the fact that I was expecting my first daughter (who was born last month!). Another perk was the fact that they would be providing me with a laptop, and they will pay for my internet connection. The salary is also around 35% higher.

It was too much a good offer to decline, considering how the past few months went at work.

### Conclusion

So, all in all, I'm excited on working on a fresh new project, and at the same time, I'm quite sad for leaving such a great company that served as a gold standard for how companies should handle their employees.

Looking back, if it wasn't for the experience that I got on the past few months that got me to doubt myself again, I would have not even considered entertaining the job offer.

As all is said and done, today is the first day of my great leap to the unknown. I hope I can make this stint better than before, and apply whatever I learned from the past few years.
