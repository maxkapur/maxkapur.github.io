---
layout:     post
title:      "Formats masterpost"
katex:      true
permalink:  /formatting/
---

Here is a post with all kinds of crazy formatting so that I can test out my CSS.<!--more-->

# Heading 1

Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam ipsa ducimus laudantium, ab numquam optio cumque perspiciatis voluptatum quis accusantium, atque excepturi, laboriosam similique! Laboriosam sed dignissimos quasi non animi!

## Heading 2

Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam ipsa ducimus laudantium, ab numquam optio cumque perspiciatis voluptatum quis accusantium, atque excepturi, laboriosam similique! Laboriosam sed dignissimos quasi non animi!

### Heading 3

Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam ipsa ducimus laudantium, ab numquam optio cumque perspiciatis voluptatum quis accusantium, atque excepturi, laboriosam similique! Laboriosam sed dignissimos quasi non animi!

### Heading 4

Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam ipsa ducimus laudantium, ab numquam optio cumque perspiciatis voluptatum quis accusantium, atque excepturi, laboriosam similique! Laboriosam sed dignissimos quasi non animi!

| Here is | an example | of a | table |
|-|-|-|-|
| I am | testing what happens | when there's | text in it |
| testing what happens | when there's | no text in it | |
| another | | line for | good measure. |

A blockquote:

> Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam ipsa ducimus laudantium, ab numquam optio cumque perspiciatis voluptatum quis accusantium, atque excepturi, laboriosam similique! Laboriosam sed dignissimos quasi non animi!
>
> Ab numquam optio cumque perspiciatis voluptatum quis accusantium, atque excepturi, laboriosam similique! Laboriosam sed dignissimos quasi non animi!

Things I like to eat:

- Apples
- Bananas
- Ooples
- Banoonoos

Items on my desk:

 1. Computer
 2. Speakers
 3. Coffee
 4. Notepad

# Code

I’ve been using the following fish alias `fzl` (“fuzzy list”) to run `fzf` (“fuzzy find”) in the current directory with a `bat` preview. It’s just a couple of light tweaks to the examples listed in the `fzf` [readme](https://github.com/junegunn/fzf#preview-window).

`~/.config/fish/functions/fzl.fish`:

````julia
function fzl
    # `bat` is aliased to `batcat` on Debian
    if type -q batcat
        set -f bat_command "batcat"
    else
        set -f bat_command "bat"
    end

    # Set the overall width of the `bat` preview to
    # 50% the width of the current terminal
    set -l bat_width $(math ceil $COLUMNS x 0.5)

    # My preferred `bat` options
    set -f bat_command \
        $bat_command \
        --style numbers \
        --color always \
        --italic-text always \
        --wrap auto \
        --terminal-width $bat_width

    fzf \
        --preview "$bat_command {}" \
        --preview-window right,$bat_width,nowrap
end
````

<!-- note: used julia syntax highlighting above because it *kind of* works and (unlike fish) is supported by jekyll -->

Example below.

![A screengrab of the terminal output produced by fzl.fish. It shows a list of filenames corresponding to posts on this blog; the post title "Thesis defense" is highlighted.](/assets/fish-fzl-example.png)

# Math

In this post, we will show that functions of the form

$$
f(X) = 1 -
\prod_{i \in \Omega \setminus X} (1 - p_i)
\prod_{i \in X} (1 - q_i)
$$

are submodular for $$p_i, q_i \in [0, 1]$$ where each $$p_i \leq q_i,$$
and examine an application of this small result that demonstrates its
practical value.[^footnote]

[^footnote]: Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam ipsa ducimus laudantium, ab numquam optio cumque perspiciatis voluptatum quis accusantium, atque excepturi, laboriosam similique! Laboriosam sed dignissimos quasi non animi!
    Ab numquam optio cumque perspiciatis voluptatum quis accusantium, atque excepturi, laboriosam similique! Laboriosam sed dignissimos quasi non animi!
