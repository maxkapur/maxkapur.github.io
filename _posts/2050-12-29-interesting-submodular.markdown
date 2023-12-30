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
yields the greatest increase in $$f(X)$$ is $$1 - 1 / e \approx 63.2%$$
optimal.[^optimal]

# Intepretation of $$f(\cdot)$$

The function $$f(X)$$ defined above can be used to model the probability of
a parallel system failing as a function of which repairs have been made to its components.

For example, suppose there are a dozen roads between our town and
the next, and the probabilities of each road being open in the coming winter
are given by $$p_1$$ through $$p_{12}$$. For each of the roads, we can engage
in repairs to increase the probability of the the road opening to $$q_i$$.
Letting $$X$$ denote the set of roads that we repair, the probability of
*at least* one road being open in the winter is one minus the probability that
all of them are closed, which is $$f(X)$$. Thus, we might give the function
above a tortured-but-accurate name such as &ldquo;parallel process success
probability with quality upgrades&rdquo;&mdash;but let&rsquo;s just stick
with $$f(\cdot)$$.

# Monotonicity and submodularity

**Theorem:** $$f(\cdot)$$ as defined above is a monotone submodular function.

**Proof:** The monotonicity of $$f(\cdot)$$ is clear from the constraints
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

# Examples

The objective function from the
[college application problem](https://github.com/maxkapur/CollegeApplication),
whose maximization I studied for my master's thesis, is

$$
g(X) = \sum_{j \in X} \Bigl(
f_j t_j \prod_{\substack{i \in X: \\ i > j}} (1 - f_i)
\Bigr)
$$

where $$f_i$$ is the probability of getting into the $$i$$th college and
$$t_i > 0$$ the utility of attending. To make the sum run over all $$j$$,
let&rsquo;s rewrite $$g(X)$$ as $$\sum_{j \in \Omega} t_j g_j(X)$$, where

$$
g_j(X) = \begin{cases}
f_j \prod_{\substack{i \in X: \\ i > j}} (1 - f_i),
& \quad j \in X \\
0,
& \quad j \in \Omega \setminus X.
\end{cases}
$$

This can be again rewritten (somewhat clumsily) as

$$
g_j(X) =
\prod_{\substack{i \in \Omega \setminus X: \\ i \neq j}} (1)
\prod_{\substack{i \in \Omega \setminus X: \\ i = j}} (0)
\prod_{\substack{i \in X: \\ i < j}} (1)
\prod_{\substack{i \in X: \\ i = j}} (f_i)
\prod_{\substack{i \in X: \\ i > j}} (1 - f_i)
$$

(where the empty product is one), and this is just an instance of
$$f(X)$$ with

$$
\begin{aligned}
p_i &= \begin{cases}
1, \quad & i = j \\
0, \quad & i \neq j
\end{cases} \\
q_i &= \begin{cases}
1, \quad & i < j \\
1 - f_i, \quad & i = j \\
f_i, \quad & i > j
\end{cases} \\
\end{aligned}
$$




<!-- College application problem -->

<!-- Zeno walk -->

<!-- # Notes -->

<!-- Supermodular when p_i \geq q_i. Linear--in fact, constant--when equal.

Also, the version where you look for
"no more than one failure" is also supermodular.-->

[^monotone]: A set function is called *monotone* if $$X \subseteq Y$$ implies $$f(X) \leq f(Y)$$.

[^optimal]: This means that if $$X^*$$ is the set that maximizes $$f(\cdot)$$ and $$\tilde X$$ is the set produced by the greedy algorithm, we are guaranteed to have $$f(\tilde X) \geq 0.632\,f(X^*)$$. In practice, the optimality gap is often much narrower.

<!-- https://en.wikipedia.org/wiki/Submodular_set_function -->
