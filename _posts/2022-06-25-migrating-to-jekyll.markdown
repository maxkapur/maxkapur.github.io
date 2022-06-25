---
layout: post
title:  "Migrating to Jekyll"
date:   2022-06-25 12:26:36 +0900
categories: personal
---


After reflecting on my dependency on Google services for so many aspects of my life, I have decided to bite the bullet and migrate my blog from Blogger to the open-source [Jekyll](https://github.com/jekyll/jekyll), with hosting provided by GitHub. Click the title of this post to read the full version, in which I explain some of the technical reasons for making this change. 

# Advantages of Jekyll

Jekyll offers several advantages over Blogger. For one thing, when writing a post in Blogger, you are forced to choose between their buggy WYSIWYG editor and raw HTML. In order to get granular control over the size of images, video embeds, and blockquotes, I got in the habit of writing in HTML, but it grew difficult to maintain a consistent style from post to post, because I always had to bear in mind the interaction among my inline styling, the CSS from Blogger’s theme, and my own custom stylesheet that I appended to the Blogger theme. Writing in Markdown will hopefully coerce me not to use inline styles at all, and since I can manually edit the base stylesheets that Jekyll uses to generate static pages, it should be easier to maintain a consistent brand. 

Another advantage is that the standard Jekyll templates seem to be much more lightweight, and do not include any of the tracking cookies that come embedded in any Blogger site. As someone who aggressively uses browser extensions to nerf these devices when another site deploys them on me, it felt hypocritical to subject my readers (both of them) to the same surveillance.

Finally, although I am currently using GitHub as a hosting service, the entire workflow for writing posts in Jekyll and building them into an HTML site takes place locally on my computer. This means that later on, if I want to switch hosting provideram usins or set up my own webserver in my basement, migration should be relatively easy.

# Pain points

If you are reading this post shortly after it went up, chances are that I am still configuring things and repairing links. For example, [old.maxkapur.com](https://old.maxkapur.com/) should take you to an archive of the old blog, but the links embedded on that blog may 404.

Another difficulty with this migration is that to host a Jekyll blog using GitHub pages, you have to name the GitHub project `maxkapur.github.io`. But I already have a project with that name, which I used to host various one-off essays and coding projects at the URL [misc.maxkapurcom](https://misc.maxkapur.com). If I set things up correctly, then that URL should still redirect you, but at the moment of writing this I haven’t actually performed the switch.

Jekyll offers some tools for automatically importing past posts from other blogging services, but I have decided against importing the full history, both because it is a nuisance, and because the design and layout of the old Illusion Slopes concords with the voice of those posts in a way that the new design does not. Nonetheless, because it is easy to create backdated posts, I will probably pull in a few of my most recent posts as well as those that have been consistent drivers of search engine traffic. 

# New license

The previous instance of Illusion Slopes featured a prominent copyright notice in the footer. Going forward, this blog will be licensed under CC BY-SA 2.0, a copyleft license that grants you the right to remix and reuse these materials without asking for permission as long as you credit me (preferably by linking to [https://www.maxkapur.com](maxkapur.com)) and release your work under a similar open license.


<!-- sample from jekyll init
You’ll find this post in your `_posts` directory. Go ahead and edit it and re-build the site to see your changes. You can rebuild the site in many different ways, but the most common way is to run `jekyll serve`, which launches a web server and auto-regenerates your site when a file is updated.

Jekyll requires blog post files to be named according to the following format:

`YEAR-MONTH-DAY-title.MARKUP`

Where `YEAR` is a four-digit number, `MONTH` and `DAY` are both two-digit numbers, and `MARKUP` is the file extension representing the format used in the file. After that, include the necessary front matter. Take a look at the source for this post to get an idea about how it works.

Jekyll also offers powerful support for code snippets:

{% highlight ruby %}
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}

Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/
--> 
