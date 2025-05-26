---
layout: post
title: My poorly automated Kubuntu setup
---

The target audience for this post is myself. I recently set up a new (old)
laptop and tried to bring it to parity with my main Kubuntu workstation in as
few steps as possible, which turned out to be … a lot of steps, most of them
manual. I wanted to document the full process and see if I can find worthwhile
opportunities for automation.<!--more-->

00. **Install Kubuntu the usual way.** Configure LUKS disk encryption and user
    account. `sudo apt update -y && sudo apt upgrade -y`.

    🎨 Difficult to automate because I make different partitioning and file
    system choices for every device.

01. **Copy password vault** manually via USB drive. Installed KeePassXC via
    `apt` because I will need it for basically everything that follows.

    🔐 Won’t automate. If you trust the KeePass security model, then in theory
    you should be willing to put your KeePass vault on a public URL and download
    it automatically … but I don’t think anyone’s that bold.

02. **Generate SSH keys** (`ssh-keygen`) for various Git hosts. Add entries like
    this in `~/.ssh/config`:

    ```
    Host github.com
        IdentityFile ~/.ssh/id_just_generated
    ```

    Log into GitHub and others in Firefox and add the new SSH keys manually.

    🔐 Won’t automate. I guess I could script this a little more with the GitHub
    CLI, but at some point I would still have to manually enter the MFA token,
    so the benefit would be marginal. (Some people choose to use the same SSH
    key for every client, which would simplify this step greatly, but I like the
    ability to scope and revoke keys individually for different workstations.)

03. **Install Syncthing** (`apt install syncthing`). Run Syncthing manually (we
    will configure autostart in step 8) and set up folder connections with other
    devices.

    🧪 Hope to automate via a script that automatically finds my main Syncthing
    server and prompts for authentication.
    [For later reference.](https://docs.syncthing.net/dev/rest.html)

04. **Run a configuration script** `setup.sh` (see below) to automatically
    install various tools, do some basic configuration, and clone a few git
    repos.

    💻 Automated. I created this script for the first as part of this setup. In
    the past, I just installed packages as I thought of them. Eventually I want
    to integrate `setup.sh` with my dotfiles.

05. **Set up Nextcloud** using the desktop client (installed in `setup.sh`).
    Configure offline folders.

    🎨 Difficult to automate. You can
    [kind of](https://docs.nextcloud.com/desktop/latest/advancedusage.html#mass-deployment-and-account-creation)
    predefine the Nextcloud server connection parameters, but there’s no getting
    around the MFA step, and I choose different offline folders for each device.

06. **Install dotfiles:** I have a private git repo (cloned in `setup.sh`) with
    a custom shell script that does this. It’s basically three steps:

    1. Apply fish shell configuration: aliases, universal variables, a few
       custom functions.
    2. Copy dotfiles for some command-line programs:
       [topgrade](https://github.com/topgrade-rs/topgrade),
       [micro](https://github.com/zyedidia/micro).
    3. Apply git configuration: `git config --global user.name`, etc.
    4. Copy some utility scripts:
       [Borg backup](https://borgbackup.readthedocs.io/) with preferred options,
       a primitive Markdown linter (I should clean this up and post it
       sometime).

    My dotfiles repo is private because it hardcodes a bunch of parameters like
    my name and email address that would only cause confusion for someone else.

    💻 Automated enough for me.

07. **Configure Korean keyboard input** with `fcitx5`. This is always the
    hardest step when I try a new Linux distro. For Kubuntu, `setup.sh` installs
    all the necessary packages, but a few additional setup steps are needed to
    get Korean input working with KDE under Wayland. Basically, the trick is to
    repeatedly log out and back in again and follow the instructions in the
    notification that automatically pops up from the automatic diagnostic tool.

    These are the changes I had to make this time around:

    1. Set the `XMODIFIERS`, `GTK_IM_MODULE`, and `QT_IM_MODULE` variables
       according to the latest recommendations in the
       [Fcitx wiki](https://www.fcitx-im.org/wiki/Setup_Fcitx_5).
    2. In KDE’s settings, under Virtual Keyboard, choose Fcitx5 Wayland Launcher
       (Experimental).
    3. Run the `im-config` GUI, let it run its diagnostic, and follow the
       prompts.
    4. Open the `fcitx5` settings by clicking the system tray icon and set up
       preferred keybindings for switching between Korean and English input.

    After doing all this, I still got a notification upon login saying that I
    should unset the `GTK_IM_MODULE` and `QT_IM_MODULE` environment variables.
    But it seems like this was a false positive, because I can verify from the
    shell that these variables are empty (as recommended). Anyway, Korean typing
    works fine everywhere I’ve tried.

    🧪 Hope to automate.

08. **Configure Syncthing (again):** Run Syncthing Tray (installed in
    `setup.sh`) manually and follow prompts to let it autostart itself and
    Syncthing.

    🧪 Hope to automate.

09. **Generate SSH keys (again):** This time for shell access to remote servers.
    Add `HostName`, `User`, and `IdentityFile` entries for each host to
    `~/.ssh/config`.

    All the servers I use allow *only* key-based access, so I used Nextcloud
    (hence waiting until now) to copy the public keys over to a client that
    already had access, then ran
    `ssh-copy-id -f -i path/to/id_whatever.pub server-hostname` on that client
    to vouch for the new one.

    🧪 Hope to automate. I could write a script to prepare the keys on the client
    that already had access, then run this script prior to setting up the new
    machine and transfer the keys as part of step 1.

10. **Install [Miniforge](https://github.com/conda-forge/miniforge):** `curl`
    then `bash` and follow interactive prompt. I install it to
    `~/.local/miniforge3` instead of the default `~/miniforge3`. Say yes when
    asked to update shell profile. This seems to only affect `bash` so I went
    ahead and ran `~/.local/miniforge3/bin/conda init --all`. Make sure I can
    configure and build
    [my website](https://github.com/maxkapur/maxkapur.github.io/).

    🧪 Hope to automate in `setup.sh`. If
    [setup-miniforge](https://github.com/conda-forge/setup-miniforge) can do it,
    then presumably I can too.

11. **Set some weird keyboard preferences:** <kbd>Menu</kbd> key (if
    unavailable, right <kbd>Alt</kbd> instead) as compose key, swap
    <kbd>Esc</kbd> and <kbd>Caps Lock</kbd>, a few other keyboard shortcuts for
    window management. I do this in the KDE settings GUI.

    🧪 Hope to automate.

These steps are in a woefully illogical order. But I think that the dependencies
among these actions simply necessitate some jumping around between manual and
automated configuration, GUI and command line, and different physical computers.

I gaze in awe upon setup guides like
[Brian’s](https://briantruong777.github.io/2025/01/01/my-arch-linux-setup-2.0.html)
that proceed monotonically from bottom (disk partitioning) to top (configuring
backups). I have to admit, I doubt that his real process is as clean as his
guide suggests: Surely Brian must backtrack and make some changes to his desktop
environment config after installing all those bespoke fonts, right? Anyway, it’s
an ideal to strive toward.

## Setup script

Contents of `setup.sh`, slightly redacted to make myself look better:

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
