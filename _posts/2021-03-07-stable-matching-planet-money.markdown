---
layout:     post
title:      Stable matching on Planet Money
date:       2021-03-07 00:00:00 +0000
categories: research
---

<em>Planet Money,</em> an NPR show about economics, recently ran an <a href="https://www.npr.org/2021/03/02/972943944/the-marriage-pact">episode entitled &ldquo;The Marriage Pact&rdquo;</a> that deals precisely with my research topic. It&rsquo;s a great episode that discusses both the basic ideas behind stable assignment as well as its applications in organ donation, job placement, and (my area of focus) school choice.

The episode begins with an interview with a Stanford econ student who designed a marriage market for his peers and managed to get 4111 of them to sign up for it. What a cool project! The student makes a few minor misstatements about the Gale&ndash;Shapley proposal algorithm that <em>Planet Money</em> leaves uncorrected. In this post, I want to offer a few corrections, not just because I can, but because in my opinion these marginal details are what make stable assignment an interesting and profitable research topic.

<!--more-->

The interviewee says that because the proposal algorithm produces a stable matching, it is guaranteed to provide participants with their &ldquo;best&rdquo; match. But it turns out that even when the participants in the proposal algorithm have strict preferences, there can actually be more than one set of stable matchings, and which stable matching you get depends on which form of the algorithm you use.

If you run the algorithm in the male-proposing form, you get a match that is simultaneously male-optimal and female-pessimal. This means that among all of the women Fido could be stably matched with, the male-proposing algorithm is guaranteed to pair Fido with his first choice, and to pair Fido&rsquo;s mate with the male she likes <em>least</em> among the males she could stably match with.

Likewise, if you run the algorithm in the female-proposing form, you get a match that is female-optimal and male-pessimal.

In the episode, the hosts mention that the algorithm provides the participants with no incentive to lie about their preference order (notwithstanding misrepresenting basic facts about <em>themselves</em> like height). But an important corollary of the result above is that the male-proposing algorithm is actually <em>not</em> strategy-proof for the <em>female</em> participants—by lying, they may end up with a male better than their worst match.

I don&rsquo;t know how the Stanford match works, but it&rsquo;s likely that (for the straight participants) they used an extension of the Gale–Shapley algorithm developed in the 1980s that finds the &ldquo;male–female optimal stable match&rdquo;—a sort of compromise between the male- and female-proposing forms. This extended algorithm, while egalitarian, isn&rsquo;t strategy proof for <em>either</em> group of participants, precisely because it gives both groups a slightly suboptimal match.

The good news it that in the one-to-one matching case with strict preferences, the differences between the male- and female-optimal matches are quite minimal (usually just a shuffling a few pairs around at the edges, if any), and the &ldquo;strategy&rdquo; you need to use to beat the market is not at all obvious.

But when we relax the assumption of strict preferences and start to work with many-to-one matching, as is the case in school choice, the set of stable matches becomes very large, and coming up with a good way to maximize participants&rsquo; outcomes while maintaining incentive compatibility is an interesting challenge. The dominant contenders in this space are randomized &ldquo;tiebreaking&rdquo; (lottery) mechanisms, including those used in school markets in New York, Boston, and elsewhere. I&rsquo;ve run a bunch of computational experiments on these mechanisms, and you can see some fun graphs on the <a href="https://github.com/maxkapur/DeferredAcceptance">Github page for my Julia package DeferredAcceptance</a>.

(I sent a version of this to the <em>Planet Money</em> team, but I&rsquo;m not betting on a response.)
