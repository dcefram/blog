+++
author = "Daniel Cefram Ramirez"
tags = ["toys"]
date = 2018-09-18T09:31:25+08:00
description = ""
draft = false
linktitle = ""
title = "Image Resizing in CLI"
type = "toys"

+++

For the past few weeks, I was looking for a new compiled language that I can make use of for my tools as I grew tired of Go language's verbosity. I tried learning Rust, but as I expected, it was more suited for system projects, and found out how much pain it could be for smaller tools due to how strict the compiler is.

With that, I eyed for both Nim and Crystal language, with the latter prevailing as my language of choice for my personal tools. The first project I thought of using Crystal on was my image resizer CLI tool that I would use for the images that I would eventually upload to my blog(s).

Here's the Github Repo of my project: [iresize](https://github.com/dcefram/iresize) (tagalog word of resize something)

### The idea

I already had in mind a particular usecase for my tool:

- It should be able to resize a bunch of files inside a directory or resize a specific file
- It should be able to resize the image while preserving the aspect ratio IF one of the dimensions is not provided (ie. If width is only given, height should automatically scale preserving the original aspect ratio)
- It would be great if I can watch a folder for new files added into it, and automatically resize them and place them to the output folder.

With that, the command should be like:

```bash
$ iresize --input="./" --output="../output/" --height=720 --watch
$ # or the short-form of the flags
$ iresize -I "./" -O "../output" -H 720 --watch
```

### Implementation

Crystal language provides tools that makes scaffolding a project really easy, similar to Rust and Nim's tooling: `crystal init app iresize #iresize is the app name`

The next step was to try out how Crystal handles arguments, or better yet, if they have a Flags parser in their standard library (Like Go's Flag library)... And yes, [they do have](https://crystal-lang.org/api/0.26.1/OptionParser.html), and a better flag parser than Go at that :)

I thought of making the main file the Go language way (wherein the only purpose of the main file is to glue things together), wherein we usually handle CLI arguments at the entry file.

Unlike Go, we do not need any "main" function, and all I did was copy paste the example code in the OptionParser API documentation to my entry file, and got everything working:

```ruby
require "option_parser"

input_path = "./"
output_path = "./output"
height = nil
width = nil
watch = false

OptionParser.parse! do |parser|
  parser.banner = "Usage: iresize [-i <PATH>] [-o <PATH>] [-h <SIZE>]"
  parser.on("-I PATH", "--input=PATH", "Path to the folder filled with images, or Path to the target image") { |path| input_path = path }
  parser.on("-O PATH", "--output=PATH", "Path to the output folder") { |path| output_path = path }
  parser.on("-H SIZE", "--height=SIZE", "Target height") { |size| height = size }
  parser.on("-W SIZE", "--width=SIZE", "Target width") { |size| width = size }
  parser.on("--watch", "Watch folder") { watch = true }
  parser.on("-h", "--help", "Show this help") { puts parser }
end

puts {
  :input_path  => input_path,
  :output_path => output_path,
  :height      => height,
  :width       => width,
}
```

All looks good so far. The next step was to create a class that would consume the Hash map that contains all the needed info.

I won't get into details on how I implemented the whole class, as you can check it out in the Github repository that I linked above.

The idea was that I would have to check if `:input_path` is a directory or not by using `File.info(path, true)`. That method returns a `File::Type`, which is an Enum that has all the properties that I need:

```ruby
File::Type::Directory
File::Type::File
File::Type::Unknown
```

I return `File::Type::Unknown` for files that isn't either a Directory, a Symlink, or a File.

The next step is to filter out the files that aren't images. All I did was create an array that holds the "valid" image file extensions (`File.extname(path)`), and then iterated through the files list (`Dir.children(path)`).

Now comes the magic part... To resize the images, I used a magick wand, no really, I used [ImageMagick](https://www.imagemagick.org/api/magick-image.php). Fortunately, someone already made a Crystal language binding for that C language library: [magickwand-crystal](https://github.com/blocknotes/magickwand-crystal).

I just glued the exposed API, which includes writing a new image.

As for implementing the watcher, all I made use of is `spawn`, `blocks`, and a forever `loop`. I save the "already" processed images to an array (which is stored in the heap), but this approach does not persist when you stop the process and run it again. I might think of creating a text file as a cache? Not sure if that's a good idea, but I'll like to create something like a redis for caching stuff so that the list of processed image persists even after you end the process.

### Conclusion

I'm not a Ruby developer, and even without reading a proper book aside from the official documentation, I felt that the language is easy to get into, without stripping down the language features like Go.

The tool that I made is pretty small, so the compile times is not that big of a deal, but I am aware that this is an issue that exists within the community. However, as long as this issue is still a thing, I'll stick onto writing small things, and even if I experiment using this for creating the backend of a website, I would go through the microservices route.

One thing that I think should be implemented before Crystal can be version 1 is auto scaling across multiple threads. The current exposed API of Crystal's green threads is quite neat, and I would like it to remain that way. It would be great if that same code would simply work out of the box once Crystal gets parallelism working.
