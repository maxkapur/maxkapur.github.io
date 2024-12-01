---
layout:     post
title:      "New old device"
---

On a recent visit home, I dug this 2007
[Sansa Clip](https://en.wikipedia.org/wiki/SanDisk_portable_media_players#Sansa_Clip)
out of a box.

<figure>
<img
  src="/assets/images/rockbox-sansa-clip.jpg"
  class="compact"
  alt="An image of an Obama-era Sansa clip (released in late 2007, probably manufactured later) running the Rockbox custom firmware"
/>
</figure>

It’s battery life is shot, but everything works, and I unearthed some critical
throwback jams from the built-in 4GB of flash memory (among other things, the
first four Brad Paisley albums in .wma format). As the picture shows, I also
installed a bit of custom firmware called [Rockbox](https://www.rockbox.org/).

<!--more-->

I remembered Rockbox from using it on a different MP3 player (a Sansa e200)
prior to the Clip. It runs on dozens of classic ’00s devices (including some of
the early iPods) and provides a wide range of features and customization options
beyond the stock firmware—things like support for the FLAC audio format, a
dynamic equalizer, and better tools for managing playlist and the “now playing”
queue. There are additional plugins for games, translations, font selection, and
image viewing.[^imageview]

[^imageview]: Image viewing works even on the Clip’s simple two-color display. It uses random [dithering](https://en.wikipedia.org/wiki/Dither) to represent fractional lightness values, and rerolls the randomness with each screen refresh to produce a nice composition effect. This kills the battery in short time.

Rockbox distributes an installation wizard for Linux platforms, but I couldn’t
get it to work (it 404’d trying to download the fonts package[^404]). Fortunately,
the “manual” installation isn’t hard. You just download one of the official
firmware updates from Sandisk, then apply Rockbox’s patch and transfer the
result to the device’s root directory. By design, the Clip attempts to execute
*any* file in the root directory whose name matches a certain pattern. This
firmware update mechanism was a welcome convenience for tinkerers, but it’s
probably too insecure for today’s internet-mandatory smartphones.

[^404]: I wasn’t sure how best to spell *404’d,* and couldn’t find the verb form in any of the dictionaries I checked, but I settled on this spelling by comparison with a reference to *86’d* in this [Merriam-Webster article](https://www.merriam-webster.com/wordplay/eighty-six-meaning-origin). The more you know.

Playing with the Clip has renewed my excitement for the
[Tangara](https://sr.ht/~jacqueline/tangara/), an open-source, crowdfunded MP3
player slash nostalgia platform that aims to combine the hackability of those
2000s devices with such modern comforts as Bluetooth and USB-C. I don’t fault
Tangara for writing their own firmware, but I really hope that Rockbox gets
ported to it, too, as Rockbox basically defined the “handheld music player”
interface for me at a formative age. Nothing else feels quite as flexible or
obvious.
