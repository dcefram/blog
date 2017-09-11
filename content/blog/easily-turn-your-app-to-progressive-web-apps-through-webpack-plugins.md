+++
author = "Daniel Cefram Ramirez"
categories = ["Programming", "Nerd Diary"]
date = 2017-03-18T03:26:00Z
description = ""
draft = false
slug = "easily-turn-your-app-to-progressive-web-apps-through-webpack-plugins"
tags = ["Programming", "Nerd Diary"]
title = "Easily turn your app to Progressive Web Apps through webpack plugins"
type = "post"

+++

If ever we wanted our WebApp available even if the user does not have any internet connection, we would need to use service workers. But the thing with service workers is that they're not "easy" to implement. It's a good thing though that the GoogleChrome team released a node module that would generate the service worker code for your project: [sw-precache](https://github.com/GoogleChrome/sw-precache).

You can use that node module in your gulp file when building/bundling your app. But we all know that gulp isn't the cool kid in the block anymore since webpack came around... So here's what you can use if ever you're using webpack in your build process and you would rather avoid adding gulp or any other build scripts:

- **[sw-precache-webpack-plugin](https://www.npmjs.com/package/sw-precache-webpack-plugin)** - This makes use of Google's own sw-precache node module... so it's  a wrapper to get sw-precache to easily work in webpack as a plugin
- **[offline-plugin](https://github.com/NekR/offline-plugin)** - The much more popular webpack plugin. I'm not sure about sw-precache, but offline-plugin uses AppCache as a fallback for browsers that do not support Service Workers.

### My Take

I am using sw-precache-webpack-plugin for one of my projects, but my colleague suggested offline-plugin, and I'm a little sold to that plugin due to the fact that they specified their fallback in case the browser does not have support for Service Workers... So yeah, if you're using webpack on your build process, I'd suggest that you go for offline-plugin.