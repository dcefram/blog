+++
author = "Daniel Cefram Ramirez"
tags = ["toys"]
date = 2022-01-10T00:00:00Z
title = "Sharing Screen Recordings"
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

## What's next

I'm planning to create some small Google Cloud Function (or just do it through firebase) that would simply map the filenames to the relevant file in Google Cloud Storage. The purpose of this is so that I won't be sharing some ugly-long GCS public URL, but instead, I would be sharing a URL that would be similar to what I'm currently sharing when I use CleanShot.

So instead of: `https://storage.googleapis.com/rmrz-blog.appspot.com/Kapture%202022-12-26%20at%2001.53.40.gif`

I would want it to be: `https://share.rmrz.ph/Kapture%202022-12-26%20at%2001.53.40.gif`

That should be neater :)