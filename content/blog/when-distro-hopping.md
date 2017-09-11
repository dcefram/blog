+++
author = "Daniel Cefram Ramirez"
categories = ["Nerd Diary"]
date = 2017-04-24T11:21:03Z
description = "Instructions to create bootable linux flash drives in Windows and in Linux, along with how to reuse/revert the flash drive."
draft = false
slug = "when-distro-hopping"
tags = ["Nerd Diary"]
title = "When distro hopping..."
type = "post"

+++

So I've been distro hopping for the past couple of weeks, and I _always_ googled how to format my boot drive and then write an ISO to my flash drive as bootable (boot-able, I'm getting a wrong spelling indicator with the "bootable" word XD) USB drive. Since I did that very frequently lately, I thought of just adding a blog post that would serve as my notes/reminder.

## Formatting Boot-able USB

You won't be able to detect a boot-able flash drive in Linux (ie. in Nautilus or Dolphin), while in Windows, Explorer would only show a very small portion of it. My flash drive is a 16GB flash drive, but Windows Explorer only lists it as a 5.12MB drive. In order to re-use the flash drive, we'll be using the terminal for both Linux and Windows... Here are the steps:

#### In Linux

1. Execute `lsblk -l`
This should list all your drives, including your flash drive with the corresponding "original" disk space. It would usually be sd**X** (**X** here is a variable, your flash drive might be listed as _sda_ or _sdb_, etc.)

2. Execute `sudo dd if=/dev/zero of=/dev/sdX bs=4k && sync` (replace X again)

3. Execute `sudo fdisk /dev/sdX`
Just press `o` to create a new empty DOS partition table.

4. Press `n` to create a new partition. Just use the default options (ie. create a new primary partition, with the size as the whole flash drive's space)

5. Execute `lsblk -l` again, you should see a new partition under your drive (ex. sdX1)

6. Execute `sudo mkfs.vfat /dev/sdX1` (replace X) to format it, and then eject your drive :) (`sudo eject /dev/sdX`)

#### In Windows

1. Execute `diskpart`

2. Execute `list disk`
This should list all drives connected to your computer. Select the drive that has the same disk space as your flash drive. We will call that as `disk X` for the sake of this post.

3. Execute `select disk X`

4. Next, execute `clean`

5. And then let's create a partition using `create partition primary`.

6. Open up the explorer, navigate to your flash drive, and then Format the drive :)

## Creating a boot-able Linux flash drive

#### In Linux

1. Execute `lsblk -l` to get the correct drive name

2. Then we have to write the iso to the flash drive:
```shell
# umount /dev/sdX
# dd if=/path/to/downloaded.iso of=/dev/sdX bs=4M status=progress && sync
```

#### In Windows

I personally use [Rufus](https://rufus.akeo.ie/), because we would still need to download cygwin to do this in the command line. Since I'm going to download something extra anyways, I'd rather go for the easier route.