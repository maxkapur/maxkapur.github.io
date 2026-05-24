+++
title = "Systems for making systems"
aliases = [ "/2026/06/03/metasystems.html",]
+++

I read a comment stating that git (a tool programmers use to collaborate on
code, sort of like Word's Track Changes) is not a version control system but a
"system for creating a version control system."

That got me thinking about other such "metasystems" I use, and the frustration
that arises when one expects a mere system and instead gets the meta
thing.<!--more-->

# Anki

[Anki](https://apps.ankiweb.net/) is a system for making a flashcard system.
I've used this excellent program for about four years to memorize Korean vocab.
But the first time I tried Anki, I downloaded a stock deck of Korean words and
felt confused and overwhelmed.

Studying with someone else's Anki deck is a mistake, because it skips the most
important part of spaced repetition learning: determining what you're actually
trying to learn and breaking it into flashcard-sized units. For example, if
you're using Anki to learn a language, how do you want to handle synonyms? (That
might be a separate post.) Creating your own deck forces you to answer such
questions and clarify your learning goals.

# Microsoft Excel

Much hated, but much misunderstood. You may think Excel is a spreadsheet tool,
but it's actually a tool for making spreadsheet tools.

I learned this the hard way when I did process automation stuff at work and
witnessed how widely people's Excel conventions vary. Everyone uses the
file/worksheet/row/column hierarchy differently. Some enlightened people code
booleans using the native `TRUE` and `FALSE`, but others use the strings "yes"
and "no" (or blank), the checkbox widget, or the cell background color (have fun
querying that in Pandas).

Did you know that Excel incorporates an entire
[programming language](https://learn.microsoft.com/en-us/office/vba/api/overview/excel)?
OK, but did you know about the
[other one](https://learn.microsoft.com/en-us/office/dev/add-ins/reference/overview/excel-add-ins-reference-overview)?
Or sorry, [this one](https://learn.microsoft.com/en-us/powerquery-m/)?

Sometimes, I wish Excel had a
[bumpers mode](https://www.youtube.com/watch?v=VAzdvyFxzy8) that removes all the
formatting options (especially Merge Cells!!) and forces you to put data in
named
[tables](https://support.microsoft.com/en-us/office/overview-of-excel-tables-7ab0bb7d-3a9e-4b56-a3c9-6c94334e492c)
with strict column types. But that would just be a spreadsheet tool. It wouldn't
be Excel.

# CSS

CSS is how you set the color, layout, and style of web pages. The CSS for this
site is quite a mess, a bunch of
[ad-hoc fixes](https://github.com/maxkapur/maxkapur.github.io/blob/938899557c4214dcd1e649cef8bca29913d366ba/_sass/minima/_layout.scss#L187-L195)
tacked on as I added new features to Illusion Slopes. I've gotten better at CSS
since setting up the Jekyll build, but my skills are mainly useful on new
projects, where I can architect the HTML and CSS from scratch. The mental shift
I made is from using CSS to style an individual page, to using CSS to create a
*system* that styles pages. A *cascade* of styles, if you will …

[This post](https://jacobb.nyc/writing/how-i-write-css-in-2024) from Jacob
Bleser outlines the kind of CSS system I want to set up for my site once I
gather the courage to do a big migration.

# Powerful but frustrating

Everyone new to git has had the [xkcd 1597](https://xkcd.com/1597/) experience
of trashing and re-cloning the repo to make a merge work. Metasystems like git
are powerful but hard to learn, which explains the abundance of businesses like
GitHub that purport to make the underlying tool more approachable.

But a good metasystem tends to resist such taming efforts because it is
precisely as complex as the problem space requires. Simplifying tools are often
unwieldly in their own ways (see
[this critique of Tailwind CSS](https://blog.sebin-blog.sebin-nyshkim.net/posts/tailwind-suffering-from-success/nyshkim.net/posts/tailwind-suffering-from-success/)),
while disappointing power users who want access to the raw workflow—the worst of
both worlds.

But hey, they added
[yet another programming language](https://support.microsoft.com/en-us/office/get-started-with-python-in-excel-a33fbcbe-065b-41d3-82cf-23d05397f53d)
to Excel.

<!--
Couldn't figure out where I was going with this

# Life is a metasystem

Life is an opportunity to define our own system. Parents, school, and society
provide some scaffolding, but it's all subject to interpretation and revision.
Everyone wants something different from git, and everyone wants something
different in life.
-->