# Ansible pour les provisionner tous !

Si vous [provisionnez vos VM VirtualBox avec Vagrant](http://blog.touret.info/2018/03/15/installation-de-vagrant/), vous avez sans doute eu l'idée d'automatiser le provisionning des machines virtuelles. Dans mon cas une VM GNU/Linux basée sur Debian 9.

Pour cela, soit vous faite tout manuellement et après les mises à jour deviennent fastidieuses, soit vous appliquez un script shell au démarrage de vagrant, soit vous utilisez [Ansible.](https://www.ansible.com/)

{{< style "text-align:center" >}}
![ansible](/assets/images/2019/06/ansible_logo.svg_.png)
{{</ style >}}

Ansible est un outil opensource permettant d'automatiser le provisionning et la mise à jour des environnements à distance (via SSH). L'avantage par rapport à des outils tels que [Puppet](https://puppet.com), est qu'il ne nécessite pas l'installation d'agent.

Je vais essayer de vous montrer comment mettre en place le provisionning via Ansible pour [VirtualBox](https://www.virtualbox.org/).

## Configuration de Vagrant

Dans le fichier Vagrantfile, on active le provisionning via Ansible:

```ini
config.vm.provision "ansible_local" 
  do |ansible| ansible.playbook = "site.yml"
  ansible.install_mode = "pip"
  ansible.version = "2.7.10"
end
```


Cette configuration fait référence à un fichier « playbook » site.yml. C'est la configuration qui sera appliqué lors du provisionning . Que ça soit à la création ou pour les mises à jour.

Voici un exemple de contenu:

```yaml
- name: VirtualBox
    hosts: all
    become: yes
    become_user: "root"
    become_method: "sudo"
    roles:
      - common:
        vars_files:
          - vars/environment.yml
```


Ce fichier est la racine de notre configuration Ansible. On y référence les rôles appliqués et les fichiers d' environnement. Voici un exemple de rôle:

```yaml
- name: "Remove useless packages from the cache"
  apt:
    autoclean: yes
    force_apt_get: yes
    
- name: "Remove dependencies that are no longer required"
  apt:
    autoremove: yes
    force_apt_get: yes
- name: "Update and upgrade apt packages (may take a while)"
  become: true
  apt:
    upgrade: dist
    update_cache: yes
    force_apt_get: yes
- name: "Install useful packages"
  become: true
  apt: 
    name:
      - gcc
      - g++
      - ...
      - zsh
      - firewalld
    state: present
    update_cache: no 
- name: ansible create directory example
  file:
    path: "{{ home }}/.m2"
    state: directory
    owner: "{{ username }}"
    group: "{{ username }}"
- name: Install Maven settings.xml
  copy: 
    src: settings.xml
    dest: "{{ home }}/.m2/settings.xml"
    owner: "{{ username }}"
    group: "{{ username }}"
- name: "Install Maven"
  raw: "curl -sL \"http://mirror.ibcp.fr/pub/apache/maven/maven-3/{{ maven_version }}/binaries/apache-maven-{{ maven_version }}-bin.tar.gz\" -o /opt/apache-maven.tar.gz && tar -zxf /opt/apache-maven.tar.gz -C /opt"
  become: true
  become_user: root
  become_method: sudo
- name: "Change Maven Rights"
  file:
    path: /opt/*
    state: touch
    modification_time: "preserve"
    access_time: "preserve"
    owner: "{{ username }}"
    group: "{{ username }}"
```


Les variables d'environnement permettent de variabiliser certains champs de vos rôles. On peut trouver par exemple les versions de certains outils déployés

```bash
maven_version: 3.5.4
username: vagrant
home: /home/vagrant
docker_compose_version: 1.22.0
```


Il y a [une quantité impressionnante de modules Ansible que l'on peut utiliser](https://docs.ansible.com/ansible/latest/modules/modules_by_category.html). Que ça soit pour lancer des commandes shell ou lancer des services. Contrairement à la création d'un script shell qui pourrait faire les mêmes actions à la création, on peut facilement gérer la mise à jour de la VM car Ansible détecte les modifications lors de son exécution.

### Configuration spécifique pour VirtualBox

Pour VirtualBox, j'ai ajouté deux fichiers de configuration supplémentaires à la racine:

##### ansible.cfg

```ini
[defaults]
  hostfile = hosts
```


##### hosts

```ini
[local]
  localhost ansible_connection=local
```


## Provisionning

### A la création

le provisionning peut se faire au lancement de vagrant via la commande:

```bash
vagrant up
```


Pour faire une mise à jour

Directement dans la box, vous pouvez lancer les commandes suivantes :

```bash
sudo mount -t vboxsf vagrant /vagrant
```

Puis, vous pouvez lancer les commandes suivantes dans la box:


```bash
su -
cd /vagrant
export ANSIBLE_CONFIG=/vagrant
ansible-playbook site.yml
```
