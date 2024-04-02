---
title: "Managing smartly different Git profiles "
date: 2024-04-02T06:00:43+01:00
draft: false
featuredImagePreview: "/assets/images/2024/04/firdouss-ross-Z4m21XW36OM-unsplash.webp"
featuredImage: "/assets/images/2024/04/firdouss-ross-Z4m21XW36OM-unsplash.webp"
images: ["/assets/images/2024/04/firdouss-ross-Z4m21XW36OM-unsplash.webp"]
tags:
  - Git
---
{{< style "text-align:center;" >}}
_Photo by [Firdouss Ross](https://unsplash.com/@firdoussross?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)_
{{< /style >}}


## Introduction
While fixing the author and email properties for a bunch of existing commits on different repositories, I realised I often forget configuring the good information for both my professional & personal GIT repositories.
I particularly skip to specify the good email address of the good GPG signature after checking them out.

I therefore looked around for an industrialised (_~lazy_) solution for fixing this issue once for all.
I found a solution which fits my needs: [the ``includeIf`` instruction](https://git-scm.com/docs/git-config#Documentation/git-config.txt-codehasconfigremoteurlcode).
Among other things, this functionality helps me centralise my Git configuration and apply the good parameters/instructions (e.g., ``user.email``) dynamically in every repository.

You could find below how I did that:

## Prerequisites

Having Git >=2.36 installed.

In case you use the current Ubuntu LTS or Linux Mint release, you can install the latest version of GIT by adding [this repository into your APT sources](https://launchpad.net/~git-core/+archive/ubuntu/ppa?ref=itsfoss.com):

You can find below the commands to run
```bash
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update && sudo apt full-upgrade -y
```

After that, you can check the version of GIT running this command:

```bash
git --version
git version 2.43.2
```

## The configuration
In this article, we will assume to have two different SCMs with two different SSH URLs:
* The corporate GIT SCM: git@gitlab.INTERNAL_URL
* Github.com: git@github.com

By the way, you can also use HTTPS URls.

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

As mentioned earlier, I use in this configuration [the ``includeIf`` functionality for checking the remote URL](https://git-scm.com/docs/git-config#Documentation/git-config.txt-codehasconfigremoteurlcode).
Regarding the remote URL (it also works with HTTPS URLs), either the corporate or GitHub configuration will be applied on the fly while applying git commands in my repos.

I then configured my corporate git configuration as following:

```ini
[user]
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

If you want to knwo more about GitHub SSH configuration, check out [the documentation](https://docs.github.com/fr/authentication/connecting-to-github-with-ssh)

## How to check it?

In one Git repository, you can check this configuration typing the command:

Here an example for a GitHub repository

```bash
> git config --get user.email
alexandre-touret@users.noreply.github.com
```

## Conclusion
In this short article I aimed to explain how to smoothly handle two (or more) Git profiles in the same development environment.
I chose to use the remote URL to segregate each one.
This configuration can finally help you apply automatically the good Git information while committing your work without setting up each project individually.

Hope this helps!
