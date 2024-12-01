---
layout:     post
title:      "Bimatrix game equilibrium via nonlinear programming"
katex:      True
---

[These lecture notes
(PDF)](https://ocw.mit.edu/courses/6-254-game-theory-with-engineering-applications-spring-2010/9cca6ef4a5399a4e05891f471d667441_MIT6_254S10_lec09.pdf)
from Asu Ozdaglar give a bilinear program whose solution is the mixed-strategy
equilibrium for a two-player, non-zero-sum game with finite action spaces—also
known as a bimatrix game. I wanted to reproduce this highly practical result in
a more accessible format and offer some implementation notes.<!--more-->

# Definitions

A *bimatrix game* is characterized by two matrices $$A, B \in \mathbb{R}^{n
\times m}.$$ When Alice chooses strategy $$i$$ and Bob chooses strategy $$j$$,
their payoffs are $$A_{ij}$$ and $$B_{ij},$$ respectively. Mixed-strategy
probability vectors $$x$$ and $$y$$ yield expected payoffs of $$x^T A y$$ and
$$x^T B y,$$ respectively.

$$(x^*, y^*)$$ is an *equilibrium* if $$x^T A y^* \leq x^{*T} A y^*$$ and
$$x^{*T} A y \leq x^{*T} A y^*$$ for all probability vectors $$x$$ and $$y.$$

# Result

**Theorem:** $$(\implies)$$ If $$(x^*, y^*)$$ is an equilibrium, then there
exist $$p^*$$ and $$q^*$$ such that $$(x^*, y^*, p^*, q^*)$$ is the optimal
solution to the following bilinear program:

$$
\begin{aligned}
    \text{maximize} \quad   & f(x, y, p, q) = x^T A y + x^T B y - p - q    \\
    \text{subject to} \quad & A y \leq p \mathbf{1} & \text{(OptA)} \\
                            & B^T x \leq q \mathbf{1} & \text{(OptB)} \\
                            & \sum x_i = \sum y_i = 1 & \text{(ProbVec1)} \\
                            & x \geq \mathbf{0}, y \geq \mathbf{0} & \text{(ProbVec2)}
\end{aligned}
$$

$$(\impliedby)$$ Conversely, the optimal solution of the bilinear program is an
equilibrium for the game.

**Proof:** $$(\implies)$$ For any feasible solution to the bilinear program,
each element of $$x$$ is nonnegative (by ProbVec2), so we can use $$x$$ to
combine the rows of the condition OptA to obtain a new valid inequality $$x^T A
y \leq x^T p \mathbf{1} = p \sum x_i = p$$ (by ProbVec1). Applying the same
logic to $$y$$ and $$q,$$ we find that $$f(x, y, p, q) \leq 0.$$

Now consider the equilibrium probability vectors $$(x^*, y^*)$$ and set $$p^* =
x^{*T} A y^*$$ and $$q^* = x^{*T} B y^{*}.$$ Then $$f(x^*, y^*, p^*, q^*) = 0,$$
and we have only to show that this solution is feasible. To be an equilibrium,
$$x^*$$ must earn Alice a better payoff against $$y^{*}$$ than does the $$i$$th
pure strategy: $$p^* = x^{*T} A y^* \geq (A y^*)_i.$$ This is precisely the
$$i$$th row of OptA. OptB follows similarly.

$$(\impliedby)$$ The bilinear program is clearly feasible and bounded (as shown
a moment ago). Let $$(\bar x, \bar y, \bar p, \bar q)$$ denote the optimal
solution. By Nash’s theorem on the existence of mixed-strategy equilibria, we
know that an equilibrium exists, and from the first part of the proof, we know
how to use this equilibrium to produce a feasible solution to the bilinear
program with an objective value of zero. Thus, $$f(\bar x, \bar y, \bar p, \bar
q) \geq 0,$$ which rearranges to

$$(\bar x^T A \bar y - \bar p) + (\bar x^T B \bar y - \bar q) \geq 0.$$

By the constraints OptA and OptB, each of the terms in parentheses is less than
or equal to zero; thus, the inequality on $$f(\bar x, \bar y, \bar p, \bar q)$$
can hold only when each of these terms *equals* zero exactly.

Now consider any probability vector $$x$$ and use it to combine the rows of
OptA: We have $$x^T A \bar y \leq x^T \bar p \mathbf{1} = \bar p = \bar x^T A
\bar y,$$ which says that $$\bar x$$ is a best response to $$\bar y$$. Applying
the same logic to $$\bar y$$ and $$\bar q$$ completes the proof. ◼

# Remarks

Solving the bilinear program is not necessarily easy. If merely solving a
bimatrix game of this form is your goal, then mitigations against local optima
such as [iterated local
search](https://en.wikipedia.org/wiki/Iterated_local_search) are essential. You
can check whether a solution is local or global by comparing the objective value
to zero, which is the global optimum guaranteed by Nash’s theorem.

In practice, I have used the bilinear program above when implementing the
[double oracle algorithm](https://arxiv.org/abs/2009.12185) for games with
complex action spaces. For example, in a modeling problem I am working on, pure
strategies are subsets of $$\mathbb{R}^n$$ with additional inequality and
integrality constraints.

The “first oracle” in the double-oracle algorithm has you compute the
equilibrium of a subgame with discrete action sets and uses the bilinear program
above. In the second oracle (typically the hard part), you then augment these
action sets by computing a pure-strategy best response for each player against
the mixed-strategy equilibrium obtained from the first oracle. You can use the
double oracle algorithm to approximate either pure- *or* mixed-strategy
equilibria by checking convergence and terminating after either the first or
second oracle, respectively.

In my use case, the open-source solver [Ipopt](https://github.com/coin-or/Ipopt)
gives acceptable results for the first oracle. I also learned about
[cyipopt](https://github.com/mechmotum/cyipopt), a nice set of Python bindings
for Ipopt that lets you `@jit` your functions with Numba or Jax for performance.
