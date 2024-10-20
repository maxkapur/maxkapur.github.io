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

On Ubuntu, `source configure.sh` installs all dependencies and sets up `rbenv`
for local site development. You can then preview the site with the following
command:

```bash
bundle exec jekyll serve
```

(If you restart the shell, you’ll need to `source configure.sh` again, or add
`eval "$(rbenv init -)"` to `.bashrc`.)
