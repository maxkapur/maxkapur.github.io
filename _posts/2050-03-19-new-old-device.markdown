---
layout:     post
title:      "New old device"
---

On my recent visit home, I dug a 2007 [Sansa Clip](https://en.wikipedia.org/wiki/SanDisk_portable_media_players#Sansa_Clip)
out of a box. Though its battery life is shot, this device is fully functional,
and I unearthed some regrettable jams of the era from the built-in 4GB of flash
memory.

![An image of an Obama-era Sansa clip (released in late 2007, probably manufactured later) running the Rockbox custom firmware](/assets/rockbox-sansa-clip.jpg)

As shown in the picture, I also managed to install the
[Rockbox](https://www.rockbox.org/) custom firmware, which I remembered using on
a different MP3 player (a Sansa e200) prior to the Clip.<!--more-->
The Rockbox installation wizard (which comes as an AppImage for Linux platforms)
didn’t work for me; it 404’d trying to download the fonts package.[^404]
But the manual installation was a breeze—all you have to do is download one of
the official firmware updates from Sandisk, then apply Rockbox’s patch and
transfer the result to the root directory of the device. In the era before cheap
WiFi chipsets, the standard way to provide firmware updates to USB devices like
this was to distribute such binary installer files and have the device attempt
to execute any file whose name matched a certain pattern—opening a window for
tinkerers, like the Rockbox developers, to work their magic.

[^404]: I wasn’t sure how best to spell *404’d,* and couldn’t find the verb form in any of the dictionaries I checked, but I settled on this spelling by comparison with a reference to *86’d* in this [Merriam-Webster article](https://www.merriam-webster.com/wordplay/eighty-six-meaning-origin). The more you know.

Rockbox is an impressive piece of software, even before you account for the
primitivity of its target devices like the Clip. The core music player functions
are all there, including queue, playlist, and database management as well as
audiophile dealbreakers like gapless playback and an equalizer. But it’s also
deeply customizable with translations, plugins, games, and the like, and comes
with its own pixel font, which looks crisp on the Clip’s low-resolution,
two-color display. Rockbox is still developed, but mostly
just for maintenance—the enthusiasm petered out when smartphones took over and
everyone forgot about these standalone MP3 players.

This little discovery has renewed my excitement for the
[Tangara](https://sr.ht/~jacqueline/tangara/), an open-source, crowdfunded MP3
player slash nostalgia platform that aims to offer the hackability of those
2000s devices with such modern comforts as Bluetooth and USB-C. I don’t fault
Tangara for writing their own firmware, but I really hope that Rockbox gets
ported to it, too, because Rockbox basically defined the “handheld music player”
interface for me at a formative age, and nothing else feels quite as flexible
or obvious.
