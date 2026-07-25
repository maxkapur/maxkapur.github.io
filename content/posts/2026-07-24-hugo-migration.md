+++
title = 'Hugo migration'

[params]
id = 'tag:max@maxkapur.com,2026-05-27:posts/2026-07-17-hugo-migration'
+++

If you're reading this, I finally updated the backend of the site to use a new
framework—from Jekyll to Hugo. I also took the opportunity to redo the homepage
a bit. I don't have as many blog-post-shaped thoughts as I used to, so I reduced
the post previews to just links to create room for more freeform content.

The [Hugo migration](https://github.com/maxkapur/maxkapur.github.io/pull/98) was
a bit of work because I took my time and did it the fun way. The old version of
the site used Jekyll and had accrued a lot of Jekyll's "isms," along with weird
conventions of my own. I wrote a custom [content migration
script](https://github.com/maxkapur/maxkapur.github.io/blob/d2ad5ba9b81e473a32c48b44e3975ea22b6e4380/migrate.py)
to transform Jekyll tags automatically where possible and flag for manual
attention where needed.

I think/hope it worked. Old post links will redirect you to the new URLs. For
RSS subscribers, depending on how your reader is configured, you may pick up a
new copy of every post; you can just mark as read everything before today's
date.
