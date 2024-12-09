---
layout: post
title: Server-side KaTeX rendering with Jekyll
katex: true
---

KaTeX is a math typesetting library that lets you render nice-looking math
equations like $$f(x) = e^{rt}$$ inside of an HTML document. As the [KaTeX
documentation describes](https://katex.org/docs/autorender), the easiest way to
use KaTeX is to import their CSS and JavaScript from your website’s `<head>`
element by adding these three lines:

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.11/dist/katex.min.css" integrity="sha384-nB0miv6/jRmo5UMMR1wu3Gz6NLsoTkbqJghGIsx//Rlm+ZU03BU6SQNC66uf4l5+" crossorigin="anonymous">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.11/dist/katex.min.js" integrity="sha384-7zkQWkzuo3B5mTepMUcHkMB5jZaolc2xDwL6VFqjFALcbeS9Ggm/Yr2r3Dy4lfFg" crossorigin="anonymous"></script>
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.11/dist/contrib/auto-render.min.js" integrity="sha384-43gviWU0YVjaDtb/GhzOouOXtZMP/7XUzwPTstBeZFe/+rCMvRwr4yROQP43s0Xk" crossorigin="anonymous"
    onload="renderMathInElement(document.body);"></script>
```

With this client-side setup, visitors to your site only receive the KaTeX
“source” (something like `$$f(x) = e^{rt}$$`) from your server, and then their
computer runs the code (KaTeX) that transforms this into MathML and tells the
browser how to style and arrange the individual symbols.

However, by running KaTeX on the *server* instead of the client, you can send
readers the MathML code directly, which removes the need for redundant
computations and queries to the KaTeX CDN. [Guillaume
Endignoux](https://gendignoux.com/blog/2020/05/23/katex.html) and [Xuning
Yang](https://www.xuningyang.com/blog/2021-01-11-katex-with-jekyll/) explain how
to achieve this setup using Jekyll, the static site generator I use. In summary:

 1. Add the `duktape`, `execjs`, `katex`, and `kramdown-math-katex` gems to your
    `Gemfile`. (You can leave out `duktape` if you already have Node.js on your
    path.)
 2. Set the following options in `_config.yml`:

    ```yml
    markdown: "kramdown"
    kramdown:
        math_engine: "katex"
    ```

 3. Add the following line to your site’s `<head>` element:

    ```html
    <link rel="stylesheet" href="{{ "/assets/katex.css" | relative_url }}">
    ```

 4. Download a KaTeX release [from
    GitHub](https://github.com/KaTeX/KaTeX/releases) and extract `katex.css` and
    `fonts/` to your source repo’s `assets/` directory.

The last step left me unsatisfied. As I described in a [previous post]({%
post_url 2024-12-06-self-host-fonts %}), I want to avoid introducing a
third-party code dependency to my source tree—especially one like the KaTeX CSS
that I’d have to keep manually in sync with the version of KaTeX installed by
the Ruby `katex` gem. Instead, I tweaked my `configure.sh` script to
automatically retrieve the KaTeX fonts and CSS from within the `katex` gem after
installing it with Bundler:

```shell
function install_katex_resources () {
    KATEX_CSS_SRC="$(find ./vendor/ -ipath "*/vendor/katex/stylesheets/katex.css")"
    KATEX_CSS_DEST="./assets/katex.css"
    rm "$KATEX_CSS_DEST" 2> /dev/null
    if [ ! -f "$KATEX_CSS_SRC" ]
    then
        echo "E: Failed to locate source katex.css" >&2
        return 1
    fi
    ln -v "$KATEX_CSS_SRC" "$KATEX_CSS_DEST"

    KATEX_FONTS_SRC=$(find ./vendor/ -ipath "*/vendor/katex/fonts/*.woff2")
    KATEX_FONTS_DEST="./assets/fonts"
    rm "$KATEX_FONTS_DEST"/*.woff2 2> /dev/null
    # shellcheck disable=SC2068  # splitting intended
    for f in ${KATEX_FONTS_SRC[@]}
    do
        BASENAME=$(basename "$f")
        ln -v "$f" "$KATEX_FONTS_DEST"/"$BASENAME"
    done
}
```

This puts the files in the `assets/` directory—right where they need to be—but
keeps Bundler in control of their versions. Using a hard link (`ln a b`) instead
of copying (`cp a b`) the files spares a few unnecessary disk operations when
rerunning `configure.sh`.

I admit that the maintenance burden this eliminates isn’t large, but in a
project with many dependencies, the little things add up.
