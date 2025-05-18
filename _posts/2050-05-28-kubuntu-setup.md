---
layout: post
title: My poorly automated Kubuntu setup process
---

I recently set up a new (old) laptop and tried to bring it to parity with my
main Kubuntu workstation in as few steps as possible. I wanted to write this
post to document my setup process and identify opportunities to automate it
further, since it is still fairly manual.

00. **Installed Kubuntu the usual way.** Configured LUKS disk encryption and
    user account. `sudo apt update -y && sudo apt upgrade -y`.

    Automation status: 🎨 Difficult to automate. I make different partitioning
    and filesystem choices for every device.

01. **Copied password vault** manually via USB drive. Installed KeePassXC via
    `apt` I knew I would need it for basically everything that follows.

    Automation status: 🔐 Won’t automate. If you trust the KeePass security
    model, then in theory you should be willing to put your KeePass vault on a
    public URL and download it automatically … but I don’t think anyone actually
    does that.

02. **Generated SSH keys** (`ssh-keygen`) for various Git hosts. Added entries
    like this in `~/.ssh/config`:

    ```
    Host github.com
        User maxkapur
        IdentityFile ~/.ssh/id_just_generated
    ```

    Logged into GitHub and others in Firefox and added the new SSH keys
    manually.

    Automation status: 🔐 Won’t automate. I guess I could script this a little
    more with the GitHub CLI, but at some point I would still have to manually
    enter the MFA token, so the benefit would be marginal. Some people choose to
    use the same SSH key for every client, but I want to be able to scope and
    revoke keys individually for different client machines.

03. **Installed Syncthing** (`apt install syncthing`). Ran Syncthing manually (I
    will configure autostart in step 8) and set up folder connections to
    existing shared folders.

    Automation status: 🧪 Hope to automate via a script that automatically finds
    to my main Syncthing server and prompts for authentication.

04. **Ran a script** `setup.sh` (see below) to automatically install various
    tools, do some basic configuration, and clone a few git repos.

    Automation status: 💻 Automated. I created this script for the first as part
    of this setup. In the past, I just installed packages as I thought of them.
    Eventually I will try to integrate `setup.sh` with my dotfiles, but
    currently those are a downstream step because installing them depends on
    programs that are themselves installed from `setup.sh`.

05. **Set up Nextcloud** using the desktop client (installed in `setup.sh`).
    Configured offline folders.

    Automation status: 🎨 Difficult to automate. You can
    [kind of](https://docs.nextcloud.com/desktop/latest/advancedusage.html#mass-deployment-and-account-creation)
    predefine the Nextcloud server connection parameters, but there’s no getting
    around the MFA step, and I choose different offline folders for each device.

06. **Installed my dotfiles.** I have a private git repo (cloned in `setup.sh`)
    with a custom shell script that does this. The repo is private because it
    hardcodes a bunch of URLs and my name and email address into various config
    files.

    Automation status: 💻 Automated.

07. **Configured Korean keyboard input** with `fcitx5`. `setup.sh` already
    installed all the necessary packages, but a few additional setup steps are
    needed to get Korean input working with KDE under Wayland. Basically, the
    trick is to repeatedly log out and back in again and follow the instructions
    in the notification that automatically pops up from the automatic diagnostic
    tool.

    These are the changes I had to make this time around:

    - Set the `XMODIFIERS`, `GTK_IM_MODULE`, and `QT_IM_MODULE` variables
      according to the latest recommendations in the
      [Fcitx wiki](https://www.fcitx-im.org/wiki/Setup_Fcitx_5).
    - In KDE’s settings, under Virtual Keyboard, chose Fcitx5 Wayland Launcher
      (Experimental).
    - Ran `im-config`, let it run its diagnostic, and followed the prompts.
    - Opened the `fcitx5` settings by clicking the system tray icon and set up
      preferred keybindings for switching between Korean and English input.

    After doing all this, I still got a notification upon login saying that I
    should unset the `GTK_IM_MODULE` and `QT_IM_MODULE` environment variables.
    But it seemed like a false positive, because I could verify from the shell
    that these variables were empty. Anyway, Korean typing works fine everywhere
    I’ve tried.

    Automation status: 🧪 Hope to automate.

08. **Configured Syncthing (again).** Ran Syncthing Tray (installed in
    `setup.sh`) manually and followed prompts to let it autostart itself and
    Syncthing.

    Automation status: 🧪 Hope to automate.

09. **Generated SSH keys (again)** for remote server shell access. Added
    `HostName`, `User`, and `IdentityFile` entries for each host to
    `~/.ssh/config`.

    All the servers I use allow *only* key-based access, so I used Nextcloud
    (hence waiting until now) to copy the public keys over to a client that
    already had access, then ran
    `ssh-copy-id -f -i path/to/id_whatever.pub server-hostname` to vouch for the
    new client.

    Automation status: 🧪 Hope to automate. I could write a script to prepare the
    keys on the client that already had access, then run this script prior to
    setting up the new client and transfer the keys as part of step 1.

10. **Installed Miniforge** (`curl` then `bash` and follow interactive prompt).
    I install it to `~/.local/miniforge3` instead of the default `~/miniforge3`.
    Say yes when asked to update shell profile. This seems to only affect `bash`
    so I went ahead and ran `~/.local/miniforge3/bin/conda init --all`. Make
    sure I can configure and build
    [my website](https://github.com/maxkapur/maxkapur.github.io/).

    Automation status: 🧪 Hope to automate in `setup.sh`. If
    [setup-miniforge](https://github.com/conda-forge/setup-miniforge) can do it,
    then presumably I can too.

11. **Set some weird keyboard preferences:** <kbd>Menu</kbd> key as compose key,
    swap <kbd>Esc</kbd> and <kbd>Caps Lock</kbd>, a few other keyboard shortcuts
    for window management.

    Automation status: 🧪 Hope to automate.

The steps above are in a topological sort order, i.e. this is an ordering that I
*know* works, but it may not be the only or most logical such ordering.

## Setup script

Slightly simplified and reduced contents of `setup.sh`:

```shell
#!/usr/bin/env bash

# Cache sudo credentials
sudo -v

# apt packages
sudo apt install -y \
    keepassxc fzf curl pipx git fish \
    nextcloud-desktop dolphin-nextcloud \
    fcitx5 fcitx5-hangul fcitx5-config-qt \
    syncthing syncthingtray syncthingtray-kde-plasma


# snap packages
snap install --classic codium
# ...

# pipx packages
pipx ensurepath
pipx install topgrade
# ...

# Configure/enable firewall
sudo ufw default deny incoming
sudo ufw allow syncthing
sudo ufw enable
sudo ufw reload

# Change shell to fish
chsh -s /usr/bin/fish

# Git repos (assumes SSH keys already set up)
mkdir -p "$HOME/gits"
pushd "$HOME/gits" || exit 1
git clone 'git@github.com:maxkapur/maxkapur.github.io.git'
# ...
```
