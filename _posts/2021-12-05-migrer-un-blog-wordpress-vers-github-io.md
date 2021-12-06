---
title: Migrer son blog Wordpress vers GitHub
date: 2021-12-05T11:53:49+02:00


header:
  teaser: /assets/images/2021/12/sebastien-goldberg-AW5MxlFDVzc-unsplash.jpg 

tags:
  - github
  - wordpress
  - planetlibre
---

L'idée me trottait dans la tête depuis quelques mois environ: migrer mon blog de Wordpress vers un site basé sur Jekyll et hébergé directement sur Github.
La date de renouvellement de ma souscription Wordpress arrivant à terme, je me suis décidé de franchir le pas.

![migration](/assets/images/2021/12/sebastien-goldberg-AW5MxlFDVzc-unsplash.jpg)

## L'hébergement de sites web sur Github

[Github permet via son service Github Pages d'héberger des sites statiques](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll) (c.-à-d. pas de base de données derrière) en permettant d'associer son nom de domaine. 
Le certificat est automatiquement généré.

Pour avoir un look un peu sympa, j'ai donc mis en oeuvre les outils suivants:

* [Jekyll](https://jekyllrb.com)
* [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/)
* [Github Actions pour construire le site](https://jekyllrb.com/docs/continuous-integration/github-actions/)
* [Markdown](https://www.markdownguide.org/) pour écrire les différents articles


## Démarrer avec Minimal Mistakes

Je vous conseille d'aller sur [ce site](https://mmistakes.github.io/minimal-mistakes/).
Tout est bien détaillé est c'est réalisable en quelques minutes seulement.

## Migration des données

Sans surprise, c'est la partie la moins drôle. Il faut en résumé:

* Exporter les données si vous êtes hébergé sur wordpress.com
* Les ré-importer dans une instance locale
* Les exporter au format Jekyll
* Copier le contenu généré dans un nouveau site

### Exporter les données

Afin d'exporter les données et de les transformer, il faut d'abord exporter les données (articles + médias) de votre site Wordpress 

![wordpress_export](/assets/images/2021/12/Screenshot_2021-12-03_12-01-31.png)

Vous obtiendrez deux archives: la première pour les articles, la deuxième pour les médias.

Création d'une instance Wordpress pour convertir les données au format Jekyll

### Importer les données

Pour faire simple, j'utilise [Docker pour monter une architecture Wordpress sur mon poste](https://docs.docker.com/samples/wordpress/).

Il faut pour ça créer un fichier ``docker-compose.yml`` et insérer le contenu suivant:


```yaml
version: "3.9"
    
services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
    
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - "8000:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
volumes:
  db_data: {}
  wordpress_data: {}
```

Ensuite, vous aurez à lancer la commande suivante:

```bash
docker-compose up
```

Une fois lancé, vous aurez à une instance Wordpress via cette URL : http://localhost:8000

Ensuite, il faut installer l'extension [jekyll-exporter](https://wordpress.org/plugins/jekyll-exporter/).
La procédure peut prendre un peu de temps.

Une fois effectuée, vous aurez une archive ZIP contenant un site Jekyll avec les images et articles associés.

## Création du site

En attendant que ça se termine, j'ai crée [un site jekyll avec le starter du thème minimal mistakes](https://github.com/mmistakes/mm-github-pages-starter/generate).

J'ai ensuite copié les articles (répertoire ``/_posts``) et images (``/assets/img``).
Au premier lancement des commandes suivantes:

```bash
bundle install
bundle exec jekyll serve
```

J'ai eu quelques erreurs. J'ai donc eu à nettoyer les fichiers via des recherche/remplace dans un éditeur

Par exemple, j'ai supprimé les références ``author`` et ``layout``

```yaml
author: admin
layout: post
```

J'ai également ajouté pour certains articles une image pour le teaser

Exemple: 

```yaml
header:
  teaser: /assets/images/2021/07/rest-book-architecture.png
```

### URL des pages et compatibilité Wordpress <> Jekyll

Pour me faciliter la vie dans les URLS et liens en tout genre, j'ai gardé le format des URLS de Wordpress.
Pour que ça soit le format par défaut de Jekyll, il faut modifier le paramètre ``permalink`` dans le fichier ``_config.yml``

```yaml
permalink: /:year/:month/:day/:title/
```

### Flux RSS pour un tag donné

J'utilisais une petite spécificité de Wordpress: la création d'un flux RSS pour un tag donné. 
Pour le mettre en place dans Jekyll, il faut configurer le plugin ``jekyll-feed`` avec les propriété suivantes:

```yaml
feed:
  tags: true
```

## Et maintenant ?

J'ai sans doute oublié quelques renommages/suppressions que j'ai pu faire ici et là.
Néanmoins, le principal est évoqué dans cet article.

Il ne vous reste plus qu'à éplucher la documentation du thème et de jekyll pour finaliser l' installation de votre nouveau site.

