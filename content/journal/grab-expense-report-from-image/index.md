+++
author = "Daniel Cefram Ramirez"
tags = ["Go", "Tools"]
date = 2024-06-07T00:23:21+08:00
title = "Grabbing details from Grab Food activities screenshot"
description = "Extracting expenses from Grab Screenshots to a CSV for budget expense tracking"
slug = "grab-expense-report-from-image"
type = "journal"
draft = false
toc = false
+++

> Source code: [Github](https://github.com/dcefram/grabenah)

Since it was the end of the month, and I failed to record the expenses as we made them, I had to encode all of those data from apps like Grab to a spreadsheet for our family's budget tracking.

But considering that I dislike repetitive work, I decided to create a tool for it. This time, I used Go to create the CLI tool just because I'm learning in the context of web services.

## The Idea

The idea is that I would take screenshots of the grab app's Activities page, and then I would airdrop it off to my macbook. I would then proceed to run the CLI tool to extract those details over to a CSV file.

Pretty simple and straightforward, considering no R&D has to be done on my end. There's already years of research done for the opensource OCR called as [Tesseract](https://github.com/tesseract-ocr/tessdoc) which made things super easy for me to implement my idea.

All I had to implement is the logic to determine which text is useful, and which is not. Saving to a CSV is done using Go's standard library, which was pretty straight forward to use... Just pass in a slice of slices and call it a day.

Here's how I use it:

<video width="100%" autoplay muted controls>
  <source src="grabenah-demo.mp4" type="video/mp4">
</video>

Pretty straightforward.

## Conclusion

Go is a super simple language that one can get into within a couple of hours and be productive to the point that you can actually deliver value.

However, I'm not a huge fan of its overly simplistic features. I might try out writing CLI tools in Swift in the future instead.

Oh, and tesseract is packaged in a way that it's pretty straightforward to use. The tool that I made is 99% done by tesseract, and the only implementation I had to do is how to make sense of the text, extract it in a way that makes sense in the context of budget tracking.
