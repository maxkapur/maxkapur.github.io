---
layout:     post
title:      "Formats masterpost"
hidden:     true
permalink:  /formatting/
---

Here is a post with all kinds of crazy formatting so that I can test out my CSS.<!--more-->

# Heading alpha

Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam ipsa ducimus laudantium, ab numquam optio cumque perspiciatis voluptatum quis accusantium, atque excepturi, laboriosam similique! Laboriosam sed dignissimos quasi non animi!

Make sure the keyboard element <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>Delete</kbd> doesn’t mess up the spacing.

## Heading bravo

Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam ipsa ducimus laudantium, ab numquam optio cumque perspiciatis voluptatum quis accusantium, atque excepturi, laboriosam similique! Laboriosam sed dignissimos quasi non animi!

<figure>
  <img
    src="/assets/images/number-of-degrees.png"
    class="squareborder"
    alt="A graph showing the number of college degrees granted in various fields of study between the years 2000 and 2017. The number of degrees granted in health professions and related programs and business has increased steadily, wile the number in the social sciences and history has increased before beginning to drop."
  />
  <figcaption>
  (National Center for Education Statistics,
  <a href="https://nces.ed.gov/programs/coe/indicator_cta.asp">Undergraduate Degree Fields</a>)
  </figcaption>
</figure>

What a figure!

### Heading charlie the first

Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam ipsa ducimus laudantium, ab numquam optio cumque perspiciatis voluptatum quis accusantium, atque excepturi, laboriosam similique! Laboriosam sed dignissimos quasi non animi!

### Heading charlie the second

Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquam ipsa ducimus laudantium, ab numquam optio cumque perspiciatis voluptatum quis accusantium, atque excepturi, laboriosam similique! Laboriosam sed dignissimos quasi non animi!

| Here is | an example | of a | table |
|-|-|-|-|
| I am | testing what happens | when there’s | text in it |
| testing what happens | when there’s | no text in it | |
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

```shell
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
```

Example below.

![A screengrab of the terminal output produced by fzl.fish. It shows a list of filenames corresponding to posts on this blog; the post title "Thesis defense" is highlighted.](/assets/images/fish-fzl-example.png)

## Python example

<https://github.com/maxkapur/cronjobs/blob/main/backup_nextcloud_contacts.py>

```python
def get_connection_parameters():
    parser = ArgumentParser(
        description="Create backups of Nextcloud calendar and contacts files"
    )
    parser.add_argument(
        "url", help="Nextcloud base URL (https://nextcloud.example.com)"
    )
    parser.add_argument("username", help="Nextcloud username (admin)")
    parser.add_argument(
        "keyfile", help="Path to file containing password (~/nextcloud_key)"
    )
    args = parser.parse_args()

    # Enforce HTTPS and allow some typical variants
    url = "https://" + args.url.rstrip("/").lstrip("http://").lstrip("https://")
    username = args.username

    with open(args.keyfile) as file:
        password = file.read()
        file.close()

    return url, username, password

def raise_an_error():
    x = 5
    if x > 4:
        raise ValueError(f"{x = } > 4")

class ClassExample:
    """A docstring.

    Has multiple lines.
    """

    def some_method(self, x: int) -> None:
        "Docstring."

        # Print it
        print(x)
```

Julia example

```julia
# Main purpose of creating this was to see "special" strings (symbol, regex) in
# action, but rouge doesn't parse them as anything special :(

if 5 < 6
    @assert match(r"\d", "hello2")
end

(string(:hello) == "hello" ? 5 : 6) |> sqrt
```

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
