+++
author = "Daniel Cefram Ramirez"
tags = ["javascript", "react-native"]
date = 2019-07-29T07:50:21+08:00
description = ""
draft = false
linktitle = ""
title = "Impressions on Expo After Three Months"
type = "post"

+++


After three months of development using [expo](https://expo.io) for an MVP, I'd like to share some feedback on my experience on using the *managed platform*. Do note that my prior experience in react native before this project was just a month of R&D two years ago.

##  It's React for mobile

Since we use React for most of the frontend of our web applications, we thought that React Native would be the best choice as it would have less "barrier of entry" for the existing workforce, since we're already familiar with the syntax, concepts, and tooling of React.

This is mostly true, as the rules of the component lifecycle is still intact. However, it does take a getting used to, for there's no DOM in React Native. I expected that much, but what took some time adjusting is how flex boxes behave. It was supposed to be easier than how you do it in browsers, but I do have to note that the most striking behavior that I found is that using `flex: 1` would only work "as you expect" if the parent view has a specified height, or also has `flex: n`. This rule cascades up to the parent-most view.

Another pain point in React Native development is the lack of developer tools, ala inspect element... That would've been a godsend when I was trying to fix some issues that only happened on iOS devices (ex. border radius), and when system font sizes were large.

CSS is similar to CSS-in-JavaScript, although each components have their own set of "valid" stying properties. You'll have to mostly refer to the documentation, although it's safe to say that most of the styling properties in the View component are used by other components. There are obviously some special cases, which is why you'll have to refer to the docs most of the time.

#### Conclusion

Even though it is JavaScript, and is still React, you will still need to put your mobile app dev hat as most of the "quality of life" developer tools available for web frontend devs are not available here.

Hot reloading works though, but it's slow and sometimes could bug out your app and you'll have to force refresh it. Thus, the rule of the thumb here is to visualize everything in your head while jotting down the code just as you would've done as a "typical" systems engineer, and then only save to check out how the UI went.

## It helps you create beautiful apps fast, but...

React Native, which extends to expo, does help springboard your mobile app development. However, with expo, you're stuck with the APIs that they exposed in their SDK.

So if you're planning to create an app that would require you to create your own *under-the-hood* functionality, you'll have to eject expo, or just use React Native from scratch.

You cannot simply create your own custom Java code and then link it up with expo to "use" that custom code inside React Native. You need to `eject` in order to `link` custom native code.

#### Conclusion

If you're pretty sure that all you'll need are the APIs provided by the expo SDK, which is honestly plentiful, and all you wanted to is to focus on creating good looking apps within the boundary of the SDK, then expo could be a great toolset for you.

You'll have to remember though that you cannot use `react-native link`, ie. you cannot link native code. Some React Native packages in npm require you to `link` because they either also include some native code, or is dependent on another library that requires you to `link`. You cannot take advantage of those packages.

This is a pain on my end when I was trying to "standardize" the date-time picker used by both iOS and Android.

## You can build for both iOS and Android, with a caveat

The main reason why we went for expo was because we were a remote team and the only laptop that the company provided to me was a Windows laptop that I purged to install Linux in it. This means that I cannot build iOS apps without bothering our Project Manager or CEO (Since they're the only ones with Macs during the first 2 months of the project).

Expo allows you to offload the building process to their servers, and they can build for both Android and iOS.

> Side: You'll still need an apple developer account to build a .IPA (for iOS) package. You'll also still need a Mac with Xcode to upload that .IPA to TestFlight

You'll have to be aware of the long queue times though, for free expo accounts. We're still on a free account as we're **still** evaluating if it expo is the togo tool for our team/company. As the developer, I would have some say on this, and I'd say that the lack of `link`ing (as stated on the section above) is **VERY** limiting, so that would be a no to a paid expo account.

#### Conclusion

Although expo did accomplish the main reason for choosing expo on building iOS builds even on a linux machine; the fact that you would still need a mac to push the built .IPA file to TestFlight neutralizes expo's advantages. In the end of the day, I still ended up buying my own Macbook.

## It has a pretty nifty tool to launch the mobile app

This is the only area where expo truly excelled. The ability to simply scan a QR code, or send a link to a colleague to test your app with **real time changes** is pretty mind blowing. It's like sharing your own local server to a QA for testing, wherein they could see their feedbacks fixed in real time... Which used to be only possible (at least in the mainstream) in web development projects.

#### Conclusion

This feature is one of the features that I truly appreciated. However, this does not mean that this is not possible in just plain React Native. One thing is for sure though, expo gives this out of the box without much setup.

## The recommended navigation library is React Navigation

[React Navigation](https://reactnavigation.org/) is a great navigation library, but we do have to note some drawbacks. As the app that we developed grew larger, we noticed that the performance of the app degraded, and the performance issue was very evident when switching between screens. This is an issue that you could find plentiful information about, and with solutions suggested to improve the experience. I honestly would've liked to use [Wix's react native navigation](https://github.com/wix/react-native-navigation) as suggested by my former colleague as that was what he switched to after failing to optimize React Navigation to the level that our QA would accept in my previous employer.

I haven't done any deep digging on this matter, but I noticed that components does not unmount when switching away from screens. I'd like to *assume* that this would eventually cause performance issues depending on how many screens are "mounted" at a given time.

## Binary size

The last drawback in my list is the binary size. Expo's documentation did mention that, along with other reasons why not to use expo's managed workflow.

The final package would have the whole expo SDK even though some, if not most, of the APIs are unused in your app. In other words, you cannot create a "lean" package through expo managed package workflow.

### Others

It's good to read expo's [list of why not to use expo managed workflow](https://docs.expo.io/versions/latest/introduction/why-not-expo/) before jumping into expo. 

## Final Thoughts

Although I owe expo a lot to get the MVP done in record time, I wouldn't recommend this for future mobile app projects. The lack of `link`ing is a bummer and severely limits the extent that you could optimize your app.

Actually, I would want to test out Flutter, as I've *heard* good things about it.