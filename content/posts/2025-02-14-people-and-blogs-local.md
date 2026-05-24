---
title: People and Blogs interview (local mirror)
layout: post
hidden: true
date: 2025-02-14T12:00:00
---

Here is a local mirror of my interview on Manuel Moreale's
[People and Blogs](https://manuelmoreale.com/pb-max-kapur) series.

**Let's start from the basics: can you introduce yourself?**

Sure. I grew up in Seattle, went to college in Los Angeles, then lived in South
Korea for four years, first as an English teacher in Naju, then as a grad
student at Seoul National University. In 2022, I moved to the Washington, DC
area for my current job as a numerical analyst at a government consulting firm.

I joke that I have “reinvented myself” several times, because I double-majored
in jazz piano and Korean language in undergrad, then considered becoming a
schoolteacher, then grew interested in math and programming and did my master’s
in industrial engineering. But there’s continuity through these chapters. At
work, I build numerical modeling tools (picture something like
[Universal Paperclips](https://www.decisionproblem.com/paperclips/)) for clients
who are sometimes skeptical of analyzing their data quantitatively. That’s
because they’ve been disappointed by past attempts that failed to account for
the right variables, or that offered too much technical flourish with too little
explanation. So, in my role, equally important to getting the math right is my
ability to tell a convincing story about why I modeled the problem a certain
way. That’s where I draw on my teaching background, the performance skills I
learned in music school, and my ability to translate specialized concepts into
accessible terms.

Sorry—I devolved into my job interview spiel. My blog is
[Illusion Slopes](https://maxkapur.com/). I post book reviews, notes on
programming and game theory, and observations about Korean language and culture.
I hope there’s something for everyone, but you might have to scroll a bit.

**What's the story behind your blog?**

In music school, we often discussed the importance of building an artistic brand
and having authority over what comes up when someone Googles your name. So, when
I started my blog in 2015, it was with the vague hope that bolstering my online
presence would help me find piano students, sell sheet music of my compositions,
and maybe get my book reviews in front of an editor. It was a very careerist
project—and not very successful by that yardstick! Still, I held onto the idea
of the blog as digital resume for some time. When I was an English teacher, I
blogged about
[language teaching](https://maxkapur.com/2020/05/06/nonnative-teacher.html); in
grad school, I blogged about my
[academic research](https://maxkapur.com/2021/10/21/administrative-allocative-efficiency.html)
into college admissions markets.

Now that I have a stable job, I feel less pressure to professionalize my blog’s
content. Instead, my goal is simply to keep writing, even at the risk of
publishing an imperfect or overplayed take. Lately, I’ve been trying to post
[silly ideas](https://maxkapur.com/2024/06/07/sports-idea.html) and
[low-stakes opinions](https://maxkapur.com/2024/04/26/iso-dates-filenames.html)
to practice writing in a different voice. The most enduring lesson I took from
music school is the growth mindset
([I memorialized it with my Crocs](https://www.youtube.com/watch?v=NltUqfuxT-M&t=69s)),
which says that in order to improve at anything, you must find the edge of your
comfort zone and take targeted risks. Before I die, I would like to get better
at writing of all forms, and Illusion Slopes is one way I practice.

**What does your creative process look like when it comes to blogging?**

Well, I have two piles of notes: a Syncthing folder full of Markdown files, and
a stack of handwritten pages torn from legal pads. I try to record all of my
ideas, even the terrible ones, as soon as they arrive. Like
[Taylor Troesh says](https://taylor.town/idea-kitty) (aside: it is very cool to
be on the [same P&B as him](https://manuelmoreale.com/pb-taylor-troesh)), you
have to make yourself a magnet for *all* ideas if you want to attract the good
ones.

Every month or so, I shuffle through my piles of notes and try to turn a few
into (for lack of a better term) finished products. A finished product can be a
blog post, but honestly, it’s more often an email or a long message to a group
chat, especially if the content is personal or an inside joke. (I like what
[Steven Garrity](https://manuelmoreale.com/pb-steven-garrity) said about
blogging in his company’s Slack chat—very relatable.)

In my blog’s queue, I also maintain a slush pile of kind-of-finished posts
scheduled for various dates in 2050. If I can’t salvage any ideas from the notes
but have fallen behind on posting, I pull something forward from the slush pile.
Technically, these posts are already readable through GitHub, but I assume
anyone who goes to the effort to find them there will recognize them as drafts
and adjust their expectations accordingly.

The downside of my approach—gradually laundering notes into blog posts—is that
it doesn’t provide a mechanism for following up on old posts with new
information. For example, I recently wrote about
[the then-impending Korean presidential impeachment](https://maxkapur.com/2024/12/08/novels-to-understand-korea.html),
but I never wrote an update when Yoon Suk Yeol was actually impeached (and
more). I’m a bit embarrassed by the lack of continuity. But at the same time,
part of the zen of non-professional blogging has got to be to release yourself
from the obligation to always have a take.

**Do you have an ideal creative environment? Also do you believe the physical
space influences your creativity?**

Not really. Sometimes I write on my phone, other times on the computer, other
times longhand. I think I do my best writing when I revisit the same piece in
different surroundings. For example, if I write the first draft on my phone in
the subway, I’ll do the second draft on a notepad at home.

**A question for the techie readers: can you run us through your tech stack?**

I started out on Blogger, which I had used once for a school project. Then I
migrated to a static site in 2022. I chose Jekyll because GitHub sets it all up
for you, meaning you can start with their opinionated configuration, then pivot
to self-hosting if your needs become more specialized. In my case, I still host
the site using GitHub Pages, but now I use a custom build script so I can run
the latest versions of Ruby and Jekyll. The one unconventional thing I do is
install the
[Ruby stack in a conda environment](https://maxkapur.com/2024/11/29/rbenv-vs-conda.html)
instead of using rbenv or a Docker container.

I bought my domain on Google Domains in 2018 or so and was automatically
migrated to Squarespace after the sale. One of these days, I want to try
migrating my domain to another registrar, mainly just to practice doing so
without breaking my 301 redirects, email, and so on.

**Given your experience, if you were to start a blog today, would you do
anything differently?**

You know, despite all the drama with Matt Mullenweg lately, I sometimes wish I’d
gone with WordPress. Most of my friends are not programmers, so when they ask me
about creating a personal site (welcome to the ’sphere,
[Longtime](https://longtimestories.wordpress.com/)), I can’t recommend my setup,
which requires you to know and love Git, Markdown syntax, YAML, SSH keys, etc. I
usually refer people to WordPress.com instead, because at least WordPress is
free, open source, and can’t trap them in a walled garden. But I wish I were
making the recommendation from a place of greater firsthand experience.

**Financial question since the Web is obsessed with money: how much does it cost
to run your blog? Is it just a cost, or does it generate some revenue? And
what's your position on people monetising personal blogs?**

With free hosting from GitHub Pages, my only direct cost is 12 USD/year for the
domain name. Every few months, I pay a penny to rent a VPS, set up my site’s
build pipeline, configure Apache, and test it all out. It’s that practice
mentality again—I want to know I have options if I ever decide to move away from
GitHub Pages.

I don’t object to others monetizing their blogs. However, when it comes to my
personal consumption habits, I seem very reluctant to pay for anything on a
subscription basis. My only media subscription is to the print edition of my
[favorite literary magazine](https://www.thesunmagazine.org/). I think my
revealed preference is for blogs that are wide open but double as a storefront
for the author’s print books or CDs, sort of like Cory Doctorow’s site.

**Time for some recommendations: any blog you think is worth checking out? And
also, who do you think I should be interviewing next?**

So, one corner where old-school blogs are still going strong is in the community
around foreign exchange programs like the (US government) Critical Language
Scholarship, Fulbright, and Peace Corps programs. Participants in these programs
often find, as I did, that living overseas for an extended period produces a
kind of character growth that is difficult to fit into the tidy post formats of
traditional social media. My friends
[Bethany](https://bethanymaz.wordpress.com/) and
[Paula](https://paulazhang.wordpress.com/) have kept their blogs going for years
since returning to the US, and both sites are awesome rabbit holes of personal
reflection and useful information about how these exchange programs work.
Fulbright Korea itself also has an official WordPress blog called
[Infusion](https://infusion.fulbright.or.kr/) run by current grantees.

Further recommendations: [Anh’s homepage](https://anhvn.com/) is one of my
favorite personal blogs. I don’t know the author, but the design and content
work together to project a very vivid sense of her personality. And she is an
exceptional artist;
[check these out](https://anhvn.com/sketchbook/pleinairpril/).

[Shellsharks](https://shellsharks.com/) is also design inspo. I appreciate the
[Style Guide](https://shellsharks.com/style) that shows all the CSS styles in
one place. This site is super ambitious—really three or four blog-type things
layered over each other—but totally sticks the landing.

[Idealistic Future](https://idealisticfuture.com/) is a small trove of insights
and anecdotes about the role of storytelling in the modern workplace.

I’ve followed [Futility Closet](https://www.futilitycloset.com/) since I learned
how to work the internet.

I love <a href="http://www.airplaneonatreadmill.com/" data-proofer-ignore>Airplane on a Treadmill</a>,
specifically for this opening line:

> I created this blog specifically to make this post. It may be the only post I
> ever write, but since human ignorance is seemingly unbounded, perhaps it won’t
> be.

(He wrote three more posts.)

I am not a parent, but I’ve always enjoyed the
[Free Range Kids](https://www.freerangekids.com/) blog, which challenges the
decades-long trend of helicopter parenting in favor of letting kids make
mistakes and grow.

The [*Chicago Manual of Style* blog](https://cmosshoptalk.com/) and
[Q&A](https://www.chicagomanualofstyle.org/qanda/latest.html) are entertaining
if you are into such things.

But as for who to interview next: I want to hear from
[Herb Childress](https://herbchildress.com/blog/). He is a retired academic who
has written vividly about
[trying and failing](https://herbchildress.com/2019/03/01/on-cooling-the-mark-out/)
to land a tenure-track job. He might offer interesting thoughts on carving out a
space (including on his blog) for his writing and academic identity despite
rejection from traditional institutions.

**Final question: is there anything you want to share with us?**

First, track 1 from Gregory Porter’s *Water* album, which is where I got my
blog’s name.

Second, Jia Tolentino’s *Trick Mirror,* which my friend got me into. I keep
coming back to this collection of essays, especially the one about unearthing a
DVD of her appearance on a reality TV show a decade after it aired. Big thoughts
about constructing the self through the perception of others.

Third, whatever the hell is going on with [fluxus.org](https://www.fluxus.org/).
