---
title: Setup Fish shell (and beyond)
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

While talking with one of my WL colleague, I stumbled upon [Fish shell](https://fishshell.com/). 
I liked its autocompletion and extensibility mechanisms
After many years using BASH and ZSH, I decided to move on to this new Shell.

At the opposite of the others, it's not [POSIX-compatible](https://fishshell.com/docs/current/fish_for_bash_users.html#fish-for-bash-users).

Furthermore, to get (at least) the same functionalities as OhMyZsh, I choose to install et setup [Starship](https://starship.rs/).

As a reminder, I will describe how I moved on and updated my existing tools such as [SdkMan](https://sdkman.io/).

## FISH Installation

{{< admonition info "OS" true >}}
I applied these commands on both [Ubuntu20](http://ubuntu.com/)/[WSL2](https://learn.microsoft.com/fr-fr/windows/wsl/install) and [Linux Mint](https://linuxmint.com/). 
{{< /admonition >}}

To install it
```jshelllanguage
sudo apt install fish
```

You must also to use a font available through [NerdFonts website](https://www.nerdfonts.com/font-downloads). 
By the way, you can also use the fonts available through your package manager. 

For instance, I chose using [JetBrains Mono](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip) 

After downloading it, you can reload your font cache using this command:

```jshelllanguage
fc-cache -fv
```
## Starship installation

I ran this command:
```jshelllanguage
curl -sS https://starship.rs/install.sh | sh
```


{{< admonition info "How to update starship" true >}}
To update Starship, you must use the same command.
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

At this stage, Sdkman doesn't work anymore. To put it alive again,I had to install [Fisher](https://github.com/jorgebucaran/fisher) and a [Sdkman for fish plugin](https://github.com/reitzig/sdkman-for-fish)  

### Fisher install
Run this command:
```jshelllanguage
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```
### Sdkman for fish plugin
Run this command:
```jshelllanguage
fisher install reitzig/sdkman-for-fish@v2.0.0
```
### Run Sdkman 

Run this command:

```jshelllanguage
sdk ug
```
Say yes and restart a shell.

## GPG 

$HOME/.config/fish/conf.d/config_gpgagent.fish

set -gx GPG_TTY (tty)
restart a shell


fisher install FabioAntunes/fish-nvm edc/bass
