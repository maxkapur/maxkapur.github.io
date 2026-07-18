+++
draft = true
title = 'Hugo migration'

[params]
id = 'tag:max@maxkapur.com,2026-05-27:posts/2026-07-17-hugo-migration'
+++

If you're reading this, it means I finally pushed through my [Hugo
migration](https://github.com/maxkapur/maxkapur.github.io/pull/98), i.e. updated
the backend of the site to a new framework.

I also redid the homepage a bit. It's the same basic design because I couldn't
come up with a better idea, but I replaced the post previews with just links. I
want to gradually transition the site's mission from "blog" to "personal
website," mainly because my writing habits have shifted and I don't have as many
blog-post-shaped thoughts as I used to.

This Hugo migration was a bit of work because I took my time and did it the fun
way. The old version of the site used Jekyll and had accrued a lot of Jekyll's
"isms," along with weird conventions of my own. I wrote a custom [content
migration
script](https://github.com/maxkapur/maxkapur.github.io/blob/d2ad5ba9b81e473a32c48b44e3975ea22b6e4380/migrate.py)
to transform Jekyll tags automatically where possible and flag for
manual attention where needed.

I think/hope it worked. Old post links will redirect you to the new URLs. For
RSS subscribers, depending on how your reader is configured, you may pick up a
new copy of every post; you can just mark as read everything before today's
date.
