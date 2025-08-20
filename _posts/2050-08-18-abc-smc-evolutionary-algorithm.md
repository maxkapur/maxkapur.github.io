---
title: Is ABC-SMC just an evolutionary algorithm?
layout: post
katex: true
---

Suppose we have data $$D$$ and a model that expresses $$D$$ as a noisy function
of a parameter vector $$\theta$$. We want to determine a value of $$\theta$$
that fits the data. For the purposes of this post, we're concerned with models
that are "difficult," meaning we cannot write down a simple expression for the
likelihood function and maximize it, whether analytically (as in ordinary least
squares) or numerically (as in nonlinear regression). In fact, all we really
know how to do is sample data from the model when given an arbitrary $$\theta$$.
(We'll get a different $$D$$ every time, because the model is nondeterministic.)

If you enjoy Bayesian statistics, then you may have already pattern-matched this
problem statement to the ABC-SMC algorithm. But if you are like me and view
parameter estimation as an optimization problem (there is no reason to privilege
this view; it's just how I turned out), then you might instead apply an
evolutionary algorithm. Below, I describe such an algorithm, then argue that
ABC-SMC is a special case. This insight suggests improvements to the
implementation and usage of both evolution and ABC-SMC.

<!--more-->

# Evolutionary algorithm

OK, so the basic template for an evolutionary algorithm looks like this:

1. Guess $$N$$ different parameter vectors $$\theta_i$$ (e.g. by sampling them
   from a distribution or applying a heuristic to the data).
2. For each $$\theta_i$$, simulate the model to generate a bunch of data
   $$D'_i$$.
3. Compare each instance of simulated data $$D'_i$$ to the real data $$D$$,
   perhaps with a distance measure $$d(D'_i, D)$$ like the 2-norm or
   summary statistics.
4. Pick a subset of the $$\theta$$ values, perhaps the $$k$$ with the lowest
   distance measure.
5. Generate a new sample of size $$N$$, perhaps by sampling randomly from the
   $$\theta_i$$s that "survived" the previous step and adding random noise.
6. Repeat an arbitrary number of times from step 2.

There are a lot of details to fill in, particularly in the choice of loss
function and resampling method.[^details] But essentially, we try to sample new
$$\theta$$ values in a way that is *biased* toward the winners identified in
step 4 (exploitation), while maintaining enough random noise in step 5 to escape
local optima (exploration). If we strike the right balance between exploitation
and exploration, evolutionary algorithms like this can be quite effective in
practice. [Free textbook
(PDF).](https://cs.gmu.edu/~sean/book/metaheuristics/Essentials.pdf)

# ABC-SMC motivation

As an operations researcher who tends to neglect Bayesian statistics, I am half
content to stop here. But the setup given above—a model, a sampler—is common
enough that we should expect to find a solution more tailored than evolution (a
rather blunt technique). Well, that solution is called [approximate Bayesian
computation
(ABC)](https://en.m.wikipedia.org/wiki/Approximate_Bayesian_computation).

(Depending on the order in which you learned things) an intuitive way to think
about ABC is as an alternative to Markov Chain Monte Carlo (MCMC). Algorithms in
the MCMC family take a likelihood function $$l(\theta)$$ and produce a sample of
the probability distribution implied. This is useful because for many
statistical models, we can easily *construct* a likelihood function
([PyMC](https://www.pymc.io/welcome.html) will do it for us), but maximizing
$$l(\theta)$$ is hard (for example, due to nonconcavity or expensive gradient
computations). With MCMC, we can just draw samples from the posterior $$P(\theta
| D)$$, which produces not only a point estimate for each entry of $$\theta$$,
but also confidence bounds, their covariance … indeed, an estimate of the entire
distribution.

Unfortunately, MCMC proves inadequate for regression problems (many involving
rank and order statistics) where we cannot write out the likelihood function in
a computationally tractable form. Consider, for example, a model where we draw
$$X$$ from a multivariate normal distribution (whose mean and covariance matrix
are part of $$\theta$$), clamp these values to unknown lower and upper bounds
(more parameters in $$\theta$$), then observe (as $$D$$) the third order
statistic. I don't think this will yield a useful likelihood function (although
I admit I haven't tried). Thus, we turn to ABC.

# ABC rejection sampling and the ABC-SMC algorithm

ABC is a sketchy alternative to MCMC which works even when we cannot compute a
likelihood function. All we need is the ability to sample data from the model
for given values of $$\theta$$, just like our problem. [The ABC rejection
algorithm](https://en.wikipedia.org/wiki/Approximate_Bayesian_computation#The_ABC_rejection_algorithm)
is basically this:

1. Sample a $$\theta$$ vector from a prior distribution.
2. Sample data $$D'$$ from the model.
3. Compare the data $$D'$$ to the sample $$D$$ using a distance measure $$d(D',
   D)$$.
4. If the distance is less than tolerance $$\varepsilon$$, accept
   $$\theta$$. If not, repeat.

I call this algorithm "sketchy" because before running it, we don't know how
many times it will loop before accepting $$N$$ posterior samples. To maximize
the sample's accuracy, step 4 tempts us to set $$\varepsilon$$ close to zero.
But doing so might drive the acceptance rate down to 0.1%, in which case we must
draw millions of samples from the prior to get thousands from the posterior. (We
might as well just figure out how many iterations we can afford to compute—say,
100,000—and accept the 1000 samples of $$\theta$$ with the lowest distance
measure. Sound familiar?)

We can tame the ABC rejection algorithm using a modification called sequential
Monte Carlo (SMC); [here is a good tutorial
(PDF)](https://arxiv.org/pdf/0910.4472). Instead of picking a huge sample size
and tiny $$\varepsilon$$ and crossing our fingers, ABC-SMC has us gradually ease
the tolerance $$\varepsilon$$ toward zero as the sample converges to the "true"
posterior. The algorithm looks like this:

1. Sample $$N$$ vectors $$\theta$$ from a prior distribution; call this the
   "population."
2. Construct a new population using ABC rejection sampling, with a tweak:

   1. Sample a $$\theta$$ vector from the population.
   2. Tweak: Add random noise to $$\theta$$.
   3. Sample data $$D'$$ from the model.
   4. Compare the data $$D'$$ to the sample $$D$$ using a distance measure.
   5. If the distance is less than tolerance $$\varepsilon$$, accept $$\theta$$
      and add it to the new population.
   6. Repeat from step 2.1 until the population has size $$N$$.

3. Keep repeating step 2 with decreasing values of $$\varepsilon$$.

This algorithm is more practical than pure ABC because we can log the acceptance
rate at each iteration in order to see how it is doing. If the acceptance rate
is too small, then we restart with a less aggressive tolerance schedule (i.e.
$$\varepsilon$$ decreasing more gradually).

The tweak in step 2.2 (adding extra noise) is necessary to enable ABC-SMC to
search beyond the $$N$$ samples initially drawn from the prior. The scale of
this extra noise—call it $$\sigma$$—is an additional free parameter in the
algorithm design. If $$\sigma$$ is too large, then the algorithm won't converge,
because each pass through step 2 resembles a fresh run of the ABC rejection
sample (poor exploitation). If $$\sigma$$ is too small, then the algorithm gets
stuck in the neighborhood of whichever $$\theta$$ from the initial sample
happened to be the best (poor exploration). So, like the evolutionary algorithm,
ABC-SMC is no turnkey solution; it requires parameter tuning to balance
exploration and exploitation effectively.

# It's the same picture

The similar "user experience" of evolution and ABC-SMC suggests we consider what
else these algorithms may have in common. Upon examination, we can recognize
step 2 in the ABC-SMC algorithm as another way of implementing steps 2 through 5
in the evolutionary algorithm. The difference is that in the evolutionary
algorithm (or at least the way I wrote it out), we choose the acceptance rate
$$k / N$$ at the outset, and the acceptance threshold $$\varepsilon =
\max\{d(D'_i, D)\}$$ (over the surviving indices $$i$$) is implied. In ABC-SMC,
it's just the opposite; we commit first to a tolerance $$\varepsilon$$, then
keep sampling until we've filled up the population.[^superficial]

Recognizing the similarity between evolution and ABC-SMC might lead us to
discover new algorithms by mixing features from each. For example, in ABC-SMC,
instead of imposing a series of decreasing tolerance, we could choose a fixed,
large *sample size* from which we always accept the top $$N$$ by distance.
Because the samples converge,[^tuning] the sequence of (implicit) tolerances
still decreases, so this algorithm should still afford the Bayesian
interpretation of producing a *sample from the posterior* (not just a point
estimate of $$\theta$$). But this modification makes the algorithm's runtime and
memory usage deterministic, a desirable property (for example, it lets us
preallocate all the arrays for a performance boost).

Another idea we can transplant from evolution to ABC-SMC is forced exploration.
In evolutionary algorithms, a common practice is to always include a few totally
random samples in each new population. In ABC-SMC, this could look like
modifying step 2 to construct a new population using $$\lceil 0.9 N \rceil$$ ABC
rejection samples, and filling the rest with fresh draws from the initial prior.
This should reduce the ABC-SMC's propensity to get stuck in a local optimum (a
real problem, in my experience), at the cost of a lower acceptance rate and
longer runtime.

What about going the other way—incorporating ideas from ABC-SMC into evolution?
In evolutionary algorithms, the custom is to return the global best solution,
but one can argue that the entire final population, as a "sample" of parameter
values that survived the top-$$k$$ filter repeatedly, deserves more attention.
Like a Bayesian posterior, this population conveys the *distribution* of good
$$\theta$$ estimates, which could have properties such as clustering or
correlation that warrant further investigation.

[^details]: And we should take care to ensure that the size of each sample
    $$D'_i$$ is sufficiently large to ward off a [winner's
    curse](https://en.wikipedia.org/wiki/Winner%27s_curse) outcome where the
    $$\theta$$ you return is actually a good estimate, not just a "lucky"
    instance where all the noise happened to point in the right direction.

[^superficial]: Another difference between the algorithms as I laid them out is
    that in my evolutionary algorithm, you upsample the $$k$$ "survivors" into a
    size-$$N$$ population at the end of the inner loop (step 5), whereas in
    ABC-SMC the upsampling occurs implicitly in steps 2.1 and 2.2. I think this
    difference is superficial—it's a matter of setting up each iteration at the
    end of the previous iteration versus at the start of the current one. Note
    that $$k$$ (not $$N$$) in the evolutionary algorithm corresponds to $$N$$ in
    ABC-SMC.

[^tuning]: Well, *if* the samples converge—which depends on tuning $$\sigma$$.
