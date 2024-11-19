# Illusion Slopes

This repository holds my personal blog, Illusion Slopes, which can be viewed at
[maxkapur.com](https://maxkapur.com).

It also used to host several one-off essays, but these have have now been moved
to separate repos, namely
[cyborgs-and-ciphers](https://github.com/maxkapur/cyborgs-and-ciphers),
[esl-data](https://github.com/maxkapur/esl-data), and
[how-do-we](https://github.com/maxkapur/how-do-we).

My blog is on a CC BY-SA 4.0 license. Comments and suggestions are welcome via
[email](mailto:max@maxkapur.com) or GitHub pull request.

## Workstation setup

`./configure.sh` installs all dependencies using `conda` (to install Ruby) then
`bundler` (to install Jekyll and other Ruby dependencies). I use `conda` to
install Ruby because, in my tests, it provided the most reliable way to install
a fixed Ruby version across platforms without requiring you to build Ruby from
source (as with `rbenv`).

You can then preview the site with the following command:

```bash
conda activate ./.conda && bundle exec jekyll serve
```

To reinstall dependencies, use `yes | ./configure.sh`, which will automatically
delete the old conda environment.
