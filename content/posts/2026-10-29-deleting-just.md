+++
draft = true
title = 'Deleting "just" from posts'

[params]
id = 'tag:max@maxkapur.com,2026-05-27:posts/2026-10-29-deleting-just'
+++

I read that you can tighten up prose by avoiding the word "just" and thought,
sure, let's try that.

I found [43 offenders](https://github.com/maxkapur/maxkapur.github.io/pull/110)
on my blog. (I only went back to 2020 or so—anything older is beyond
redemption.) The worst instances are those where "just" is used as a synonym of
"only," but that modifier is already implied by the sentence structure:

> A student who wishes to apply to a top university needs more than ~just~
  confidence in her academic talent.

Another tic of mine is to use "just" just to mean "simply," when it's really up
to the reader to decide whether what follows is simple:

> To figure this out, we ~~just need to~~ solve our {{< math "x^*" />}} equation
  for {{< math "c" />}}. 

I opted to let "just" stand in cases where it makes a sentence more precise:

> it takes just under two minutes

I also think "just" pulls its weight when used to mean "exactly":

> it's just the opposite

<!--more-->

Shell commands:

```shell
# Finding removal candidates, one year at time
git grep --line-number --extended-regexp --ignore-case '\bjust\b' content/posts/2025*

# How many "just"s did I remove? (Probably some false positives)
git diff master HEAD | grep -E '^\-.*\bjust\b' | wc -l  # 43
```
