+++
title = "Houseplant measurements"
aliases = [ "/2020/01/02/houseplant-measurements.html",]

[params]
id = "https://maxkapur.com/2020/01/02/houseplant-measurements"
+++

I have been measuring the leaves of my houseplants.

{{< figure
  src="houseplants-1-length-width.png"
  class="compact squareborder"
  alt="Scatter plot showing positively correlated length and width of houseplant leaves, color coded for Aretha (big plant) and Brad (small plant)"
>}}

<!--more-->

It <em>is</em> surprising how normal these distributions are.

{{< figure
  src="houseplants-2-area-qq.png"
  class="compact squareborder"
  alt="q-q plot for area of Brad and Aretha leaves against a normal distribution"
>}}

{{< figure
  src="houseplants-3-ratio-qq.png"
  class="compact squareborder"
  alt="q-q plot for aspect ratio of Brad and Aretha leaves against a normal distribution"
>}}

I’m putting my stats notes
[here](https://github.com/maxkapur/maxkapur.github.io/blob/e08d16ffa237fcb418a96fcae35298d3b04e733d/math/stats.ipynb).

> **Note:** I imported this post from my Blogger archive on April 27, 2024. The original title was “Aretha and Brad”—the names of the houseplants (after Franklin and Mehldau, respectively) whose measurements are pictured. This mindfulness project was likely inspired by the beloved [iris dataset](https://en.wikipedia.org/wiki/Iris_flower_data_set).
>
> I’ve updated the “my stats notes” link to point to the latest version of that Jupyter notebook in GitHub’s view of the Git source tree for this site, in the unlikely event that it is useful to anyone.
>
> With four years of additional perspective, I would be remiss not to point out that leaf geometry in which both the area {{< math "XY" />}} and the aspect ratio {{< math "X/Y" />}} are both normally distributed would be serendipitous indeed—and that the plots above don’t look particularly linear to me anymore.
