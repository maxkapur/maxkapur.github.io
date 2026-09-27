+++
draft = true
title = 'Cheap(?) and easy(??) portfolio rebalancing'

[params]
id = 'tag:max@maxkapur.com,2026-05-27:posts/2026-09-30-cheap-easy-rebalancing'
+++

I have been learning about investments lately and encountered a concept called
[rebalancing](https://en.wikipedia.org/wiki/Rebalancing_investments). In short,
many investors have a target allocation across different asset categories. For
example, you may resolve to hold 80% of your investments in stock and 20% in
bonds. Over time, stocks tend to grow more quickly than bonds, so if you let
these investments sit, your mix might drift to something like 90/10.

Rebalancing simply means exchanging assets to restore the target allocation. For
typical investment portfolios, it's not hard to figure out how to do this: In
the example above, one would exchange 1/9th of the stocks for bonds.

But let's overthink this a bit and consider the general case with {{< math "n"
/>}} funds and {{< math "m" />}} asset categories. What's the "cheapest" way to
rebalance (i.e. the minimal number of transactions)? And can we make "AI" (note:
not actually AI) find the answer for us instead of eyeballing it?

## Example

*Funds* are held in an investment account and typically represented by a ticker
symbol like VTI. For example, we might be trying to balance a portfolio with
{{< math "n = 5" />}} funds as follows:

|             Fund|Holding|
|:----------------|------:|
|Whole-world Stock|$100.00|
|   US Tilt Equity|$100.00|
|   Strategy 90/10|$500.00|
|       Ex-US Fund|$250.00|
|        Bond Fund| $50.00|

In our example (and real life) mutual funds and ETFs can contain an arbitrary
mix of *asset categories.* Let's suppose we are interested specifically in
balancing our portfolio to achieve a target mix across US equities, foreign
equities, and bonds. We research the composition of our funds across these
{{< math "m = 3" />}} categories to obtain the following:

|             Fund|US equities|Foreign equities|Bonds|
|:----------------|----------:|---------------:|----:|
|Whole-world Stock|        60%|             40%|     |
|   US Tilt Equity|        90%|             10%|     |
|   Strategy 90/10|        90%|                |  10%|
|       Ex-US Fund|           |            100%|     |
|        Bond Fund|           |                | 100%|

To balance a portfolio, we need to plan our target allocation across the asset
categories. The table below also shows our current allocation, which you can
calculate using the previous two tables, for comparison.

|       Component|Current allocation|Target allocation|
|:---------------|-----------------:|----------------:|
|     US equities|               60%|              70%|
|Foreign equities|               30%|              25%|
|           Bonds|               10%|               5%|

It looks like we have a little too much in bonds and not enough in US equities.
Our overall portfolio is worth $1000. So, eyeballing, one way to achieve the
target allocation might be to sell everything we have in the bond fund
(decreasing our allocation from 10% to 5% in bonds) and put it into US Tile
Equity. That still leaves us short of our desired allocation in foreign
equities, so we'll need to exchange some of our holdings of Ex-US Fund for US
Tilt Equity, too, to complete the rebalancing. With some fiddling, we arrive at
the following sequence of transactions:

|Exchange amount| From fund|       To fund|
|--------------:|:---------|:-------------|
|         $50.00| Bond Fund|US Tilt Equity|
|         $61.11|Ex-US Fund|US Tilt Equity|

But can we do any better?

## Yes

It's possible to rebalance this portfolio in just one transaction:

|Exchange amount| From fund|       To fund|
|--------------:|:---------|:-------------|
|        $111.11|Ex-US Fund|US Tilt Equity|

This results in the following holdings, which you can verify meet the target
allocation:

|             Fund|Current holding|Rebalanced holding|
|:----------------|--------------:|-----------------:|
|Whole-world Stock|        $100.00|           $100.00|
|   US Tilt Equity|        $100.00|           $211.11|
|   Strategy 90/10|        $500.00|           $500.00|
|       Ex-US Fund|        $250.00|           $138.89|
|        Bond Fund|         $50.00|            $50.00|

It's possible to discover the one-transaction solution by staring at the data
and thinking about it. But for a general solution, with large numbers of funds
or allocation categories, we can use a mixed-integer linear program to solve
for the shortest sequence of transactions that rebalances the portfolio.

## The linear program

Let {{< math "x_{ij} \geq 0" />}} denote the amount of fund {{< math "i" />}} that
we should exchange for {{< math "j" />}}. This variable can't go negative;
{{< math "x_{ji}" />}} represents an exchange in the other direction.

Let {{< math "h_i" />}} denote our initial holdings of fund {{< math "i" />}}. 
After applying the transactions {{< math "x_{ij}" />}}, our rebalanced holdings of
{{< math "i" />}} are

{{< math >}}
y_i(X) = h_i + \sum_{j=1}^n x_{ji} - \sum_{j=1}^n x_{ij}
{{< /math >}}

which is a linear function of {{< math "X" />}}.

We'll use a matrix {{< math "C" />}} to denote the composition of the various funds on
offer: {{< math "c_{ki}" />}} is the proportion of fund {{< math "i" />}} that
aligns to category {{< math "k" />}}.

Let {{< math "t_k" />}} denote our target allocation for category {{< math "k" />}}.
Actually, it will be easier to work with {{< math "d_k = t_k \sum y_i" />}}, which
is just {{< math "t_k" />}} rescaled to currency units, or the number of "dollars"
we have invested in each of the {{< math "m" />}} asset categories. 

We want to minimize the number of nonzero entries in {{< math "X" />}}. To model
this, we apply the standard integer programming trick of introducing a helper
binary variable {{< math "z_{ij}" />}} which is zero only if {{< math "x_{ij}" />}} is.
The objective function is then just the sum of the elements of {{< math "Z" />}}.

Here is the completed linear program:

{{< math >}}
\begin{aligned}
  \text{minimize} \quad     & \sum z_{ij} \\
  \text{subject to} \quad   & Cy(x) = d \\
                            & X \leq MZ \\
                            & y(x) \geq \mathbf{0} \\
                            & X \geq \mathbf{0} \\
                            & z_{ij} \text{ binary}
\end{aligned}
{{< /math >}}

The {{< math "M" />}} in {{< math "X \leq MZ" />}} is a large constant; I used
{{< math "M = \sum h_i" />}}. The {{< math "y(x) \geq \mathbf{0}" />}}
constraint prevents us from trying to sell more units of a fund than we own. 

To avoid taking ourselves too seriously, we've used all the sloppy operations
researcher notation: {{< math "a \geq b" />}} for vectors or matrices means the inequality
holds between corresponding elements, {{< math "X" />}} and
{{< math "Z" />}} are technically not matrices because they aren't defined on
the diagonal, etc.

## The code

The rest is just [coding](https://github.com/maxkapur/portfolio_rebalancing). At
that link, I implemented the integer program in Python using the
(PySCIPOpt)[https://pyscipopt.readthedocs.io/en/latest/index.html] bindings for
the [SCIP](https://scipopt.org/) solver. (Pyomo)[https://www.pyomo.org/] is the
more popular Python library for this kind of work, but I thought the simplicity
of PySCIPOpt was a better match to this task.

My code specifies the problem as above, solves it, and renders the results in
Markdown tables that I pasted above.
