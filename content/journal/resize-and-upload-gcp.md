+++
author = "Daniel Cefram Ramirez"
tags = ["Fish", "Tools"]
date = 2023-07-23T23:38:35+08:00
title = "Resizing images and uploading to GCP Storage"
description = "A simple script to upload images that are blog-friendly"
type = "toys"
draft = false
aliases = ['/posts/resize-and-upload-gcp']

+++

I am currently using GCS for the images in my blog, and I usually never resized images before uploading them to the bucket. I always thought that everything would be handled for me once I upload images to the bucket, thinking that there was already a built-in CDN on top of GCS.

This resulted in a couple of my blog posts loading large images that take quite some time to fully load.

I’ll manually set up Google CDN for my blog, but apart from that, I’ll make it a habit to resize my images down to a maximum of 1,200 pixels, either width or height, preserving the aspect ratio.

## Resizing the image

I did some research on a couple of ways to resize images (aside: I created a tool for resizing images a few years back, but that was during the time I was using Linux as my daily driver), and found out that MacOS already had one built-in called as `sips`, with the usage as:

```fish
sips -Z 1200 $file -o $output

# example
sips -Z 1200 ~/Pictures/a-huge-image.jpeg -o ~/Pictures/blog/a-huge-image.jpeg
```

It just works without much fanfare, so I’ll stick to this for a while until I find a reason not to. An alternative that I’d like to explore sometime in the future is [pngquant](https://github.com/kornelski/pngquant), which optimizes the image somehow.

## Uploading to GCS

I use `gcloud` command to upload files to my google cloud storage bucket with the following command:

```fish
gcloud storage cp ~/Pictures/blog/$file gs://$bucket
```

It’s pretty straightforward too.

## Packaging it all up

But to take it a step further, saving me extra keypresses moving forward, I decided to wrap these all up in a fish function. The idea would be:

```mermaid
flowchart LR
    A(Resize image) --> B(Upload to GCP)
    B --> C(Copy link to clipboard)
```

Creating fish functions was straightforward as I’ve done a couple already before. What was new was figuring out how to:
- get the named arguments/flags
- verify if the variable exists
- use a fallback value if the variable is empty

To get values passed in flags, we could use `argparse`. I only wanted to support two flags: output and input.
```fish
argparse 'i/image'= 'o/output'= -- $argv
```

To access those flags, we use a predefined `$_flag_` local variable, prefixed with the flag name.
```fish
echo $_flag_i # for the i/image flag
echo $_flag_o # for the o/output flag
```

Now, what I wanted is that the input should be *required*, while the output would be optional, falling back to the input value if it does not exist. Unfortunately, I haven’t yet figured out how to define default values for these flags, so I ended up using if statements:
```fish
if test -z $_flag_i
  echo "Missing -i, please specify which image to share"
  return 1
end

# set output default value as the -o flag value
set -l output $_flag_o

# if output (which uses -o flag value) is empty, then we use -i flag's value
if test -z "$output"
  set output $_flag_i
end
```

Next, I use the two commands I shared earlier: resize -> upload:
```fish
# resize image and save to ~/Pictures/blog/
sips -Z 1200 $_flag_i -o ~/Pictures/blog/$output

# we upload to gcp
gcloud storage cp ~/Pictures/blog/$output gs://$bucket
```

Lastly, we copy it to the clipboard:
```fish
echo "https://storage.googleapis.com/$bucket/$output" | pbcopy
```

The link is now in your clipboard and ready to be pasted to the blog post.

## Final code

```fish
function shareimg
  argparse 'i/image'= 'o/output'= -- $argv

  if test -z $_flag_i
    echo "Missing -i, please specify which image to share"
    return 1
  end

  set -l output $_flag_o

  if test -z "$output"
    set output $_flag_i
  end

  # resize image and save to ~/Pictures/blog/
  sips -Z 1200 $_flag_i -o ~/Pictures/blog/$output

  # we upload to gcp
  gcloud storage cp ~/Pictures/blog/$output gs://$bucket

  # copy to clipboard
  echo "https://storage.googleapis.com/$bucket/$output" | pbcopy
end
```

Here's some demonstration of it's actual usage:

![](http://storage.googleapis.com/rmrz-blog.appspot.com/snippet-shareimg-usage.gif)

Aaand, this is the image that I uploaded using the script :)

![Here's the resized sample image I uploaded](https://storage.googleapis.com/rmrz-blog.appspot.com/TwitchCon2015-13.jpg)
