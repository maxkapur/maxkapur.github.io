---
layout:     post
title:      "An interesting class of submodular functions"
katex:      True
---

In this post, I will show that functions of the form

$$
f(X) = 1 -
\prod_{i \in \Omega \setminus X} (1 - p_i)
\prod_{i \in X} (1 - q_i)
$$

are submodular for $$p_i, q_i \in [0, 1]$$ where each $$p_i \leq q_i$$,
and provide a few examples of this class to demonstrate the practical
value of this small result.
<!--more-->

# Background on submodular functions

Given a ground set $$\Omega$$, a function $$f: 2^\Omega \mapsto \mathbb{R}$$,
is called [*submodular*](https://en.wikipedia.org/wiki/Submodular_set_function)
if, for any $$X \subset Y \subset \Omega$$ and $$j \in \Omega \setminus Y$$,
we have

$$f(X \cup \{j\}) - f(X) \geq f(Y \cup \{j\}) - f(Y).$$

In plain language, this says that the marginal value of adding $$j$$ to $$X$$
is greater than when adding it to $$Y$$. Thus, submodularity expresses a
form of diminishing marginal returns (for set functions) that is analogous to
concavity (for continuous functions).

Submodular functions have a number of desirable traits. A famous result of
Nemhauser et al. (1976, [paywall](https://doi.org/10.1007/BF01588971)) holds
that when maximizing a monotone[^monotone] submodular function over a cardinality
constraint, the greedy algorithm that iteratively adds to $$X$$ the element that
yields the greatest increase in $$f(X)$$ is $$1 - 1 / e \approx 63.2\%$$
optimal.[^optimal]

# Intepretation of $$f(X)$$

The function $$f(X)$$ defined above can be used to model the probability of
a parallel system failing as a function of which repairs have been made to
its components.

For example, suppose there are a dozen roads between our town and
the next, and the probabilities of each road being open in the coming winter
are given by $$p_1$$ through $$p_{12}$$. For each of the roads, we can engage
in repairs to increase the probability of the the road opening to $$q_i$$.
Letting $$X$$ denote the set of roads that we repair, the probability of
*at least* one road being open in the winter is one minus the probability that
all of them are closed, which is $$f(X)$$. Thus, we might give the function
above a tortured-but-accurate name such as &ldquo;parallel process success
probability with quality upgrades&rdquo;&mdash;but let&rsquo;s just stick
with $$f(X)$$.

This interpretation is admittedly a bit narrow. The versatility of $$f(X)$$
as a functional form starts to show itself, in my opinion, when we start
taking conic combinations&mdash;see the examples below.

# Monotonicity and submodularity

**Theorem:** $$f(X)$$ as defined above is a monotone submodular function.

**Proof:** The monotonicity of $$f(X)$$ is clear from the constraints
on $$p$$ and $$q$$: Adding any element $$j$$ to $$X$$ replaces the
$$1 - p_j$$ term with the (smaller) $$1 - q_j$$ term, increasing the
overall function value.

The proof of submodularity is also straightforward: Pick any
$$X \subset Y \subset \Omega$$ and $$j \in \Omega \setminus Y$$. If
$$p_j < 1$$, we have

$$
\begin{aligned}
f(X \cup \{j\}) - f(X)
&= \biggl[1 -
\frac{1 - q_j}{1 - p_j}
\prod_{i \in \Omega \setminus X} (1 - p_i)
\prod_{i \in X} (1 - q_i)
\biggr] -
\biggl[1 -
\prod_{i \in \Omega \setminus X} (1 - p_i)
\prod_{i \in X} (1 - q_i)
\biggr] \\
&= - \biggl(\frac{1 - q_j}{1 - p_j}\biggr)
\prod_{i \in \Omega \setminus X} (1 - p_i)
\prod_{i \in X} (1 - q_i) +
\prod_{i \in \Omega \setminus X} (1 - p_i)
\prod_{i \in X} (1 - q_i) \\
&= \biggl(1 - \frac{1 - q_j}{1 - p_j}\biggr)
\Bigl(1 - f(X)\Bigr) \\
&\geq \biggl(1 - \frac{1 - q_j}{1 - p_j}\biggr)
\Bigl(1 - f(Y)\Bigr) \\
&= f(Y \cup \{j\}) - f(Y).
\end{aligned}
$$

The penultimate inequality follows from monotonicity, and the final
equality is just applying the first three steps in reverse, with $$Y$$
instead of $$X$$.

In the $$p_j = 1$$ case, $$f(X \cup \{j\}) = 1$$ for any $$X$$ and
the inequality collapses to $$- f(X) \geq - f(Y)$$, which is just
monotonicity again. &#9724;

# Example: Optimizing scrum, aka the $$m$$-dimensional Zeno walk

Consider a
[Zeno walk](https://en.wikipedia.org/wiki/Zeno%27s_paradoxes#Dichotomy_paradox)
between an arbitrary origin and destination. Let $$\Omega$$ is a set of
possible *steps* that we can take toward our destination. Each step's size
is $$s_i \in [0, 1]$$, which means that if you choose to take step $$i$$,
you get $$s_i$$ percent of the way from your current location to the
destination.[^zeno] Where $$X$$ is the set of steps you choose
to take, your final distance is

$$
g(X) = 1 - \prod_{i \in X} (1 - s_i)
$$

which is just $$f(X)$$ where each $$p_i = 0$$ and $$q_i = s_i$$.

Now, consider a process optimization problem of the following form: We
have a set $$\Psi$$ (indexed by $$j$$) of *goals* that we would like to
and a set $$\Omega$$ (indexed by $$i$$) of *tasks* we can complete in
service of the goals. Tasks can advance multiple goals at once. Let
$$v_{ij}$$ denote the *effectiveness* of task $$i$$ against goal $$j$$,
meaning that if you engage in task $$i$$, $$v_{ij}$$ percent of goal $$j$$
will be completed.
Each goal is worth $$t_j \geq 0$$
*[story points](https://en.wikipedia.org/wiki/Burndown_chart),*
and can be completed fractionally. Our goal is to choose the set of tasks
$$X$$ that maximizes the team&rsquo;s
[*velocity*](https://en.wikipedia.org/wiki/Velocity_(software_development))
in the current planning period, defined the total number of story points
completed, which is

$$
h(X) = \sum_{j \in \Psi} t_j - t_j \prod_{i \in X} (1 - v_{ij}).
$$

Tasks are subject to a variety of constraints due to considerations such
as cost, scheduling, and dependency. It is not immediately obvious which
tasks we should prioritize&mdash;for example, should we favor tasks that
advance many different goals, or those that have high effectiveness
against the most important goals? Well, the $$j$$th term of $$h(X)$$
is just $$t_j g(X)$$ where $$s$$ is the $$j$$th column of $$v$$. Thus,
$$h(X)$$, as a conic combination of submodular functions, is itself
submodular,[^conic] and we can compute the optimal velocity using
any of the well-known techniques for submodular maximization.

# Remarks

It is not difficult to show, using a similar proof as above, that the
&ldquo;*serial* process success probability with quality upgrades&rdquo;
function

$$
\tilde f(X) = \prod_{i \in \Omega \setminus X} p_i \prod_{i \in X} q_i
$$

with $$p_i \leq q_i$$ is monotone and *supermodular;* that is,
$$- \tilde f(X)$$ is monotone *decreasing* and submodular. Note that
$$1 - \tilde f(X)$$ has the same functional form as the original $$f(X)$$,
but the inequality on $$p_i$$ and $$q_i$$ comes out backwards. This turns
back into the original result (that $$f(X)$$ is increasing and submodular)
if you interchange the roles of $$X$$ and $$\Omega \setminus X$$.

[^monotone]: A set function is called *monotone* if $$X \subseteq Y$$ implies $$f(X) \leq f(Y)$$.

[^optimal]: This means that if $$X^*$$ is the set that maximizes $$f(X)$$ and $$\tilde X$$ is the set produced by the greedy algorithm, we are guaranteed to have $$f(\tilde X) \geq 0.632\,f(X^*)$$. In practice, the optimality gap is often much narrower.

[^zeno]: In the original Zeno walk, each $$s_i = 1/2$$, and the (supposedly unachievable) &ldquo;goal&rdquo; is to reach the destination rather than to get as close as possible to it.

[^conic]: This fact isn't mentioned on the [Wikipedia article](https://en.wikipedia.org/wiki/Submodular_set_function), but it falls right out of the second definition listed.
