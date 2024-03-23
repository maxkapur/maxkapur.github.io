---
layout:     post
title:      "New old device"
---

On my recent visit home, I dug a 2007 [Sansa Clip](https://en.wikipedia.org/wiki/SanDisk_portable_media_players#Sansa_Clip)
out of a box. Though its battery life is shot, the device is fully functional. I
unearthed some inevitable jams of the era from the built-in 4GB of flash memory.
And as this picture shows, I also managed to install a bit of custom firmware
called [Rockbox](https://www.rockbox.org/).

![An image of an Obama-era Sansa clip (released in late 2007, probably manufactured later) running the Rockbox custom firmware](/assets/rockbox-sansa-clip.jpg)

<!--more-->

I remembered Rockbox from using it on a different MP3 player (a Sansa e200)
prior to the Clip. When I first installed it, it felt like a sophisticated hack:
I spent hours customizing the “now playing” screen with custom graphics and
reams of statistics about each song’s length and encoding format. And as a work
of software, I’m *still* impressed by Rockbox. The core music player functions
are all there, including queue, playlist, and database management, as are
audiophile dealbreakers like gapless playback and an equalizer. But Rockbox also
affords deep customization thanks to its modular design, with additional plugins
for games, translations, font selection, and image viewing.[^imageview]

[^imageview]: Image viewing works even on the Clip’s simple two-color display. It uses random [dithering](https://en.wikipedia.org/wiki/Dither) to represent fractional lightness values, and rerolls the randomness with each screen refresh to produce a nice composition effect. This kills the battery in short time.

Rockbox distributes installation wizard for Linux platforms. But I couldn’t get
it to work; it 404’d trying to download the fonts package.[^404] Fortunately,
the “manual” installation is easy as pie. All you have to do is download one of
the official firmware updates from Sandisk. Then you apply Rockbox’s patch and
transfer the result to the device’s root directory. It turns out that the Clip
will attempt to execute any file in the root directory whose name matches a
certain pattern—opening an invaluable window for tinkerers like the Rockbox
developers to work their magic. Alas, this update method probably doesn’t meet
the security requirements of the smartphone epoch.

[^404]: I wasn’t sure how best to spell *404’d,* and couldn’t find the verb form in any of the dictionaries I checked, but I settled on this spelling by comparison with a reference to *86’d* in this [Merriam-Webster article](https://www.merriam-webster.com/wordplay/eighty-six-meaning-origin). The more you know.

This little discovery has renewed my excitement for the
[Tangara](https://sr.ht/~jacqueline/tangara/), an open-source, crowdfunded MP3
player slash nostalgia platform that aims to combine the hackability of those
2000s devices with such modern comforts as Bluetooth and USB-C. I don’t fault
Tangara for writing their own firmware, but I really hope that Rockbox gets
ported to it, too, as Rockbox basically defined the “handheld music player”
interface for me at a formative age. Nothing else feels quite as flexible or
obvious.
