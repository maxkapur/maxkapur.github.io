---
layout: post
title:  "Migrating to Jekyll"
---


After reflecting on my unsustainable dependency on Google services, I have decided to bite
the bullet and migrate my blog from Blogger to the open-source [Jekyll](https://github.com/jekyll/jekyll),
with hosting provided by GitHub. In the full version of this post,
I explain some of the technical reasons for making this change. 

<!--more-->

# Advantages of Jekyll

The Jekyll workflow offers several advantages over Blogger. For one thing, when writing a post in Blogger,
I was forced to choose between a buggy WYSIWYG editor and raw HTML. To obtain granular control over the
post formatting, blockquote styles, image sizes, embedded video behavior, and so on, I came to favor the HTML
editor over time. However, since Blogger’s interface offers only limited control over the blog’s stylesheet, in
order to obtain the post layouts I wanted, I always had to
bob and weave among inline CSS styles, a custom stylesheet I appended to the Blogger theme, and various
sliders in Blogger’s config GUI that let me indirectly modify the underlying template. It was yucky.

By contrast,
the Markdown/Jekyll workflow creates a clear distinction between writing and typesetting tasks. I can compose
my posts in Markdown with minimal distraction from all those HTML tags, and format everything from above by tweaking
the well-organized stylesheets from Jekyll’s templates. For readers, I hope this means I will be able to maintain 
a more consistent voice in my writing, and because the formatting, typesetting, and layout will be stable from post to
post, you can expect less visual “noise” from the website itself. 

Because I have total control over every bit of code on this new website, I also can ensure that it is free of the
cookies, UA sniffers, and other tracking devices that were embedded in Blogger. As someone who aggressively uses
browser extensions to nerf these devices when another site deploys them on me, it felt hypocritical to subject my
readers—both of them—to the same surveillance.

Finally, since Jekyll builds everything to static HTML on the server side,
the load times should be faster. And later on, if I want to switch hosting providers or set up my own web server in my
basement, future migrations should be much easier than this one.

# Pain points

If you are reading this post shortly after it went up, chances are that I am still configuring things and repairing links.
For example, [old.maxkapur.com](https://old.maxkapur.com/) should take you to an archive of the old blog,
but the links embedded on that blog may 404.

Another difficulty with this migration is that to host a Jekyll blog using GitHub pages, you have to create a GitHub project named `maxkapur.github.io` (or whatever your GitHub username is). But I already had a project with that name, which I used to host various one-off essays and coding projects at the URL [misc.maxkapur.com](https://misc.maxkapur.com). Now, I have overwritten the `maxkapur.github.io` repository with the code for this site and created separate GitHub repositories for the projects that felt worth preserving. If I set things up correctly, then the old links should forward to correctly to their new homes. Of course, you can also 
dig into the [commit history](https://github.com/maxkapur/maxkapur.github.io/commits/master) for `maxkapur.github.io` and find the source code for those
pages that way. But this will probably break some of the links on the old blog that used absolute paths instead of relative ones.

Jekyll offers some tools for automatically importing past posts from other blogging services, but I have decided against importing the full history, both because it is a nuisance, and because the design and layout of the old Illusion Slopes concords with the tone and content of those posts in a way that (in my view) the new design does not. Nonetheless, because it is easy to create backdated posts, I will probably pull in a couple of the most recent posts and some of the “greatest hits” (i.e. posts that were major drivers of search engine traffic) from the old Illusion Slopes site. This will help me practice the new workflow and get a feel for where I need to apply further customizations to the Jekyll CSS.

# New license

The previous instance of Illusion Slopes featured a prominent copyright notice in the footer. Going forward, this blog will be licensed under CC BY-SA 4.0, a copyleft license that grants you the right to remix and reuse these materials without asking for permission as long as you credit me (preferably by linking to [maxkapur.com]({{ site.url }})) and release your work under a similar open license.
