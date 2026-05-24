---
layout:     post
title:      "Applying the KISS principle to amp modeling"
---

I’ve been playing electric guitar using only computer modeling software (without a physical amplifier) for about five years now.
I started out with Garageband and Mainstage, then briefly experimented with [Amplifikation Vermilion](https://www.kuassa.com/products/amplifikation-vermilion/), and for the last year and half have turned to a free, open-source package called [Guitarix](https://guitarix.org/) and a small collection of impulse response files culled from guitar forums.
In my experience, a good impulse response file fed into a basic convolver does a lot more for your sound than trying to optimize the countless parameters on an expensive simulator.

<!--more-->

The hardest thing about playing through an amp modeler is overcoming the desire to replicate the sound of a classic physical amp.
Modern software is powerful enough to get you asymptotically close to a reference tone, but only with some know-how and a lot of fiddling.
For a hobbyist, it’s better (for your sanity) to treat the simulated guitar amp as a distinct instrument from a vintage combo, and try above all to create sounds that are interesting and dynamic on their own.
This goes doubly for people (like me) whose understanding of classic guitar tones draws more from listening to carefully mastered recordings than firsthand experience.

The second-hardest thing about amp modeling is creating a sense of physical space.
With a physical amp, you experience each note in several different ways: the physical vibration of the instrument against your body, the sound coming from the amp, the vibration of the floor in response to the amp’s low end, and the echoes of the sound off the walls of the room.
A digital amp model, even one with low latency and good dynamic response, can sound sterile and distant when fed into headphones or bookshelf monitors because it doesn’t provide these rich audiospatial cues.
I rely on three devices to create a sense of physical space in my simulated guitar sound:

- Delaying the right channel by 20–40 ms.
Just a simple sample delay at any point in the signal chain will do.
It creates the sense of an amp sitting just to the left of your head, but still filling the room with sound.
- Judicious use of a chorus effect.
This also helps cut through the mix when playing along with recordings.
- Rolling off the bass a little.
The principle here is that if your overall sound has a heavy low end, then your body will expect to feel sympathetic vibrations through the floor and chair.
By opting for a warmer tone, you remove this cue.

My primary goal is to keep my setup as simple and portable as possible.
I don’t subscribe to a particular chorus or reverb effect, nor do I have any impulse response files I couldn’t live without.
I have trained my fingers to make the most of middle-of-the-road settings.
