---
layout:     post
title:      "The best thing about fish"
---

The best thing about fish is probably the
[lateral line](https://en.wikipedia.org/wiki/Lateral_line),
which sort of like ears for underwater that enable fish to sense and locate
predators even in dark or murky conditions.

The best thing about the fish command-line *shell,* on the other hand, has to be
its “fuzzy” completions. In most other shells (like Microsoft PowerShell, which
I use every day at work), you can tab-complete a filename like
`blog_post_idea.md` by typing `blog` (the first part of the filename) and
pressing <kbd>Tab</kbd>. If there are multiple matches, you use the arrow keys
to scroll through them until you get the one you want.

This works fine if you put the most-unique part of your filenames at the
beginning. But I like to begin my filenames with
[ISO dates]({% post_url 2024-04-26-iso-dates-filenames %}),
so to tab-complete `2024-03-06_blog_post_idea.md` in PowerShell, I have to
type `2024` and then jab the arrow key a bunch of times, which is like using a
phone book that is sorted by phone number. In fish, I can just type `blogpost`
(even without the underscore) and it will autocomplete to
`2024-03-06_blog_post_idea.md`.

Similar completions work for the options of most command-line programs, and it’s
(relatively) easy to extend the built-in completions with your own
[configuration files](https://fishshell.com/docs/current/completions.html)
(but I’ve never needed to).

<!--
  Ref: https://fishshell.com/docs/current/completions.html
  
  Ref: https://github.com/fish-shell/fish-shell/blob/c209e6b5fbaae8cd54c9554ec790860550595b43/src/complete.rs#L1500
-->
