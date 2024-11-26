source "https://rubygems.org"

gem "base64", "~> 0.2"
gem "bigdecimal", "~> 3.1"
gem "csv", "~> 3.3"
gem "html-proofer", "~> 5.0"
gem "logger", "~> 1.6"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "~> 4.3"

# This is the default theme for new Jekyll sites. You may change this to anything you like.
gem "minima", "~> 2.5"

# Markdown parser used by Jekyll
gem "kramdown", "~> 2.5"

group :kramdown_math_katex do
    # kramdown-math-katex (enables server-side KaTeX rendering) and its deps
    gem "kramdown-math-katex", "~> 1.0"
    gem "katex", "~> 0.10"
    gem "execjs", "~> 2.9"
end

# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-redirect-from", "~> 0.16"
  gem "jekyll-seo-tag", "~> 2.8"
  gem "jekyll-sitemap", "~> 1.4"
end

# This should be pulled in as a Jekyll dependency, but sometimes that doesn't
# happen. See e.g. https://github.com/jekyll/jekyll/issues/5423
gem "json", "~> 2.7"

# Don't need Windows or JRuby
# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
# platforms :mingw, :x64_mingw, :mswin, :jruby do
#   gem "tzinfo", "~> 2.0"
#   gem "tzinfo-data"
# end

# Don't need Windows
# Performance-booster for watching directories on Windows
# gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Don't need JRuby
# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
# gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]

# Implied by transitivity
# gem "webrick", "~> 1.8"

# Maybe later
# gem "jekyll-paginate", "~> 1.1"
