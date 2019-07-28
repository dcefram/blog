+++
author = "Daniel Cefram Ramirez"
tags = ["node"]
date = 2019-03-04T14:10:06+08:00
description = ""
draft = false
linktitle = ""
title = "Structuring a NodeJS CLI Tool"
type = "post"

+++

I just thought that I'd share what I did on an internal CLI tool that allows others to **NOT** modify any existing files in the NodeJS CLI Tool project.

## The Problem

We thought of creating a tool that would streamline our development workflow by automating some tidious, manual, and repetitive tasks.

The first order of the game is to list down the possible "commands" that this CLI tool would handle, and what those commands would do. However, we realized that we might have the need to add additional commands further down the line for every "task" that we found as a boilerplate. With this thought in mind, I proceeded to think of a way that would allow us to simply create a new folder with the command's logic in that folder and have the CLI tool "read" that folder out of the box without having to modify any existing files.

{{< img-post "date" "adding-new-command.gif" "Add new command" >}}

As demonstrated in the GIF above, we would want to simply do a copy-paste, and then just modify that new folder's contents, and nothing else.

## The solution

The solution is to create a standard structure for the commands. Here's the folder structure of the command:

```bash
new-command-here
├── actions.js
└── index.js
```

The `index.js` file should contain the metadata of the command, and by that I meant that it should contain the command's keyword, description, and even the file that contains the "action" or logic. Here's a sample content of the `index.js` file:

```javascript
module.exports = {
  command: 'new <type> <project>',
  desc: 'Scaffold a project. Valid <type>: something or sumthing',
  options: [
    '--typescript',
    [
      '-N, --name <name>',
      'Specify project name. This defaults to string assigned to <project> param',
    ],
  ],
  action: require('./actions'), // Actions should have a function exported by default, and that function would get executed when this command is "called".
};
```

As you can see, we're requiring the `actions` file, which is simply a `.js` file that has all the logic as to what this command would do when called.

But before we go into details as to how we would read this metadata JS file, I should first list the libraries that I used for this ClI tool:

- [commander](https://github.com/tj/commander.js/)
- And nothing else but the standard NodeJS API :D

Now, we should create the part of the CLI tool that we would rarely (and as much as possible, never) update: The entry file that should read all the available commands and execute them accordingly.

So the idea is that the CLI tool's entry file should read the contents of the folder that contains all the commands, open up their metadata file (`index.js`), and pass that data to commander.

Let me break that down and spoon feed you, the reader:

**1. Read the contents of the folder that contains the commands**

I suggest that you name the folder that contains all the commands as... **commands**. Inside that folder, we would have multiple folders, one for each command.

Since we're going to treat each folder inside the `commands` folder as a "command", then that means we could simply use the basic `fs.readdirSync` (or the async version, whatevs) to get all the folder names as an array and put them in a variable called commands.

```javascript
const path = require('path');
const fs = require('fs');

const commands = fs.readdirSync(path.join(__dirname, 'commands'));

console.log(commands); // Prints all the folder names inside our commands folder
```

**2. Now, iterate through all the commands folder and get their `index.js` file**

When I said "get", I literally meant "require". I bet that a code snippet would be much more understandable:

```javascript
commands.forEach(name => {
  const command = require(`./commands/${name}`);

  console.log(command); // This should print out a JavaScript object that contains the contents of commands/<command>/index.js
});
```

Note that `command` is a JavaScript object, so that means we can safely pass the properties to commander:

```javascript
const path = require('path');
const fs = require('fs');
const program = require('commander'); // This is the commander library that I listed above.

const commands = fs.readdirSync(path.join(__dirname, 'commands'));


commands.forEach(name => {
  const entry = require(`./commands/${name}`);
  const command = program
    .command(entry.command)
    .action(entry.action)
    .description(entry.desc);

  if (entry.options) {
    entry.options.forEach(option => {
      const args = typeof option === 'string' ? [option] : option;
      command.option(...args);
    });
  }
});
```

`commander`'s `options` property should accept an array of strings or an array of array. But since we would want our tool to be a little "simple", I am implicitly converting the string into an array instead :D

That last code snippet is actually all that is needed for your CLI tool, and the rest is to actually implement each command/option that your tool would support :D

### Conclusion

With this, you won't need to modify any existing code when implementing a new command, but rather, just add in your new commands inside the `commands` folder.

Oh, here's the sample CLI tool, along with the logic for installing this stuff as a "global" nodejs command using `npm ln`: [nodejs-cli-boilerplate](https://github.com/dcefram/nodejs-cli-boilerplate)
