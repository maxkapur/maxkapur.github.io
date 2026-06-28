+++
title = "PageRanking People and Blogs interviews"
aliases = [ "/2026/05/06/pageranking-pb.html",]

[params]
id = "https://maxkapur.com/2026/05/06/pageranking-pb"
+++

I recently learned about [PageRank](https://en.wikipedia.org/wiki/PageRank), the
original Google algorithm for ranking webpages. It works by constructing a
Markov chain on links between pages and computing the stationary distribution.
The stationary probability of a given page measures the page's centrality in the
web, an index of popularity.

I wanted to try implementing the algorithm myself and fiddle with a few Rust
libraries, so I wrote a [script](https://github.com/maxkapur/pbnx) that runs
PageRank on interviews from the [People and Blogs](https://peopleandblogs.com/)
series. P&B interviews are a tidy dataset for the algorithm, because Manu always
asks interviewees to recommend other blogs, then he uses these recommendations
to pick subsequent interviewees. This means the graph is well connected despite
its small size.

I was going to share the results here, but ranking blogs by popularity seems
against the spirit of the indie web ethos, so you'll have to run the program
yourself. (But to make it clear I'm not covering anything up, let me acknowledge
that [my interview](https://manuelmoreale.com/interview/max-kapur) is in a
61-way tie for last place, with all the other blogs that had no links to them.)

A few observations from this exercise below.

<!--more-->

- I computed the stationary distribution explicitly using `ndarray_linalg::eig`
  because that's one of the libraries I was fiddling with, but for a graph with
  a large number of nodes, storing the {{< math "O(n^2)" />}} Markov array in memory is
  impractical; you'd be better off just simulating the random jumps instead.
- A Monte Carlo simulation would yield cleaner code than my solution, too. Most
  of the bugs I had to fix in my implementation had to do with constructing the
  Markov matrix, normalizing columns, and handling edge cases like nodes with
  outdegree zero. If all you're doing is walking the graph one node at a time,
  you can address the edge cases procedurally in a way that's more obviously
  correct (e.g. "if a page has no links, jump randomly to any page").
- The hard work in Google's implementation would surely have been the data
  engineering. You have to find the "content" part of every page to avoid
  overrepresseing header and footer links like About and Privacy, but semantic
  HTML wasn't a thing yet. And it would take a lot of work to normalize URLs to
  handle synonyms that differ only by a `www.` prefix or trailing slash (not to
  mention redirects and permalinks).

Like many developers, the LLM era is interfering with my motivation to post
[brain coded](https://domm.plix.at/perl/2025_10_braincoded_static_image_gallery.html)
projects like this. That's especially true when, as here, I'm exercising a
language or concept that I'm still learning—my PageRank implementation is
neither performant nor educational. But as I told Manu in the P&B interview, I
use my blog and GitHub more for accountability than publicity: The goal is to
simply keep myself writing and coding.

Publish post.
