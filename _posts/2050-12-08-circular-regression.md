---
layout: post
katex: true
title: Circular regression when you already know the period
---

This [Stack Exchange](https://stats.stackexchange.com/a/660199) answer reminded
me of a data science trick that may be new to some. In short, if you try to
model $$y$$ as a sinusoidal function of $$x$$, you obtain a regression formula
that is nonlinear in the parameters. However, if you know the period, you can
linearize the formula and compute an exact least-squares fit.<!--more-->

# Background

Suppose you are trying to create a regression model for data that looks like
this:

![Scatter plot of sample input data. The y variable appears to be a sine wave
with a period of roughly 6.28, amplitude a little less than 1, shifted to the
right by about 6 units.](/assets/images/cyclical-data-before.svg)

$$y$$ is clearly a sinusoidal function of $$x$$ (plus noise), so there are three
parameters we need to estimate:

1. The period $$T$$ (distance between peaks)
2. The amplitude $$A$$ (height of the peaks)
3. The phase $$\phi$$ (where in the cycle the peaks occur)

But for some data, there’s really only one value for the period that makes
sense. For example, if $$x$$ represents “day of the year” (as in the Stack
Exchange question), then we are clearly expecting a yearly cycle (or else we
would have collected exact dates). Thus, $$T = 365.25$$ (or however you want to
handle leap years), and we have only to estimate the amplitude and phase that
best fit the data.

# Problem statement

Without loss of generality, we can assume that $$T = 2 \pi$$ (if not, multiply
each $$x_i$$ by $$2 \pi / T$$). Then our objective is to minimize the error in
the system of equations

$$y_i = A \sin( x_i + \phi )$$

for each $$(x_i, y_i)$$ in the input data.

Unfortunately, this model is not linear in the parameters to be estimated ($$A$$
and $$\phi$$), so we can’t estimate it using ordinary least-squares regression.

# The trick

The trick is to estimate the following model instead, which *is* linear in the
parameters $$\beta_0$$ and $$\beta_1$$:

$$y_i = \beta_0 \cos x + \beta_1 \sin x$$

To see that this model is equivalent, apply a [trig
identity](https://en.wikipedia.org/wiki/List_of_trigonometric_identities#Angle_sum_and_difference_identities)
to find that

$$A \sin( x_i + \phi ) = A \cos x_i \sin \phi + A \sin x_i \cos \phi.$$

Matching coefficients on $$\sin x_i$$ and $$\cos x_i$$, we have

$$
\begin{aligned}
\beta_0 &= A \sin \phi \\
\beta_1 &= A \cos \phi .
\end{aligned}
$$

Dividing the first equation by the second, we recover
$$\phi = \operatorname{atan2}(\beta_0, \beta_1)$$. Then
$$A = \beta_0 / \sin \phi = \beta_1 / \cos \phi$$.

# Demo

The following Python script demonstrates our technique.

```python
#!/usr/bin/env python
import numpy as np
import matplotlib.pyplot as plt

rng = np.random.default_rng()

if __name__ == "__main__":
    # Make fake training data
    size = 128  # Number of points
    x = rng.uniform(0, 10, size)
    A = rng.standard_exponential()
    phi = rng.uniform(0, 2 * np.pi)
    sigma = 0.20 * A  # Scale of random noise
    y = A * np.sin(x + phi) + rng.normal(size=size, scale=sigma)

    # First plot showing what the data looks like
    plt.scatter(x, y)
    plt.savefig("cyclical-data-before.svg", transparent=True, bbox_inches="tight")

    # Transform x to its cos and sin, then solve
    #   y = x_transformed @ beta
    # by least squares.
    x_transformed = np.stack([np.cos(x), np.sin(x)]).T
    (beta0, beta1), *_ = np.linalg.lstsq(x_transformed, y)  # Discard other outputs

    # Recover A and phi using the transformation we derived. Estimate A using
    # both expressions and take the average.
    phi_pred = np.atan2(beta0, beta1)
    A_pred = (beta0 / np.sin(phi_pred) + beta1 / np.cos(phi_pred)) / 2

    # Plot the estimated model using regularly spaced values of x
    x_pred = np.linspace(x.min(), x.max(), 500)
    y_pred = A_pred * np.sin(x_pred + phi_pred)
    plt.plot(x_pred, y_pred)
    plt.savefig("cyclical-data-with-fit.svg", transparent=True, bbox_inches="tight")
```

Here is what the predicted model looks like:

![The same scatter plot as above, this time with the estimated sine wave drawn
on top. The estimated wave fits the data
well.](/assets/images/cyclical-data-with-fit.svg)

# Notes

**Retaining the linearized parameterization:** In the Python code above, we
compute $$\phi$$ and $$A$$ just to demonstrate that the technique actually
works. But the code will throw a zero-division error at the computation of
`A_pred` if $$\phi$$ is a multiple of $$\pi / 2$$ (which happens when one of the
$$\beta_j = 0$$). In practice, I recommend the $$\beta_j$$ values and running
predictions using the $$y_i = \beta_0 \cos x + \beta_1 \sin x$$ model.
Experienced data scientists will recognize this transformation, but you could
add a comment along the lines of “this is a linear reparamaterization of $$A
\sin( x + \phi )$$.”

**Composition of sinusoids:** You can also use this technique if your $$y$$
variable is a linear combination of sine waves of known periods. For example, if
$$x$$ is “minute of day” and $$y$$ is “volume of emails,” you might expect an
overall daily trend (period of 24 hours) with smaller variations within each
hour (due to scheduled emails going out at the top of each hour). Then you can
set $$w_i = 2 \pi x_i / (24 \cdot 60)$$, $$z_i = 2 \pi x_i / 60$$, and estimate
the model

$$y = A_w \sin( w_i + \phi_w ) + A_z \sin( z_i + \phi_z )$$

using the transformation above.

**Fourier transform:** If you *don’t* know the period $$T$$ and your $$x_i$$ are
evenly spaced, then what you’re looking for is probably not a regression model
but a [discrete Fourier
transform](https://en.wikipedia.org/wiki/Discrete_Fourier_transform).
