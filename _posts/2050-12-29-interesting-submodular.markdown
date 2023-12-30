---
layout:     post
title:      "An interesting class of submodular functions"
---

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

In this post, I will show that the function

$$f(X) = 1 -
\prod_{i \in \Omega \setminus X} (1 - p_i)
\prod_{i \in X} (1 - q_i)
$$

is submodular for $$p_i, q_i \in [0, 1]$$ where each $$p_i \leq q_i$$.


<!-- How to understand this function: -->

<!-- Submodularity proof -->

<!-- # Examples -->

<!-- College application problem -->

<!-- Zeno walk -->

<!-- # Notes -->

<!-- Supermodular when p_i \geq q_i. Also, the version where you look for
"no more than one failure" is also supermodular.-->

[^monotone]: A set function is called *monotone* if $$X \subset Y$$ implies
$$f(X) \leq f(Y)$$.

[^optimal]: This means that if $$X*$$ is the set that maximizes $f(\cdot)

<!-- https://en.wikipedia.org/wiki/Submodular_set_function -->
