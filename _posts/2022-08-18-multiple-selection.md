---
layout:     post
title:      "Grading multiple-selection questions"
katex:      true
---

Consider the following test question:

> Which of the following are US States? (select multiple)
>
> <ol type="a">
>    <li>Washington </li>
>    <li>Delaware   </li>
>    <li>Frankfurt  </li>
>    <li>Memphis    </li>
> </ol>

This is a multiple-selection question, so the correct answer is `a` and `b`. How would you grade a question [like this]({% post_url 2020-05-06-nonnative-teacher %}) on an exam?
<!--more-->

When I was in school, the Scantron machines we used supported these kinds of multiple-selection questions, but they were graded all or nothing: You got one point if your answer matched the key exactly, and zero points otherwise. I have it on good authority that the MOOC site [edX](https://www.edx.org/) works the same way.

In the era of floating-point arithmetic, all-or-nothing grading for multiple-selection questions is a hard practice to defend.
A student who answers `a` is clearly *more correct* than a student who answers `c` and `d`, because the question above is really four questions:

> <ol type="a">
>    <li>Is Washington a US state?</li>
>    <li>Is Delaware   a US state?</li>
>    <li>Is Frankfurt  a US state?</li>
>    <li>Is Memphis    a US state?</li>
> </ol>

## An alternative to all-or-nothing grading

I propose grading multiple-selection problems as $$n$$ true-or-false questions, each weighted $$1/n$$ points. In this example, a response of `a` is correct with respect to questions a, c, and d, and receives 0.75 points. A response of `c` and `d` is correct with respect to none of the items and receives zero points.

What about students who guess randomly? A student who guesses randomly receives, in expectation, 0.5 points under my proposal and $$1/ 2^n$$ points under the all-or-nothing method. Therefore, one objection to my proposal is that it provides students with a strong incentive to guess. I contend that this is not a real problem, because

 - The incentive for students to guess is still positive under all-or-nothing grading,
 - In creating examinations, there is no objective reason to make “discourage students from guessing” a design goal,
 - Even if you insist that reducing the incentive to guess is a good thing, you can accomplish this by instating a penalty (of 0.5 points) for incorrect answers.

Wrong-answer penalties, however, are a [potential source of bias (open-access article)](https://doi.org/10.1287/mnsc.2013.1776) in testing because students vary in their risk aversion.

## Better yet

Multiple-selection questions are not very user friendly to begin with. Some students fail to realize that they are allowed to choose more than one answer and agonize over technicalities (*Maybe he means Washington, DC?*). Others (mistakenly) *assume* that they will be graded all or nothing, recognize the slim chances of success, and just skip the question to pursue lower-hanging fruit.

Therefore, as long as you accept my argument that multiple-selection questions should be regarded as $$n$$ true-or-false questions for grading purposes, why not simply write them out that way on the test sheet? Then there is no way to misread the question as a single selection, and the grading scheme is obvious.
