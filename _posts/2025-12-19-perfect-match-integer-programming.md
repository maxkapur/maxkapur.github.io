---
layout: post
katex: true
title: Find your perfect match with integer programming
---

Owen Lacey
[blogged](https://blog.owenlacey.dev/posts/are-you-the-one-is-free-money/) about
a reality game show called *Are You the One?* in which contestants win a
prize by guessing the soulmate ordained for them by the show's producers.
Specifically, there are $$n$$ men and $$n$$ women, and each one has an unknown
"perfect" match; to win the prize, the contestants (as a group) must pair
everyone up correctly.

During each episode, the contestants get two kinds of clues:

1. Truth Booth, where the contestants submit a single *couple* and learn whether
   that couple is a perfect match.
2. Match Up, where the contestants submit a *matching* (assigning everyone to a
   couple) and learn the number (but not the identity) of perfect matches
   present in their matching.

The game ends after Match Up if all $$n$$ couples in the matching are correct.
Definitely check out Owen's post, which has a better (and illustrated!)
explanation of the rules.

Below, I present an efficient algorithm for playing Are You the One.
It exploits both the informational clues and contestants' intuitions to find
perfect matches quickly. With modest assumptions on the quality of
players' intuitions, my algorithm wins by episode&nbsp;10 in 100% of simulated
seasons.<!--more-->

(I will style the name of the show as *Are You the One?* and the name of the
underlying game as just Are You the One.)

# Owen's algorithm: Eliminate alternatives with information theory

To set the stage, let me summarize Owen's approach. In short, he chooses Truth
Booth and Match Up submissions on the basis of the expected information to be gained.

Imagine writing down a list of all $$n!$$ possible matchings at the beginning of
the season. If, in the episode&nbsp;1 Truth Booth, we learn that Alice and
Bob *aren't* a perfect match, we can cross off all $$n! / n$$ matchings that
include this couple. That's progress.

Similarly, after we get our Match Up score
at the end of the episode, we can examine each possible matching and ask, "If this
were the ground truth, what would have been our guess's Match Up score?" If the
observed score differs, then that rules out that matching.

As the season evolves,
Owen's goal is to narrow things down as quickly as possible by submitting the guesses
that eliminate the most matchings. Thus, in both subgames, his algorithm has us
simulate each potential guess against each potential matching. We count up the
average number of matchings that each guess would cross out. The logarithm of this value
is called the guess's *entropy.* We play the guess with the highest entropy.

This algorithm won the game by episode&nbsp;10 in 98% of Owen's simulations—convincing
evidence that *Are You the One?* is "pretty much free money."

# My design objectives

Owen's post left me with two questions.

First, the information-theoretic algorithm is
pessimistic. It assumes zero intuition about which couples belong together;
every matching is equally likely. But what if we *do* have some
intuition about compatibility—can we exploit this knowledge to
win sooner, or more consistently?

- **Objective 1:** Exploit both clues *and* contestant intuition to
  maximize the win rate.

Second, computing entropies entails a lot of math. In Truth Booth and Match Up
alike, to count the number of eliminations, we have little choice but to scan
the full, long list of potential matchings. There's no shortcut, because previous
eliminations interact with new clues in complicated ways. And we have to run that
scan for *every* possible guess. Owen
applied a few clever optimizations to avoid provably wrong guesses, but it's
hard to salvage factorial time complexity:

> I ran this information theory simulation 41 times (for no other reason than I
> got bored waiting)

Can we make our algorithm computationally efficient? Here's an arbitrary benchmark
that I totally didn't come up with until after testing my code.

- **Objective 2:** Simulate 100 seasons in under 1 minute on an unremarkable
  desktop (AMD Ryzen 5 4600G processor, 16GB of RAM).

Point of emphasis: With these objectives, my algorithm and Owen's aren't really
in competition. My problem setup is more generous (players have additional
information at the outset), and my goals (win more, simulate faster) are
therefore more ambitious.

# My algorithm: Balance intuition and informational constraints

My model of Are You the One includes three components:

1. A statistical model of the "vibes" that contestants get about each couple's compatibility
2. An algorithm for choosing which couple to guess for Truth Booth
3. An algorithm for choosing which matching to guess for Match Up

The statistical model lets us slide the strength of contestants' intuition
up and down to experiment with how it affects the win rate.
The guessing algorithms are based on integer programming (IP), an operations research
technique that lets us optimize for a goal (my guess reflects my intuition)
while applying logical constraints (my guess doesn't contradict any clues).
IP solvers don't need to iterate every possible solution or matching, because they
leverage the problem's mathematical structure to prune whole families of suboptimal
solutions from the search space.

## Statistical model of contestant intuitions

To generate random instances, my model first assigns each couple a compatibility score
$$c_{ij}$$ drawn from a standard normal distribution. These values represent
the "true" compatibility of man $$i$$ with woman $$j$$ (according to the
show's producers). We then solve the
[maximum-weight bipartite matching](https://en.wikipedia.org/wiki/Assignment_problem)
problem to obtain the ground-truth perfect matching.

This computation sounds fancier than
it is; the idea is to match everyone up in a way that maximizes the overall
sum of compatibility scores. [More sophisticated matching algorithms]({%- post_url 2021-03-07-stable-matching-planet-money -%})
exist, but the maximum-weight procedure suits our purposes well.
It generates each of the possible $$n!$$ matchings with equal probability, and
it comes with extra data $$c_{ij}$$ that we can use to drive intuitions.

Contestants don't get to see $$c_{ij}$$, but instead observe
$$v_{ij}$$, which is $$c_{ij}$$ plus a normal variate with mean zero and
standard deviation $$2^{-s}$$. Here $$s$$ represents the strength of
contestants' intuition. If $$s \ll 0$$, then their intuitions are essentially
random noise; if $$s \gg 0$$ then their intuitions are spot-on.

The strength parameter $$s$$ enables us to test how bad players' intuitions
can get before a pessimistic algorithm like Owen's has better odds of
winning than one based on vibes. I chose to scale $$s$$ exponentially on the
hunch that this would yield a roughly linear relationship between $$s$$ and the
number of turns to win (which turned out to be true).

## Match Up algorithm

I'll present my algorithm for Match Up first, because the Truth Booth algorithm
builds on it.

In my algorithm, we pick the guess for Match Up that best resonates with our
vibes without contradicting any of the clues we've gathered. Formally, we compute
the maximum-weight bipartite matching using the $$v_{ij}$$ values as the weights,
while applying logical constraints generated by previous rounds of Truth Booth
and Match Up.

Let the binary decision variable $$x_{ij}$$ equal one if man
$$i$$ matches with woman $$j$$ in our Match Up submission, and zero if not.

Let $$P$$ denote the set of couples $$(i, j)$$ known (from the Truth Booth) to be
perfect matches, and $$\cancel{P}$$ the set of couples known *not* to be perfect
matches.

Let $$\mathcal{M}$$ denote the set of Match Up results. The elements of
$$\mathcal{M}$$ are tuples $$(M, k)$$, where $$M$$ is the set of couples $$(i,
j)$$ submitted, and $$k$$ is the score.

The solution to the following IP is called the *best matching:*

$$
\begin{aligned}
  \text{maximize} \quad     & \sum_{i=1}^n \sum_{j=1}^n v_{ij} x_{ij} \\
  \text{subject to} \quad   & \sum_{j=1}^n x_{ij} = 1 & \forall i \in \{1 \dots n\} \\
                            & \sum_{i=1}^n x_{ij} = 1 & \forall j \in \{1 \dots n\} \\
                            & x_{ij} = 1 & \forall (i, j) \in P \\
                            & x_{ij} = 0 & \forall (i, j) \in \cancel{P} \\
                            & \sum_{(i, j) \in M} x_{ij} = k & \forall (M, k) \in \mathcal{M} \\
                            & x_{ij} \text{ binary} & \forall (i, j) \in \{1 \dots n\}^2
\end{aligned}
$$

The first two constraints define the
[bipartite matching polytope](https://en.wikipedia.org/wiki/Assignment_problem#Solution_by_linear_programming).
The following three constraints require that $$x_{ij}$$ agree with our clues.
The final constraint just says that $$x_{ij}$$ is binary (not a fraction).

## Truth Booth algorithm

The Truth Booth is purely informational; we don't win anything with a correct
guess. However, in the absence of other clues, a correct guess in Truth
Booth rules out more matchings than an incorrect guess. So, for the Truth Booth, my
algorithm tries to make a guess that is *not certain,* but still *likely* to be
correct.

First, we compute the best matching using the IP above. Any of the $$(i, j)$$
pairs in the best matching is a *valid* guess for truth booth. But some of them
are *silly* guesses, because we already know they are a perfect match; we
should filter these out (hence the "not certain" criterion above).

The easiest couples to filter out are those that were already revealed as a
perfect match in a past Truth Booth. No sense submitting them again.

Among the remaining couples, even without a Truth Booth result, we may know
*implicitly* that they go together, because all matchings in which they don't
are contradicted by the sum of our clues. To detect if $$(i, j)$$ from the best
matching is an implicit perfect match, we can solve another IP, which consists
of the best matching IP with the additional constraint $$x_{ij} = 0$$. If this
adjusted IP is *infeasible,* then $$(i, j)$$ is an implicit perfect match, so
we shouldn't submit that couple to the truth booth.

The couples that survive these filters are *flexible couples,*
i.e. we can identify a matching, compatible with our clues, in which they pair
with someone else. Among the flexible couples, my heuristic is to guess the
couple with the *highest* vibes. This satisfies the "likely" criterion above.

(I experimented with choosing the flexible couple with the *poorest* vibes.
There isn't much of an impact to the bottom-line win rate, but the
script spends longer solving the integer programs.)

# Implementation and experiments

I implemented the algorithm in Julia using the JuMP.jl modeling language and
SCIP solver. You can find all the source code [here on
GitHub](https://github.com/maxkapur/AreYouTheOne.jl).

I ran three experiments to verify that my algorithm fulfills the design objectives.

## Experiment 1: Intuition strength vs. turns to win

For this experiment, we sample $$s$$ uniformly between $$-5$$ and $$5$$. These
endpoints represent signal-to-noise ratios of 1:32 and 32:1, respectively, so
the x-axis in the plot below runs the [gamut](https://www.etymonline.com/word/gamut)
from "virtually no intuition" to "spot-on intuition."

Each point in the scatter plot below corresponds to one full game (one season).
The y-axis represents how many turns contestants took to make a correct
guess in Match Up.

<figure>
  <img
    class="compact squareborder"
    alt="Scatter plot showing negative correlation between strength of intuition and turns to win"
    src="{{ site.baseurl }}/assets/images/are-you-the-one/strength-vs-nturns.svg"
  />
</figure>

We see a roughly linear, negative relationship between intuition strength and
turns taken. We win by episode&nbsp;10 most of the time, even on the noisy side
of the plot.

## Experiment 2: No intuition

To stress-test my algorithm, let's focus on the left edge of the experiment&nbsp;1
plot and slide the intuition strength all the way down to $$s = -\infty$$. (What I actually do is
delete $$c_{ij}$$ entirely from the expression for $$v_{ij}$$ and sample
the vibes as pure Gaussian noise.)

This case is similar to Owen's setup. Participants have no intuition about which
couples are perfect matches, and their vibes $$v_{ij}$$ serve only to give the IP
solver something to optimize.

The histogram below shows how many episodes contestants typically need to win.

<figure>
  <img
    class="compact squareborder"
    alt="Histogram showing number of turns to win with intuition fixed to negative infinity. A bell curve centered around 8 or 9"
    src="{{ site.baseurl }}/assets/images/are-you-the-one/no-intuition.svg"
  />
</figure>

In the challenging environment of experiment&nbsp;2, my algorithm wins by
episode&nbsp;10 only 93% of the time, compared to Owen's 98%. However, 93% is
still appreciably better than the 74% and 71% accuracy obtained, respectively,
by random guessing and actual *Are You the One?* contestants (according to
Owen's post). And it takes just under two minutes to run all 500 simulations
reflected in the plot above.

## Experiment 3: Weak intuition

The conditions of experiment&nbsp;3 cater best to my algorithm's objectives.
Here, we fix $$s = -1$$ (a signal-to-noise ratio of 1:2),
meaning that contestants have some intuition, but it's not particularly strong.

<figure>
  <img
    class="compact squareborder"
    alt="Histogram showing number of turns to win with intuition fixed to negative one. A bell curve centered around 6 or 7"
    src="{{ site.baseurl }}/assets/images/are-you-the-one/weak-intuition.svg"
  />
</figure>

In this case, we eke out a win 100% of the time! And again, running all 500
simulations takes less than two minutes.

# Best we can do?

Above, we devised an algorithm for Are You the One that balances competing
objectives:

- Exploit clues from Truth Booth and Match Up
- Capitalize on contestants' intuition about compatibility
- Compute efficiently

Under favorable conditions, the algorithm wins 100% of simulated games. Under
unfavorable conditions with scrambled contestant intuitions,
the algorithm still wins 93% of the time. In every case, it's fast enough to
simulate many seasons without getting bored.

Like Owen, I find Are You the One to have charming similarities
to Wordle. In Wordle, you must balance the information gained by *exploring*
unused letters against the win potential of *exploiting* clues already provided.
In the *New York Times* version of Wordle, a pessimistic strategy informed
by information theory is the only way to guarantee a win. But in two-player
Wordle, where an opponent chooses the word, you can leverage intuition about the
opponent's favorite words to guess the answer more quickly.

Many numerical optimization problems feature such an explore/exploit tradeoff.
In classic cases of the [multi-armed bandit
problem](https://en.wikipedia.org/wiki/Multi-armed_bandit), for example, we can
prove that certain strategies strike an ideal (in a technical sense) balance between
exploration and exploitation.

I doubt that my algorithm attains the optimal probability of winning for
my problem setup, even in the special case of experiment&nbsp;3 (where the 100% figure
is merely empirical; if you keep running my script, you'll see losses here and there).
The information-theoretic concepts introduced in Owen's blog post can be applied to arbitrary, not just
uniform, distributions over matchings, including the conditional distribution of
the ground-truth matching on the vibes $$v_{ij}$$. If you can estimate that
distribution (more simulations&nbsp;…), then you
can compute the entropies in Owen's algorithm as weighted averages over
matchings. That algorithm would be, you know, *optimal* optimal. And *very* slow.

# Further reading

- [Owen Lacey's blog post](https://blog.owenlacey.dev/posts/are-you-the-one-is-free-money/)
  analyzing Are You the One from an information theory perspective
- [3blue1brown video](https://www.3blue1brown.com/lessons/wordle) solving Wordle
  with information theory
- [Adversarial Wordle](https://absurdleonline.github.io/), where the word keeps
  changing to prolong the game—imagine an analogous variant of Are You the One,
  where the perfect matches change to confound the contestants
- [Source code](https://github.com/maxkapur/AreYouTheOne.jl) for my algorithm
  and plots
