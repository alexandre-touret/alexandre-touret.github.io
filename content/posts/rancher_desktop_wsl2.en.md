---
title: "Set up WSL2 to be compatible with Rancher Desktop"
date: 2023-11-07T14:35:16+01:00
draft: true

images: ["/assets/images/2023/11/carlo-borella-ozDrGigNQXY-unsplash.webp"]
featuredImagePreview: /assets/images/2023/11/carlo-borella-ozDrGigNQXY-unsplash.webp
featuredImage: /assets/images/2023/11/carlo-borella-ozDrGigNQXY-unsplash.webp

---

I just downloaded and sat up Rancher Desktop on my laptop.
Here is a (very) short reminder about how to configure WSL2 Ubuntu virtual machines and Docker with it. 

## Install & configure Rancher Desktop

The setup is pretty straightforward. 
I chose to install Moby to use Docker and Docker Compose.

After installing it, you have to [plug your VM to expose the Docker daemon and the relative commands](https://docs.rancherdesktop.io/ui/preferences/wsl/).

Perhaps, you will need to restart both WSL2 & Rancher Desktop afterward.

## Configure Docker Credential Store

When you start your Docker compose infrastructure, if you come across this error:
```jshelllanguage
Error saving credentials: error storing credentials - err: exit status 1,
```

You must add to create the ``$HOME/.docker/config.json`` inside your VM with the following content: 

```json
{                            
"credsStore": "wincred.exe"
}   
```

It will automatically resolve to the ``docker-credential-wincred.exe`` binary and fix this issue.

## Get container's output in the console

When you run a docker container (e.g., ``docker run hello-world``) you don't get any output on the console. 
This [issue is known](https://github.com/rancher-sandbox/rancher-desktop/issues/1558).
To get it, you must start your commands with the ``-i`` option.

For instance:

```jshelllanguage
docker run -i hello-world
```

Hope this helps!
