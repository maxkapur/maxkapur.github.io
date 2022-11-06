---
layout:     post
title:      "Two truths and one lie"
---

A puzzle based on the icebreaker game.

> Two truths and one lie:
>
> 1. I have a twin.
> 2. I used a random number generator to decide whether to place a true or false statement in #1.
> 3. I do not understand the rules of “two truths and one lie.”

Solution inside.<!--more-->

<details markdown="block">
<summary>Hint</summary>

The solution to the puzzle consists of assigning a truth value (true or false) to each of the three
statements. 
</details>

<details markdown="block">

<summary>Solution and explanation</summary>

Start by taking cases; there are eight:

- Suppose I used the RNG. Then we have `2: true` and
    - `1: false` and `3: false` is an inconsistent assignment, because I claimed to understand the rules but broke them by writing two lies and one truth.
    - `1: false` and `3: true`  is an inconsistent assignment, because I denied understanding the rules but followed them.
    - `1: true` and `3: false` is a consistent assignment, because I claimed to understand the rules and followed them.
    - `1: true` and `3: true`  is a consistent assignment, because I denied understanding the rules and broke them.
- Suppose I didn't flip a coin. Then we have `2: false` and (applying similar logic)
    - `1: false` and `3: false` is inconsistent. 
    - `1: false` and `3: true`  is consistent.
    - `1: true` and `3: false` is inconsistent. 
    - `1: true` and `3: true`  is inconsistent.
     
The consistent assignments are as follows.

|Statement:|1|2|3|
|-|-|-|-|
|Assignment A|true |true |false|
|Assignment B|true |true |true |
|Assignment C|false|false|true |

It appears that any of the statements could be true or false under a consistent assignment. 
However, since I could not know the result of the RNG in advance, I could only have used it if
I knew that the three statements would admit at least one consistent assignment whether the RNG
returned `1: false` or `1: true`.

But this is not the case: There is *no* consistent assignment in which
I used the RNG and got the result `1: false`. Therefore, I must not have used the RNG at all, which rules out
assignments A and B and leaves assignment C, namely `1: false`, `2: false`, and `3: true`, as the only option. 

See Wikipedia, [“Boolean satisfiability problem.”](https://en.wikipedia.org/wiki/Boolean_satisfiability_problem)
</details>
