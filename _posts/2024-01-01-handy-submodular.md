---
layout:     post
title:      "A handy class of submodular functions"
katex:      True
---

In this post, we will show that functions of the form

$$
f(X) = 1 -
\prod_{i \in \Omega \setminus X} (1 - p_i)
\prod_{i \in X} (1 - q_i)
$$

are submodular for $$p_i, q_i \in [0, 1]$$ where each $$p_i \leq q_i,$$
and examine an application of this small result that demonstrates its
practical value.<!--more-->

# Background on submodular functions

Given a ground set $$\Omega,$$ a function $$f: 2^\Omega \mapsto \mathbb{R}$$
is called [*submodular*](https://en.wikipedia.org/wiki/Submodular_set_function)
if, for any $$X \subseteq Y \subseteq \Omega$$ and $$j \in \Omega \setminus Y,$$
we have

$$f(X \cup \{j\}) - f(X) \geq f(Y \cup \{j\}) - f(Y).$$

In plain language, this says that the marginal value of adding $$j$$ to $$X$$
is greater than when adding it to $$Y$$. Thus, submodularity expresses a
form of diminishing marginal returns (for set functions) that is analogous to
concavity (for continuous functions).

Submodular functions have a number of desirable traits. A famous result of
Nemhauser et al. (1978) holds that when maximizing a monotone[^monotone]
submodular function over a cardinality constraint, the greedy algorithm that
iteratively adds to $$X$$ the element that yields the greatest increase in
$$f(X)$$ is $$1 - \frac{1}{e} \approx 63.2\%$$ optimal.[^optimal] Efficient algorithms
that provide the same approximation ratio for more complex constraint structures
have also been identified (Badanidiyuru et al. 2014, Chekuri et al. 2014,
Kulik et al. 2013). See Vondrák (2017) for an introduction to submodular functions
with many examples.

# Preliminary interpretation of $$f(X)$$

The function $$f(X)$$ defined above can be used to model the probability of
a parallel system failing when optional repairs are made to its components.
For example, suppose there are a dozen roads between our town and the next,
and the probabilities of each road being open in the coming winter are
given by $$p_1$$ through $$p_{12}$$. For each of the roads, we can engage
in repairs to increase the availability to $$q_i$$. Letting $$X$$ denote the set
of roads that we repair, the probability of *at least* one road being open in the
winter is one minus the probability that all of them are closed, which is $$f(X).$$

With this interpretation in mind, we are tempted to give $$f(X)$$ a
tortured-but-accurate name such as the “parallel process success probability
with quality upgrades” function—but we’ll just stick with
$$f(X)$$ for now.

The applicability of $$f(X)$$ in its current form is, admittedly, a bit
narrow. The versatility of this functional form shows itself more clearly
when we start taking conic combinations—see the examples below.

# Monotonicity and submodularity proof

**Theorem:** $$f(X)$$ as defined above is a monotone submodular function.

**Proof:** The monotonicity of $$f(X)$$ is clear from the constraints
on $$p$$ and $$q$$: Adding any element $$j$$ to $$X$$ replaces the
$$1 - p_j$$ term with the (smaller) $$1 - q_j$$ term, increasing the
overall function value.

To prove submodularity, pick any $$X \subseteq Y \subseteq \Omega$$ and
$$j \in \Omega \setminus Y.$$ If $$p_j < 1,$$ we have

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
instead of $$X.$$

In the $$p_j = 1$$ case, $$f(X \cup \{j\}) = 1$$ for any $$X$$ and
the inequality collapses to $$- f(X) \geq - f(Y),$$ which is just
monotonicity. ◼

# Application: Optimal scrum velocity, aka the $$m$$-dimensional Zeno walk

Let’s examine a plausible(ish) application of this functional form.

**The Zeno walk:** Consider a
[Zeno walk](https://en.wikipedia.org/wiki/Zeno%27s_paradoxes#Dichotomy_paradox)
between an arbitrary origin and destination. Let $$\Omega$$ provide a set of
possible *steps* that we can take toward our destination. Each step’s size
is $$s_i \in [0, 1],$$ which means that if you choose to take step $$i,$$
you get $$100 s_i$$ percent of the way from your current location to the
destination.[^zeno] If $$X$$ is the set of steps you choose to take,
you will make it

$$
g(X) = 1 - \prod_{i \in X} (1 - s_i)
$$

of the way to the destination from your starting point. This $$g(X)$$
is just $$f(X)$$ where each $$p_i = 0$$ and $$q_i = s_i$$.

**The multidimensional Zeno walk:** Now, consider a process optimization
problem. We have a set $$\Psi$$ (indexed by $$j$$) of *goals* to achieve,
as well as a set $$\Omega$$ (indexed by $$i$$) of *tasks* we can complete
in service of the goals. Tasks can advance multiple goals at once. Let
$$v_{ij}$$ denote the *effectiveness* of task $$i$$ against goal $$j,$$
meaning that if you engage in task $$i,$$ then $$v_{ij}$$ of (whatever
remains of)[^whatever] goal $$j$$ will be completed. Each goal is
worth $$t_j \geq 0$$
*[story points](https://en.wikipedia.org/wiki/Burndown_chart),*
and goals can be completed fractionally.

We would like to choose the set of tasks $$X$$ that maximizes the team’s
[*velocity*](https://en.wikipedia.org/wiki/Velocity_(software_development))
in the current planning period, defined as the total number of story points
completed, which is

$$
h(X) = \sum_{j \in \Psi} \Bigl(
t_j - t_j \prod_{i \in X} (1 - v_{ij})
\Bigr).
$$

Tasks are subject to a variety of constraints due to considerations such
as cost, scheduling, and dependency. It is not immediately obvious which
tasks we should prioritize—for example, should we favor tasks that
advance many different goals, or those that have high effectiveness
against the most important goals? Well, the $$j$$th term of $$h(X)$$
is just $$t_j g(X)$$ where $$s$$ is the $$j$$th column of $$v$$. Thus,
$$h(X),$$ as a conic combination of submodular functions, is itself
submodular,[^conic] and we can compute the optimal velocity using
any of the well-known techniques for submodular maximization.

Returning to Zeno’s paradox, the business process described above is
akin to a *multidimensional* Zeno walk in which $$t_j$$ gives your distance
from the target in the $$j$$th coordinate axis, and each step $$i$$ moves you
$$v_{ij}$$ of the way towards the target along that axis. The function
$$h(X)$$ measures the one-norm distance between your final position and the
target.

# Remarks

**Linearization:** To maximize $$f(X)$$ as written, in typical cases, it
will be simplest to minimize $$1 - f(X),$$ which is a *modular* function
after taking the logarithm.[^modular] The logarithm trick doesn’t work,
however, for conic combinations of $$f(X)$$; the best we can do is introduce
helper variables and reformulate the problem as an integer convex
program.[^integerconvex] Thus, recognizing the submodularity of $$f(X)$$
(and the strong approximation results implied) is worthwhile.

**Serial processes:** It is not difficult to show, using a similar proof
as above, that the “*serial* process success probability with quality upgrades”
function

$$
\tilde f(X) = \prod_{i \in \Omega \setminus X} p_i \prod_{i \in X} q_i
$$

with $$p_i \leq q_i$$ is monotone and *supermodular;* that is,
$$- \tilde f(X)$$ is monotone *decreasing* and submodular. Note that
$$1 - \tilde f(X)$$ has the same functional form as the original $$f(X),$$
but the inequality on $$p_i$$ and $$q_i$$ comes out backwards. This turns
back into the original result (that $$f(X)$$ is increasing and submodular)
if you interchange the roles of $$X$$ and $$\Omega \setminus X$$.

# References

Open access:

- Badanidiyuru, Ashwinkumar and Jan Vondrák. 2014. “Fast Algorithms for Maximizing Submodular Functions.” In *Proceedings of the 2014 Annual ACM--SIAM Symposium on Discrete Algorithms,* 1497–1514. <https://doi.org/10.1137/1.9781611973402.110>.
- Vondrák, Van. 2017. “Submodular Functions.” Lecture 14 from Math 233B: Polyhedral Techniques in Combinatorial Optimization. <https://theory.stanford.edu/~jvondrak/MATH233B-2017/MATH233B.html>.
- Wikipedia, s.v. [“burndown chart.”](https://en.wikipedia.org/wiki/Burndown_chart)
- Wikipedia, s.v. [“submodular set function.”](https://en.wikipedia.org/wiki/Submodular_set_function)
- Wikipedia, s.v. [“velocity (software development).”](https://en.wikipedia.org/wiki/Velocity_(software_development))
- Wikipedia, s.v. [“Zeno’s paradox.”](https://en.wikipedia.org/wiki/Zeno%27s_paradoxes#Dichotomy_paradox)

Paywall:

- Chekuri, Chandra, Jan Vondrák, and Rico Zenklusen. 2014. “Submodular Function Maximization via the Multilinear Relaxation and Contention Resolution Schemes.” *SIAM Journal on Computing* 43, no. 6: 1831–79. <https://doi.org/10.1137/110839655>.
- Kulik, Ariel, Hadas Shachnai, and Tami Tamir. 2013. “Approximations for Monotone and Nonmonotone Submodular Maximization with Knapsack Constraints.” *Mathematics of Operations Research* 38, no. 4: 729–39. <https://doi.org/10.1287/moor.2013.0592>.
- Nemhauser, George, Laurence Wolsey, and Marshall Fisher. 1978. “An Analysis of Approximations for Maximizing Submodular Set Functions—I.” *Mathematical Programming* 14: 265–94. <https://doi.org/10.1007/BF01588971>.

<!--Nemhauser, George and Laurence Wolsey. 1978. “Best Algorithms for Approximating the Maximum of a Submodular Set Function.” *Mathematics of Operations Research* 3, no. 3: 177–88. <https://doi.org/10.1287/moor.3.3.177>.-->

[^monotone]: A set function is called *monotone* if $$X \subseteq Y$$ implies $$f(X) \leq f(Y)$$.

[^optimal]: This means that if $$X^*$$ is the set that maximizes $$f(X)$$ and $$\tilde X$$ is the set produced by the greedy algorithm, we are guaranteed to have $$f(\tilde X) \geq 0.632\,f(X^*)$$. In practice, the optimality gap is often much narrower.

[^zeno]: In the original Zeno walk, each $$s_i = \frac{1}{2},$$ and the (supposedly unachievable) “goal” is to reach the destination rather than to get as close as possible to it.

[^whatever]: Depending on the context, it may be more appropriate to have tasks advance goals additively—but that would just be a knapsack problem. Here, we are interested in the more difficult case where tasks make diminishing marginal contributions against the goals. One way this arises in real life is when tasks address goals in redundant ways. For example, against the goal “get rid of all the junk in my house,” the tasks “throw away any items not used in the past six months” and “throw away any items that spark fewer than $$k$$ units of joy” may separately elicit a 50 percent reduction in the total junk, but doing *both* tasks won’t necessarily remove all the junk, because there is some overlap in the junk removed by both operations.

[^conic]: The fact that a conic combination of submodular functions is submodular isn’t mentioned on the [Wikipedia article](https://en.wikipedia.org/wiki/Submodular_set_function), but it falls right out of the second definition.

[^modular]: A set function is *modular* if it is both submodular and supermodular. This means that each item’s marginal value is constant—and thus modular functions are equivalent to *linear* functions of the characteristic vector. The knapsack objective function is an example of a monotone modular function.

[^integerconvex]: [Email me](mailto:{{ site.email }}) if you would be interested in a follow-up post explaining how to do this.
