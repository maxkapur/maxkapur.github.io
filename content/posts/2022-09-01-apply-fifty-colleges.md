+++
title = "Apply to fifty colleges"
aliases = [ "/2022/09/01/apply-fifty-colleges.html",]

[params]
id = "https://maxkapur.com/2022/09/01/apply-fifty-colleges"
+++

In this post, we’ll use fake numbers and a simplified model to argue that the most college applicants should apply to far more colleges than they actually do. You can probably extend the argument to job applications and the dating game. I’ll also compute a few fake comparative statics and speculate about why real students don’t apply to more schools.<!--more-->[^obvious]

[^obvious]: We will avoid the obvious argument that goes, “If you are willing to spend six figures on an a college education, then what’s a few hundred extra in application fees?” This argument is incorrect, because it assumes that each additional application is worth the value of attending that college times the probability of getting in. In actuality, you can only attend *one* of the colleges you get into; thus additional applications make a sublinear contribution to the overall expected utility. Our model will account for this.

## Fake numbers and a simplified model

We’ll start by making a few simplifying, conservative assumptions about the college admissions process. Here “conservative” means that we will err on the side of *understating* the value of applying to college, thereby arriving at an *underestimate* of the optimal number of college applications. Thus, our choices make it challenging to arrive at this post’s headline conclusion, such that if we *nonetheless* draw the conclusion that students should apply to more colleges, we have some degree of confidence that this statement applies to the actual numbers, too.

First, let’s assume that you always have the option of attending a “safety school.” The safety school could also represent a community college or entering the workforce directly after high school. In addition, there are many “reach schools,” or elite universities, with competitive admissions. It is better to attend a reach school than the safety school, but applying to a reach school takes time and effort.

Let {{< math "t" />}} denote the utility of attending an elite university, measured in monetary units relative to the safety school. By a conservative estimate, an elite university might offer us an expected salary increase of \$20,000 per year, at a tuition cost of \$30,000 dollars per year higher than the safety school. Thus, aggregating over 40 years of employment and 5 years of college attendance, we can estimate

{{< math >}}
t = 40 \times 20000 - 5 \times 30000  = 650000.
{{< /math >}}

Let’s assume, for simplicity, that all the reach schools are equally competitive, and let {{< math "p" />}} denote the probability of getting into an elite university. Assume that admissions at each school are probabilistically independent. Let’s pick {{< math "p = 0.1" />}}, which is near the acceptance rate (and therefore, the average admissions probability across all applicants) at many elite US universities. If you apply to {{< math "x" />}} reach schools, the probability of getting into *at least* one is {{< math "1 - (1 - p)^x" />}}, in which case you receive {{< math "t" />}} units of utility.

However, applying to college is not free: You have to pay an application fee, various clerical fees for submitting transcripts and test scores, and then there are time costs associated with writing essays, requesting recommendation letters, and filling out the online form. Let {{< math "c" />}} denote the cost of applying to a reach school, so the cost of applying to {{< math "x" />}} schools is {{< math "cx" />}}, and the expected utility of the entire college application process can be written as follows:[^sublinear]

[^sublinear]: Note that our assumption that the cost is linear in {{< math "x" />}} is conservative: In reality, since you can recycle essays and recommendation letters, the marginal costs diminish as {{< math "x" />}} increases; a function like {{< math "c \ln x" />}} or {{< math "c \sqrt{x}" />}} is arguably more realistic.

{{< math >}}
f(x) = t\bigl(1 - (1 - p)^x\bigr) - cx.
{{< /math >}}

Typical college application fees are \$50 or so; let’s take {{< math "c = 200" />}} to account generously for the other costs. Our goal is to maximize {{< math "f(x)" />}}.

## The model says apply to fifty colleges

With these values of {{< math "t" />}}, {{< math "p" />}}, and {{< math "c" />}}, here’s the graph of {{< math "f(x)" />}}. As you can see, the maximum occurs at about {{< math "x^* = 55" />}} applications!

![A graph showing the number of applications and the utility.](/assets/images/app-count-utility.svg)

We can solve for the maximum analytically using a method you might have learned in high school calculus: {{< math "x^*" />}} represents the point where {{< math "f(x)" />}} stops increasing and starts decreasing. That is, the point where its slope {{< math "f'(x)" />}} is zero.

With a little bit of legwork, you can check that the derivative of {{< math "f(x)" />}} is

{{< math >}}
f'(x) = -t (1-p)^m \ln(1-p) - c
{{< /math >}}

and setting this equal to zero and solving for {{< math "x" />}} yields

{{< math >}}
x^* = \frac{\ln c - \ln t - \ln \bigl(- \ln\left(1-p\right)\bigr)}{\ln\left(1-p\right)}.
{{< /math >}}

(It’s a pleasant surprise to encounter a nested logarithm somewhere other than computer science.) Plug in {{< math "t" />}}, {{< math "p" />}}, and {{< math "c" />}} to obtain {{< math "x^* = 55" />}}, as promised.[^exact]

[^exact]: The exact answer is {{< math "x^* = 55.39" />}}, but you can only apply to a whole number of colleges. Since {{< math "f(x)" />}} is a concave, univariate function, the optimal integer solution has to be either 55 or 56, and you can verify that {{< math "f(55) > f(56)" />}}. We’ll use the same approach for the rest of the post.

## Checking our work with comparative statics

The reflexive economist move is to stick the expression for {{< math "x^*" />}} in a [Desmos box](https://www.desmos.com/calculator/yhxxla3wko) as follows, start dragging the sliders around, and see if we can spot any patterns. For example, click the “edit graph on Desmos” box and try increasing the value of {{< math "c" />}} slightly: You should see the vertical line, which represents the optimal number of applications, move to the left.

<iframe src="https://www.desmos.com/calculator/hjgrroyjqs?embed" width="100%" height="500" style="border: 1px solid #ccc" frameborder=0></iframe>

If we’re feeling especially inspired, we might take the derivative of {{< math "x^*" />}} in each of the parameters. Computing these so-called comparative statics will help us verify that our “conservative” assumptions are actually conservative in the way that we think we are. For example,

{{< math >}}
\frac{\partial x^*}{\partial c} = \frac{1}{c \ln (1- p)} < 0
{{< /math >}}

(since {{< math "1-p" />}} is less than one, its logarithm is negative) tells us that increasing the costs *decreases* the optimal number of applications. But (in my opinion) the linear function {{< math "cx" />}} is an *overestimate* of the cost, and the true optimum {{< math "x^*" />}} should be even higher: conservatism fulfilled.

Similarly, {{< math "\partial x^* / \partial t > 0" />}}, meaning that in the [(probable)](https://money.com/wage-gap-college-high-school-grads/) case that an elite college degree is worth more than \$650k, the central argument of this post is even truer.

{{< math "p" />}} is where we get into trouble. I lowballed {{< math "p" />}} above on the assumption that the “value” of a college application correlates with how likely it is to yield an admission letter. However, the *marginal value* of a college application is actually greatest when colleges are hard to get into, and therefore so is your willingness to invest in an additional application. In other words, I should have tried to overshoot {{< math "p" />}} instead.

To understand this counterintuitive result, let’s compute

{{< math >}}
\frac{\partial x^*}{\partial p} = \frac{ \ln{c} - \ln{t} - \ln{\bigl(- \ln{\left(1 - p \right)} \bigr)} + 1}{\left(1 - p\right) \ln^2{\left(1 - p \right)}},
{{< /math >}}

whose sign tells us whether the optimal number of applications is increasing or decreasing in the admissions odds {{< math "p" />}}. The denominator of this expression is positive, so the overall sign depends on the sign of the numerator, which is positive only when

{{< math >}}
p < 1 - \exp(-ce / t).
{{< /math >}}

But in college admissions, this is seldom the case: Typically, {{< math "t" />}} is much larger than {{< math "c" />}}, meaning that {{< math "1 - \exp(-ce / t) \approx 1 -  \exp(0) = 0" />}}, breaking the condition. Lowballing {{< math "p" />}} is only conservative if {{< math "p" />}} is very small in the first place, and {{< math "c" />}} is large relative to {{< math "t" />}}.[^exceptionalregime]

[^exceptionalregime]: For example, to see a regime where {{< math "x^*" />}} is increasing in {{< math "p" />}}, try setting {{< math "t = 10000" />}} and {{< math "c = 1000" />}} in the Desmos box, and vary {{< math "p" />}} between 0.1 and 0.2.

## Oops, apply to thirty colleges

So, if we are being conservative, we should try to *overestimate* {{< math "p" />}}. If we double our previous estimate to {{< math "p = 0.20" />}} and repeat the calculation above, we get a more modest result of {{< math "x^* = 30" />}}. But this is still much higher than the number of colleges real students apply to, right?

We have to increment {{< math "p" />}} much further before {{< math "x^*" />}} starts to align with typical applicant behavior: When {{< math "p = 0.7" />}}, for instance, you get {{< math "x^* = 7" />}}. Now, you might object that {{< math "p = 0.7" />}} sounds like a perfectly reasonable admissions probability for an ambitious student. To this, I offer two responses:

1. As someone who reads blog posts about economics in their free time, your social circle may have instilled in you an biased sense of what is achievable for the typical student.
2. *Some* students have high admissions odds, but others don’t: The odds have to average out to around 10 percent for elite colleges to maintain acceptance rates in that neighborhood.

In other words, our comparative statics analysis revealed an error in our so-called conservative fake numbers, but the error wasn’t quite large enough to undermine our central argument.

## Why don’t students apply to more colleges?

Most students apply to ten or so colleges. Why not more? What do they know that our model doesn’t?

One idea that might come to mind if you’ve played with [Mulberry](https://maxkapur.com/mulberry/) is that most students apply not just to elite schools and a safety school, but also to a continuum of “target schools” in between. Target schools have higher admissions odds, and indeed make up the [bulk of the admissions market](https://www.pewresearch.org/fact-tank/2019/04/09/a-majority-of-u-s-colleges-admit-most-students-who-apply/). This observation isn’t enough to explain real students’ small application portfolios, however, because elite universities also are (perceived as) much more valuable than target schools.

The model above can also be applied to a student who has already applied to safety and target schools and is trying to decide how many reach schools to add to her portfolio: Simply discount {{< math "t" />}} to reflect the value of a degree from an elite school relative to the (actuarial) value of a degree from a target school. Conservatively, if we hack {{< math "t" />}} all the way down to \$200k, take {{< math "p = 0.2" />}}, and {{< math "c = 200" />}}, we *still* get a hefty {{< math "x^* = 24" />}}.

Here’s what I think is really going on: Students don’t apply to zillions of colleges because they aren’t optimization machines. When I was a senior in high school, I categorically refused to apply to more than five colleges because I didn’t want to look like a tryhard.[^idw] The psychological costs of college application are *really large,* because they include not only the exhaustion of composing and submitting applications, but also the cost of *imagining* the disappointment of being rejected from a dream school.

[^idw]: It didn’t work.

## Revealed cost of college application

What, in dollar terms, is the value of the subjective cost students associate with college application, after taking into account this risk aversion? Let’s stick with our conservative {{< math "t = 200000" />}} and {{< math "p = 0.2" />}} scenario, and turn the question around: Given that most students apply to about a dozen colleges, what application cost {{< math "c" />}} makes this number of applications optimal?

To figure this out, we just need to solve our {{< math "x^*" />}} equation for {{< math "c" />}}. The answer is

{{< math >}}
c = - t (1 - p)^x \log{\left(1 - p \right)}
{{< /math >}}

and plugging in the numbers yields {{< math "c = 3067" />}} dollars per application.

Remember: These numbers are fake. But we have made a plausible argument that the majority of the costs incurred in the college application process are psychological, rather than material. If you can overcome the psychological costs, then by applying to thirty or fifty colleges, you may be able to reap significant material rewards.

## Reader exercises

- Repeat the calculations above for another situation, such as job application. How many jobs should you apply to? Is the model a good choice?
- Identify a regime in which {{< math "\partial x^* / \partial p" />}} is positive and explain, in qualitative terms, why this is the case.
- If every student adopts the optimal application strategy, then everyone might apply to twice as many schools. But then each school will become twice as competitive, changing the admissions odds and therefore the optimal strategies. Can you sketch the equilibrium criteria for this market? What other information would you need? [(Paywalled academic paper about this.)](https://www.journals.uchicago.edu/doi/10.1086/675503)
- Suppose that the admissions probabilities and utility values for the reach schools are all different. What is the utility expression in this case? *Hint:* Replace {{< math "x" />}} with a set indicating which colleges you apply to. You can find the answer [here](https://maxkapur.com/mulberry/) or in my [master’s thesis](https://github.com/maxkapur/CollegeApplication).
