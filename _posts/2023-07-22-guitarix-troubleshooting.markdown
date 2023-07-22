---
layout:     post
title:      "Guitarix troubleshooting"
---

For the past few updates of [Guitarix](https://guitarix.org/), I have been
having issues where changing the JACK server latency causes the audio output
to go crazy. This seems to stem from changes that the developer has been
making to the config files, because the following commands usually get things
working again:

```bash
mv ~/.config/guitarix ~/.config/guitarix.backup
mkdir ~/.config/guitarix
cp -r ~/.config/guitarix.backup/banks ~/.config/guitarix/banks
```

These commands backup your amp/effects presets from `~/.config/guitarix/banks`
(which are the hard part to restore manually), and let the default settings 
take over the next time the application is launched.
