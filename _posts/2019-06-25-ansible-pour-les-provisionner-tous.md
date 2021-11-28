---
id: 168
title: Ansible pour les provisionner tous !
date: 2019-06-25T11:34:51+02:00
author: admin
layout: post


timeline_notification:
  - "1561458892"
publicize_twitter_user:
  - touret_alex
categories:
  - gnu/linux
  - logiciels libres
tags:
  - ansible
  - debian
  - Planet-Libre
---
Si vous [provisionnez vos VM VirtualBox avec Vagrant](http://blog.touret.info/2018/03/15/installation-de-vagrant/), vous avez sans doute eu l&rsquo;idée d&rsquo;automatiser le provisionning des machines virtuelles. Dans mon cas une VM GNU/Linux basée sur Debian 9.

Pour cela, soit vous faite tout manuellement et après les mises à jour deviennent fastidieuses, soit vous appliquez un script shell au démarrage de vagrant, soit vous utilisez [Ansible.](https://www.ansible.com/)

<img loading="lazy" class="size-medium wp-image-180 aligncenter" src="/assets/img/posts/2019/06/ansible_logo.svg_.png?w=244" alt="" width="244" height="300" srcset="/assets/img/posts/2019/06/ansible_logo.svg_.png 832w, /assets/img/posts/2019/06/ansible_logo.svg_-244x300.png 244w, /assets/img/posts/2019/06/ansible_logo.svg_-768x945.png 768w" sizes="(max-width: 244px) 100vw, 244px" /> 

Ansible est un outil opensource permettant d&rsquo;automatiser le provisionning et la mise à jour des environnements à distance (via SSH). L&rsquo;avantage par rapport à des outils tels que [Puppet](https://puppet.com), est qu&rsquo;il ne nécessite pas l&rsquo;installation [d&rsquo;agent.](https://puppet.com/docs/puppet/6.0/man/agent.html) 

Je vais essayer de vous montrer comment mettre en place le provisionning via Ansible pour [VirtualBox](https://www.virtualbox.org/).

## Configuration de Vagrant

Dans le fichier Vagrantfile, on active le provisionning via Ansible:

<pre>config.vm.provision "ansible_local" do |ansible|<br />ansible.playbook = "site.yml"<br />ansible.install_mode = "pip"<br />ansible.version = "2.7.10"<br />end
```


Cette configuration fait référence à un fichier « playbook » site.yml. C&rsquo;est la configuration qui sera appliqué lors du provisionning . Que ça soit à la création ou pour les mises à jour.

Voici un exemple de contenu:

<pre>- name: VirtualBox<br />hosts: all<br />become: yes<br />become_user: "root"<br />become_method: "sudo"<br />roles:<br />- common<br />vars_files:<br />- vars/environment.yml
```


Ce fichier est la racine de notre configuration Ansible. On y référence les rôles appliqués et les fichiers d&rsquo; environnement. Voici un exemple de rôle:

<pre>- name: "Remove useless packages from the cache"<br />apt:<br />autoclean: yes<br />force_apt_get: yes<br /><br />- name: "Remove dependencies that are no longer required"<br />apt:<br />autoremove: yes<br />force_apt_get: yes<br /><br />- name: "Update and upgrade apt packages (may take a while)"<br />become: true<br />apt:<br />upgrade: dist<br />update_cache: yes<br />force_apt_get: yes<br /><br />- name: "Install useful packages"<br />  become: true<br />  apt: <br />    name:<br />      - gcc<br />      - g++<br /> ...<br />      - zsh<br />      - firewalld<br />    state: present<br />    update_cache: no <br /><br />- name: ansible create directory example<br />file:<br />path: "{{ home }}/.m2"<br />state: directory<br />owner: "{{ username }}"<br />group: "{{ username }}"<br /><br />- name: Install Maven settings.xml<br />copy: <br />src: settings.xml<br />dest: "{{ home }}/.m2/settings.xml"<br />owner: "{{ username }}"<br />group: "{{ username }}"<br /><br />- name: "Install Maven"<br />raw: "curl -sL \"http://mirror.ibcp.fr/pub/apache/maven/maven-3/{{ maven_version }}/binaries/apache-maven-{{ maven_version }}-bin.tar.gz\" -o /opt/apache-maven.tar.gz && tar -zxf /opt/apache-maven.tar.gz -C /opt"<br />become: true<br />become_user: root<br />become_method: sudo<br /><br />- name: "Change Maven Rights"<br />file:<br />path: /opt/*<br />state: touch<br />modification_time: "preserve"<br />access_time: "preserve"<br />owner: "{{ username }}"<br />group: "{{ username }}"
```


Les variables d&rsquo;environnement permettent de variabiliser certains champs de vos rôles. On peut trouver par exemple les versions de certains outils déployés

<pre>maven_version: 3.5.4<br />username: vagrant<br />home: /home/vagrant<br />docker_compose_version: 1.22.0
```


Il y a [une quantité impressionnante de modules Ansible que l&rsquo;on peut utiliser](https://docs.ansible.com/ansible/latest/modules/modules_by_category.html). Que ça soit pour lancer des commandes shell ou lancer des services. Contrairement à la création d&rsquo;un script shell qui pourrait faire les mêmes actions à la création, on peut facilement gérer la mise à jour de la VM car Ansible détecte les modifications lors de son exécution.

### Configuration spécifique pour VirtualBox

Pour VirtualBox, j&rsquo;ai ajouté deux fichiers de configuration supplémentaires à la racine:

##### ansible.cfg

<pre>[defaults]<br />hostfile = hosts
```


##### hosts

<pre>[local]<br />localhost ansible_connection=local
```


## Provisionning

### A la création

le provisionning peut se faire au lancement de vagrant via la commande:

<pre>vagrant up
```


Pour faire une mise à jour

Directement dans la box, vous pouvez lancer les commandes suivantes :

<pre>sudo mount -t vboxsf vagrant /vagrant
```


<p dir="auto">
  Puis, vous pouvez lancer les commandes suivantes dans la box:
</p>

<pre>su -<br />cd /vagrant<br />export ANSIBLE_CONFIG=/vagrant<br />ansible-playbook site.yml
```


 