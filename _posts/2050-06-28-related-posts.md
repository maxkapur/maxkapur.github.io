---
layout: post
title: "Jekyll plugin to recommend related posts"
---

I wrote my first plugin for the Jekyll static website builder: a [tool that
recommends related posts](https://github.com/maxkapur/jekyll-related)
at the end of each page. It determines the similarity between post pairs using
a fairly unremarkable token-counting algorithm—so it's fast enough to rerun on
every site build. You can configure the number of posts to recommend and a
parameter `factor` which determines the algorithm's sensitivity to rare vs.
common words.

I made a little [demo of the plugin]({{ site.url }}/jekyll-related/) with a fake
blog whose posts are the articles of the UN Universal Declaration of Human
Rights. You can also see a demo on the current version of this site if you click
the "read more" link below to go to this post's individual page.
I think it works pretty well!<!--more-->

There are still some tweaks I want to
make before I publish this plugin to [RubyGems.org](https://rubygems.org/).
Currently, `jekyll-related` depends on this ancient
[tokenizer](https://github.com/arbox/tokenizer) gem, which I want to inline so
I can add more configurable options for things like whitespace and capitalization
handling.
