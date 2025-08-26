+++
author = "Daniel Cefram Ramirez"
tags = ["invoice"]
date = 2025-08-26T19:23:12+08:00
title = "Creating Invoices in the command line"
description = "Just stumbled upon this gem, and my laziness got some ideas"
slug = "invoice-cli"
type = "journal"
draft = false
toc = false
+++

I stumbled upon this nifty [invoice project](https://github.com/maaslalani/invoice), which is also
available in homebrew: `brew install invoice`.

Usage is as simple as:

```bash
invoice generate --from "Dream, Inc." --to "Imagine, Inc." \
    --item "Rubber Duck" --quantity 2 --rate 25 \
    --tax 0.13 --discount 0.15 \
    --note "For debugging purposes."
```

I can even use a config file which would be a lot easier to maintain:

```bash
invoice generate --import path/to/data.json \
    --output duck-invoice.pdf
```

```json
{
  "logo": "/path/to/image.png",
  "from": "Dream, Inc.",
  "to": "Imagine, Inc.",
  "tax": 0.13,
  "items": ["Yellow Rubber Duck", "Special Edition Plaid Rubber Duck"],
  "quantities": [5, 1],
  "rates": [25, 25]
}
```

This got me a couple of ideas to automate my invoice sending
errands, one of which is to simply pull data each month and generate
the JSON file and then pipe it to the `invoice` command.

However, I don't want to spend money for a proper SaaS to send emails, and
plus, I want the emails to seem to come from me personally, so this is what
I need to explore next. Office 365 has Power Automate, maybe that's something
I can use 🤔

