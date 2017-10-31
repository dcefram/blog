+++
author = "Daniel Cefram Ramirez"
tags = ["Geek-ism"]
date = 2017-05-29T06:26:05Z
description = ""
draft = false
featured = "arch.png"
featuredalt = ""
featuredpath = "date"
linktitle = ""
slug = "my-notes-in-setting-up-arch"
title = "My notes in setting up Arch"
type = "post"

+++

I'm aware that there are many many articles on how to setup Arch Linux, with the official Wiki as the best one to check out first.

I just documented my experience on setting up Arch with the objective that I should be able replicate the same setup and environment on other Computers if needed.

### Install Reflector

This is so that we would use the fastest server in our mirrorlist

```
pacman -Syy
pacman -S reflector
```

After installation:
```
reflector -c "Philippines" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
```

### Partition the Hard drive

To check the current partition/hard drives
```
fdisk -l
```
To partition the disk, wherein `/dev/sda` is the actual path of the disk as stated in `fdisk -l`
```
chdisk /dev/sda
```

If ever we're going to have only Arch in the machine, then it's safe to delete whatever partition there is and then create a new one. Make it primary and bootable. Don't forget to Write the changes before quitting.

Your partition would most likely be `/dev/sda1`, but just to make sure, use `fdisk -l` again to list all your disks and partitions.

We'll have to change the filesystem of the partition. To do that, execute the following:

```
mkfs.ext4 /dev/sda1
```

### Mount the Hard drive

```
mount /dev/sda1 /mnt
```

Verify the drive that we mounted

```
lsblk
```

### Install the base system

```
pacstrap -i /mnt base base-devel
```

### Generate fstab file

```
genfstab -U -p /mnt >> /mnt/etc/fstab
```

### Login to our system in root

```
arch-chroot /mnt /bin/bash
```

### Set the locale of the system

```
vim /etc/locale.gen
```

Remove the comment sign (`#`) of the locale that you'll be using... I usually use `en_US.UTF-8 UTF-8`

Then generate the locale:

```
locale-gen
```

### Set the time

```
ln -sf /usr/share/zoneinfo/Asia/Hongkong /etc/localtime
hwclock --systohc --utc
```

### Set the computer name

```
echo daraworld > /etc/hostname
vim /etc/hosts
```

Add the following line to the host file:

```
127.0.1.1  localhost.localdomain  daraworld
```

### Enable the network service

```
systemctl enable dhcpcd
```

### Setup your password

```
passwd
```

### Install bootloader group

```
pacman -S grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

We're almost done, let's `exit` the root, and then unmount the partition... and then reboot

```
exit
umount -R /mnt
reboot
```

### Create your user

Using the root user isn't ideal at all. So we'll have to create a user:

```
useradd -m -g users -G wheel -s /bin/bash dcefram
passwd dcefram
EDITOR=vim visudo
```

Find the line `wheel All=(ALL) ALL`, and uncomment that. Now, try logging in using your new account.

### Install audio packages

```
sudo pacman -S pulseaudio pulseaudio-alsa
```

### Install i3 display manager with XOrg

```
pacman -S i3 dmenu xorg xorg-xinit
echo "exec i3" > ~/.xinitrc
```

That's about it :)