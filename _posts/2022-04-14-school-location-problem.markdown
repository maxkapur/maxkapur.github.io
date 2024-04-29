---
layout:     post
title:      The school location problem
katex:      True
---

I’ve spent a few days thinking about a facility location problem that
we might call the *school location problem.* The goal is to place $$n$$
schools to serve $$m$$ families, such that the *furthest* distance
between any family and their *nearest* school is *minimized.* This
problem is almost a $$k$$-means or ellipsoid fitting problem, but its
unusual “minimin” form makes it computationally challenging.

In the video below, and associated Jupyter notebook ([GitHub](https://gist.github.com/maxkapur/e907289b457ebee8e3a191cbda7f7381), [HTML viewer](https://nbviewer.org/urls/gist.githubusercontent.com/maxkapur/e907289b457ebee8e3a191cbda7f7381/raw/37cd78433076b0f880ef3d645a93ef278abce33d/SchoolLocation.ipynb)), I discuss the formulation of this problem, show to express it as a mixed-integer second-order convex program, and then solve a small instance using the Julia/JuMP/Juniper/SCS stack.

Here’s the [video link](https://www.youtube.com/watch?v=/bjreiQRHerU).
