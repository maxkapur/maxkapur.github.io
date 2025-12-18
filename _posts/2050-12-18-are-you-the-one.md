---
layout: post
katex: true
title: Find your perfect match with integer programming
---

Owen Lacey
[blogged](https://blog.owenlacey.dev/posts/are-you-the-one-is-free-money/) about
a reality game show called *Are You the One?* in which contestants can win a
prize if they guess the matching ordained for them by the show's producers.
Specifically, there are $$n$$ men and $$n$$ women, and each one an unknown
"perfect" match; to win the prize, they have to pair everyone up correctly.

Each episode, the contestants get two kinds of clues:

1. Truth Booth, where the contestants submit a single *couple* and learn whether
   that couple is a perfect match.
2. Match Up, where the contestants submit a *matching* (assigning everyone to a
   couple) and learn the number (but not the identity) of perfect matches
   present in their matching.

The game ends after Match Up if all $$n$$ couples in the matching are correct.
Definitely check out Owen's post, which has a better (and illustrated!)
explanation of the rules.

In this post, I present an efficient algorithm for playing *Are You the One?*
It exploits both the informational clues and contestants' intuitions about
compatibility to win consistently. With modest assumptions on the quality of
players' intuitions, my algorithm wins by episode&nbsp;10 in 100% of simulated
seasons.

<!--more-->

# Owen's algorithm: Eliminating alternatives using information theory

To set the stage for my algorithm, let me summarize Owen's approach.

Owen's central idea is to choose Truth Booth and Match Up submissions on the
basis of the expected information to be gained.
Imagine, at the beginning of the season, writing down a list of all $$n!$$
possible matchings. If, in the episode&nbsp;1 Truth Booth, we learn that Alice and
Bob *aren't* a perfect match, we can cross off all $$n! / n$$ matchings that
include this couple—that's progress.

Similarly, after we get our Match Up score
at the end of the episode, we can examine each possible matching and ask, if it
were the ground truth, what the Match Up score would have been. If the real score
differs, then that eliminates that matching from consideration.

In Truth Booth and Match Up alike, the number of matchings a given guess
eliminates is hard to know without actually scanning the full list of matchings,
because previous eliminations can interact with new clues in complicated ways.
Thus, Owen's algorithm for both subgames (as I understand it) is consider each
potential guess, and simulate it against each potential matching. We compute the 
average number of matchings eliminated by each guess. The logarithm of this value
gives each guess's *entropy,* and we select the guess with the highest entropy.

This algorithm won the game in 98% of Owen's simulations.

# My design objectives

Owen's blog post left me with two questions. First, Owen's algorithm is
pessimistic. It assumes zero intuition about which couples are perfect matches;
every possible matching is equally likely. But what if we *do* have some
intuition about which couples are compatible—can we exploit this knowledge to
win sooner, or more consistently?

- **Objective 1:** Exploit both clues *and* contestant intuition in order to
  maximize the win rate.

Second, iterating all possible guesses and matches is a heavy proposition. Owen
applied a few clever optimizations to avoid provably wrong guesses, but it's
hard to salvage factorial time complexity:

> I ran this information theory simulation 41 times (for no other reason than I
> got bored waiting)

Can we write an algorithm that is computationally efficient? Let's set an
arbitrary goal.

- **Objective 2:** Simulate 100 seasons in under 1 minute on my unremarkable
  desktop (AMD Ryzen 5 4600G processor, 16GB of RAM).

Point of emphasis: With these objectives, my algorithm and Owen's aren't really
in competition. My problem setup is more generous (players have additional
information at the outset), and thus my goals are more ambitious (win more, simulate faster).

# My algorithm: Balancing contestant intuition with informational constraints

My model of *Are You the One?* has three components:

1. A *statistical model* of the "vibes" that contestants get about each couple's compatibility.
2. An algorithm for choosing which couple to guess for Truth Booth.
3. An algorithm for choosing which matching to guess for Match Up.

My guessing algorithms are based on integer programming (IP), an operations research
technique that lets us optimize for a goal (my guess reflects my intuition) while applying logical constraints (my guess doesn't contradict any clues). 

## Statistical model of contestant intuitions

To generate random instances, we first assign each couple a compatibility score
$$c_{ij}$$ drawn from a standard normal distribution. These values represent
the true compatibility of man $$i$$ with woman $$j$$ (that is, according to the
show's producers). We then solve the
[maximum-weight bipartite matching](https://en.wikipedia.org/wiki/Assignment_problem)
problem to obtain the ground-truth perfect matching. This procedure generates
each of the possible $$n!$$ matchings with equal probability.

Contestants cannot observe $$c_{ij}$$ directly, but instead observe
$$v_{ij}$$, which is $$c_{ij}$$ plus a normal variate with mean zero and
standard deviation $$2^{-s}$$. Here $$s$$ represents the strength of
contestants' intuition: If $$s \ll 0$$, then their intuitions are essentially
random noise; if $$s \gg 0$$ then their intuitions are spot-on.

The strength parameter $$s$$ gives us a slider to test how bad our intuitions
need to get before a pessimistic algorithm like Owen's has better odds of
winning. I chose to scale $$s$$ exponentially on the hunch that this would yield
a roughly linear relationship between $$s$$ and the number of turns to win
(which turned out to be true).

## Match Up algorithm

I'll present my algorithm for Match Up first, because the Truth Booth algorithm
is really an extension of it.

In my algorithm, we compute the contestants' guess for Match Up as the
maximum-weight bipartite matching, using the $$v_{ij}$$ values as the weights,
with additional constraints generated by the clues they have seen so far.
In plain language, we pick the guess that best resonates with our vibes without
contradicting any of the clues we've received.

Specifically, let the binary decision variable $$x_{ij}$$ equal one if man
$$i$$ matches with woman $$j$$ in our Match Up submission. Let $$P$$ denote the
set of couples $$(i, j)$$ known (from the Truth Booth) to be perfect matches,
and $$\cancel{P}$$ the set of couples known *not* to be perfect matches. Let
$$\mathcal{M}$$ denote the set of Match Up results. The elements of
$$\mathcal{M}$$ are tuples $$(M, k)$$, where $$M$$ is the set of couples $$(i,
j)$$ submitted, and $$k$$ is the score.

The solution to the following IP is called the *best matching:*

$$
\begin{aligned}
  \text{maximize} \quad     & \sum_{i=1}^n \sum\_{j=1}^n v_{ij} x_{ij} \\
  \text{subject to} \quad   & \sum_{j=1}^n x_{ij} = 1 & \forall i \in \{1 ... n\} \\
                            & \sum_{i=1}^n x_{ij} = 1 & \forall j \in \{1 ... n\} \\
                            & x_{ij} == 1 & \forall (i, j) \in P \\
                            & x_{ij} == 0 & \forall (i, j) \in \cancel{P} \\
                            & \sum_{(i, j) \in M} x_{ij} == k & \forall (M, k) \in \mathcal{M} \\
                            & x_{ij} \text{ binary} & \forall (i, j) \in \{1 ... n\}^2
\end{aligned}
$$

The first two constraints define the
[bipartite matching polytope](https://en.wikipedia.org/wiki/Assignment_problem#Solution_by_linear_programming).
The following three constraints say that $$x_{ij}$$ must agree with our clues.

## Truth Booth algorithm

The Truth Booth is purely informational; you don't win anything by guessing
correctly. However, in the absence of other clues, a correct guess in Truth
Booth rules out more matchings (about $$(n-1) / n$$ of them) than an incorrect
guess (which rules out only $$1/n$$ matchings). So, for the Truth Booth, my
algorithm uses a heuristic: We try to make a guess that is *not certain,*
but still *likely* to be correct.

First, we compute the best matching using the IP above. Any of the $$(i, j)$$
pairs in the best matching is a *valid* guess for truth booth. But some of them
are *silly* guesses, because we already know they are a perfect match; we
should filter these out (the "not certain" criterion above)

The easiest couples to filter out are those that were already revealed as a
perfect match in a past Truth Booth. No sense submitting them again.

For the remaining couples, even without a Truth Booth result, we may know
*implicitly* that they go together, because all matchings in which they don't
are contradicted by the sum of our clues. To detect if $$(i, j)$$ from the best
matching is an implicit perfect match, we can solve another IP, which consists
of the best matching IP, with the added constraint $$x_{ij} == 0$$. (We can also
delete the objective function.) If this adjusted IP is *infeasible,*
then $$(i, j)$$ is an implicit perfect match, and we should filter it out of
our set of candidate truth booth guesses, too.

The couples that remain after applying these filters are *flexible couples,*
i.e. we can identify a matching, compatible with our clues, in which they pair
with someone else. Among the flexible couples, in my heuristic, we guess the
couple with the *highest* vibes. This satisfies the "likely" criterion above.

(FWIW, I experimented choosing the flexible couple with the *poorest* vibes
instead. There wasn't much of an impact to the bottom-line win rate, but the
script ended up spending a lot more time solving the integer programs.)

# Implementation and experiments

I implemented the algorithm in Julia, using the JuMP.jl modeling language and
SCIP as the IP solver background. You can find all the source code [here on
GitHub](https://github.com/maxkapur/AreYouTheOne.jl).

I then ran three experiments to see if my algorithm fulfills the design objectives.

## Experiment 1: Intuition strength vs. turns to win

For this experiment, we sample $$s$$ uniformly between $$-5$$ and $$5$$. These
endpoints represent signal-to-noise ratios of 1:32 and 32:1, respectively, so
the x-axis in the plot below run the gamut from "virtually no intuition" to
"spot-on intuition."

Each point in the scatter plot below corresponds to one season or run of the full game.
The y-axis represents the number of turns the contestants took to make a correct
guess in Match Up.

<figure>
  <img
    alt="Scatter plot showing negative correlation between strength of intuition and turns to win"
    src="{{ site.baseurl }}/assets/images/are-you-the-one/strength-vs-nturns.svg"
  />
</figure>

We see a roughly linear, negative relationship between intuition strength and
turns taken. We win by episode&nbsp;10 most of the time, even at the noisy left end
of the plot. 

## Experiment 2: No intuition

To stress-test my algorithm, let's focus on the left edge of the Experiment 1
plot and slide $$s$$ all the way down to $$-\infty$$. (What I actually do is
just delete $$c_{ij}$$ entirely from the expression for $$v_{ij}$$ and sample
the vibes as pure standard normal noise.)

This case is similar to Owen's setup—participants have no intuition about which
couples are perfect matches, and their vibes $$v_{ij}$$ exist only as an
arbitrary guide so that the IP solver has something to optimize.

Let's plot a simple histogram showing how many episodes it takes contestants to win.

<figure>
  <img
    alt="Histogram showing number of turns to win with intuition at negative infinity. A bell curve centered around 8 or 9"
    src="{{ site.baseurl }}/assets/images/are-you-the-one/no-intuition.svg"
  />
</figure>

In this case, Owen's algorithm is clearly the best possible. My algorithm wins
by episode&nbsp;10 only 93% of the time, compared to Owen's 98%. However, 93% is
still much better than the 74% and 71% accuracy obtained, respectively, by
random guessing and actual *Are You the One?* contestants (according to Owen's
post), and it took only about two minutes to run all 500 simulations reflected in
the plot above.

## Experiment 3: Weak intuition

The third experiment features conditions that are better aligned to my
algorithm's objectives. We fix $$s = -1$$ (a signal-to-noise ratio of 1:2),
meaning that contestants have some intuition, but it's not particularly strong.

<figure>
  <img
    alt="Histogram showing number of turns to win with intuition at negative infinity. A bell curve centered around 6 or 7"
    src="{{ site.baseurl }}/assets/images/are-you-the-one/weak-intuition.svg"
  />
</figure>

In this case, we eke out a win 100% of the time! And again, running all 500
simulations took less than two minutes.

# Is this the best we can do?

Above, we devised an algorithm for *Are You the One?* that balances competing
objectives:

- Utilize clues from Truth Booth and Match Up
- Exploit contestants' intuition about compatibility
- Computational efficiency

Under favorable conditions, the algorithm wins 100% of the time. Under
unfavorable conditions (if we scramble contestants' intuitions),
the algorithm still wins 93% of the time. In every case, it's fast enough to
run a large number of simulations.

Like Owen, I find the *Are You the One?* game to have many charming similarities
to Wordle. In Wordle, you have to balance the information gained by *exploring*
unused letters against *exploiting* the clues you already have. In the *New York
Times* version of Wordle, a pessimistic strategy informed by information
theory is the only way to guarantee a win. But in two-player Wordle (where an
opponent chooses the word), you can leverage your intuitions about the opponent's
favorite words to guess the answer more quickly.

Many numerical optimization problems feature such an explore/exploit tradeoff.
In classic cases of the [multi-armed bandit
problem](https://en.wikipedia.org/wiki/Multi-armed_bandit), for example, we can
identify strategies that strike an ideal (in a technical sense) balance between
exploration and exploitation.

I doubt that my algorithm is optimal, from a win-probability standpoint, for
my problem setup. All of the information-theoretic concepts introduced in Owen's
blog post can be applied to arbitrary (not just uniform) distributions over
matchings—to include the conditional distribution of the ground-truth matching
on the vibes $$v_{ij}$$. If you can estimate that distribution (more simulations…), then you
can compute the entropies in Owen's algorithm as weighted averages over
matchings. That algorithm would be, you know, *optimal* optimal—and *very* slow.

# References

- [Owen Lacey's blog post](https://blog.owenlacey.dev/posts/are-you-the-one-is-free-money/)
  analyzing *Are You the One?* from an information theory perspective
- [Source code](https://github.com/maxkapur/AreYouTheOne.jl) for my algorithm
  and plots
