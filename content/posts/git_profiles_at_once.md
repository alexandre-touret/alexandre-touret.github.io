---
title: "Managing smartly different work profiles with Git"
date: 2024-03-25T06:00:43+01:00
draft: true
featuredImagePreview: "/assets/images/2024/03/tobias-fischer-PkbZahEG2Ng-unsplash.webp"
featuredImage: "/assets/images/2024/03/tobias-fischer-PkbZahEG2Ng-unsplash.webp"
images: ["/assets/images/2024/03/tobias-fischer-PkbZahEG2Ng-unsplash.webp"]
tags:
  - Git
---



Git 2.36 min
https://stackoverflow.com/questions/72078027/git-user-depending-on-remote-url

https://git-scm.com/docs/git-config#Documentation/git-config.txt-codehasconfigremoteurlcode


Host github.com
    Hostname ssh.github.com
    Port 443
    User git
    IdentityFile ~/.ssh/id_rsa_github
[init]
	defaultBranch = main
[pull]
	rebase = merges
[core]
	autocrlf = true

[includeIf "hasconfig:remote.*.url:git@gitlab.INTERNAL_URL:*/**"]
    path = ~/.gitconfig-wl
[includeIf "hasconfig:remote.*.url:git@github.com:*/**"]
	path = ~/.gitconfig-github



[user]
	name = Alexandre Touret
	email = alexandre.touret@XXX.com
[credential]
	username = XXXX
	helper = cache


[user]
  	email = alexandre-touret@users.noreply.github.com
	signingkey = XXXXXXXXX
	name = Alexandre Touret
[credential]
	username = XXXX
	helper = cache
[gpg]
	program = gpg
[commit]
	gpgsign = true

