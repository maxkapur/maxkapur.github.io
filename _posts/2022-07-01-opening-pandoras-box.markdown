---
layout:     post
title:      Opening Pandora’s Box
---

A harrowing thing that happens in research is that occasionally, you stumble upon a
[paper from 1979 (paywall)](https://doi.org/10.2307/1910412) that appears to solve
the exact problem that you’ve been working on for months, but that escaped your
attention because it used different terminology or notation.

That *almost* happened to me this week, but mercy was on my side. The paper linked above, Martin Weitzman’s
“Optimal Search for the Best Alternative,” considers a problem called the Pandora’s
Box problem that resembles my college application problem except for one crucial
difference: The Pandora’s Box problem has a time dimension, whereas the college application 
problem is static. 

The unusual thing is that the static problem appears more difficult.
<!--more-->

## College application vs. the Pandora’s Box problem

If we apply the Pandora’s Box problem to college application, we get the following scenario:
Pandora applies one by one to colleges in the admissions market. At each point in time,
she can either submit a new college application (which costs money),
in which case she will observe her admissions outcome after a time delay,
or she can enroll at one of the schools she has already gotten into (and receive a payoff).
The problem is to determine an optimal *stopping rule* for when Pandora should halt her
search and accept the payoff she has on hand. Weitzman showed how to calculate a 
*reservation price*—roughly, the expected value of application—for
each of the colleges. The optimal policy is to halt the search when
the value of the current best offer exceeds the reservation price of all the colleges
left to apply to.

Weitzman’s model is a dynamic model because under the optimal strategy,
there is no way to predict Pandora’s application decisions from the problem data alone.
The set of schools she ultimately applies to, or her *application portfolio,*
depends on the values of the random variables observed in a given “round” of the admissions game.
On the other hand, in the static model of college application considered in
[my master’s thesis](https://github.com/maxkapur/CollegeApplication),
the decisionmaker commit to her entire application portfolio at the outset.

Arguably, the static model is more hostile to students than the Pandora’s Box problem.
If, for example, an unlucky Pandora is rejected from a safety school at an early round of application,
then she can compensate for the unexpected loss by applying to new safety schools in subsequent
rounds. By contrast, the static college application problem does not allow
students to modulate their risk allocation after observing some of the random variables.

The admissions process used in the United States can be viewed as the concatenation of
both problems: In the fall, students solve the static problem, send out a batch of
applications, and pray for a good outcome. Then, after observing their first-round
admissions outcomes in March, they use the Pandora strategy to pursue additional opportunities
by negotiating their financial aid offers[^1]
and applying to schools that offer rolling admissions.

## Static models aren’t necessarily simpler

Often, when we are presented with two optimization models and told that
one is “static” and the other is “dynamic,” it is safe to guess that the static problem
is a special case of the dynamic one. College application breaks this intuitive
principle. In the dynamic Pandora’s box problem, any given moment,
you are only asking two questions:

- Should I apply to another school?
- If so, which one?

To answer correctly, you only ever need to compute the marginal utility of *individual*
college applications relative to the offers you already have on hand, which is not terribly
difficult. But in the static college application problem, the expected payoff depends on the 
*combination* of schools in the application portfolio. This yields a larger array of choices,
and a more challenging decision problem. 

In my thesis, I prove that the college application problem is hard in a mathematical sense
called NP–completeness, which means that barring an unprecedented computational breakthrough,
there is no way to solve it that is both fast and accurate. The NP–completeness proof
exploits the interaction among simultaneous applications in order to make the
objective function misbehave.

[^1]: For the uninitiated—yes, you can [negotiate college financial aid offers](https://www.forbes.com/sites/markkantrowitz/2021/04/19/how-to-negotiate-a-better-college-financial-aid-offer/?sh=361cdbb61420).
