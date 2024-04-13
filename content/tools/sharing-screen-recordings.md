+++
author = "Daniel Cefram Ramirez"
tags = ["JavaScript"]
date = 2022-12-25T00:00:00Z
title = "Sharing Screen Recordings with Kap"
description = "In a quest to minimize recurring subscription expenses, I made a plugin for Kap."
type = "toys"
+++

I've been a long-time [CleanShot](https://cleanshot.cloud) user turned CleanShot **Cloud** user, but recently, I've been trying to clamp down on my online subscriptions. With that, I'm trying to look for alternatives to the current tools I use, although it does not need to be a free alternative. I'm aiming to cut down the monthly costs, so I'm just fine with software that would charge for a one-time payment with free updates for at least a year.

The alternative to CleanShot is [Shottr](https://shottr.cc) for screenshots and [Kap](https://getkap.co) for screen recordings. I'm fine with Shottr as it is, as sharing screenshots using the clipboard is more than enough nowadays. However, it isn't the same with screen recordings, wherein I couldn't *paste* GIFs to Jira when my recordings are quite long.

Fortunately, Kap has a plugin system that should help us upload files to a cloud storage. What's unfortunate though is that there is no existing plugin to upload the files to Google Cloud Storage.

My blog is hosted in GCP, so it makes sense to just use GCS for the screen recording uploads. With that, I decided to create the plugin myself.

## The Acceptance Criteria

My objective is to have a very similar workflow as to what I had using CleanShot:
- After doing the recording, I get to either save the recording locally or choose to upload it to the internet.
- After uploading is done, it should automatically save the URL to my clipboard, ready for sharing with others.

## The Implementation

The first thing I did was figure out how to upload files to GCS using Node.js. This was simple, as Google's docs had examples for just that, and unlike AWS S3, GCS has a helper method that encapsulates the stream-related logic, so the API is as simple as `upload(filePath)`.

```javascript
const { Storage } = require("@google-cloud/storage");

const main = async () => {
  const storage = new Storage({
    keyFilename: path.join('some', 'path', 'to', 'keyfile.json'),
  });
  const bucket = storage.bucket('some-bucket');
  const [file] = await bucket.upload(
    path.join('path', 'to', 'file'),
    { public: true }
  );
  console.log(file.publicUrl());
};

main();
```

After verifying that this worked, I went ahead and copied [kap-s3](https://github.com/SamVerschueren/kap-s3)'s approach, and just modified it to use GCS instead.

Some key things that the end-user has to provide:
- path to the keyfile
- the bucket name
- I also am asking for the project ID, but this might not actually be required

The end code is very similar to the test code I made, just that the keyfile, bucket name, and the file to upload are all provided by Kap. Kap uses the context approach to *share* that information to the plugin.

```javascript
// the screen rec file created by Kap
const filePath = await ctx.filePath();

// getting values that the user provided
const keyFilename = ctx.config.get("keyFilename");

// copying values to the clipboard
ctx.copyToClipboard(publicUrl);

// showing some notification
ctx.notify("Google Cloud Storage Public URL copied to clipboard");
```

See the full source code here: https://github.com/dcefram/kap-gcs

## Sharing with custom URL

I'm currently using `share.rmrz.ph` for CleanShot and I do not want my existing links to stop working, so the alternative is to create a new bucket called `shr.rmrz.ph` and use CNAME for GCS to automatically handle the subdomain routing.

However, I also wanted to know how many people would open my shared screen recordings.

One option I thought of was to create a GCP Cloud Functions that would proxy the upload by creating signed URLs for upload, and at the same time, saving the file name to a database. I would then create a separate frontend that would use that record to know if the recording is valid, and save the stats to the specific record.

But another genius idea that popped in my head while driving was to simply use my blog instead. I would create a separate page that would load the image or video using javascript and URLSearchParams.

The URL would be something like [https://rmrz.ph/share/?n=Kapture%202023-01-08%20at%2015.40.41.webm](https://rmrz.ph/share/?n=Kapture%202023-01-08%20at%2015.40.41.webm), and the JavaScript in that page would check for the URLSearchParams, get the value of `n`, and check if the extension is a video or an image.

```javascript
const params = new URLSearchParams(document.location.search);
const fileName = params.get('n');

if (fileName) {
  const header = document.getElementById('shared-asset-title');
  header.textContent = fileName;

  const isVideo = /(\.mp4|\.webm|\.apng)$/ig.test(fileName);
  const file = '{{ .Site.Params.Info.shareBaseUrl }}' + fileName;

  // check if file exists
  const elem = document.createElement(isVideo ? 'video' : 'img');
  const handleOnLoad = () => {
    const container = document.getElementById('shared-asset-container');
    container.appendChild(elem);
  };

  elem.addEventListener('error', () => { console.error('target asset does not exist :D') });
  elem.addEventListener('loadeddata', handleOnLoad);
  elem.addEventListener('load', handleOnLoad);
  elem.setAttribute('src', file);

  if (isVideo) {
    elem.setAttribute('controls', 'true');
  }
}
```

I would then use an image tag or a video tag to load the asset.

This would mean that I can reuse [GoatCounter](http://goatcounter.com) for my analytics, with the added benefit of ignoring my own IP address.

![GoatCounter screenshot](https://storage.googleapis.com/rmrz-blog.appspot.com/SCR-20230109-vim.png)

Although not as pretty as CleanShot's dashboard, it's pretty functional and does what I exactly need.

## Final Thoughts

With that small project done, I am able to trim my monthly expense, from $8 to $0.22... Cents that I already spend for my blog (Google Cloud DNS) anyways.

## Edit

I'll have to be completely honest though, I still prefer CleanShot's features over Kap, and thus, I ended up relying on my own OneDrive account for
sharing screen recordings. One surprising thing though is that OneDrive got a pretty decent video player.