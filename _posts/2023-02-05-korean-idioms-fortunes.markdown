---
layout:     post
title:      "Learning Korean idioms with UNIX fortune"
---

[fortune](https://en.wikipedia.org/wiki/Fortune_(Unix)) is a classic UNIX program that displays random fortunes, pithy quotes, and the like:

```text
$ fortune
If you think last Tuesday was a drag, wait till you see what happens tomorrow!
```

Today, I repurposed fortune (really [fortune-mod](https://github.com/shlomif/fortune-mod)) as a language study tool by scraping some [Korean idioms from Wikiquote](https://github.com/maxkapur/korean-fortunes) from Wikiquote):

```text
$ fortune korean
“쇠귀에 경 읽기.”
    아무리 좋은 말을 하면서 가르치려고 하여도 그 뜻을 제대로 헤아리지 못하는 사람을 두고 하는 말.
```

This one says “Chanting sutras into the ears of a cow,“ defined as “A phrase used when someone fails to understand what you are trying to teach them no matter how well you choose your words.”

I set `fortune korean` (with some gentle text styling) as my fish greeting, so I can learn a new idiom every time I open a terminal—see below.<!--more-->

![A screenshot of a fish prompt preceded by the output of the `fish_greeting.fish` script. The idiom is “한 번 엎지른 물은 다시 주워 담지 못한다” and its explanation is 한 번 지나간 일은 다시 돌이켜 회복할 수 없다는 말.](./assets/fish-fortune-greeter.png)

You can find my database and `fish_greeter.fish` script on [GitHub](https://github.com/maxkapur/korean-fortunes).

