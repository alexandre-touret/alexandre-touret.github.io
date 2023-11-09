---
title: "Configuring WSL2 for Seamless Compatibility with Rancher Desktop"
date: 2023-11-07T14:35:16+01:00
draft: true

images: ["/assets/images/2023/11/carlo-borella-ozDrGigNQXY-unsplash.webp"]
featuredImagePreview: /assets/images/2023/11/carlo-borella-ozDrGigNQXY-unsplash.webp
featuredImage: /assets/images/2023/11/carlo-borella-ozDrGigNQXY-unsplash.webp

tags:
  - WSL2
  - Rancher_Desktop
  - Docker

---

Just out of curiosity, I [downloaded and sat up Rancher Desktop on my laptop](https://docs.rancherdesktop.io/getting-started/installation#installing-rancher-desktop-on-windows).

I daily use [Docker](https://docs.docker.com/) and [Docker compose](https://docs.docker.com/compose/) on top of [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install) using _home made mechanism/tooling_
I would then see if Rancher Desktop fits well in this case and could help me.

In this (very short) article, we'll go over the necessary steps to configure [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install) Ubuntu virtual machines and Docker with Rancher Desktop. 

If you want to get into Rancher Desktop in another way and discover how to install [Skaffold](https://skaffold.dev/), you [can read this article](https://malkav30.gitlab.io/posts/first-rancherdesktop-application-skaffold/). 

## Install & configure Rancher Desktop

{{< style "text-align:center" >}}
![rancher desktop logo](/assets/images/2023/11/rancher-desktop-logo.svg)
{{</ style>}}

The setup is quite straightforward.
Follow [the instructions provided in the official documentation](https://docs.rancherdesktop.io/getting-started/installation#installing-rancher-desktop-on-windows) to get Rancher Desktop up and running on your Windows machine.
Rancher Desktop allows you to run Docker and Docker Compose seamlessly within a WSL2 environment.

During the setup process, I chose to install [Moby](https://github.com/moby/moby) to use [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/).

After installing Rancher Desktop, you will need to ensure your virtual machine (VM) is connected to expose the Docker daemon and related commands. 
You can find detailed steps in the Rancher Desktop documentation under [WSL Preferences](https://docs.rancherdesktop.io/ui/preferences/wsl/). 
Don't forget that in some cases, you may need to restart both WSL2 and Rancher Desktop for the changes to take effect.

## Configure Docker Credential Store

When you start your Docker compose infrastructure and encounter an error like this:

```jshelllanguage
Error saving credentials: error storing credentials - err: exit status 1,
```

You'll need to configure Docker's credential store.
To resolve this issue, follow these steps:
1. Inside your WSL2 VM, create or edit the ``~/.docker/config.json`` file.
2. Add the following content to the ``config.json`` file:

```json
{                            
"credsStore": "wincred.exe"
}   
```

This configuration points to the ``docker-credential-wincred.exe`` binary and will resolve the credential storage problem when using Docker.

## Get container's output in the console

A common issue with Docker containers in Rancher Desktop is the lack of output in the console when running a container, such as with the command ``docker run hello-world``.
This issue is well-documented in [this GitHub issue](https://github.com/rancher-sandbox/rancher-desktop/issues/1558).

To view the container's output in the console, you need to start your commands with the ``-i`` option. For example:

For instance:

```jshelllanguage
docker run -i hello-world
```
This option tells Docker to attach to the container's standard input, allowing you to see the output directly in your console.

## Conclusion

I hope this article has been helpful for you, and you're now ready to _supercharge_ your development workflow with Rancher Desktop and Docker!
