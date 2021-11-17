+++
author = "Daniel Cefram Ramirez"
tags = ["toys"]
date = 2020-07-03T09:31:25+08:00
description = ""
draft = false
linktitle = ""
title = "Generate TS Interfaces from JSON or XML"
type = "toys"

+++

While working on XJS 3, I had to frequently parse the XML strings that the XBC core is sending to me, and then create an interface for TS so that tslint would stop complaining my use of any.

With that, I created a tool to automatically generate the interfaces for me, along with a JSON output just so that I can inspect how the XML would look like when parsed.

Link: https://ts-interface-from-json.vercel.app/
