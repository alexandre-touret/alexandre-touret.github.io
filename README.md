[![Build and deploy to GitHub Pages](https://github.com/alexandre-touret/alexandre-touret.github.io/actions/workflows/gh-pages.yml/badge.svg?branch=main)](https://github.com/alexandre-touret/alexandre-touret.github.io/actions/workflows/gh-pages.yml)

## Setup

```bash
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.19.5.linux-amd64.tar.gz
wget -c https://github.com/gohugoio/hugo/releases/download/v0.110.0/hugo_extended_0.110.0_linux-amd64.deb
sudo apt install ./hugo_extended_0.110.0_linux-amd64.deb
```

## Start the website

```bash
hugo serve -D -F
```
