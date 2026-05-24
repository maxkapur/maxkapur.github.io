---
layout: post
title: Some things I tried recently
---

[Kagi Search:](https://kagi.com/) It’s a paid search engine that promises to
give better results than Google and friends. Indeed, the search results are a
little more relevant, especially when researching technical topics. I made great
use of the ability to
[filter and promote entire domains](https://kagi.com/stats?stat=leaderboard).
However, the pricing doesn’t work for me: \$5/month gets you 300 searches, which
isn’t enough (I burned through the free 100 searches in a week), and for
unlimited searches, you have to pay \$10 for a bundle deal that also includes AI
stuff I don’t care about. Kagi wants to become an everything app (probably
[adding email soon](https://olly.pagecord.com/some-thoughts-on-kagi-search-after-two-months)),
which a tough sell while claiming to be a privacy-focused company. (Same issue
with Proton, by the way.)

[Fender Studio:](https://www.fender.com/pages/fender-studio) Fender, the guitar
company, just kind of threw this over the fence in May. It’s a free (but not
open source) digital audio workstation, so it competes with the likes of Ardour
and GarageBand. But Fender Studio runs on Linux, and quite well at that. On my
machine, it supports JACK with minimal configuration and achieves lower latency
than [Guitarix](https://guitarix.org/) while doing a lot more. The vendored
backing tracks are a bit cheesy but well engineered.

[Proselint:](https://github.com/amperser/proselint) It’s a prose … linter, i.e.
you feed it your draft blog post and it complains about vague wording and common
typography problems like curly vs. straight quotes. I like that Proselint uses
regex instead of an LLM, so there’s no
[creative interference]({% post_url 2025-06-18-thesaurus-cheating %}); it’s more
like an automated style guide than a chatty editor. But my homegrown
`typography.py` script (I need to upload this to GitHub sometime) enforces a few
lesser irks, such as
[en dashes in numerical ranges](https://editorsmanual.com/articles/number-ranges/),
that Proselint lets be, so I’m still using both.
