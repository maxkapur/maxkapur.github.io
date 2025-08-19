---
title: Is ABC-SCM just an evolutionary algorithm?
layout: post
katex: true
---

Suppose we have some data $$D$$ and a statistical model that expresses $$D$$ as
a noisy function of some parameter vector $$\theta$$. We want to determine a
value of $$\theta$$ that fits the data. For the purposes of this post, we're
concerned with models that are "difficult," meaning that there isn't a simple
expression for the likelihood function that you can maximize, whether
analytically (as in ordinary least squares) or numerically (as in nonlinear
regression). In fact, all we really know how to do is take a value of $$\theta$$
and sample some data $$D$$ from the model. We'll get a different $$D$$ every
time, because the model is nondeterministic.

If you are steeped in Bayesian statistics, then you may have already
pattern-matched this problem statement to the ABC-SCM algorithm. But if you are
like me and view parameter estimation as essentially an optimization problem
(there is no good reason to privilege this view; it's just how I turned out),
then you might instead estimate $$\theta$$ using an evolutionary algorithm.
Below, I describe such an algorithm, then argue that ABC-SCM is really just a
special case of it.

<!--more-->

# Evolutionary algorithm

OK, so here is the algorithm:

1. Guess $$N$$ different parameter vectors $$\theta_i$$ (e.g. by sampling them
   from a distribution, or applying some heuristic to the data).
2. For each $$\theta_i$$, simulate the model to generate a bunch of data
   $$D'_i$$.
3. Compare each instance of simulated data $$D'_i$$ to the real data $$D$$,
   perhaps with a distance measure $$d(D'_i, D)$$ like the 2-norm or some
   summary statistics.
4. Pick a subset of the $$\theta$$ values, perhaps the $$k$$ with the lowest
   distance measure.
5. Generate a new sample of size $$N$$, perhaps by sampling randomly from the
   $$\theta_i$$s that "survived" the previous step and adding some random noise.
6. Go back to step 2 and keep looping until you find an acceptable solution,
   exceed a time limit, or whatever.

There are a lot of details you can play with in this algorithm, particularly in
the choice of loss function in step 3 and the resampling method in step
5.[^details] But the basic idea is to sample new $$\theta$$ values in a way that
is *biased* toward the best values identified in step 3 (exploitation), while
still including enough random noise in step 5 to avoid local optima
(exploration). If you get the details right and strike a good balance between
exploitation and exploration, evolutionary algorithms like this can be quite
effective in practice. [Here is a free textbook about
that](https://cs.gmu.edu/~sean/book/metaheuristics/Essentials.pdf) if you want
it.

# ABC-SCM motivation

<mark>help needed</mark> Anyway, as an operations researcher who tends to
neglect Bayesian statistics, I was long content to stop here. But now, I have
 learned about applied evolutionary algorithms happily to a variety of
regression problems, until one day I was doing some reading and learned about
[approximate Bayesian
computation](https://en.m.wikipedia.org/wiki/Approximate_Bayesian_computation)
(ABC). (Again, depending on the order in which you learned things) an intuitive
way to think about ABC is as an alternative to Markov Chain Monte Carlo (MCMC).
MCMC is a popular family of algorithms that take a likelihood function
$$l(\theta)$$ and produce a sample of the probability distribution implied. This
algorithm is useful for the wide variety of regression problems in which
constructing a likelihood function is easy but maximizing it (to estimate the
parameters) is hard; with MCMC, you can just draw many samples from the
posterior, which gives you not only a point estimate for each parameter, but
also confidence bounds—indeed, an estimate of the whole distribution.

The problem is that some practical problems, especially those involving order
statistics, are too hard even for MCMC because it is impossible to write out the
likelihood function in a computationally tractable form. Consider, for example,
a model where you draw from a multivariate normal distribution (whose mean and
covariance matrix are part of $$\theta$$), then clamp these values to some
unknown lower and upper bounds (more parameters in $$\theta$$), then observe the
3rd order statistic—I don't think this will yield a useful likelihood function
(although I admit I haven't tried).

# ABC rejection sampling and the ABC-SCM algorithm

ABC is a sketchy alternative to MCMC which works even when you cannot compute a
likelihood function. All you need is the ability to sample data from the model
for given values of $$\theta$$ (just like the problem set up at the outset) [The
algorithm](https://en.wikipedia.org/wiki/Approximate_Bayesian_computation#The_ABC_rejection_algorithm)
is basically this:

1. Sample a $$\theta$$ vector from a prior distribution.
2. Sample data $$D'$$ from the model.
3. Compare the data $$D'$$ to the sample $$D$$ you have using a distance measure
   $$d(D', D)$$.
4. Reject $$\theta$$ if the distance function exceeds some tolerance
   $$\varepsilon$$.

I call this algorithm "sketchy" because there is no way to know, until you run
it, how long it will take to take to produce $$N$$ samples of $$\theta$$. The
posterior sample will be more accurate if you set $$\varepsilon$$ close to zero,
but then you might end up with an acceptance rate of 0.1%, and have to draw
millions of samples from the prior to get thousands from the posterior. You
might as well just figure out how many iterations you can afford to compute
(say, 100,000), store *all* the $$\theta$$s, then reject all but the $$k=1000$$
with the lowest distance measure (sound familiar?).

We can improve the basic ABC rejection algorithm using an extension called
sequential Monte Carlo (SMC); [here is a good tutorial
(PDF)](https://arxiv.org/pdf/0910.4472). Instead of picking a huge sample size,
tiny $$\varepsilon$$, and crossing your fingers, ABC-SMC has you gradually ease
the tolerance $$\varepsilon$$ toward zero as the sample converges to the "true"
posterior. The algorithm looks like this:

1. Sample $$N$$ vectors $$\theta$$ from a prior distribution; call this the
   "population."
2. Construct a new population using ABC rejection sampling, with a tweak: a.
   Sample a $$\theta$$ vector from the population. b. Tweak: Add some random
   noise to $$\theta$$. c. Sample data $$D'$$ from the model. d. Compare the
   data $$D'$$ to the sample $$D$$ you have using a distance measure. e. Accept
   $$\theta$$ and add it to the new population if the distance function exceeds
   some tolerance $$\varepsilon$$. f. Repeat from step 2a until the population
   has size $$N$$.
3. Keep repeating step 2 with decreasing values of $$\varepsilon$$.

This algorithm is more practical than pure ABC because you can log the
acceptance rate at each iteration in order to see how the algorithm is doing. If
the acceptance rate is too small, then you can restart with a less aggressive
tolerance schedule (i.e. $$\varepsilon$$ decreasing more gradually).

The "tweak" in step 2b (adding extra noise) is necessary to enable the algorithm
to search beyond the $$N$$ samples initially drawn from the prior. The scale of
this extra noise—call it $$\sigma$$—is an additional free parameter in the
ABC-SMC algorithm. If $$\sigma$$ is too large, then the algorithm will fail to
converge, because each pass through step 2 resembles a fresh run of the ABC
rejection sample (poor exploitation). If $$\sigma$$ is too small, then the
algorithm gets stuck in the neighborhood of whichever $$\theta$$ from the
initial sample happened to be the best (poor exploration). This reminds us that
ABC-SMC is not a turnkey solution to hard regression problems. Like the
evolutionary algorithm, it requires some manual (or perhaps automated) parameter
tuning to achieve a good balance between exploration and exploitation.

# It's the same algorithm

The similar "user experience" of evolution and ABC-SMC suggests we consider what
else these algorithms may have in common. Indeed, upon examination, we can
recognize step 2 in the ABC-SMC algorithm as another way of implementing steps 2
through 5 in the evolutionary algorithm. The difference is that in the
evolutionary algorithm (or at least the way I wrote it out), we choose the
acceptance rate $$k / N$$ at the outset, and the acceptance threshold
$$\varepsilon = \max\{d(D'_i, D)\}$$ (over the surviving indices $$i$$) is
implied.

In ABC-SMC, it's just the opposite; we commit first to a tolerance
$$\varepsilon$$, then keep sampling until we've filled up the
population.[^superficial] But you can cross-pollinate these approaches to obtain
a chimera[^xpollinate] algorithm. For example, in ABC-SMC, you could set a
sequence of increasing *population sizes* instead of decreasing tolerances, and
always accept the top $$N$$. Since the sequence of implicit tolerances is still
decreasing, this algorithm should still afford the Bayesian interpretation of
producing a *sample from the posterior* (not just a point estimate of
$$\theta$$), meaning you obtain confidence intervals for each parameter and
other measures of interest from the output sample (not just a point estimate of
$$\theta$$).

Come to think of it, although it's customary to return the global best solution
from an evolutionary algorithm, one can argue that the final *population* is of
greater interest. This population is less prone to overfit, like a Bayesian
posterior, it gives a sense of the *distribution* of good $$\theta$$ estimates,
which could have interesting properties such as clustering or correlation.

[^details]: And we should take care to ensure that the size of each sample
    $$D'_i$$ is sufficiently large to ward off a [winner's
    curse](https://en.wikipedia.org/wiki/Winner%27s_curse) outcome where the
    $$\theta$$ you return is actually a good estimate, not just a "lucky"
    instance where all the noise happened to point in the right direction.

[^superficial]: There is another difference between the algorithms as I laid
    them out, which is that in my evolutionary algorithm you upsample the $$k$$
    "survivors" into a size-$$N$$ population at the end of the inner loop (step
    5), whereas in ABC-SMC the upsampling occurs implicitly in steps 2a and 2b.
    I think this difference is superficial.

[^xpollinate]: I acknowledge the flawed biology behind this metaphor and invoke
    my poetic license.
