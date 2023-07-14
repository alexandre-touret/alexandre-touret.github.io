---
title: Setup Fish shell (and beyond)
date: 2023-08-01 08:00:00
images: ["/assets/images/2023/03/vardan-papikyan-DnXqvmS0eXM-unsplash.webp"]
featuredImagePreview: /assets/images/2023/03/vardan-papikyan-DnXqvmS0eXM-unsplash.webp
featuredImage: /assets/images/2023/03/vardan-papikyan-DnXqvmS0eXM-unsplash.webp
og_image: /assets/images/2023/03/vardan-papikyan-DnXqvmS0eXM-unsplash.webp
draft: true
tags:
- shell
- GNU/Linux

---

Fish

sudo apt install fish


Nerd Font 
https://www.nerdfonts.com/font-downloads

fc-cache -fv

Starship
curl -sS https://starship.rs/install.sh | sh




 fish
  Add the following to the end of ~/.config/fish/config.fish:

	starship init fish | source

https://starship.rs/presets/plain-text.html

starship preset plain-text-symbols -o ~/.config/starship.toml

SDKMAN


Fisher https://github.com/jorgebucaran/fisher

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

SDKMAN for fish https://github.com/reitzig/sdkman-for-fish

fisher install reitzig/sdkman-for-fish@v2.0.0


sdk ug

y

restart a shell