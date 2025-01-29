source "https://rubygems.org"

gem "base64", "~> 0.2"
gem "bigdecimal", "~> 3.1"
gem "csv", "~> 3.3"
gem "html-proofer", "~> 5.0"
gem "logger", "~> 1.6"

gem "jekyll", "~> 4.4"

group :jekyll_plugins do
    # gem "jekyll-paginate", "~> 1.1"
    gem "jekyll-redirect-from", "~> 0.16"
    gem "jekyll-seo-tag", "~> 2.8"
    gem "jekyll-sitemap", "~> 1.4"
end

group :jekyll_deps do
    # Dependencies of Jekyll that we version explicitly
    gem "json", "~> 2.9"
    gem "kramdown", "~> 2.5"
end

# kramdown-math-katex (enables server-side KaTeX rendering) and its deps
group :kramdown_math_katex do
    gem "execjs", "~> 2.9"
    gem "duktape", "~> 2.7"
    gem "katex", "~> 0.10"
    gem "kramdown-math-katex", "~> 1.0"
end

# Jekyll theme
gem "minima", "~> 2.5"
