---
title: Moving on to Fish shell (and beyond)
date: 2023-08-01 08:00:00
images: ["/assets/images/2023/07/jakub-kapusnak-vLQzopDRSNI-unsplash.webp"]
featuredImagePreview: /assets/images/2023/07/jakub-kapusnak-vLQzopDRSNI-unsplash.webp
featuredImage: /assets/images/2023/07/jakub-kapusnak-vLQzopDRSNI-unsplash.webp
og_image: /assets/images/2023/07/jakub-kapusnak-vLQzopDRSNI-unsplash.webp
draft: true
tags:
- shell
- GNU/Linux
---

While chatting with one of [my WL colleague](https://twitter.com/foxlegend), I stumbled upon [Fish shell](https://fishshell.com/). 
I immediately liked its autocompletion and extensibility mechanisms.
After many years using [BASH](https://www.gnu.org/software/bash/) and [ZSH](https://zsh.sourceforge.io/), I therefore decided to move on to this new [shell](https://en.wikipedia.org/wiki/Unix_shell).

Unlike the others, it's not [POSIX-compatible](https://fishshell.com/docs/current/fish_for_bash_users.html#fish-for-bash-users).

Furthermore, to get (_at least_) the same functionalities as [OhMyZsh](https://github.com/ohmyzsh/ohmyzsh), I chose to install [StarShip](https://starship.rs/).

I will then describe how I moved on and updated my existing tools such as [SdkMan](https://sdkman.io/).

## FISH Installation

{{< admonition info "OS" true >}}
I applied these commands on both [Ubuntu20](http://ubuntu.com/)/[WSL2](https://learn.microsoft.com/fr-fr/windows/wsl/install) and [Linux Mint](https://linuxmint.com/). 
{{< /admonition >}}

To install it, run this command:

```jshelllanguage
sudo apt install fish
```

You must also to use a font available on the [NerdFonts website](https://www.nerdfonts.com/font-downloads). 
By the way, you can also use the fonts available through your package manager. 

For instance, I chose using [JetBrains Mono](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip) 

After downloading it, you can reload your font cache running this command:

```jshelllanguage
fc-cache -fv
```
## StarShip installation

I ran this command:
```jshelllanguage
curl -sS https://starship.rs/install.sh | sh
```

{{< admonition info "How to update StarShip" true >}}
To update StarShip, you must use the same command.
{{< /admonition >}}

I also added the following command at the end of ``~/.config/fish/config.fish``:

```shell
starship init fish | source
```
Due to some WSL2 incompatibilities, I also chose to use [the plain text presets](https://starship.rs/presets/plain-text.html) running this command:

```jshelllanguage
starship preset plain-text-symbols -o ~/.config/starship.toml
```

## SDKMAN update
At this stage, SdkMan didn't work anymore. To put it alive again, I had to install [Fisher](https://github.com/jorgebucaran/fisher) and a [SdkMan for fish plugin](https://github.com/reitzig/sdkman-for-fish).

### Fisher install
Run this command:
```jshelllanguage
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```
### SdkMan for fish plugin
Run this command:
```jshelllanguage
fisher install reitzig/sdkman-for-fish@v2.0.0
```
### Run SdkMan 
Run this command:

```jshelllanguage
sdk ug
```
Say yes and restart a shell.
Now it should work.

## NVM
I had the same issue with [NVM](https://github.com/nvm-sh/nvm).

I then installed another plugin with Fisher:

```jshelllanguage
fisher install jorgebucaran/nvm.fish
```

## GnuPG 
I use [GnuPG for signing my GIT commits](https://blog.touret.info/2019/08/09/verifier-les-commit-git-avec-gpg/).
Installing Fisher broke my setup.

I then add this new configuration file ``$HOME/.config/fish/conf.d/config_gpgagent.fish`` with the following content:   

```jshelllanguage
set -gx GPG_TTY /dev/pts/0
``` 
Restart your shell (again).

## Conclusion
After all of these commands, I can use FISH for my daily job.
As I said in preamble, this article is only a reminder for my next setups.

Hope it will help you!