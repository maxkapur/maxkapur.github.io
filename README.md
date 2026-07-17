# Illusion Slopes

This repository holds my personal website, Illusion Slopes, which can be viewed at
[maxkapur.com](https://maxkapur.com).

The site has been through a few iterations. This version uses the Hugo static site generator,
which I migrated to [from Jekyll](https://github.com/maxkapur/maxkapur.github.io/pull/98) in 
summer 2026.

The old Jekyll site itself was a summer 2022 migration [from Blogger](https://maxkapur.com/2022/06/25/migrating-to-jekyll).

Prior to that, I used the maxkapur.github.io repo as a basic landing page to host
a few one-off web essays that have now been moved to separate repos:

- [cyborgs-and-ciphers](https://github.com/maxkapur/cyborgs-and-ciphers)
- [esl-data](https://github.com/maxkapur/esl-data)
- [how-do-we](https://github.com/maxkapur/how-do-we)

Comments and suggestions are welcome via [email](mailto:git@maxkapur.com) or
GitHub pull request.

## License

- Blog content is licensed under CC BY-SA 4.0 (see `LICENSE.txt`).
- The theme is licensed under Apache (see `themes/illusion-slopes/LICENSE.txt`).

## Workstation setup

```shell
sudo apt install nix

# Preview the site
./devshell.sh hugo serve 

# Read-only scan for problems
./devshell.sh ./lint.sh

# Automatic formatting
./devshell.sh ./format.sh

# Freestyle
./devshell.sh
```
