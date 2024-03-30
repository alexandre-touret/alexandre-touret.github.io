---
title: "Managing smartly different work profiles with Git"
date: 2024-04-04T06:00:43+01:00
draft: true
featuredImagePreview: "/assets/images/2024/04/luke-chesser-LG8ToawE8WQ-unsplash.webp"
featuredImage: "/assets/images/2024/04/luke-chesser-LG8ToawE8WQ-unsplash.webp"
images: ["/assets/images/2024/04/luke-chesser-LG8ToawE8WQ-unsplash.webp"]
tags:
  - Git
---

__Photo de [Luke Chesser](https://unsplash.com/fr/@lukechesser?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)__
  

## Introduction
While fixing the author and email properties for existing commits on some repositories, I realised I often forget configuring the good information for both my profesional & personal GIT repositories.
I particularly forget to specify the good email address of the good GPG signature.

I therefore looked around for an industrialised solution for fixing this issue once for all.
You could find below how I did that:

## Prerequisites
Having installed Git >=2.36 

## The configuration
We will assume in this article we consider two different SCMs with two different SSH URLs:
* The corporate GIT SCM: git@gitlab.INTERNAL_URL
* Github.com: git@github.com

Now let's configure our main git configuration (e.g. ``$HOME/.gitconfig``)

```ini
[init]
	defaultBranch = main
[pull]
	rebase = merges
[core]
	autocrlf = true

[includeIf "hasconfig:remote.*.url:git@gitlab.INTERNAL_URL:*/**"]
    path = ~/.gitconfig-corporate
[includeIf "hasconfig:remote.*.url:git@github.com:*/**"]
	path = ~/.gitconfig-github
```

In this configuration I use [the ``includeIf`` functionality for checking the remote URL](https://git-scm.com/docs/git-config#Documentation/git-config.txt-codehasconfigremoteurlcode).
Regarding the remote URL (it also works with HTTPS URLs), either the corporate or github configuration will be applied on the fly while applying git commands in my repos.

I then configured my corporate git configuration as following:

```ìni
user]
	name = Alexandre Touret
	email = alexandre.touret@XXX.com
[credential]
	username = XXXX
	helper = cache
```

and the GitHub configuration

```ini
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
```


## Gentle reminder: how to use GitHub SSH connection without using Standard 22 port
Hopefully, GitHub has enabled SSH connections through the standard HTTPS port. 
You can then set up your SSH client adding this configuration in the ``$HOME/.ssh/config``:

```ini
Host github.com
    Hostname ssh.github.com
    Port 443
    User git
    IdentityFile ~/.ssh/id_rsa_github

``` 

## How to check it?

In one Git repository, you can check this configuration typing the command:

Here an example for a GitHub repository

```jshelllanguage
> git config --get user.email
alexandre-touret@users.noreply.github.com
```


## Conclusion
This short article aimed to explain how to smoothly handle two (or more) Git profiles in the same development environment.
This configuration can help you applying automatically the good Git information while committing your work without setting up each project individually.

Hope this helps!