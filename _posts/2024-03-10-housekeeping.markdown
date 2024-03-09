---
layout:     post
title:      "Housekeeping"
---

Completed some overdue site maintenance over the past few weeks:

- **RSS feed styling:**
  With help from a
  [template found on GitHub](https://gist.github.com/andrewstiefel/57a0a400aa2deb6c9fe18c6da4e16e0f),
  I created a stylesheet for the RSS feed so that it looks nice when
  viewed in the browser. Ctrl+F “RSS” on this page to find the link,
  or just scroll all the way to the bottom, or maybe
  [try this link](/feed.xml).

  I am not a big consumer of RSS feeds myself; I prefer to just
  bookmark blog URLs and read posts in their original context. But RSS
  is an important bit of
  [plumbing](https://inessential.com/2013/03/14/why_i_love_rss_and_you_do_too.html)
  for the indie web, and probably covers accessibility use cases
  that I haven’t anticipated.

  (Technically, I am serving an Atom feed rather than RSS, but
  [people use the terms interchangeably](https://indieweb.org/RSS).)

- **Upgraded to Jekyll 4:**
  Jekyll is a tool for building a static HTML site out of Markdown files.
  The built-in GitHub functionality for hosting a Jekyll blog is stuck
  on an old version of Jekyll which has some end-of-life dependencies,
  and they are
  [stuck searching for an upgrade path](https://github.com/github/pages-gem/issues/651#issuecomment-581069671)
  that doesn’t break existing sites.

  I followed this
  [wonderful guide](https://www.moncefbelyamani.com/making-github-pages-work-with-latest-jekyll/)
  to switch my publication workflow to a GitHub Action that lets me manually
  manage my Ruby and Jekyll versions. It’s a great tutorial that also helped
  clear up several misunderstandings about Ruby, Gems, and `rbenv`.

- **Removed embedded YouTube videos:**
  I replaced embedded YouTube videos with simple links to improve page load
  times and user privacy.
